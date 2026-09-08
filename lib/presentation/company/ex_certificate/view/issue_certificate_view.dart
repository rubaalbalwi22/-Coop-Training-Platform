// company/views/issue_certificate_view.dart
import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';
import '../controller/certificate_controller.dart';

class IssueCertificateView extends GetWidget<ManageCertificateController> {

   final List<String> students = [
    'Ahmed Ali',
    'Mahmoud Mohamed',
    'Mohamed Ahmed',
    'Ali Mahmoud',
    'Hassan Mohamed',
    'Mohamed Hassan',
    'Mahmoud Ali',
    'Hassan Ali',
    'Ali Hassan',
    'Mohamed Mahmoud',
  ];
  final List<String> trainings = [
    'تطوير البرمجيات',
    'تقنية المعلومات',
    'النظم والتشغيل',
  ];
  final RxString selectedStudentId = ''.obs;
  final RxString selectedTrainingId = ''.obs;
  final RxString selectedTemplate = 'default'.obs;
  final TextEditingController validityController = TextEditingController(text: '365');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إصدار شهادة جديدة'),
        backgroundColor: theme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'اختر الطالب',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            SizedBox(height: 16),
            Obx(() {
              return DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'الطالب',
                  border: OutlineInputBorder(),
                ),
                value: selectedStudentId.value.isEmpty ? null : selectedStudentId.value,
                items: students.map((student) {
                  return DropdownMenuItem(
                    value: student,
                    child: Text(student,style: TextStyle(color: theme.primaryColor) ,),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedStudentId.value = value!;
                },
              );
            }),
            SizedBox(height: 24),
            Text(
              'اختر التدريب',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            SizedBox(height: 16),
            Obx(() {
              return DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'التدريب',
                  border: OutlineInputBorder(),
                ),
                value: selectedTrainingId.value.isEmpty ? null : selectedTrainingId.value,
                items: trainings.map((training) {
                  return DropdownMenuItem(
                    value: training,
                    child: Text(training,style: TextStyle(color: theme.primaryColor) ,),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedTrainingId.value = value!;
                },
              );
            }),

            SizedBox(height: 32),
            SizedBox(
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
                  if (selectedStudentId.isEmpty || selectedTrainingId.isEmpty) {
                    Get.snackbar('خطأ', 'الرجاء اختيار الطالب والتدريب');
                    return;
                  }

                  final student = students.firstWhere(
                        (s) => s == selectedStudentId.value,
                  );

                  final training = trainings.firstWhere(
                        (t) => t == selectedTrainingId.value,
                  );


                },
                child: Text(
                  'إصدار الشهادة',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}