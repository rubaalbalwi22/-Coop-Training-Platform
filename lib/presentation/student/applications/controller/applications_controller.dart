// student/controllers/applications_controller.dart
import 'package:train_link/core/utils/state_renderer/state_renderer.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';
import 'package:train_link/data/user_remote_data_source/user_remote_data_source.dart';

import '../../../../core/app_export.dart';
import '../../training_opportunity/model/training_application_model.dart';

class ApplicationsController extends GetxController {
  final RxList<TrainingApplication> applications = <TrainingApplication>[].obs;
  final RxString selectedFilter = 'الكل'.obs;

  final List<String> filters = ['الكل', 'قيد المراجعة', 'مقبول', 'مرفوض'];
  final UserRemoteDataSource userRemoteDataSource =
      Get.find<UserRemoteDataSourceImpl>();
  final Rx<FlowState> flowState = Rx<FlowState>(
    LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState),
  );

  @override
  void onInit() {
    fetchApplications();
    super.onInit();
  }

  Future<void> fetchApplications() async {
    flowState.value = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );
    (await userRemoteDataSource.getTrainingApplications()).fold(
      (l) {
        flowState.value = ErrorState(
          StateRendererType.popupErrorState,
          l.message,
        );
      },
      (r) {
        applications.assignAll(r);
        flowState.value = ContentState();
      },
    );
  }

  List<TrainingApplication> get filteredApplications {
    if (selectedFilter.value == 'الكل') return applications;
    return applications.where((app) {
      switch (selectedFilter.value) {
        case 'قيد المراجعة':
          return app.status == 'pending';
        case 'مقبول':
          return app.status == 'approved';
        case 'مرفوض':
          return app.status == 'rejected';
        default:
          return true;
      }
    }).toList();
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }
}
