import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:train_link/presentation/company/training_course/model/training_course_model.dart';
import 'package:train_link/widgets/drawer/admin_drawer.dart';

import '../../../../core/app_export.dart';
import '../../../../core/utils/state_renderer/state_renderer_impl.dart';
import '../controller/course_management_controller.dart';
import '../model/course_model.dart' hide CourseStatus;

class ListCoursesView extends GetWidget<CourseManagementController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminDrawer(),
      appBar: AppBar(
        title: const Text('إدارة الدورات التدريبية', textDirection: TextDirection.rtl),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: Obx(() => controller.flowState.value.getScreenWidget(_body(), () {
              controller.flowState.value = ContentState();
            })),
          ),
        ],
      ),
    );
  }


  _body(){
    if (controller.filteredCourses.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد دورات متاحة',
          textDirection: TextDirection.rtl,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: controller.filteredCourses.length,
      itemBuilder: (context, index) {
        final course = controller.filteredCourses[index];
        return _buildCourseCard(course);
      },
    );
  }
  Widget _buildFilters() {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              textDirection: TextDirection.rtl,
              decoration: const InputDecoration(
                labelText: 'بحث في الدورات',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                controller.searchQuery.value = value;
                controller.applyFilters();
              },
            ),
            const SizedBox(height: 10),
            Obx(() => DropdownButtonFormField<CourseStatus>(
              value: controller.selectedStatus.value,
              decoration: const InputDecoration(
                labelText: 'حالة الدورة',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('الكل',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                      textDirection: TextDirection.rtl),
                ),
                ...CourseStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(_getStatusText(status),
                        style: TextStyle(
                          color: _getStatusColor(status),
                        ),
                        textDirection: TextDirection.rtl),
                  );
                }),
              ],
              onChanged: (value) {
                controller.selectedStatus.value = value;
                controller.applyFilters();
              },
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(TrainingCourse course) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderRow(course),
            const SizedBox(height: 10),
            _buildCourseDetail('الوصف', course.description),
            _buildCourseDetail('التصنيف', course.category),
            _buildCourseDetail('المدة', '${course.duration} ساعة'),
            _buildCourseDetail('تاريخ البدء', intl.DateFormat('yyyy/MM/dd').format(course.startDate)),
            _buildCourseDetail('تاريخ الانتهاء', intl.DateFormat('yyyy/MM/dd').format(course.endDate)),
            _buildCourseDetail('الحد الأقصى للمتدربين', '${course.maxParticipants}'),

           /* if (course.status == CourseStatus.rejected && course.rejectionReason != null)
              _buildCourseDetail('سبب الرفض', course.rejectionReason!),*/

            if (course.status == CourseStatus.pending) ...[
              const SizedBox(height: 12),
              _buildActionButtons(course),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow(TrainingCourse course) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: TextDirection.rtl,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textDirection: TextDirection.rtl,
              ),
              Text(
                'المدرب: ${course.companyName}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),
        _buildStatusIndicator(course.status),
      ],
    );
  }

  Widget _buildStatusIndicator(CourseStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getStatusText(status),
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Widget _buildCourseDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        textDirection: TextDirection.rtl,
       crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(TrainingCourse course) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () => controller.approveCourse(course.id??""),
          icon: const Icon(Icons.check),
          label: const Text('قبول'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size(120, 40),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => controller.showRejectionDialog(course.id??""),

          icon: const Icon(Icons.close),
          label: const Text('رفض'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            minimumSize: const Size(120, 40),
          ),
        ),
      ],
    );
  }

  String _getStatusText(CourseStatus status) {
    switch (status) {
      case CourseStatus.pending:
        return 'قيد المراجعة';
      case CourseStatus.approved:
        return 'مقبولة';
      case CourseStatus.rejected:
        return 'مرفوضة';
    }
  }

  Color _getStatusColor(CourseStatus status) {
    switch (status) {
      case CourseStatus.pending:
        return Colors.orange;
      case CourseStatus.approved:
        return Colors.green;
      case CourseStatus.rejected:
        return Colors.red;
    }
  }
}
