// student/controllers/training_opportunities_controller.dart
import 'package:train_link/core/utils/state_renderer/state_renderer.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';
import 'package:train_link/presentation/company/training_course/model/training_course_model.dart';

import '../../../../core/app_export.dart';
import '../../../../data/user_remote_data_source/user_remote_data_source.dart';
import '../../../company/training_opportunity/model/training_opportunity_model.dart';

// student/controllers/training_opportunities_controller.dart
class TrainingOpportunitiesController extends GetxController {
  final RxList<TrainingOpportunity> opportunities = <TrainingOpportunity>[].obs;
  final RxList<TrainingCourse> courses = <TrainingCourse>[].obs;
  final RxInt selectedSpecialization = 0.obs;
  List<String> specializations = [];
  final UserRemoteDataSource user = Get.find<UserRemoteDataSourceImpl>();
  final Rx<FlowState> coursesFlowState = Rx<FlowState>(
    LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState),
  );
  final Rx<FlowState> trainingFlowState = Rx<FlowState>(
    LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState),
  );

  @override
  void onInit() {
    getSpecializations();
    fetchOpportunities();
    fetchCourses();
    super.onInit();
  }

  RxBool isSpecializationLoaded = false.obs;
  Future<void> getSpecializations() async {
    isSpecializationLoaded.value = false;
    (await user.getAllSpecializations()).fold(
      (l) {
        isSpecializationLoaded.value = false;
      },
      (r) {
        specializations = r.map((e) => e.name).toList();
        isSpecializationLoaded.value = false;
      },
    );
  }

  Future<void> fetchOpportunities() async {
    trainingFlowState.value = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );
    (await user.getAllTrainingOpportunities()).fold(
      (l) {
        trainingFlowState.value = ErrorState(
          StateRendererType.popupErrorState,
          l.message,
        );
      },
      (r) {
        opportunities.assignAll(r);
        trainingFlowState.value = ContentState();
      },
    );
  }

  Future<void> fetchCourses() async {
    try {
      coursesFlowState.value = LoadingState(
        stateRendererType: StateRendererType.fullScreenLoadingState,
      );
      (await user.getAllTrainingCourses()).fold(
        (l) {
          coursesFlowState.value = ErrorState(
            StateRendererType.popupErrorState,
            l.message,
          );
        },
        (r) {
          courses.assignAll(r);
          coursesFlowState.value = ContentState();
        },
      );
    } catch (e) {
      coursesFlowState.value = ErrorState(
        StateRendererType.popupErrorState,
        e.toString(),
      );
    }
  }

  void changeSpecialization(int value) {
    selectedSpecialization.value = value;
  }
}
