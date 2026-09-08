// student/controllers/training_report_controller.dart
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';
import 'package:train_link/data/user_remote_data_source/user_remote_data_source.dart';
import 'package:train_link/presentation/student/applications/controller/applications_controller.dart';

import '../../../../core/app_export.dart';
import '../../../../core/utils/state_renderer/state_renderer.dart';
import '../../training_opportunity/model/training_application_model.dart';
import '../model/training_report_model.dart';

class TrainingReportController extends GetxController {
  final RxList<TrainingReport> reports = <TrainingReport>[].obs;
  final RxString selectedFile = ''.obs;
   final TextEditingController notesController = TextEditingController();
  final UserRemoteDataSource userRemoteDataSource =
      Get.find<UserRemoteDataSourceImpl>();
  final Rx<FlowState> flowStateUploadReport = Rx<FlowState>(ContentState());
  final Rx<FlowState> flowStateReports = Rx<FlowState>(LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState));

  @override
  onInit() {
    super.onInit();
    fetchReports();
  }

  Future<void> fetchReports() async {
    flowStateReports.value = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );
    (await userRemoteDataSource.getAllTrainingReports()).fold(
      (l) {
        flowStateReports.value = ErrorState(
          StateRendererType.popupErrorState,
          l.message,
        );
      },
      (r) {
        reports.assignAll(r);
        flowStateReports.value = ContentState();
      },
    );
  }

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        selectedFile.value = result.files.single.path!;
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في اختيار الملف: ${e.toString()}');
    }
  }

  Future<void> submitReport(TrainingApplication training) async {
    if (selectedFile.isEmpty) {
      Get.snackbar('خطأ', 'يجب اختيار ملف التقرير أولاً');
      return;
    }

    flowStateUploadReport.value = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );
    var report = TrainingReport(
      trainingId: training.id,
      filePath: selectedFile.value,
      notes: notesController.text,
      submittedAt: DateTime.now(),
      trainingTitle: training.title,
      status: 'pending',
      studentId: training.studentId,
      type: TrainingApplicationType.train,
    );

    (await userRemoteDataSource.uploadReport(report)).fold(
      (l) {
        flowStateUploadReport.value = ErrorState(
          StateRendererType.popupErrorState,
          l.message,
        );
      },
      (r) {
        selectedFile.value = '';
        notesController.clear();

        flowStateUploadReport.value = SuccessState(
          StateRendererType.popupSuccessState,
          'تم تقديم التقرير بنجاح',
        );
      },

    );
    Get.find<ApplicationsController>().fetchApplications();
  }
}
