import 'package:flutter/material.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';
import 'package:train_link/data/admin_remote_data_source/admin_remote_data_source.dart';

import '../../../../core/app_export.dart';
import '../../../company/training_course/model/training_course_model.dart';

class CourseManagementController extends GetxController {
  final RxList<TrainingCourse> courses = <TrainingCourse>[].obs;
  final RxList<TrainingCourse> filteredCourses = <TrainingCourse>[].obs;
   final selectedStatus = Rx<CourseStatus?>(null);
  final searchQuery = ''.obs;
  final rejectionReasonController = TextEditingController();
  final AdminRemoteDataSource adminRemoteDataSource = Get.find<AdminRemoteDataSourceImpl>();
  final Rx<FlowState> flowState = Rx<FlowState>(LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState));

  @override
  void onInit() {
    fetchCourses();
    super.onInit();
  }

  Future<void> fetchCourses() async {
    flowState.value = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );
    (await adminRemoteDataSource.getAllTrainingCourses()).fold(
      (l) {
        flowState.value = ErrorState(
          StateRendererType.popupErrorState,
          l.message,
        );
      },
      (r) {
        courses.assignAll(r);
        filteredCourses.assignAll(r);
        flowState.value = ContentState();
      },
    );
  }

  void applyFilters() {
    filteredCourses.assignAll(courses.where((course) {
      final matchesStatus = selectedStatus.value == null || course.status == selectedStatus.value;
      final matchesSearch = searchQuery.value.isEmpty ||
          course.title.toLowerCase().contains(searchQuery.value.toLowerCase());

      return matchesStatus && matchesSearch;
    }));
  }

  Future<void> approveCourse(String courseId) async {
    final index = courses.indexWhere((c) => c.id == courseId);
    if (index != -1) {
      flowState.value = LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState);
      courses[index] = courses[index].copyWith(
        status: CourseStatus.approved,
        rejectionReason: null,
      );

      (await adminRemoteDataSource.updateTrainingCourse(courses[index])).fold((l) {
        flowState.value = ErrorState(StateRendererType.popupErrorState, l.message);
      }, (r) async {
        await fetchCourses();
        flowState.value = SuccessState(StateRendererType.popupSuccessState, 'تم قبول الدورة بنجاح');
      });
      applyFilters();
    }
   }

  Future<void> rejectCourse(String courseId) async {
    if (rejectionReasonController.text.isEmpty) {
      Get.snackbar(
        'خطأ',
        'يرجى إدخال سبب الرفض',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

      final index = courses.indexWhere((c) => c.id == courseId);
      if (index != -1) {
        flowState.value = LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState);
        courses[index] = courses[index].copyWith(
          status: CourseStatus.rejected,
          rejectionReason: rejectionReasonController.text,
        );
        (await adminRemoteDataSource.updateTrainingCourse(courses[index])).fold((l) {
          flowState.value = ErrorState(StateRendererType.popupErrorState, l.message);
        }, (r) async {
          await fetchCourses();
          flowState.value = SuccessState(StateRendererType.popupSuccessState, 'تم رفض الدورة بنجاح');
        });
        if (filteredCourses.isNotEmpty) {
          filteredCourses[index] = filteredCourses[index].copyWith(
            status: CourseStatus.rejected,
            rejectionReason: rejectionReasonController.text,
          );
        }

        applyFilters();
      }
      rejectionReasonController.clear();
      Get.back();

  }

  void showRejectionDialog(String courseId) {
    Get.defaultDialog(
      title: 'تأكيد الرفض',
      content: Padding(
        padding: EdgeInsets.all(8),
        child: Text('هل أنت متأكد من رغبتك في رفض الدورة؟'),
      ),
      textConfirm: 'نعم',
      textCancel: 'لا',
      confirmTextColor: Colors.white,
      onConfirm: () => rejectCourse(courseId),
    );
  }

  @override
  void onClose() {
    rejectionReasonController.dispose();
    super.onClose();
  }
}

extension CourseExtension on TrainingCourse {
  TrainingCourse copyWith({
    String? id,
    String? title,
    String? description,
    String? instructorId,
    String? instructorName,
    String? category,
    int? duration,
    DateTime? startDate,
    DateTime? endDate,
    int? maxStudents,
    CourseStatus? status,
    DateTime? createdAt,
    String? rejectionReason,
  }) {
    return TrainingCourse(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
       category: category ?? this.category,
      duration: duration ?? this.duration,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      hoursPerWeek: hoursPerWeek,
      imageUrl: imageUrl,
      maxParticipants: maxParticipants,
      isActive: isActive,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      level:  level,
      mode: mode,
      location: location,
      companyId: companyId,
      criteria:  criteria,
      updatedAt: DateTime.now(),
    );
  }
}