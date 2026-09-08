import '../../../../core/app_export.dart';
import '../controller/comment_management_controller.dart';

class ListCommentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CommentManagementController());
  }
}