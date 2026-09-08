import 'package:get_storage/get_storage.dart';

import '../../../core/app_export.dart';

class OnboardingController extends GetxController {
  final storage = GetStorage();

  void completeOnboarding() {
    storage.write('onboarding_completed', true);
    storage.write('locale', 'ar'); // حفظ اللغة العربية
  }

  bool isOnboardingCompleted() {
    return storage.read('onboarding_completed') ?? false;
  }
}