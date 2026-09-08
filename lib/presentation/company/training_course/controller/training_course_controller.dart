// company/controllers/training_course_controller.dart
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';
import 'package:train_link/data/company_remote_data_source/company_remote_data_source.dart';

import '../../../../core/app_export.dart';
import '../model/training_course_model.dart';

class TrainingCourseController extends GetxController {
  final RxList<TrainingCourse> courses = <TrainingCourse>[].obs;
  final RxString selectedCategory = ''.obs;
  final RxString selectedLevel = 'مبتدئ'.obs;
  final RxString selectedMode = 'حضوري'.obs;
  final RxList<String> criteriaList = <String>[].obs;
  final TextEditingController criteriaController = TextEditingController();
  final CompanyRemoteDataSource companyRemoteDataSource =
      Get.find<CompanyRemoteDataSourceImpl>();
  final Rx<FlowState> flowState = Rx<FlowState>(
    LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState),
  );

  // قوائم الاختيارات
  final List<String> categories = [
    'تطوير الويب',
    'الذكاء الاصطناعي',
    'تحليل البيانات',
    'التسويق الرقمي',
    'البرمجة',
    'التصميم الجرافيكي',
  ];

  final List<String> levels = ['مبتدئ', 'متوسط', 'متقدم'];

  final List<String> modes = ['حضوري', 'عن بُعد'];

  // متحكمات النماذج
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController hoursController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController participantsController = TextEditingController();
  final RxString imagePath = ''.obs;
  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);
  final RxBool isActive = true.obs;

  @override
  void onInit() {
    fetchCourses();
    super.onInit();
  }

  Future<void> fetchCourses() async {
    flowState.value = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );
    (await companyRemoteDataSource.getAllTrainingCourses()).fold(
      (l) {
        flowState.value = ErrorState(
          StateRendererType.popupErrorState,
          l.message,
        );
      },
      (r) {
        courses.assignAll(r);
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

  Future<void> pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result != null) {
        imagePath.value = result.files.single.path!;
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في اختيار الصورة: ${e.toString()}');
    }
  }

  Future<void> addCourse() async {
    if (!_validateForm()) return;
    final newCourse = TrainingCourse(
      title: titleController.text,
      description: descriptionController.text,
      category: selectedCategory.value,
      level: selectedLevel.value,
      mode: selectedMode.value,
      duration: int.parse(durationController.text),
      hoursPerWeek: int.parse(hoursController.text),
      location: locationController.text,
      startDate: startDate.value!,
      endDate: endDate.value!,
      maxParticipants: int.parse(participantsController.text),
      imageUrl: imagePath.value,
      isActive: isActive.value,
      createdAt: DateTime.now(),
      status: CourseStatus.pending,
      criteria: criteriaList,
    );
    Get.back();
    flowState.value = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );

    (await companyRemoteDataSource.addTrainingCourse(newCourse)).fold(
      (l) {
        flowState.value = ErrorState(
          StateRendererType.popupErrorState,
          l.message,
        );
      },
      (r) async {
        resetForm();

        await fetchCourses();
        flowState.value = SuccessState(
          StateRendererType.popupSuccessState,
          'تم اضافة الدورة بنجاح',
        );
      },
    );
  }

  Future<void> updateCourse(TrainingCourse course) async {
    if (!_validateForm()) return;
    Get.back();
    final updatedCourse = TrainingCourse(
      id: course.id,
      companyId: course.companyId,
      title: titleController.text,
      description: descriptionController.text,
      category: selectedCategory.value,
      level: selectedLevel.value,
      mode: selectedMode.value,
      duration: int.parse(durationController.text),
      hoursPerWeek: int.parse(hoursController.text),
      location: locationController.text,
      startDate: startDate.value!,
      endDate: endDate.value!,
      maxParticipants: int.parse(participantsController.text),
      imageUrl: imagePath.value.isNotEmpty ? imagePath.value : course.imageUrl,
      isActive: isActive.value,
      createdAt: course.createdAt,
      updatedAt: DateTime.now(),
      status: course.status,
      criteria: criteriaList,
    );
    flowState.value = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );
    (await companyRemoteDataSource.updateTrainingCourse(updatedCourse)).fold(
      (l) {
        flowState.value = ErrorState(
          StateRendererType.popupErrorState,
          l.message,
        );
      },
      (r) async {
        resetForm();

        await fetchCourses();
        flowState.value = SuccessState(
          StateRendererType.popupSuccessState,
          'تم تحديث الدورة بنجاح',
        );
      },
    );
  }

  Future<void> deleteCourse(String courseId) async {
    flowState.value = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );
    (await companyRemoteDataSource.deleteTrainingCourse(courseId)).fold(
      (l) {
        flowState.value = ErrorState(
          StateRendererType.popupErrorState,
          l.message,
        );
      },
      (r) async {
        await fetchCourses();
        flowState.value = SuccessState(
          StateRendererType.popupSuccessState,
          'تم حذف الدورة بنجاح',
        );
      },
    );
  }

  void loadCourseForEdit(TrainingCourse course) {
    titleController.text = course.title;
    descriptionController.text = course.description;
    selectedCategory.value = course.category;
    selectedLevel.value = course.level;
    selectedMode.value = course.mode;
    durationController.text = course.duration.toString();
    hoursController.text = course.hoursPerWeek.toString();
    locationController.text = course.location;
    startDate.value = course.startDate;
    endDate.value = course.endDate;
    participantsController.text = course.maxParticipants.toString();
    imagePath.value = course.imageUrl;
    isActive.value = course.isActive;
    criteriaList.clear();
    criteriaList.addAll(course.criteria ?? []);

  }

  void resetForm() {
    titleController.clear();
    descriptionController.clear();
    selectedCategory.value = '';
    selectedLevel.value = 'مبتدئ';
    selectedMode.value = 'حضوري';
    durationController.clear();
    hoursController.clear();
    locationController.clear();
    startDate.value = null;
    endDate.value = null;
    participantsController.clear();
    imagePath.value = '';
    isActive.value = true;
    criteriaList.clear();
  }

  bool _validateForm() {
    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedCategory.isEmpty ||
        durationController.text.isEmpty ||
        hoursController.text.isEmpty ||
        startDate.value == null ||
        endDate.value == null ||
        participantsController.text.isEmpty) {
      Get.snackbar('خطأ', 'الرجاء تعبئة جميع الحقول المطلوبة');
      return false;
    }

    if (endDate.value!.isBefore(startDate.value!)) {
      Get.snackbar('خطأ', 'تاريخ الانتهاء يجب أن يكون بعد تاريخ البدء');
      return false;
    }

    return true;
  }
}
