import 'package:flutter/material.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';
import 'package:train_link/data/admin_remote_data_source/admin_remote_data_source.dart';
import 'package:train_link/presentation/admin/universities/view/add_university_view.dart';

 import '../../../../core/app_export.dart';
import '../../../../core/utils/state_renderer/state_renderer.dart';
import '../models/university_model.dart';

class UniversityController extends GetxController {
  final RxList<University> universities = <University>[].obs;
   final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final emailController = TextEditingController();
  final isEditing = false.obs;
  final editingId = ''.obs;

  Rx<FlowState> flowState = Rx<FlowState>(LoadingState(
    stateRendererType: StateRendererType.fullScreenLoadingState,
  ));
  AdminRemoteDataSource adminRemoteDataSource = Get.find<AdminRemoteDataSourceImpl>();



  @override
  void onInit() {
    fetchUniversities();
    super.onInit();
  }

  Future<void> fetchUniversities() async {
     flowState.value = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );
    (await adminRemoteDataSource.getAllUniversities()).fold((l) {
      flowState.value = ErrorState(
        StateRendererType.popupErrorState,
        l.message,
      );
    }, (r) {
      universities.value = r;
      flowState.value = ContentState();
    });
  }

  Future<void> addOrUpdateUniversity() async {

    if (!formKey.currentState!.validate()) return;
    flowState.value = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );
     try {
      final university = University(
        id: isEditing.value ? editingId.value : DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text,
        location: locationController.text,
        contactEmail: emailController.text,
        createdAt: DateTime.now(),
      );

      if (isEditing.value) {
        (await adminRemoteDataSource.updateUniversity(university)).fold((l) {
          flowState.value = ErrorState(
            StateRendererType.popupErrorState,
            l.message,
          );
        },(r) async{
          await fetchUniversities();
           flowState.value = SuccessState(
            StateRendererType.popupSuccessState,
            'تم تحديث الجامعة بنجاح',
          );
        },);
      } else {
        (await adminRemoteDataSource.addUniversity(university)).fold((l) {
           flowState.value = ErrorState(
            StateRendererType.popupErrorState,
            l.message,
          );
        }, (r) async{
          await fetchUniversities();
           flowState.value = SuccessState(
            StateRendererType.popupSuccessState,
            'تم اضافة الجامعة بنجاح',
          );
        },);
      }


      clearForm();
      Get.snackbar(
        'نجاح',
        isEditing.value ? 'تم تحديث الجامعة بنجاح' : 'تم إضافة الجامعة بنجاح',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
     }
  }

  void editUniversity(University university) {
    isEditing.value = true;
    editingId.value = university.id;
    nameController.text = university.name;
    locationController.text = university.location;
    emailController.text = university.contactEmail;
    Get.dialog(AddUniversityView());
  }

  Future<void> deleteUniversity(String id) async {
    Get.defaultDialog(
      title: 'حذف الجامعة',
      content: Text('هل أنت متأكد من رغبتك في حذف هذه الجامعة؟', textDirection: TextDirection.rtl),
      textConfirm: 'نعم',
      textCancel: 'لا',
      confirmTextColor: Colors.white,
      onConfirm: () async {
      (await adminRemoteDataSource.deleteUniversity(id)).fold((l) {
         flowState.value = ErrorState(
            StateRendererType.popupErrorState,
            l.message,
          );
      }, (r) async{
        await fetchUniversities();
        flowState.value = SuccessState(
            StateRendererType.popupSuccessState,
            'تم حذف الجامعة بنجاح',
          );

      },);


      },
    );
  }

  void clearForm() {
    nameController.clear();
    locationController.clear();
    emailController.clear();
    isEditing.value = false;
    editingId.value = '';
  }

  @override
  void onClose() {
    nameController.dispose();
    locationController.dispose();
    emailController.dispose();
    super.onClose();
  }
}