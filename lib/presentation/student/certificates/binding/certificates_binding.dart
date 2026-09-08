import 'package:train_link/presentation/student/certificates/controller/certificate_controller.dart';

import '../../../../core/app_export.dart';

class MyCertificatesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyCertificateController());
  }
}