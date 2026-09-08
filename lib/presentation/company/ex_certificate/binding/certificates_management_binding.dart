import 'package:train_link/presentation/company/ex_certificate/controller/certificate_controller.dart';

import '../../../../core/app_export.dart';

class ManageCertificatesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ManageCertificateController());
  }
}