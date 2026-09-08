// student/views/upload_report_view.dart
import 'package:flutter/material.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';

import '../../../../core/app_export.dart';
import '../../training_opportunity/model/training_application_model.dart';
import '../controller/training_report_controller.dart';

class UploadReportView extends StatelessWidget {
  TrainingReportController controller = Get.find();
  final TrainingApplication training;

  UploadReportView({super.key, required this.training});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('رفع تقرير الإنجاز'),
        backgroundColor: theme.primaryColor,
        centerTitle: true,
      ),
      body: Obx(
        () => controller.flowStateUploadReport.value.getScreenWidget(
          _body(),
          () {
            controller.flowStateUploadReport.value = ContentState();
          },
        ),
      ),
    );
  }

  _body() => SingleChildScrollView(
    padding: EdgeInsets.all(16),
    child: Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تعليمات رفع التقرير:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '1. يجب أن يكون التقرير بصيغة PDF\n'
            '2. حجم الملف لا يتجاوز 5MB\n'
            '3. تأكد من تضمين جميع أجزاء التقرير المطلوبة\n'
            '4. يمكنك إضافة ملاحظات إضافية في الحقل أدناه',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 24),
          Text('ملف التقرير:', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          InkWell(
            onTap: controller.pickFile,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.cloud_upload,
                    size: 48,
                    color: controller.selectedFile.isNotEmpty
                        ? Colors.green
                        : Colors.grey,
                  ),
                  SizedBox(height: 8),
                  Text(
                    controller.selectedFile.isNotEmpty
                        ? 'تم اختيار الملف: ${controller.selectedFile.value.split('/').last}'
                        : 'اضغط لاختيار ملف التقرير',
                    style: TextStyle(
                      color: controller.selectedFile.isNotEmpty
                          ? Colors.green
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'ملاحظات إضافية (اختياري):',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          TextField(
            controller: controller.notesController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'أكتب أي ملاحظات إضافية عن التقرير...',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 24),
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
              onPressed: () => controller.submitReport(training),
              child: Text('رفع التقرير', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      );
    }),
  );
}
