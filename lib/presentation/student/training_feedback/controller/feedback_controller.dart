// student/controllers/feedback_controller.dart
import 'package:flutter/material.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';
import 'package:train_link/data/user_remote_data_source/user_remote_data_source.dart';

import '../../../../core/app_export.dart';
import '../../../../core/utils/state_renderer/state_renderer.dart';
import '../../training_report/controller/training_report_controller.dart';
import '../model/training_feedback_model.dart';

class FeedbackController extends GetxController {
  final RxList<TrainingFeedback> feedbacks = <TrainingFeedback>[].obs;
  final RxInt rating = 0.obs;
  final TextEditingController commentController = TextEditingController();
  final RxBool isAnonymous = false.obs;
  final UserRemoteDataSource userRemoteDataSource =
      Get.find<UserRemoteDataSourceImpl>();
  final Rx<FlowState> flowState = Rx<FlowState>(ContentState());

  @override
  onInit() {
    super.onInit();
  }

  Future<void> submitFeedback(String trainingId) async {
    if (rating.value == 0) {
      Get.snackbar('خطأ', 'الرجاء اختيار تقييم');
      return;
    }

    if (commentController.text.isEmpty) {
      Get.snackbar('خطأ', 'الرجاء كتابة تعليقك');
      return;
    }
    flowState.value = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );
    var feedback = TrainingFeedback(
      trainingId: trainingId,
      rating: rating.value,
      comment: commentController.text,
      submittedAt: DateTime.now(),
      isAnonymous: isAnonymous.value,
    );

    (await userRemoteDataSource.addTrainingFeedback(feedback)).fold(
      (l) {
        flowState.value = ErrorState(
          StateRendererType.popupErrorState,
          l.message,
        );
      },
      (r) {
        // إعادة تعيين الحقول
        rating.value = 0;
        commentController.clear();
        isAnonymous.value = false;
        flowState.value = SuccessState(
          StateRendererType.popupSuccessState,
          'تم تقديم التقييم بنجاح',
        );
        Get.find<TrainingReportController>().fetchReports();
      },
    );
  }
}
