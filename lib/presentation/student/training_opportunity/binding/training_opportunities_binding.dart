import '../../../../core/app_export.dart';
import '../controller/training_application_controller.dart';
import '../controller/training_opportunities_controller.dart';

class TrainingOpportunitiesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TrainingOpportunitiesController());
    Get.lazyPut(() => TrainingApplicationController());
  }
}