
import 'package:flutter/material.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';
import 'package:train_link/data/admin_remote_data_source/admin_remote_data_source.dart';

import '../../../../core/app_export.dart';
import '../model/specialization_model.dart';
import '../view/add_specialization_view.dart';

class SpecializationController extends GetxController {
  final RxList<Specialization> specializations = <Specialization>[].obs;
   final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
   final isEditing = false.obs;
  final editingId = ''.obs;

  final Rx<FlowState> flowState = Rx<FlowState>(LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState));
  final AdminRemoteDataSource adminRemoteDataSource = Get.find<AdminRemoteDataSourceImpl>();

  @override
  void onInit() {
    fetchSpecializations();
    super.onInit();
  }

  Future<void> fetchSpecializations() async {
    flowState.value = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );
    (await adminRemoteDataSource.getAllSpecializations()).fold((l) {
      flowState.value = ErrorState(
        StateRendererType.popupErrorState,
        l.message,
      );
    }, (r) {
      specializations.value = r;
      flowState.value = ContentState();
    });
  }

  Future<void> addOrUpdateSpecialization() async {
    if (!formKey.currentState!.validate()) return;

    flowState.value  = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );
     final specialization = Specialization(
        id: isEditing.value ? editingId.value : DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text,
         createdAt: DateTime.now(),
       );

      if (isEditing.value) {
        (await adminRemoteDataSource.updateSpecialization(specialization)).fold((l) {
          flowState.value = ErrorState(
            StateRendererType.popupErrorState,
            l.message,
          );
        }, (r) async {
          await fetchSpecializations();
          flowState.value = SuccessState(
            StateRendererType.popupSuccessState,
            'تم تحديث التخصص بنجاح',
          );
        });

      } else {
        (await adminRemoteDataSource.addSpecialization(specialization)).fold((l) {
          flowState.value = ErrorState(
            StateRendererType.popupErrorState,
            l.message,
          );
        }, (r) async {
          await fetchSpecializations();
          flowState.value = SuccessState(
            StateRendererType.popupSuccessState,
            'تم إضافة التخصص بنجاح',
          );
        });
      }

      Get.back();
      clearForm();
  }

  void editSpecialization(Specialization specialization) {
    isEditing.value = true;
    editingId.value = specialization.id;
    nameController.text = specialization.name;
   //  Get.toNamed(Routes.ADD_SPECIALIZATION);
    Get.dialog(AddSpecializationView());
  }

  Future<void> deleteSpecialization(String id) async {
    Get.defaultDialog(
      title: 'حذف التخصص',
      content: Text('هل أنت متأكد من رغبتك في حذف هذا التخصص؟', textDirection: TextDirection.rtl),
      textConfirm: 'نعم',
      textCancel: 'لا',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        Get.back();
        flowState.value = LoadingState(
          stateRendererType: StateRendererType.fullScreenLoadingState,
        );
        (await adminRemoteDataSource.deleteSpecialization(id)).fold((l) {
          flowState.value = ErrorState(
            StateRendererType.popupErrorState,
            l.message,
          );
        }, (r) async {
          await fetchSpecializations();
          flowState.value = SuccessState(
            StateRendererType.popupSuccessState,
            'تم حذف التخصص بنجاح',
          );
        });
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

extension SpecializationExtension on Specialization {
  Specialization copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return Specialization(
      id: id ?? this.id,
      name: name ?? this.name,
       createdAt: createdAt ?? this.createdAt,
     );
  }
}