import '../../../../core/app_export.dart';
import '../../training_report/controller/training_report_controller.dart';
import '../controller/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut(() =>  TrainingReportController());
  }
}