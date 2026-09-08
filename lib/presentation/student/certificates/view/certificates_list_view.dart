// views/certificates_list_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:train_link/presentation/admin/report_management/view/certificate_view.dart';
import 'package:train_link/presentation/student/certificates/controller/certificate_controller.dart';

import '../../../../core/app_export.dart';
import '../model/certificate_model.dart';

class MyCertificatesListView extends GetWidget<MyCertificateController>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('شهاداتي الإلكترونية',style: TextStyle(
          color: theme.primaryColor,
          fontWeight: FontWeight.bold,
        ),),
        backgroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation( theme.primaryColor),
            ),
          );
        }

        if (controller.certificates.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment, size: 60, color: Colors.grey[400]),
                SizedBox(height: 16),
                Text(
                  'لا توجد شهادات متاحة',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchCertificates,
          color:  theme.primaryColor,
          child: ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: controller.certificates.length,
            separatorBuilder: (context, index) => SizedBox(height: 12),
            itemBuilder: (context, index) {
              final cert = controller.certificates[index];
              return _buildCertificateCard(cert);
            },
          ),
        );
      }),
    );
  }

  Widget _buildCertificateCard(Certificate cert) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    cert.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Icon(cert.fileTypeIcon, color:  theme.primaryColor),
              ],
            ),
            SizedBox(height: 8),
            Text(
              cert.description,
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  'تاريخ الإصدار: ${_formatDate(cert.issueDate)}',
                  style: TextStyle(fontSize: 12),
                ),
                Spacer(),
                Icon(Icons.sd_storage, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  cert.formattedFileSize,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            Divider(height: 20, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.remove_red_eye),
                    label: Text('عرض'),
                    onPressed: () {
                      Get.to(CertificateView(
                        duration:  '12 ساعات',
                        studentName: 'اسم الطالب',
                          trainingTitle: 'اسم التدريب',
                        endDate: DateTime.now(),
                      ));
                     },
                    style: OutlinedButton.styleFrom(
                      foregroundColor:  theme.primaryColor,
                      side: BorderSide(color:  theme.primaryColor),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.download),
                    label: Text('تحميل'),
                    onPressed: () {
                     },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}