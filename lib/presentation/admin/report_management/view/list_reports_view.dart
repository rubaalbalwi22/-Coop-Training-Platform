import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';
import 'package:train_link/widgets/drawer/admin_drawer.dart';

import '../../../../core/app_export.dart';
import '../../../student/training_report/model/training_report_model.dart';
import '../controller/report_management_controller.dart';

class ListReportsView extends StatelessWidget {
  final ReportManagementController controller = Get.put(
    ReportManagementController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminDrawer(),
      appBar: AppBar(
        title: Text('تقارير المتدربين', textDirection: TextDirection.rtl),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.flowState.value.getScreenWidget(_body(), () {
          controller.flowState.value = ContentState();
        }),
      ),
    );
  }

  _body() {
    if (controller.reports.isEmpty) {
      return Center(
        child: Text('لا توجد تقارير متاحة', textDirection: TextDirection.rtl),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: controller.reports.length,
      itemBuilder: (context, index) {
        final report = controller.reports[index];
        return _buildReportCard(report);
      },
    );
  }

  Widget _buildReportCard(TrainingReport report) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              report.student?.name ?? "",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'تاريخ البدء: ${intl.DateFormat('yyyy/MM/dd').format(report.trainingApplication?.appliedAt ?? DateTime.now())}',
                  textDirection: TextDirection.rtl,
                ),
                Text(
                  'تاريخ الانتهاء: ${intl.DateFormat('yyyy/MM/dd').format(report.trainingApplication?.endDate ?? DateTime.now())}',
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.viewReport(report),
                    child: Text('عرض التقرير'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (report.trainingApplication?.endDate?.isBefore(
                            DateTime.now().subtract(Duration(days: 1)),
                          ) ??
                          false) {
                        controller.viewCertificate(report);
                      } else {
                        Get.snackbar(
                          'خطاء',
                          'لا يمكن عرض الشهادة قبل انتهاء التدريب',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: theme.primaryColor,
                      side: BorderSide(color: theme.primaryColor, width: 2),
                      backgroundColor: Colors.white,
                    ),
                    child: Text('عرض الشهادة'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
