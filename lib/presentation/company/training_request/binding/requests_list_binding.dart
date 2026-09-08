import 'package:train_link/core/app_export.dart';
import 'package:train_link/presentation/company/training_request/controller/training_request_controller.dart';

class RequestsListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TrainingRequestController());
  }
}