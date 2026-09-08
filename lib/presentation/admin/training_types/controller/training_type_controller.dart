import 'package:flutter/material.dart';
import 'package:train_link/core/app_export.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';
import 'package:train_link/data/admin_remote_data_source/admin_remote_data_source.dart';
import '../../../../core/utils/state_renderer/state_renderer.dart';
import '../models/training_type_model.dart';
import '../view/add_training_type_view.dart';

class TrainingTypeController extends GetxController {
  final RxList<TrainingType> trainingTypes = <TrainingType>[].obs;
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final isEditing = false.obs;
  final editingId = ''.obs;

  final Rx<FlowState> flowState = Rx<FlowState>(
    LoadingState(stateRendererType: StateRendererType.fullScreenSuccessState)
  );

  final AdminRemoteDataSource adminRemoteDataSource =
      Get.find<AdminRemoteDataSourceImpl>();

  @override
  void onInit() {
    fetchTrainingTypes();
    super.onInit();
  }

  Future<void> fetchTrainingTypes() async {
    flowState.value = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );
    (await adminRemoteDataSource.getAllTrainingTypes()).fold(
      (l) {
        flowState.value = ErrorState(
          StateRendererType.popupErrorState,
          l.message,
        );
      },
      (r) {
        trainingTypes.value = r;
        flowState.value = ContentState();
      },
    );
  }

  Future<void> addOrUpdateTrainingType() async {
    if (!formKey.currentState!.validate()) return;
    flowState.value = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );
    final trainingType = TrainingType(
      id: isEditing.value
          ? editingId.value
          : DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text,
      createdAt: DateTime.now(),
    );

    if (isEditing.value) {
      (await adminRemoteDataSource.updateTrainingType(trainingType)).fold(
        (l) {
          flowState.value = ErrorState(
            StateRendererType.popupErrorState,
            l.message,
          );
        },
        (r) async {
          await fetchTrainingTypes();
          flowState.value = SuccessState(
            StateRendererType.popupSuccessState,
            'تم تحديث نوع التدريب بنجاح',
          );
        },
      );
    } else {
      (await adminRemoteDataSource.addTrainingType(trainingType)).fold(
        (l) {
          flowState.value = ErrorState(
            StateRendererType.popupErrorState,
            l.message,
          );
        },
        (r) async {
          await fetchTrainingTypes();
          flowState.value = SuccessState(
            StateRendererType.popupSuccessState,
            'تم إضافة نوع تدريب جديد بنجاح',
          );
        },
      );
    }
    clearForm();
  }

  void editTrainingType(TrainingType trainingType) {
    isEditing.value = true;
    editingId.value = trainingType.id;
    nameController.text = trainingType.name;
    Get.dialog(AddTrainingTypeView());
  }

  Future<void> deleteTrainingType(String id) async {
    Get.defaultDialog(
      title: 'حذف نوع التدريب',
      content: Text(
        'هل أنت متأكد من رغبتك في حذف هذا النوع؟',
        textDirection: TextDirection.rtl,
      ),
      textConfirm: 'نعم',
      textCancel: 'لا',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        flowState.value = LoadingState(
          stateRendererType: StateRendererType.fullScreenLoadingState,
        );
        (await adminRemoteDataSource.deleteTrainingType(id)).fold(
          (l) {
            flowState.value = ErrorState(
              StateRendererType.popupErrorState,
              l.message,
            );
          },
          (r) async {
            await fetchTrainingTypes();
            flowState.value = SuccessState(
              StateRendererType.popupSuccessState,
              'تم حذف نوع التدريب بنجاح',
            );
          },
        );

      },
    );
  }

  void clearForm() {
    nameController.clear();
    isEditing.value = false;
    editingId.value = '';
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
