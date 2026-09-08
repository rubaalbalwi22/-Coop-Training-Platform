import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/app_export.dart';
import '../model/student_model.dart';

class ViewStudentProfileScreen extends StatelessWidget {
  final StudentModel student;

  const ViewStudentProfileScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'الملف الشخصي للطالب',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: theme.primaryColor,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(),
              SizedBox(height: 24),

              // Personal Information Card
              _buildInfoCard(
                title: 'المعلومات الشخصية',
                children: [
                  _buildInfoRow('الاسم الكامل', student.fullName),
                  _buildDivider(),
                  _buildInfoRow('البريد الإلكتروني', student.email),
                  _buildDivider(),
                  _buildInfoRow('رقم الهاتف', student.phone),
                ],
              ),

              SizedBox(height: 20),

              // Academic Information Card
              _buildInfoCard(
                title: 'المعلومات الأكاديمية',
                children: [
                  _buildInfoRow('الجامعة', student.universityName),
                  _buildDivider(),
                  _buildInfoRow('التخصص', student.specializationName),
                ],
              ),

              // CV Card
              if (student.cvUrl != null) ...[
                SizedBox(height: 20),
                _buildCvCard(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.primaryColor.withOpacity(0.2),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[200],
              backgroundImage: student.profileImage != null
                  ? NetworkImage(student.profileImage!)
                  : AssetImage(ImageConstant.imageNotFound) as ImageProvider,
            ),
          ),
          SizedBox(height: 16),
          Text(
            student.fullName,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
          SizedBox(height: 4),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'طالب',
              style: TextStyle(
                fontSize: 14,
                color: theme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(fontSize: 15, color: Colors.black87),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Divider(height: 1, color: Colors.grey[200]),
    );
  }

  Widget _buildCvCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'السيرة الذاتية',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.picture_as_pdf,
                      size: 28,
                      color: Colors.red[400],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.cvFileName ?? 'السيرة الذاتية',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'PDF ملف',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.download, size: 20),
                    label: Text('تحميل الملف'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      _downloadAndOpenCv(student.cvUrl ?? '');
                    },
                  ),
                ),
                /*  SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.remove_red_eye, size: 20),
                    label: Text('عرض'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.primaryColor,
                      side: BorderSide(color: theme.primaryColor),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _viewCvInBrowser,
                  ),
                ),*/
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadAndOpenCv(String cvUrl) async {
    Get.dialog(
      Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
        ),
      ),
      barrierDismissible: false,
    );

    if (await canLaunchUrlString(cvUrl)) {
      await launchUrlString(cvUrl);
    }

    Get.back();
  }

  Future<void> _viewCvInBrowser() async {
    try {
      Get.defaultDialog(
        title: 'عرض السيرة الذاتية',
        titleStyle: TextStyle(
          color: theme.primaryColor,
          fontWeight: FontWeight.bold,
        ),
        content: Column(
          children: [
            Icon(Icons.picture_as_pdf, size: 60, color: Colors.red[400]),
            SizedBox(height: 16),
            Text(
              'سيتم فتح السيرة الذاتية في المتصفح',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        confirm: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: () => Get.back(),
          child: Text('حسناً', style: TextStyle(color: Colors.white)),
        ),
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'تعذر فتح الملف: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
    }
  }
}
