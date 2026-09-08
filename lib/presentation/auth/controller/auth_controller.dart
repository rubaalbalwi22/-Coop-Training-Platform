import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:train_link/core/constants/constant.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';
import 'package:train_link/data/auth_remote_data_source/auth_remote_data_source.dart';
import 'package:train_link/presentation/admin/user_management/model/user_model.dart';
import '../../../core/app_export.dart';
import '../../admin/specialization/model/specialization_model.dart';
import '../../admin/universities/models/university_model.dart';

class AuthController extends GetxController {
  // عناصر التحكم في النماذج
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  final TextEditingController registerNameController = TextEditingController();
  final TextEditingController registerEmailController = TextEditingController();
  final TextEditingController registerPasswordController =
      TextEditingController();
  final TextEditingController registerConfirmPasswordController =
      TextEditingController();
  final TextEditingController registerPhoneController = TextEditingController();
  final TextEditingController forgetEmailController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController companyAddressController =
      TextEditingController();
  final TextEditingController companyWebsiteController =
      TextEditingController();
  final TextEditingController companyRegisterNumberController =
      TextEditingController();
  final TextEditingController companyDescriptionController =
      TextEditingController();
  final userType = 'student'.obs; // 'student' أو 'company'
  var hidePassword = true.obs;
  var cvFile = Rx<File?>(null);
  var selectedUniversityId = '0'.obs;
  var selectedSpecializationId = '0'.obs;


  final loginFormKey = GlobalKey<FormState>();
  final forgetPasswordFormKey = GlobalKey<FormState>();
  // Data lists (to be populated from API)
  var universities = <University>[].obs;
  var specializations = <Specialization>[].obs;

  Rx<FlowState> registerState = Rx<FlowState>(ContentState());
  Rx<FlowState> loginState = Rx<FlowState>(ContentState());
  Rx<FlowState> forgetPasswordState = Rx<FlowState>(ContentState());
  AuthRemoteDataSource authRemoteDataSource =
      Get.find<AuthRemoteDataSourceImpl>();

  void setUserType(String type) {
    userType.value = type;
  }
  // حالات التطبيق

  @override
  void onInit() {
    fetchSpecializations();
    fetchUniversities();
    super.onInit();
  }

  // Add to your AuthController class
  Rx<File?> companyLogo = Rx<File?>(null);

  Future<void> pickCompanyLogo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        //   allowedExtensions: ['jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result != null) {
        companyLogo.value = File(result.files.single.path!);
      }
    } catch (e) {
      print(e);
      Get.snackbar('خطأ', 'حدث خطأ أثناء اختيار الشعار');
    }
  }

  void togglePasswordVisibility() => hidePassword.toggle();
  RxBool  isUniversityLoading = true.obs;
  Future<void> fetchUniversities() async {
    (await authRemoteDataSource.getAllUniversities()).fold((l) {
      isUniversityLoading.value = false;
    }, (r) {
        universities.assignAll(r);
        isUniversityLoading.value = false;
    },);
  }

  RxBool isSpecializationLoading = true.obs;
  Future<void> fetchSpecializations() async {
    (await authRemoteDataSource.getAllSpecializations()).fold((l) {
      isSpecializationLoading.value = false;
    }, (r) {
        specializations.assignAll(r);
        isSpecializationLoading.value = false;
    },);
  }

  Future<void> pickCvFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        cvFile.value = File(result.files.single.path!);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick file');
    }
  }

  Future<void> login() async {
    if (loginFormKey.currentState!.validate()) {
      loginState.value = LoadingState(
        stateRendererType: StateRendererType.fullScreenLoadingState,
      );
      (await authRemoteDataSource.login(
        loginEmailController.text,
        loginPasswordController.text,
      )).fold(
        (l) {
          loginState.value = ErrorState(
            StateRendererType.popupErrorState,
            l.message,
          );
        },
        (r) {
          if (r == UserRole.student) {
            Get.offAllNamed(AppRoutes.userMainScreen);
          } else if (r == UserRole.company) {
            Get.offAllNamed(AppRoutes.companyMainScreen);
          } else {
            Get.offAllNamed(AppRoutes.listOfUniversityScreen);
          }
        },
      );
    }
  }

  Future<void> register() async {
    registerState.value = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );
    (await authRemoteDataSource.register(
      AppUser(
        name: registerNameController.text,
        email: registerEmailController.text,
        password: registerPasswordController.text,
        phone: registerPhoneController.text,
        universityId: selectedUniversityId.value,
        specializationId: selectedSpecializationId.value,
        cvUrl: cvFile.value?.path,
        companyLogo: companyLogo.value?.path,
        type: userType.value.toUserType(),
        companyAddress: companyAddressController.text,
        companyName: companyNameController.text,
        companyDescription: companyDescriptionController.text,
        companyRegisterNumber: companyRegisterNumberController.text,
        companyWebsite: companyWebsiteController.text,
        createdAt: DateTime.now(),
        isActive: true ,
        specialization:  specializations.firstWhereOrNull((element) => element.id == selectedSpecializationId.value )?.name,
        status: UserStatus.pending,
        university: universities.firstWhereOrNull((element) => element.id == selectedUniversityId.value )?.name,
      ),
    )).fold(
      (l) {
        registerState.value = ErrorState(
          StateRendererType.popupErrorState,
          l.message,
        );
      },
      (r) {

      registerState.value = SuccessState(StateRendererType.popupSuccessState,'تم التسجيل بنجاح');

      },
    );
  }

  Future<void> resetPassword() async {
    if (forgetPasswordFormKey.currentState!.validate()) {
      forgetPasswordState.value = LoadingState(
        stateRendererType: StateRendererType.fullScreenLoadingState,
      );
      if (forgetPasswordFormKey.currentState!.validate()) {
        (await authRemoteDataSource.forgetPassword(
          forgetEmailController.text,
        )).fold(
          (l) {
            forgetPasswordState.value = ErrorState(
              StateRendererType.popupErrorState,
              l.message,
            );
          },
          (r) {
            forgetPasswordState.value = SuccessState(
              StateRendererType.popupSuccessState,
              'تم ارسال كلمة المرور الى بريدك الالكتروني',
            );
          },
        );
      }
    }
  }

  void clearLoginForm() {
    loginEmailController.clear();
    loginPasswordController.clear();
  }

  void clearRegisterForm() {
    registerNameController.clear();
    registerEmailController.clear();
    registerPasswordController.clear();
    registerPhoneController.clear();
  }
}
