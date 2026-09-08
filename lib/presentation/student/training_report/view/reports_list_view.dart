// student/views/reports_list_view.dart
import 'package:flutter/material.dart';
import 'package:train_link/core/app_export.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';
import 'package:train_link/presentation/student/training_feedback/view/submit_feedback_view.dart';
import 'package:train_link/presentation/student/training_opportunity/model/training_application_model.dart';
import '../../../admin/report_management/view/certificate_view.dart';
import '../../training_feedback/model/training_feedback_model.dart';
import '../controller/training_report_controller.dart';
import '../model/training_report_model.dart';

class ReportsListView extends GetWidget<TrainingReportController> {
  const ReportsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'شهاداتي',
          style: TextStyle(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Obx(
        () => controller.flowStateReports.value.getScreenWidget(_body(), () {
          controller.fetchReports();
        }),
      ),
    );
  }

  _body() {
    if (controller.reports.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.list_alt, size: 60, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'لا توجد تقارير مرفوعة بعد',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.fetchReports,
      color: theme.primaryColor,
      child: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: controller.reports.length,
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          final report = controller.reports[index];
          return _buildReportCard(report);
        },
      ),
    );
  }

  Widget _buildReportCard(TrainingReport report) {
    final status = _getStatusInfo(report.trainingApplication?.status ?? "");

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  report.trainingTitle ?? "",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: status.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: status.color.withOpacity(0.3)),
                  ),
                  child: Text(
                    status.text,
                    style: TextStyle(color: status.color),
                  ),
                ),
              ],
            ),
            Divider(height: 20, thickness: 1),
            /* Text(
              'اسم الملف: ${report.filePath.split('/').last}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),*/
            SizedBox(height: 8),
            if (report.notes != null && report.notes!.isNotEmpty) ...[
              Text('ملاحظاتك:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(report.notes!),
              SizedBox(height: 8),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تاريخ الرفع:',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      _formatDate(report.submittedAt ?? DateTime.now()),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                if (report.feedback != null && report.feedback!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'ملاحظات المشرف:',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        report.feedback!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              spacing: 10.0,
              children: [
                if (report.trainingApplication?.status == 'rated') ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.visibility),
                      label: Text('عرض الشهاده '),
                      onPressed: () {
                        Get.to(
                          CertificateView(
                            duration:
                                '${report.trainingApplication?.duration} ساعات',
                            studentName: report.student?.name ?? "",
                            trainingTitle:
                                report.trainingApplication?.title ?? "",
                            endDate:
                                report.trainingApplication?.endDate ??
                                DateTime.now(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.primaryColor,
                        side: BorderSide(color: theme.primaryColor),
                      ),
                    ),
                  ),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.rate_review),
                      label: Text('تقييمي السابق '),
                      onPressed: () {
                        if (report.trainingFeedback == null) {
                          Get.snackbar(
                            'تنبيه',
                            'تم حزفه من قبل المشرف',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        } else {
                          Get.dialog(
                            Dialog(
                              child: _buildFeedbackCard(
                                report.trainingFeedback!,
                                report.trainingApplication!.title ?? "",
                              ),
                            ),
                          );
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.primaryColor,
                        side: BorderSide(color: theme.primaryColor),
                      ),
                    ),
                  ),
                ],

                if (report.trainingApplication?.status == 'unrated')
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.rate_review),
                      label: Text('تقييم'),
                      onPressed: () {
                        Get.to(
                          SubmitFeedbackView(
                            trainingId: report.trainingId ?? "",
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.primaryColor,
                        side: BorderSide(color: theme.primaryColor),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _StatusInfo _getStatusInfo(String status) {
    switch (status) {
      case 'rated':
        return _StatusInfo('مقيم', Colors.green);
      case 'unrated':
        return _StatusInfo('غير مقيم', Colors.grey);
      case 'rejected':
        return _StatusInfo('مرفوض', Colors.red);
      default:
        return _StatusInfo('قيد المراجعة', Colors.orange);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildFeedbackCard(TrainingFeedback feedback, String title) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'تقييم التدريب #${title}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Row(
                  children: [
                    Text(
                      '${feedback.rating}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Icon(Icons.star, color: Colors.amber, size: 20),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            if (feedback.isAnonymous)
              Text(
                'تقييم مجهول',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            Divider(height: 20, thickness: 1),
            Text('تعليقك:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(feedback.comment),
            SizedBox(height: 12),
            Text(
              'تاريخ التقييم: ${_formatDate(feedback.submittedAt)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusInfo {
  final String text;
  final Color color;

  _StatusInfo(this.text, this.color);
}
