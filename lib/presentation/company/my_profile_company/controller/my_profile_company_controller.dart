import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:train_link/data/company_remote_data_source/company_remote_data_source.dart';
import 'package:train_link/presentation/admin/user_management/model/user_model.dart';

import '../model/company.dart';

class CompanyProfileController extends GetxController {
  final Rx<AppUser?> company = Rx<AppUser?>(null);
  final RxBool isLoading = false.obs;

  // الحقول القابلة للتعديل
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final phoneController = TextEditingController();
  RxString logoPath = ''.obs;
  final locationController = TextEditingController();
  final emailController = TextEditingController();
  final websiteController = TextEditingController();
  final registerNumberController = TextEditingController();
  final Rx<File?> companyLogo = Rx<File?>(null);
  final CompanyRemoteDataSource companyRemoteDataSource =
      Get.find<CompanyRemoteDataSourceImpl>();

  void pickCompanyLogo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null && result.files.isNotEmpty) {
      final pickedFile = result.files.first;
      companyLogo.value = File(pickedFile.path!);
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading(true);
    (await companyRemoteDataSource.getMyProfile()).fold(
      (l) => isLoading(false),
      (r) {
        company.value = r;
        nameController.text = r.name;
        descriptionController.text = r.companyDescription ?? "";
        locationController.text = r.companyAddress ?? "";
        emailController.text = r.email;
        websiteController.text = r.companyWebsite ?? "";
        registerNumberController.text = r.companyRegisterNumber ?? "";
        phoneController.text = r.phone ?? "";

        isLoading(false);
      },
    );
  }

  void updateProfile() async {
    isLoading(true);
    (await companyRemoteDataSource.updateUser(
      company.value!.copyWith(
        name: nameController.text,
        companyDescription: descriptionController.text,
        companyAddress: locationController.text,
        email: emailController.text,
        companyWebsite: websiteController.text,
        companyRegisterNumber: registerNumberController.text,
        phone: phoneController.text,
        companyLogo: companyLogo.value?.path,
      ),
    )).fold((l) => isLoading(false), (r) async {
      await loadProfile();
      isLoading(false);
    });
  }
}
