import 'package:flutter/material.dart';
import 'package:train_link/data/admin_remote_data_source/admin_remote_data_source.dart';
import 'package:train_link/presentation/student/training_feedback/model/training_feedback_model.dart';

import '../../../../core/app_export.dart';
import '../model/comment_model.dart';

class CommentManagementController extends GetxController {
  final RxList<TrainingFeedback> comments = <TrainingFeedback>[].obs;
  final RxList<TrainingFeedback> filteredComments = <TrainingFeedback>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final AdminRemoteDataSource adminRemoteDataSource =
      Get.find<AdminRemoteDataSourceImpl>();

  @override
  void onInit() {
    fetchComments();
    super.onInit();
  }

  Future<void> fetchComments() async {
    isLoading.value = true;
    (await adminRemoteDataSource.getTrainingFeedback()).fold((l) {}, (r) {
      comments.assignAll(r);
      applyFilters();
      isLoading.value = false;
    });
  }

  void applyFilters() {
    filteredComments.assignAll(
      comments.where((comment) {
        final matchesSearch =
            searchQuery.value.isEmpty ||
            comment.comment.toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            ) ||
            comment.student!.name.toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            );
        return matchesSearch;
      }),
    );
  }

  Future<void> deleteComment(String commentId) async {
    Get.defaultDialog(
      title: 'حذف التعليق',
      content: Text(
        'هل أنت متأكد من رغبتك في حذف هذا التعليق؟',
        textDirection: TextDirection.rtl,
      ),
      textConfirm: 'نعم',
      textCancel: 'لا',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        try {
          isLoading.value = true;
          (await adminRemoteDataSource.deleteTrainingFeedback(commentId)).fold(
            (l) {
              Get.snackbar(
                'خطاء',
                'فشل في حذف التعليق',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            (r) async {
              await fetchComments();
              Get.back();
              Get.snackbar(
                'نجاح',
                'تم حذف التعليق بنجاح',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          );
        } finally {
          isLoading.value = false;
        }
      },
    );
  }
}
