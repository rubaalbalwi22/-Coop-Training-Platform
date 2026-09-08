import 'package:train_link/presentation/student/training_report/controller/training_report_controller.dart';

import '../../../../core/app_export.dart';

class TrainingReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() =>  TrainingReportController());
  }
}