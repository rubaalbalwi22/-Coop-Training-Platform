import '../../../../core/app_export.dart';
import '../controller/training_type_controller.dart';

class TrainingTypeViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TrainingTypeController());
  }
}