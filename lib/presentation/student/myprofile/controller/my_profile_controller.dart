import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';
import 'package:train_link/data/user_remote_data_source/user_remote_data_source.dart';
import 'package:train_link/presentation/admin/user_management/model/user_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../admin/specialization/model/specialization_model.dart';
import '../../../admin/universities/models/university_model.dart';

class ProfileController extends GetxController {
  // Form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  AppUser? myData;
  // State variables
  final hidePassword = true.obs;
  final isLoading = false.obs;
  final profileImage = Rxn<File>();
  final cvFile = Rxn<File>();
  final cvUrl = ''.obs;

  // Dropdown values
  final selectedUniversityId = ''.obs;
  final selectedSpecializationId = ''.obs;

  final UserRemoteDataSource userRemoteDataSource =
      Get.find<UserRemoteDataSourceImpl>();
  final Rx<FlowState> flowState = Rx<FlowState>(
    LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState),
  );

  // Mock data - replace with your actual data source
  final universities = <University>[].obs;

  final specializations = <Specialization>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load initial profile data
    loadProfileData();
  }

  updateProfile() async {
    flowState.value = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );
    (await userRemoteDataSource.updateUser(
      myData!.copyWith(
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        universityId: selectedUniversityId.value,
        specializationId: selectedSpecializationId.value,
        cvUrl: cvFile.value?.path,
      ),
      newPassword: newPasswordController.text.isEmpty
          ? null
          : newPasswordController.text,
      oldPassword: currentPasswordController.text.isEmpty
          ? null
          : currentPasswordController.text,
    )).fold(
      (l) {
        flowState.value = ErrorState(
          StateRendererType.popupErrorState,
          l.message,
        );
      },
      (r) async{
        // clean password fields
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
        await loadProfileData();
        flowState.value = SuccessState(StateRendererType.popupSuccessState, 'تم التحديث بنجاح');
      },
    );
  }

  Future<void> loadProfileData() async {
    flowState.value = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );
    (await userRemoteDataSource.getMyProfile()).fold(
      (l) {
        flowState.value = ErrorState(
          StateRendererType.popupErrorState,
          l.message,
        );
      },
      (r) async {
        myData =r ;
        nameController.text = r.name;
        emailController.text = r.email;
        phoneController.text = r.phone ?? "";
        selectedUniversityId.value = r.universityId ?? "";
        selectedSpecializationId.value = r.specializationId ?? "";
        cvUrl.value = r.cvUrl ?? "";
        (await userRemoteDataSource.getAllUniversities()).fold((l) {}, (r) {
          universities.value = r;
        });
        (await userRemoteDataSource.getAllSpecializations()).fold((l) {}, (r) {
          specializations.value = r;
        });
        flowState.value = ContentState();
      },
    );

    // Replace with actual data loading logic
  }

  void togglePasswordVisibility() {
    hidePassword.toggle();
  }

  Future<void> pickProfileImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        profileImage.value = File(result.files.single.path!);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في اختيار الصورة');
    }
  }

  Future<void> pickCvFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        cvFile.value = File(result.files.single.path!);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في اختيار الملف');
    }
  }

  Future<void> viewCv() async {
    if (cvUrl.isNotEmpty) {
      try {
        // For web/network PDFs:
        await launchUrl(Uri.parse(cvUrl.value));

        // For local files:
        // if (cvFile.value != null) {
        //   await OpenFile.open(cvFile.value!.path);
        // } else {
        //   Get.snackbar('خطأ', 'لا يمكن عرض الملف');
        // }
      } catch (e) {
        Get.snackbar('خطأ', 'فشل في فتح الملف');
      }
    }
  }


  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
