import 'package:train_link/core/app_export.dart';
import 'package:train_link/presentation/company/training_course/controller/training_course_controller.dart';

class TrainingCourseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrainingCourseController>(() => TrainingCourseController());
  }
}