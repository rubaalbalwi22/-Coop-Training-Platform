import '../../../../core/app_export.dart';
import '../controller/training_opportunity_controller.dart';

class CompanyTrainingOpportunityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TrainingOpportunityController());
  }
}