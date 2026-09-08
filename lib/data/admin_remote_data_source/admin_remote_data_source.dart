import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:train_link/presentation/admin/universities/models/university_model.dart';
import 'package:train_link/presentation/student/training_feedback/model/training_feedback_model.dart';
import 'package:train_link/presentation/student/training_opportunity/model/training_application_model.dart';
import 'package:train_link/presentation/student/training_report/model/training_report_model.dart';

import '../../core/errors/error_handler.dart';
import '../../core/errors/failure.dart';
import '../../presentation/admin/banned_word/model/banned_word_model.dart';
import '../../presentation/admin/specialization/model/specialization_model.dart';
import '../../presentation/admin/training_types/models/training_type_model.dart';
import '../../presentation/admin/user_management/model/user_model.dart';
import '../../presentation/company/training_course/model/training_course_model.dart';
import '../../presentation/company/training_opportunity/model/training_opportunity_model.dart';

abstract class AdminRemoteDataSource {
  Future<Either<Failure, void>> addUniversity(University universityModel);
  Future<Either<Failure, void>> updateUniversity(University universityModel);
  Future<Either<Failure, void>> deleteUniversity(String universityId);
  Future<Either<Failure, List<University>>> getAllUniversities();

  Future<Either<Failure, void>> addTrainingType(TrainingType trainingTypeModel);
  Future<Either<Failure, void>> updateTrainingType(
    TrainingType trainingTypeModel,
  );
  Future<Either<Failure, void>> deleteTrainingType(String trainingTypeId);
  Future<Either<Failure, List<TrainingType>>> getAllTrainingTypes();

  Future<Either<Failure, void>> addSpecialization(
    Specialization specializationModel,
  );
  Future<Either<Failure, void>> updateSpecialization(
    Specialization specializationModel,
  );
  Future<Either<Failure, void>> deleteSpecialization(String specializationId);
  Future<Either<Failure, List<Specialization>>> getAllSpecializations();

  Future<Either<Failure, void>> addBannedWord(BannedWord bannedWord);
  Future<Either<Failure, void>> updateBannedWord(BannedWord bannedWord);
  Future<Either<Failure, void>> deleteBannedWord(String bannedWordId);
  Future<Either<Failure, List<BannedWord>>> getAllBannedWords();
  Future<Either<Failure, List<AppUser>>> getAllUsers();
  Future<Either<Failure, void>> updateUser(AppUser user);

  Future<Either<Failure, List<TrainingCourse>>> getAllTrainingCourses();

  Future<Either<Failure, void>> updateTrainingCourse(
    TrainingCourse trainingCourse,
  );

  Future<Either<Failure, List<TrainingOpportunity>>>
  getAllTrainingOpportunities();
  Future<Either<Failure, void>> updateTrainingOpportunity(
    TrainingOpportunity trainingOpportunity,
  );
  Future<Either<Failure, List<TrainingReport>>> getAllTrainingReports();
  Future<Either<Failure,List<TrainingFeedback>>> getTrainingFeedback();
  Future<Either<Failure,void>> deleteTrainingFeedback(String trainingId);
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  FirebaseFirestore firebaseFirestore;

