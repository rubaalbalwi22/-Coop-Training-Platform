// company/views/course_details_view.dart
import 'package:flutter/material.dart';
import 'package:train_link/core/app_export.dart';

import '../model/training_course_model.dart';

class CourseDetailsView extends StatelessWidget {
  final TrainingCourse course;

  const CourseDetailsView({required this.course});

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
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.category, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(course.category),
                SizedBox(width: 16),
                Icon(Icons.star, size: 16, color: Colors.amber),
                SizedBox(width: 4),
                Text(course.level),
              ],
            ),
            Divider(height: 24, thickness: 1),
            Text(
              'وصف الدورة:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(course.description),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildDetailChip(
                  icon: Icons.access_time,
                  label: '${course.duration} أسابيع',
                ),
                _buildDetailChip(
                  icon: Icons.timer,
                  label: '${course.hoursPerWeek} ساعة/أسبوع',
                ),
                _buildDetailChip(
                  icon: Icons.people,
                  label: '${course.maxParticipants} مقاعد',
                ),
                _buildDetailChip(
                  icon: course.mode == 'حضوري' ? Icons.location_on : Icons.wifi,
                  label: course.mode,
                ),
                if (course.mode == 'حضوري')
                  _buildDetailChip(
                    icon: Icons.pin_drop,
                    label: course.location,
                  ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تاريخ البدء:',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        '${course.startDate.day}/${course.startDate.month}/${course.startDate.year}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تاريخ الانتهاء:',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        '${course.endDate.day}/${course.endDate.month}/${course.endDate.year}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(
              'حالة الدورة:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: course.isActive ? Colors.green[50] : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: course.isActive ? Colors.green : Colors.grey,
                ),
              ),
              child: Text(
                course.isActive ? 'نشطة' : 'غير نشطة',
                style: TextStyle(
                  color: course.isActive ? Colors.green : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip({required IconData icon, required String label}) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      backgroundColor: Colors.grey[100],
    );
  }
}