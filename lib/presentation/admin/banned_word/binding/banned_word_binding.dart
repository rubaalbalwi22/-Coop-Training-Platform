import '../../../../core/app_export.dart';
import '../controller/banned_word_controller.dart';

class BannedWordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BannedWordController());
  }
}