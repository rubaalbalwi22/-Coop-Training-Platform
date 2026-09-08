// student/views/course_detail_view.dart
import 'package:flutter/material.dart';
import 'package:train_link/core/app_export.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';
import 'package:train_link/presentation/company/training_course/model/training_course_model.dart';
import 'package:train_link/presentation/student/training_opportunity/controller/training_application_controller.dart';
import 'package:train_link/presentation/student/training_opportunity/model/training_application_model.dart';

class CourseDetailView extends StatelessWidget {
  TrainingApplicationController controller = Get.put(TrainingApplicationController());
  final TrainingCourse course;

  CourseDetailView({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الدورة'),
        backgroundColor: theme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
                image: DecorationImage(
                  image: NetworkImage(course.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              course.title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(course.companyName??"", style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            Divider(height: 24, thickness: 1),
            Text(
              'وصف الدورة:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(course.description),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildDetailChip(
                  icon: Icons.timer,
                  label: '${course.duration} أسابيع',
                ),
                _buildDetailChip(icon: Icons.star, label: '${course.level} '),
                _buildDetailChip(
                  icon: Icons.people,
                  label: '${course.maxParticipants} مقعد',
                ),
                _buildDetailChip(
                  icon: course.mode == 'حضوري' ? Icons.location_on : Icons.wifi,
                  label: course.mode,
                ),
                Visibility(
                  visible: course.mode == 'حضوري',
                  child: _buildDetailChip(
                    icon: Icons.location_on,
                    label: course.location,
                  ),
                ),
                _buildDetailChip(
                  icon: Icons.calendar_today,
                  label:
                      'من ${_formatDate(course.startDate)} إلى ${_formatDate(course.endDate)}',
                ),
              ],
            ),
            Divider(height: 24, thickness: 1),
            Text(
              'المعاير:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            Text(
              course.criteria?.map((String criterion) => '- $criterion').join('\n')??"",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),

            SizedBox(height: 24),
          Obx(() =>controller.flowState.value.getScreenWidget(_body(), (){
            controller.flowState.value = ContentState();
          }))
          ],
        ),
      ),
    );
  }

  _body()=>  SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.primaryColor,
        padding: EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {
        // Enroll in course
        controller.applyForTraining(course.id??"",
            course.companyId??""
            , TrainingApplicationType.course,course.title,course.duration , course.endDate);
      },
      child: Text(
        'التسجيل في الدورة',
        style: TextStyle(fontSize: 16),
      ),
    ),
  );

  Widget _buildDetailChip({required IconData icon, required String label}) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      backgroundColor: theme.primaryColor.withOpacity(0.1),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
