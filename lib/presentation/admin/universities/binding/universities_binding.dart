import '../../../../core/app_export.dart';
import '../controller/university_controller.dart';

class UniversitiesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UniversityController());
  }
}