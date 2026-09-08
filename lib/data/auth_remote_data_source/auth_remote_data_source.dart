import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:train_link/core/errors/error_handler.dart';
import 'package:train_link/data/client_service/client_service_api.dart';
import 'package:train_link/presentation/admin/user_management/model/user_model.dart';
import '../../core/constants/constant.dart';
import '../../core/errors/failure.dart';
import '../../presentation/admin/specialization/model/specialization_model.dart';
import '../../presentation/admin/universities/models/university_model.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, UserRole>> login(String email, String password);
  Future<Either<Failure, UserRole>> register(AppUser registerModel);
  Future<Either<Failure, void>> forgetPassword(String email);
  Future<Either<Failure, UserRole>> isLoggedIn();
  Future<Either<Failure, List<Specialization>>> getAllSpecializations();
  Future<Either<Failure, List<University>>> getAllUniversities();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  FirebaseAuth firebaseAuth;
  FirebaseFirestore firebaseFirestore;
  ClientServiceApi clientServiceApi;
  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firebaseFirestore,
    required this.clientServiceApi,
  });
  @override
  Future<Either<Failure, UserRole>> login(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      var userCheckStatus = await firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .get()
          .then((value) => value.data()!['status']);
      if (userCheckStatus == 0) {
        return Left(
          Failure(
            '00',
            'لا يمكنك تسجيل الدخول حتى يتم موافقة الإدارة على طلبك',
          ),
        );
      }
      var userActiveCheck = await firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .get()
          .then((value) => value.data()!['isActive']);
      if (userActiveCheck == false) {
        return Left(DataSource.USER_DISABLED.getFailure());
      }

      var userRole = await firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .get()
          .then((value) => value.data()!['type']);
      if (userRole == 0) {
        return Right(UserRole.student);
      } else if (userRole == 1) {
        return Right(UserRole.company);
      } else {
        return Right(UserRole.admin);
      }
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> forgetPassword(String email) async {
    try {
      return Right(await firebaseAuth.sendPasswordResetEmail(email: email));
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, UserRole>> register(AppUser registerModel) async {
    try {
      if (registerModel.cvUrl != null) {
        registerModel.cvUrl = await clientServiceApi.uploadImageToCloudinary(
          File(registerModel.cvUrl!),
        );
      }

      if (registerModel.companyLogo != null) {
        registerModel.companyLogo = await clientServiceApi
            .uploadImageToCloudinary(File(registerModel.companyLogo!));
      }

      await firebaseAuth.createUserWithEmailAndPassword(
        email: registerModel.email,
        password: registerModel.password!,
      );
      registerModel.id = firebaseAuth.currentUser!.uid;
      await firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .set(registerModel.toMap());
      if (registerModel.type.toShortString() == 'student') {
        return Right(UserRole.student);
      } else if (registerModel.type.toShortString() == 'company') {
        return Right(UserRole.company);
      } else {
        return Right(UserRole.admin);
      }
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
  Future<Either<Failure, UserRole>> isLoggedIn() async {
    try {
      if (firebaseAuth.currentUser != null) {
        var userRole = await firebaseFirestore
            .collection('users')
            .doc(firebaseAuth.currentUser!.uid)
            .get()
            .then((value) => value.data()!['type']);
        if (userRole == 0) {
          return Right(UserRole.student);
        } else if (userRole == 1) {
          return Right(UserRole.company);
        } else {
          return Right(UserRole.admin);
        }
      } else {
        return Right(UserRole.unknown);
      }
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
