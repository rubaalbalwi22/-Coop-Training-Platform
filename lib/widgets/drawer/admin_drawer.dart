import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: 300,
            child: DrawerHeader(
              child: Column(
                children: [
                  Image.asset('assets/images/logo.png'),
                  SizedBox(height: 10),
                  Text(
                    'مرحبا بك المشرف',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                _buildListTileItem(
                  title: 'إدارة الجامعات',
                  icon: Icons.school,
                  onTap: () => Get.toNamed(AppRoutes.listOfUniversityScreen),
                ),
                Divider(),
                _buildListTileItem(
                  title: 'إدارة أنواع التدريب',
                  icon: Icons.work,
                  onTap: () => Get.toNamed(AppRoutes.listOfTrainingTypeScreen),
                ),
                Divider(),
                _buildListTileItem(
                  title: 'إدارة التخصصات',
                  icon: Icons.category,
                  onTap: () =>
                      Get.toNamed(AppRoutes.listOfSpecializationScreen),
                ),
                Divider(),
                _buildListTileItem(
                  title: 'إدارة الكلمات المحظورة',
                  icon: Icons.block,
                  onTap: () => Get.toNamed(AppRoutes.listOfBannedWordScreen),
                ),
                Divider(),
                _buildListTileItem(
                  title: 'إدارة المستخدمين',
                  icon: Icons.people,
                  onTap: () => Get.toNamed(AppRoutes.listOfUsersScreen),
                ),
                Divider(),
                _buildListTileItem(
                  title: 'إدارة فرص التدريب',
                  icon: Icons.work_outline,
                  onTap: () => Get.toNamed(AppRoutes.listOfTrainingScreen),
                ),
                Divider(),
                _buildListTileItem(
                  title: 'إدارة الدورات',
                  icon: Icons.book,
                  onTap: () => Get.toNamed(AppRoutes.listOfCoursesScreen),
                ),
                Divider(),
                _buildListTileItem(
                  title: 'إدارة التعليقات',
                  icon: Icons.comment,
                  onTap: () => Get.toNamed(AppRoutes.listOfCommentsScreen),
                ),
                Divider(),
                _buildListTileItem(
                  title: 'تقارير المتدربين',
                  icon: Icons.assignment,
                  onTap: () => Get.toNamed(AppRoutes.listOfCertificatesScreen),
                ),

                Divider(),
                _buildListTileItem(
                  title: 'تسجيل الخروج',
                  icon: Icons.logout,
                  onTap: () async {
                    Get.defaultDialog<bool>(
                      title: 'تأكيد',
                      middleText: 'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
                      textConfirm: 'نعم',
                      textCancel: 'لا',
                      confirmTextColor: Colors.white,
                      onConfirm: () {
                        Get.offAllNamed(AppRoutes.loginScreen);
                      },
                    );
                  },
                ),

                // يمكنك إضافة المزيد من العناصر هنا
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTileItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: theme.primaryColor),
      title: Text(
        title,
        textAlign: TextAlign.right,
        style: TextStyle(fontSize: 16),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
