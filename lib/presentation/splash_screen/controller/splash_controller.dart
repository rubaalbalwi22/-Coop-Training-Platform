import 'dart:async';
import 'package:train_link/data/auth_remote_data_source/auth_remote_data_source.dart';

import '../../../core/app_export.dart';
import '../../../core/constants/constant.dart';

/// A controller class for the SplashScreen.
///
/// This class manages the state of the SplashScreen, including the
/// current splashModelObj
class SplashController extends GetxController {
  //Rx<SplashModel> splashModelObj = SplashModel().obs;
final AuthRemoteDataSource authRemoteDataSource = Get.find<AuthRemoteDataSourceImpl>();

  @override
  void onInit() {
    Timer(Duration(seconds: 3), () async{
      (await authRemoteDataSource.isLoggedIn()).fold((l) {
        Get.offAllNamed(AppRoutes.onboardingScreen);
      }, (r) {
        if (r == UserRole.student) {
          Get.offAllNamed(AppRoutes.userMainScreen);
        } else if (r == UserRole.company) {
          Get.offAllNamed(AppRoutes.companyMainScreen);
        } else if (r == UserRole.admin) {
          Get.offAllNamed(AppRoutes.listOfUniversityScreen);
        } else {
          Get.offAllNamed(AppRoutes.onboardingScreen);
        }
      }
      );

    });
    super.onInit();
  }
}
