import '../../../../core/app_export.dart';
import '../controller/specialization_controller.dart';

class SpecializationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SpecializationController());
  }
}