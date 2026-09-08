import '../../../../core/app_export.dart';
import '../controller/training_management_controller.dart';

class TrainingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TrainingManagementController());
  }
}