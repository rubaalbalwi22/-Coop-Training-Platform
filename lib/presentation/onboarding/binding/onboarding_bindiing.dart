import '../../../core/app_export.dart';
import '../controller/onboarding_controller.dart';

class OnBoardingBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OnboardingController());
  }
}