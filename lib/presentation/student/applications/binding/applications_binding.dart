import '../../../../core/app_export.dart';
import '../controller/applications_controller.dart';

class ApplicationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApplicationsController>(() => ApplicationsController());
  }
}