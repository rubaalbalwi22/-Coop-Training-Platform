import '../../../../core/app_export.dart';
import '../controller/main_controller.dart';

class CompanyMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompanyMainController>(() => CompanyMainController());
  }
}