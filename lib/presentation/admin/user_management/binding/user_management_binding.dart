import '../../../../core/app_export.dart';
import '../controller/user_management_controller.dart';

class UserManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserManagementController>(() => UserManagementController());
  }
}