  AdminRemoteDataSourceImpl({required this.firebaseFirestore});
  @override
  Future<Either<Failure, void>> addUniversity(
    University universityModel,
  ) async {
    try {
      var result = await firebaseFirestore
          .collection('universities')
          .add(universityModel.toMap());
      universityModel.id = result.id;
      await firebaseFirestore
          .collection('universities')
          .doc(result.id)
          .set(universityModel.toMap());
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> deleteUniversity(String universityId) async {
    try {
      await firebaseFirestore
          .collection('universities')
          .doc(universityId)
          .delete();
      return const Right(null);
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
  Future<Either<Failure, void>> updateUniversity(
    University universityModel,
  ) async {
    try {
      firebaseFirestore
          .collection('universities')
          .doc(universityModel.id)
          .update(universityModel.toMap());
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> addTrainingType(
    TrainingType trainingTypeModel,
  ) async {
    try {
      var result = await firebaseFirestore
          .collection('training_types')
          .add(trainingTypeModel.toMap());
      trainingTypeModel.id = result.id;
      await firebaseFirestore
          .collection('training_types')
          .doc(result.id)
          .set(trainingTypeModel.toMap());
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> deleteTrainingType(
    String trainingTypeId,
  ) async {
    try {
      await firebaseFirestore
          .collection('training_types')
          .doc(trainingTypeId)
          .delete();
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
  Future<Either<Failure, void>> updateTrainingType(
    TrainingType trainingTypeModel,
  ) async {
    try {
      firebaseFirestore
          .collection('training_types')
          .doc(trainingTypeModel.id)
          .update(trainingTypeModel.toMap());
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> addSpecialization(
    Specialization specializationModel,
  ) async {
    try {
      var result = await firebaseFirestore
          .collection('specializations')
          .add(specializationModel.toMap());
      specializationModel.id = result.id;
      await firebaseFirestore
          .collection('specializations')
          .doc(result.id)
          .set(specializationModel.toMap());
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> deleteSpecialization(
    String specializationId,
  ) async {
    try {
      await firebaseFirestore
          .collection('specializations')
          .doc(specializationId)
          .delete();
      return const Right(null);
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
  Future<Either<Failure, void>> updateSpecialization(
    Specialization specializationModel,
  ) async {
    try {
      firebaseFirestore
          .collection('specializations')
          .doc(specializationModel.id)
          .update(specializationModel.toMap());
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> addBannedWord(BannedWord bannedWord) async {
    try {
      var result = await firebaseFirestore
          .collection('banned_words')
          .add(bannedWord.toMap());
      bannedWord.id = result.id;
      await firebaseFirestore
          .collection('banned_words')
          .doc(result.id)
          .set(bannedWord.toMap());
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> deleteBannedWord(String bannedWordId) async {
    try {
      await firebaseFirestore
          .collection('banned_words')
          .doc(bannedWordId)
          .delete();
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<BannedWord>>> getAllBannedWords() async {
    try {
      List<BannedWord> bannedWords = [];
      await firebaseFirestore.collection('banned_words').get().then((value) {
        for (var element in value.docs) {
          bannedWords.add(BannedWord.fromMap(element.data()));
        }
      });
      return Right(bannedWords);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> updateBannedWord(BannedWord bannedWord) async {
    try {
      firebaseFirestore
          .collection('banned_words')
          .doc(bannedWord.id)
          .update(bannedWord.toMap());
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<AppUser>>> getAllUsers() async {
    try {
      List<AppUser> users = [];
      var value = await firebaseFirestore.collection('users').get();
      for (var element in value.docs) {
        users.add(AppUser.fromMap(element.data()));
      }
      return Right(users);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> updateUser(AppUser user) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(user.id)
          .set(user.toMap());
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<TrainingCourse>>> getAllTrainingCourses() async {
    try {
      List<TrainingCourse> trainingCourses = [];
      await firebaseFirestore.collection('training_courses').get().then((
        value,
      )async {
        for (var element in value.docs) {
          var trainingCourse =TrainingCourse.fromMap(element.data()) ;
          trainingCourse.companyName = (await getUser(trainingCourse.companyId??"")).companyName;
          trainingCourses.add(trainingCourse);
        }
      });
      return Right(trainingCourses);
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
  Future<Either<Failure, List<TrainingOpportunity>>>
  getAllTrainingOpportunities() async {
    try {
      List<TrainingOpportunity> trainingOpportunities = [];
      await firebaseFirestore.collection('training_opportunities').get().then((
        value,
      ) {
        for (var element in value.docs) {
          trainingOpportunities.add(
            TrainingOpportunity.fromJson(element.data()),
          );
        }
      });
      return Right(trainingOpportunities);
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
  Future<Either<Failure, List<TrainingReport>>> getAllTrainingReports() async {
    try {
      List<TrainingReport> trainingReports = [];
      await firebaseFirestore.collection('training_reports').get().then((
        value,
      ) async{
        for (var element in value.docs) {
          var trainingReport = TrainingReport.fromJson(element.data());
          trainingReport.id = element.id;
          trainingReport.student =  await getUser(trainingReport.studentId??"");
          trainingReport.trainingApplication =await getTrainingApplication(
            trainingReport.trainingId??"",
          );
          trainingReports.add(trainingReport);
        }
      });
      return Right(trainingReports);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  Future<AppUser> getUser(String userId) => firebaseFirestore
      .collection('users')
      .doc(userId)
      .get()
      .then((value) => AppUser.fromMap(value.data()!));

  Future<TrainingApplication> getTrainingApplication(
    String trainingId,
  ) {
    return firebaseFirestore
      .collection('training_applications')
      .doc(trainingId)
      .get()
      .then((value) => TrainingApplication.fromMap(value.data()!));
  }

  @override
  Future<Either<Failure, void>> deleteTrainingFeedback(String trainingId) async{
     try {
      await firebaseFirestore
          .collection('training_feedbacks')
          .doc(trainingId)
          .delete();
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<TrainingFeedback>>> getTrainingFeedback() async{
    try {
      List<TrainingFeedback> trainingFeedbacks = [];
      await firebaseFirestore
          .collection('training_feedbacks')
           .get()
          .then((value) async{
        for (var element in value.docs) {
          var trainingFeedback =TrainingFeedback.fromJson(element.data());
          trainingFeedback.student =await  getUser(trainingFeedback.studentId??"");
          trainingFeedbacks.add(trainingFeedback);
        }
      });
      return Right(trainingFeedbacks);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
