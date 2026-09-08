// company/views/courses_list_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';

import '../../../../theme/theme_helper.dart';
import '../controller/training_course_controller.dart';
import '../model/training_course_model.dart';
import 'course_details_view.dart';
import 'course_form_view.dart';

class CoursesListView extends GetWidget<TrainingCourseController> {
  CoursesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('دوراتي التدريبية'),
        backgroundColor: theme.primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              controller.resetForm();
              Get.to(() => CourseFormView());
            },
          ),
        ],
      ),
      body: Obx(
        () => controller.flowState.value.getScreenWidget(_body(), () {
          controller.fetchCourses();
        }),
      ),
    );
  }

  _body() {
    if (controller.courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, size: 60, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'لا توجد دورات مضافة بعد',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                controller.resetForm();
                Get.to(() => CourseFormView());
              },
              child: Text('إضافة دورة جديدة'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.fetchCourses,
      color: theme.primaryColor,
      child: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: controller.courses.length,
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          final course = controller.courses[index];
          return _buildCourseCard(course);
        },
      ),
    );
  }

  Widget _buildCourseCard(TrainingCourse course) {
    final statusColor = course.status == CourseStatus.approved
        ? Colors.green
        : course.status == CourseStatus.rejected
        ? Colors.red
        : Colors.orange;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Get.to(() => CourseDetailsView(course: course));
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                      image: DecorationImage(
                        image: NetworkImage(course.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                course.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: statusColor.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                course.status == CourseStatus.approved
                                    ? 'مقبولة'
                                    : course.status == CourseStatus.rejected
                                    ? 'مرفوضة'
                                    : 'قيد المراجعة',
                                style: TextStyle(color: statusColor),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          course.category,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.star, size: 16, color: Colors.amber),
                            SizedBox(width: 4),
                            Text(course.level),
                            SizedBox(width: 16),
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 4),
                            Text('${course.duration} أسابيع'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(height: 20, thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'يبدأ في:',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        '${course.startDate.day}/${course.startDate.month}/${course.startDate.year}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ينتهي في:',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        '${course.endDate.day}/${course.endDate.month}/${course.endDate.year}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'المقاعد:',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        '${course.maxParticipants}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: theme.primaryColor),
                    onPressed: () {
                      controller.loadCourseForEdit(course);
                      Get.to(() => CourseFormView(course: course));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showDeleteDialog(course.id??"");
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(String courseId) {
    Get.dialog(
      AlertDialog(
        title: Text('حذف الدورة'),
        content: Text('هل أنت متأكد من رغبتك في حذف هذه الدورة؟'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('إلغاء')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteCourse(courseId);
            },
            child: Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
