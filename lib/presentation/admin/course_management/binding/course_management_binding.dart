import '../../../../core/app_export.dart';
import '../controller/course_management_controller.dart';

class CourseManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CourseManagementController>(() => CourseManagementController());
  }
}