import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:train_link/data/client_service/client_service_api.dart';
import 'package:train_link/presentation/admin/universities/models/university_model.dart';
import 'package:train_link/presentation/admin/user_management/model/user_model.dart';

import '../../core/errors/error_handler.dart';
import '../../core/errors/failure.dart';
import '../../presentation/admin/specialization/model/specialization_model.dart';
import '../../presentation/company/training_course/model/training_course_model.dart';
import '../../presentation/company/training_opportunity/model/training_opportunity_model.dart';
import '../../presentation/student/training_feedback/model/training_feedback_model.dart';
import '../../presentation/student/training_opportunity/model/training_application_model.dart';
import '../../presentation/student/training_report/model/training_report_model.dart';

abstract class UserRemoteDataSource {
  Future<Either<Failure, List<TrainingOpportunity>>>
  getAllTrainingOpportunities();

  Future<Either<Failure, List<TrainingCourse>>> getAllTrainingCourses();
  Future<Either<Failure, List<Specialization>>> getAllSpecializations();
  Future<Either<Failure, List<University>>> getAllUniversities();

  Future<Either<Failure, void>> applyForTraining(
    TrainingApplication trainingApplication,
  );

  Future<Either<Failure, List<TrainingApplication>>> getTrainingApplications();
  Future<Either<Failure, void>> uploadReport(TrainingReport trainingReport);
  Future<Either<Failure, void>> addTrainingFeedback(
    TrainingFeedback trainingFeedback,
  );
  Future<Either<Failure, List<TrainingReport>>> getAllTrainingReports();
  Future<Either<Failure, AppUser>> getMyProfile();
  Future<Either<Failure, void>> updateUser(
    AppUser user, {
    String? oldPassword,
    String? newPassword,
  });
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  FirebaseFirestore firebaseFirestore;
  FirebaseAuth firebaseAuth;
  ClientServiceApi clientServiceApi;
  UserRemoteDataSourceImpl({
    required this.firebaseFirestore,
    required this.firebaseAuth,
    required this.clientServiceApi,
  });
  @override
  Future<Either<Failure, List<TrainingCourse>>> getAllTrainingCourses() async {
    try {
      List<TrainingCourse> trainingCourses = [];
      await firebaseFirestore
          .collection('training_courses')
          .where('status', isEqualTo: 0)
          .get()
          .then((value) async {
            for (var element in value.docs) {
              if (await firebaseFirestore
                  .collection('training_applications')
                  .where('trainingId', isEqualTo: element.id)
                  .where('studentId', isEqualTo: firebaseAuth.currentUser!.uid)
                  .get()
                  .then((value) => value.docs.isEmpty)) {
                var trainingCourse = TrainingCourse.fromMap(element.data());
                trainingCourse.companyName = (await getUser(trainingCourse.companyId??"")).companyName;

                trainingCourses.add(trainingCourse);
              }
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
          .where('status', isEqualTo: 'approved')
          .get()
          .then((value) async {
            for (var element in value.docs) {
              if (await firebaseFirestore
                  .collection('training_applications')
                  .where('trainingId', isEqualTo: element.id)
                  .where('studentId', isEqualTo: firebaseAuth.currentUser!.uid)
                  .get()
                  .then((value) => value.docs.isEmpty)) {
                var trainingOpportunity =
                    TrainingOpportunity.fromJson(element.data());
                trainingOpportunity.companyName = (await  getUser(trainingOpportunity.companyId??"")).companyName;
                trainingOpportunities.add(
                  trainingOpportunity
                );
              }
            }
          });
      return Right(trainingOpportunities);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<Specialization>>> getAllSpecializations() async {
    try {
      List<Specialization> specializations = [];
      await firebaseFirestore.collection('specializations').get().then((value) {
        for (var element in value.docs) {
          specializations.add(Specialization.fromMap(element.data()));
        }
      });
      return Right(specializations);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> applyForTraining(
    TrainingApplication trainingApplication,
  ) async {
    try {
      var snapshot = await firebaseFirestore
          .collection('training_applications')
          .where('trainingId', isEqualTo: trainingApplication.trainingId)
          .where('studentId', isEqualTo: firebaseAuth.currentUser!.uid)
          .get();
      if (snapshot.docs.isNotEmpty) {
        return Left(Failure('01', 'لقد قمت بالفعل بتسجيل طلبك على هذه الفرصة'));
      }

      var result = await firebaseFirestore
          .collection('training_applications')
          .add(trainingApplication.toJson());
      trainingApplication.id = result.id;
      trainingApplication.studentId = firebaseAuth.currentUser!.uid;

      await firebaseFirestore
          .collection('training_applications')
          .doc(result.id)
          .set(trainingApplication.toJson());
      return const Right(null);
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
          .where('studentId', isEqualTo: firebaseAuth.currentUser!.uid)
          .get()
          .then((value) {
            for (var element in value.docs) {
              if (element.data()['status'] == 'approved' ||
                  element.data()['status'] == 'rejected' ||
                  element.data()['status'] == 'pending') {
                trainingApplications.add(
                  TrainingApplication.fromMap(element.data()),
                );
              }
            }
          });
      return Right(trainingApplications);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> uploadReport(
    TrainingReport trainingReport,
  ) async {
    try {
      if (trainingReport.filePath == '') {
        return Left(Failure('02', 'الرجاء اختيار الملف'));
      }

      if (await firebaseFirestore
          .collection('training_reports')
          .where('studentId', isEqualTo: firebaseAuth.currentUser!.uid)
          .where('trainingId', isEqualTo: trainingReport.trainingId)
          .get()
          .then((value) => value.docs.isNotEmpty)) {
        return Left(
          Failure('03', 'لقد قمت بالفعل بتسجيل تقريرك على هذه الفرصة'),
        );
      }

      if (trainingReport.filePath?.startsWith('/data/user/') ?? false) {
        trainingReport.filePath =
            await clientServiceApi.uploadImageToCloudinary(
              File(trainingReport.filePath ?? ""),
            ) ??
            "";
      }
      trainingReport.studentId = firebaseAuth.currentUser!.uid;

      var result = await firebaseFirestore
          .collection('training_reports')
          .add(trainingReport.toJson());
      trainingReport.id = result.id;
      await firebaseFirestore
          .collection('training_reports')
          .doc(result.id)
          .set(trainingReport.toJson());

      await firebaseFirestore
          .collection('training_applications')
          .doc(trainingReport.trainingId)
          .update({'status': 'unrated'});
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<TrainingReport>>> getAllTrainingReports() async {
    try {
      List<TrainingReport> trainingReports = [];
      await firebaseFirestore.collection('training_reports').get().then((
        value,
      ) async {
        for (var element in value.docs) {
          var trainingReport = TrainingReport.fromJson(element.data());
          trainingReport.id = element.id;
          trainingReport.student = await getUser(
            trainingReport.studentId ?? "",
          );
          trainingReport.trainingApplication = await getTrainingApplication(
            trainingReport.trainingId ?? "",
          );
          trainingReport.trainingFeedback = (await getTrainingFeedback(
            trainingReport.trainingId ?? "",
          ));
          trainingReports.add(trainingReport);
        }
      });
      return Right(trainingReports);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  Future<TrainingFeedback?> getTrainingFeedback(String trainingId) async {
    var trainingFeedback = await firebaseFirestore
        .collection('training_feedbacks')
        .where('trainingId', isEqualTo: trainingId)
        .where('studentId', isEqualTo: firebaseAuth.currentUser!.uid)
        .get();
    if (trainingFeedback.docs.isNotEmpty) {
      return TrainingFeedback.fromJson(trainingFeedback.docs.first.data());
    } else {
      return null;
    }
  }

  Future<AppUser> getUser(String userId) async {
    var user = await firebaseFirestore.collection('users').doc(userId).get();
    return AppUser.fromMap(user.data()!);
  }

  Future<TrainingApplication> getTrainingApplication(String trainingId) async {
    var trainingApplication = await firebaseFirestore
        .collection('training_applications')
        .doc(trainingId)
        .get();
    return TrainingApplication.fromMap(trainingApplication.data()!);
  }

  @override
  Future<Either<Failure, void>> addTrainingFeedback(
    TrainingFeedback trainingFeedback,
  ) async {
    try {
      trainingFeedback.studentId = firebaseAuth.currentUser!.uid;
      trainingFeedback.submittedAt = DateTime.now();
      var result = await firebaseFirestore
          .collection('training_feedbacks')
          .add(trainingFeedback.toJson());
      trainingFeedback.id = result.id;
      await firebaseFirestore
          .collection('training_feedbacks')
          .doc(result.id)
          .set(trainingFeedback.toJson());

      await firebaseFirestore
          .collection('training_applications')
          .doc(trainingFeedback.trainingId)
          .update({'status': 'rated'});
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
  Future<Either<Failure, List<University>>> getAllUniversities() async {
    try {
      List<University> universities = [];
      await firebaseFirestore.collection('universities').get().then((value) {
        for (var element in value.docs) {
          universities.add(University.fromMap(element.data()));
        }
      });
      return Right(universities);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> updateUser(
    AppUser user, {
    String? oldPassword,
    String? newPassword,
  }) async {
    try {
      if (user.cvUrl?.startsWith('/data/user/') ?? false) {
        user.cvUrl =
            await clientServiceApi.uploadImageToCloudinary(
              File(user.cvUrl ?? ""),
            ) ??
            "";
      }

      await firebaseFirestore
          .collection('users')
          .doc(user.id)
          .set(user.toMap());
      if (oldPassword != null && newPassword != null) {
        var result = await firebaseAuth.currentUser!
            .reauthenticateWithCredential(
              EmailAuthProvider.credential(
                email: firebaseAuth.currentUser!.email ?? "",
                password: oldPassword,
              ),
            );

        if (result.user == null) {
          return Left(Failure('04', 'كلمة المرور القديمة غير صحيحة'));
        }
        await firebaseAuth.currentUser!.updatePassword(newPassword);

        await firebaseFirestore.collection('users').doc(user.id).update({
          'password': newPassword,
        });
      }

      return const Right(null);
    } catch (e) {
      if ((e as FirebaseAuthException).code.toString() ==
          'invalid-credential') {
        return Left(Failure('04', 'كلمة المرور القديمة غير صحيحة'));
      }
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
