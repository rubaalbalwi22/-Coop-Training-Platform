// company/controllers/training_opportunity_controller.dart
import 'package:flutter/material.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';
import 'package:train_link/data/company_remote_data_source/company_remote_data_source.dart';

import '../../../../core/app_export.dart';
import '../model/training_opportunity_model.dart';

class TrainingOpportunityController extends GetxController {
  final RxList<TrainingOpportunity> opportunities = <TrainingOpportunity>[].obs;
  final RxString selectedType = ''.obs;
  final RxString selectedMode = 'حضوري'.obs;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);
  final RxList<String> criteriaList = <String>[].obs;
  final TextEditingController criteriaController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final CompanyRemoteDataSource companyRemoteDataSource =
      Get.find<CompanyRemoteDataSourceImpl>();
  final Rx<FlowState> flowState = Rx<FlowState>(
    LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState),
  );

  final List<String> trainingTypes = [];

  final List<String> trainingModes = ['حضوري', 'عن بُعد'];

  @override
  void onInit() {
    getTrainingTypes();
    fetchOpportunities();
    super.onInit();
  }

  RxBool isTrainingTypeLoading = false.obs;
  void getTrainingTypes() async {
    isTrainingTypeLoading.value = true;
    (await companyRemoteDataSource.getAllTrainingTypes()).fold(
      (l) {
        isTrainingTypeLoading.value = false;
      },
      (r) {
        isTrainingTypeLoading.value = false;
        trainingTypes.assignAll(r.map((e) => e.name).toList());
      },
    );
  }

  /// Load opportunity for edit mode
  void loadOpportunityForEdit(String opportunityId) {
    final opportunity = opportunities.firstWhere(
      (element) => element.id == opportunityId,
    );
    titleController.text = opportunity.title ?? "";
    descriptionController.text = opportunity.description ?? "";
    selectedType.value = opportunity.type ?? "";
    durationController.text = opportunity.durationHours.toString();
    capacityController.text = opportunity.capacity.toString();
    locationController.text = opportunity.location ?? '';
    startDate.value = opportunity.startDate;
    endDate.value = opportunity.endDate;
    selectedMode.value = opportunity.mode ?? '';
    criteriaList.clear();
    criteriaList.addAll(opportunity.criteria ?? []);
  }

  Future<void> fetchOpportunities() async {
    flowState.value = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );
    (await companyRemoteDataSource.getAllTrainingOpportunities()).fold(
      (l) {
        flowState.value = ErrorState(
          StateRendererType.popupErrorState,
          l.message,
        );
      },
      (r) {
        opportunities.assignAll(r);
        flowState.value = ContentState();
      },
    );
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      startDate.value = picked;
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      endDate.value = picked;
    }
  }

  Future<void> updateOpportunity(String opportunityId) async {
    flowState.value = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );
    TrainingOpportunity opportunity = opportunities.firstWhere(
      (element) => element.id == opportunityId,
    );
    opportunity.title = titleController.text;
    opportunity.description = descriptionController.text;
    opportunity.type = selectedType.value;
    opportunity.durationHours = int.parse(durationController.text);
    opportunity.capacity = int.parse(capacityController.text);
    opportunity.location = locationController.text;
    opportunity.startDate = startDate.value ?? opportunity.startDate;
    opportunity.endDate = endDate.value ?? opportunity.endDate;
    opportunity.criteria = criteriaList;
    opportunity.mode = selectedMode.value;

    (await companyRemoteDataSource.updateTrainingOpportunity(opportunity)).fold(
      (l) {
        flowState.value = ErrorState(
          StateRendererType.popupErrorState,
          l.message,
        );
      },
      (r)  async{
        Get.back();
        fetchOpportunities();
         flowState.value = SuccessState(
          StateRendererType.popupSuccessState,
          'تم تحديث الفرصة بنجاح',
        );
      },
    );
  }

  Future<void> submitOpportunity() async {
    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedType.isEmpty ||
        durationController.text.isEmpty ||
        capacityController.text.isEmpty ||
        startDate.value == null ||
        endDate.value == null) {
      Get.snackbar('خطأ', 'الرجاء تعبئة جميع الحقول المطلوبة');
      return;
    }

    if (selectedMode.value == 'حضوري' && locationController.text.isEmpty) {
      Get.snackbar('خطأ', 'الرجاء إدخال الموقع للتدريب الحضوري');
      return;
    }
    var opportunity = TrainingOpportunity(
      title: titleController.text,
      description: descriptionController.text,
      type: selectedType.value,
      mode: selectedMode.value,
      durationHours: int.parse(durationController.text),
      capacity: int.parse(capacityController.text),
      location: locationController.text,
      startDate: startDate.value!,
      endDate: endDate.value!,
      status: 'pending',
      criteria: criteriaList,
      createdAt: DateTime.now(),
    );
    flowState.value = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );
    (await companyRemoteDataSource.addTrainingOpportunity(opportunity)).fold(
      (l) {
        flowState.value = ErrorState(
          StateRendererType.popupErrorState,
          l.message,
        );
      },
      (r)  async{
        Get.back();
        await fetchOpportunities();
         flowState.value = SuccessState(
          StateRendererType.popupSuccessState,
          'تم اضافة الفرصة بنجاح',
        );
      },
    );
  }
}
