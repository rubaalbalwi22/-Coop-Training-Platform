import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:train_link/presentation/admin/user_management/model/user_model.dart';
import 'package:train_link/presentation/company/training_opportunity/model/training_opportunity_model.dart';

import '../../core/errors/error_handler.dart';
import '../../core/errors/failure.dart';
import '../../presentation/admin/training_types/models/training_type_model.dart';
import '../../presentation/company/training_course/model/training_course_model.dart';
import '../../presentation/student/training_opportunity/model/training_application_model.dart';
import '../client_service/client_service_api.dart';

abstract class CompanyRemoteDataSource {
  Future<Either<Failure, List<TrainingOpportunity>>>
  getAllTrainingOpportunities();
  Future<Either<Failure, void>> addTrainingOpportunity(
    TrainingOpportunity trainingOpportunity,
  );
  Future<Either<Failure, void>> updateTrainingOpportunity(
    TrainingOpportunity trainingOpportunity,
  );
  Future<Either<Failure, void>> deleteTrainingOpportunity(
    String trainingOpportunityId,
  );

  Future<Either<Failure, List<TrainingCourse>>> getAllTrainingCourses();
  Future<Either<Failure, void>> addTrainingCourse(
    TrainingCourse trainingCourse,
  );
  Future<Either<Failure, void>> updateTrainingCourse(
    TrainingCourse trainingCourse,
  );
  Future<Either<Failure, void>> deleteTrainingCourse(String trainingCourseId);

  Future<Either<Failure, List<TrainingType>>> getAllTrainingTypes();

  Future<Either<Failure, List<TrainingApplication>>> getTrainingApplications();
  Future<Either<Failure, void>> updateTrainingApplication(
    TrainingApplication trainingApplication,
  );

  Future<Either<Failure, AppUser>> getMyProfile();
  Future<Either<Failure, void>> updateUser(AppUser user);
}

class CompanyRemoteDataSourceImpl implements CompanyRemoteDataSource {
  FirebaseFirestore firebaseFirestore;
  FirebaseAuth firebaseAuth;
  ClientServiceApi clientServiceApi;

  CompanyRemoteDataSourceImpl({
    required this.firebaseFirestore,
    required this.clientServiceApi,
    required this.firebaseAuth,
  });

