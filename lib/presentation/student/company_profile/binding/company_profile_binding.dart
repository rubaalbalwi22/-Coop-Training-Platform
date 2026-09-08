import '../../../../core/app_export.dart';
import '../controller/company_profile_controller.dart';

class CompanyProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompanyProfileController>(() => CompanyProfileController());
  }
}