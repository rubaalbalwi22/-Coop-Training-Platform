import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../../../../theme/theme_helper.dart';
import '../controller/main_controller.dart';

class CompanyMainScreen extends GetWidget<CompanyMainController>{
  const CompanyMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: PageView.builder(
        itemBuilder: (context, index) => controller.screens[index],
        controller: controller.pageController,
        itemCount: controller.screens.length,
        onPageChanged: (value) {
          controller.onItemTapped(value);
        },
      ),
      bottomNavigationBar: Obx(
        () =>BottomNavigationBar(
          showSelectedLabels: true,
          showUnselectedLabels: false,
          unselectedItemColor: Colors.grey[400],
          selectedItemColor: theme.primaryColor,
          currentIndex: controller.currentIndex.value,
          onTap:(value) {
            controller.onItemTapped(value);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list_outlined),
              label:  'فرص التدريب',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'ادارة الدورات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.file_copy),
              label: 'طلبات التدريب',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard),
              label: 'الشهادات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'الملف الشخصي',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: 'تسجيل خروج',
            ),
          ],
        ),
      ),
    );
  }
}