  @override
  Future<Either<Failure, void>> addTrainingCourse(
    TrainingCourse trainingCourse,
  ) async {
    try {
      if (trainingCourse.imageUrl.startsWith('/data/user/')) {
        trainingCourse.imageUrl =
            await clientServiceApi.uploadImageToCloudinary(
              File(trainingCourse.imageUrl),
            ) ??
            "";
      }

      var result = await firebaseFirestore
          .collection('training_courses')
          .add(trainingCourse.toMap());
      trainingCourse.id = result.id;
      trainingCourse.companyId = firebaseAuth.currentUser!.uid;
      await firebaseFirestore
          .collection('training_courses')
          .doc(result.id)
          .set(trainingCourse.toMap());
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> addTrainingOpportunity(
    TrainingOpportunity trainingOpportunity,
  ) async {
    try {
      var result = await firebaseFirestore
          .collection('training_opportunities')
          .add(trainingOpportunity.toJson());
      trainingOpportunity.id = result.id;
      trainingOpportunity.companyId = firebaseAuth.currentUser!.uid;
      await firebaseFirestore
          .collection('training_opportunities')
          .doc(result.id)
          .set(trainingOpportunity.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> deleteTrainingCourse(
    String trainingCourseId,
  ) async {
    try {
      await firebaseFirestore
          .collection('training_courses')
          .doc(trainingCourseId)
          .delete();
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> deleteTrainingOpportunity(
    String trainingOpportunityId,
  ) async {
    try {
      await firebaseFirestore
          .collection('training_opportunities')
          .doc(trainingOpportunityId)
          .delete();
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<TrainingCourse>>> getAllTrainingCourses() async {
    try {
      List<TrainingCourse> trainingCourses = [];
      await firebaseFirestore
          .collection('training_courses')
          .where('company_id', isEqualTo: firebaseAuth.currentUser!.uid)
          .get()
          .then((value) async {
            for (var element in value.docs) {
              var trainingCourse = TrainingCourse.fromMap(element.data());
              List<AppUser> users = [];
              var trainingApplications =
                  (await firebaseFirestore
                          .collection('training_applications')
                          .where(
                            'companyId',
                            isEqualTo: firebaseAuth.currentUser!.uid,
                          )
                          .where('trainingId', isEqualTo: trainingCourse.id)
                          .get())
                      .docs;
              for (var element in trainingApplications) {
                var us = await getUser(element.data()['studentId']);
                users.add(us);
              }
              trainingCourse.participants = users;
              trainingCourses.add(trainingCourse);
            }
          });
      return Right(trainingCourses);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<TrainingOpportunity>>>
  getAllTrainingOpportunities() async {
    try {
      List<TrainingOpportunity> trainingOpportunities = [];
      await firebaseFirestore
          .collection('training_opportunities')
          .where('companyId', isEqualTo: firebaseAuth.currentUser!.uid)
          .get()
          .then((value) async {
            for (var element in value.docs) {
              var trainingOpportunity = TrainingOpportunity.fromJson(
                element.data(),
              );
              List<AppUser> users = [];
              var trainingApplications =
                  (await firebaseFirestore
                          .collection('training_applications')
                          .where(
                            'companyId',
                            isEqualTo: firebaseAuth.currentUser!.uid,
                          )
                          .where(
                            'trainingId',
                            isEqualTo: trainingOpportunity.id,
                          )
                          .get())
                      .docs;
              for (var element in trainingApplications) {
                var us = await getUser(element.data()['studentId']);
                users.add(us);
              }
              trainingOpportunity.participants = users;
              trainingOpportunities.add(trainingOpportunity);
            }
          });
      return Right(trainingOpportunities);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> updateTrainingCourse(
    TrainingCourse trainingCourse,
  ) async {
    try {
      await firebaseFirestore
          .collection('training_courses')
          .doc(trainingCourse.id)
          .update(trainingCourse.toMap());
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> updateTrainingOpportunity(
    TrainingOpportunity trainingOpportunity,
  ) async {
    try {
      await firebaseFirestore
          .collection('training_opportunities')
          .doc(trainingOpportunity.id)
          .update(trainingOpportunity.toJson());

      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<TrainingType>>> getAllTrainingTypes() async {
    try {
      List<TrainingType> trainingTypes = [];
      await firebaseFirestore.collection('training_types').get().then((value) {
        for (var element in value.docs) {
          trainingTypes.add(TrainingType.fromMap(element.data()));
        }
      });
      return Right(trainingTypes);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<TrainingApplication>>>
  getTrainingApplications() async {
    try {
      List<TrainingApplication> trainingApplications = [];
      await firebaseFirestore
          .collection('training_applications')
          .where('companyId', isEqualTo: firebaseAuth.currentUser!.uid)
          .get()
          .then((value) async {
            for (var element in value.docs) {
              var trainingApplication = TrainingApplication.fromMap(
                element.data(),
              );
              trainingApplication.student = await getUser(
                trainingApplication.studentId ?? "",
              );

              trainingApplications.add(trainingApplication);
            }
          });
      return Right(trainingApplications);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  Future<AppUser> getUser(String userId) async {
    var user = await firebaseFirestore.collection('users').doc(userId).get();
    return AppUser.fromMap(user.data()!);
  }

  @override
  Future<Either<Failure, void>> updateTrainingApplication(
    TrainingApplication trainingApplication,
  ) async {
    try {
      await firebaseFirestore
          .collection('training_applications')
          .doc(trainingApplication.id)
          .set(trainingApplication.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, AppUser>> getMyProfile() async {
    try {
      var user = await getUser(firebaseAuth.currentUser!.uid);
      return Right(user);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> updateUser(AppUser user) async {
    try {
      if (user.companyLogo?.startsWith('/data/user/') ?? false) {
        {
          user.companyLogo =
              await clientServiceApi.uploadImageToCloudinary(
                File(user.companyLogo ?? ""),
              ) ??
              "";
        }
      }
      await firebaseFirestore
          .collection('users')
          .doc(user.id)
          .set(user.toMap());
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
