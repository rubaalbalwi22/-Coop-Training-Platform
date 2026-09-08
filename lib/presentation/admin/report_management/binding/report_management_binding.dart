import '../../../../core/app_export.dart';
import '../controller/report_management_controller.dart';

class ReportManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportManagementController>(() => ReportManagementController());
  }
}