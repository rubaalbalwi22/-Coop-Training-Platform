import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';
import 'package:train_link/data/company_remote_data_source/company_remote_data_source.dart';

import '../../../../core/app_export.dart';
import '../../training_course/model/training_course_model.dart';
import '../../training_opportunity/model/training_opportunity_model.dart';

class ManageCertificateController extends GetxController {
  // Certificate Management
   final RxList<TrainingOpportunity> trainings = <TrainingOpportunity>[].obs;
  final RxList<TrainingCourse> courses = <TrainingCourse>[].obs;
  final TextEditingController revocationReasonController =
      TextEditingController();
  final CompanyRemoteDataSource companyRemoteDataSource =
      Get.find<CompanyRemoteDataSourceImpl>();
  final Rx<FlowState> flowStateTraining = Rx<FlowState>(
    LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState),
  );
  final Rx<FlowState> flowStateCourses = Rx<FlowState>(
    LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState),
  );

  @override
  void onInit() {
    fetchInitialData();
    super.onInit();
  }

  Future<void> fetchInitialData() async {
    await Future.wait([fetchTrainings(), fetchCourses()]);
  }

  // Training Management
  Future<void> fetchTrainings() async {
    flowStateTraining.value = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );
    (await companyRemoteDataSource.getAllTrainingOpportunities()).fold(
      (l) {
        flowStateTraining.value = ErrorState(
          StateRendererType.popupErrorState,
          l.message,
        );
      },
      (r) {
        trainings.assignAll(r);
        flowStateTraining.value = ContentState();
      },
    );
  }

  // Course Management
  Future<void> fetchCourses() async {
   flowStateCourses .value = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );
    (await companyRemoteDataSource.getAllTrainingCourses()).fold(
      (l) {
        flowStateCourses.value = ErrorState(
          StateRendererType.popupErrorState,
          l.message,
        );
      },
      (r) {
        courses.assignAll(r);
        flowStateCourses.value = ContentState();
      },
    );
  }




 }


