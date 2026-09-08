// company/controllers/training_request_controller.dart
import 'package:flutter/material.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';
import 'package:train_link/data/company_remote_data_source/company_remote_data_source.dart';

import '../../../../core/app_export.dart';
import '../../../student/training_opportunity/model/training_application_model.dart';
import '../../training_opportunity/model/training_opportunity_model.dart';
import '../model/training_request_model.dart';

class TrainingRequestController extends GetxController {
  final RxList<TrainingApplication> requests = <TrainingApplication>[].obs;
  final RxString selectedFilter = 'الكل'.obs;

  final List<String> filters = ['الكل', 'قيد المراجعة', 'مقبولة', 'مرفوضة'];

  final TextEditingController responseController = TextEditingController();
  final CompanyRemoteDataSource companyRemoteDataSource =
      Get.find<CompanyRemoteDataSourceImpl>();
  final Rx<FlowState> flowState = Rx<FlowState>(
    LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState),
  );

  @override
  void onInit() {
    fetchRequests();
    super.onInit();
  }

  Future<void> fetchRequests() async {
    flowState.value = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );
    (await companyRemoteDataSource.getTrainingApplications()).fold(
      (l) {
        flowState.value = ErrorState(
          StateRendererType.popupErrorState,
          l.message,
        );
      },
      (r) {
        requests.assignAll(r);

        flowState.value = ContentState();
      },
    );
  }

  List<TrainingApplication> get filteredRequests {
    List<TrainingApplication> filtered = requests;

    // تصفية حسب حالة الطلب
    if (selectedFilter.value != 'الكل') {
      filtered = filtered.where((req) {
        switch (selectedFilter.value) {
          case 'قيد المراجعة':
            return req.status == 'pending';
          case 'مقبولة':
            return req.status == 'approved' || req.status == 'rated' || req.status == 'unrated';
          case 'مرفوضة':
            return req.status == 'rejected';
          default:
            return true;
        }
      }).toList();
    }



    return filtered;
  }

  Future<void> approveRequest(String requestId, String response) async {
    flowState.value = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );

    final index = requests.indexWhere((req) => req.id == requestId);
    if (index != -1) {
      requests[index] = requests[index].copyWith(
        status: 'approved',
        responseMessage: response,
        processedAt: DateTime.now(),
      );
    }

    (await companyRemoteDataSource.updateTrainingApplication(
      requests[index],
    )).fold(
      (l) {
        flowState.value = ErrorState(
          StateRendererType.popupErrorState,
          l.message,
        );
      },
      (r) {
        responseController.clear();
        flowState.value =SuccessState(StateRendererType.popupSuccessState, 'تم قبول الطلب بنجاح');
      },
    );
  }

  Future<void> rejectRequest(String requestId, String response) async {
    final index = requests.indexWhere((req) => req.id == requestId);
    if (index != -1) {
      requests[index] = requests[index].copyWith(
        status: 'rejected',
        responseMessage: response,
        processedAt: DateTime.now(),
      );
    }
    (await companyRemoteDataSource.updateTrainingApplication(
      requests[index],
    )).fold(
      (l) {
        flowState.value = ErrorState(
          StateRendererType.popupErrorState,
          l.message,
        );
      },
      (r) {
        responseController.clear();
        flowState.value = SuccessState(StateRendererType.popupSuccessState, 'تم رفض الطلب بنجاح');
      },
    );
  }
}

// إضافة امتداد لنسخ النموذج مع تحديث بعض الحقول
extension TrainingRequestCopyWith on TrainingApplication {
  TrainingApplication copyWith({
    String? status,
    String? responseMessage,
    DateTime? processedAt,
  }) {
    return TrainingApplication(
      id: id,
      studentId: studentId,
      trainingId: trainingId,
      status: status ?? this.status,
      responseMessage: responseMessage ?? this.responseMessage,
      appliedAt: appliedAt,
      companyId: companyId,
      requestMsg: requestMsg,
      processedAt: processedAt ?? this.processedAt,
      type: type,
    );
  }
}
