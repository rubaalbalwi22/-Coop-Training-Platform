import 'package:train_link/core/utils/state_renderer/state_renderer.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';
import 'package:train_link/data/admin_remote_data_source/admin_remote_data_source.dart';

import '../../../../core/app_export.dart';
import '../../../company/training_opportunity/model/training_opportunity_model.dart';
import '../view/training_details_view.dart';

class TrainingManagementController extends GetxController {
  final RxList<TrainingOpportunity> trainings = <TrainingOpportunity>[].obs;
  final RxList<TrainingOpportunity> filteredTrainings = <TrainingOpportunity>[].obs;
   final selectedStatus = Rx<String?>(null);
  final searchQuery = ''.obs;
  final AdminRemoteDataSource adminRemoteDataSource = Get.find<AdminRemoteDataSourceImpl>() ;
  final Rx<FlowState> flowState = Rx<FlowState>(LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState));

  @override
  void onInit() {
    fetchTrainings();
    super.onInit();
  }

  Future<void> fetchTrainings() async {
     flowState.value = LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState);
     (await adminRemoteDataSource.getAllTrainingOpportunities()).fold((l) {
      flowState.value = ErrorState(StateRendererType.popupErrorState, l.message);
    }, (r) {
      trainings.assignAll(r);
      filteredTrainings.assignAll(r);
      applyFilters();
      flowState.value = ContentState();
    });


  }

  void applyFilters() {
    if (selectedStatus.value == null) {
      filteredTrainings.assignAll(trainings.where((training) {
        final matchesSearch = searchQuery.value.isEmpty ||
            training.title!.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            training.description!.toLowerCase().contains(searchQuery.value.toLowerCase());
        return matchesSearch;
      }));
    } else {
      filteredTrainings.assignAll(trainings.where((training) {
        final matchesStatus = training.status == selectedStatus.value;
        final matchesSearch = searchQuery.value.isEmpty ||
            training.title!.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            training.description!.toLowerCase().contains(searchQuery.value.toLowerCase());
        return matchesStatus && matchesSearch;
      }));
    }
  }

  Future<void> updateTrainingStatus(String trainingId, String newStatus) async {
    final index = trainings.indexWhere((t) => t.id == trainingId);
    if (index != -1) {
      trainings[index] = trainings[index].copyWith(status: newStatus);
      flowState.value = LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState);
      (await adminRemoteDataSource.updateTrainingOpportunity(trainings[index])).fold((l) {
        flowState.value = ErrorState(StateRendererType.popupErrorState, l.message);
      }, (r) async {
        await fetchTrainings();
        flowState.value = SuccessState(StateRendererType.popupSuccessState, 'تم تحديث حالة الدورة بنجاح');
      });
    }
  }

  void viewTrainingDetails(TrainingOpportunity training) {
   // Get.toNamed(Routes.TRAINING_DETAILS, arguments: training);
    Get.to(TrainingDetailsView(),arguments: training);
  }
}

extension TrainingOpportunityExtension on TrainingOpportunity {
  TrainingOpportunity copyWith({
    String? id,
    String? title,
    String? description,
    String? companyId,
    String? typeId,
    List<String>? specializationIds,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
    int? durationHours,
    int? capacity,
    String? status,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return TrainingOpportunity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      companyId: companyId ?? this.companyId,
      type: typeId ?? type,
      criteria: criteria,
      mode: mode,
      rejectionReason: rejectionReason,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      durationHours: durationHours ?? this.durationHours,
      capacity: capacity ?? this.capacity,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}