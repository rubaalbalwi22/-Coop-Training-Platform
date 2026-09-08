// student/controllers/training_application_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';
import 'package:train_link/presentation/student/training_opportunity/model/training_application_model.dart';

import '../../../../data/user_remote_data_source/user_remote_data_source.dart';

class TrainingApplicationController extends GetxController {
  final RxString applicationMessage = ''.obs;
  final TextEditingController messageController = TextEditingController();

  final UserRemoteDataSource userRemoteDataSource =
      Get.find<UserRemoteDataSourceImpl>();
  final Rx<FlowState> flowState = Rx<FlowState>(ContentState());

  Future<void> applyForTraining(
    String trainingId,
    String companyId,
    TrainingApplicationType type,
      String title,
      int duration,
      DateTime endDate



  ) async {
    flowState.value = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );
    applicationMessage('');
    (await userRemoteDataSource.applyForTraining(
      TrainingApplication(
        trainingId: trainingId,
        requestMsg: messageController.text,
        status: 'pending',
        appliedAt: DateTime.now(),
        type: type,
        companyId:  companyId,
        title: title,
        duration: duration ,
        endDate: endDate ,
      ),
    )).fold(
      (l) {
        flowState.value = ErrorState(
          StateRendererType.popupErrorState,
          l.message,
        );
      },
      (r) {
        applicationMessage('تم تقديم طلبك بنجاح وسيتم مراجعته قريباً');
        messageController.clear();
        flowState.value = SuccessState(
          StateRendererType.popupSuccessState,
          'تم تقديم طلبك بنجاح وسيتم مراجعته قريباً',
        );
      },
    );
  }
}
