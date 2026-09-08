import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:train_link/presentation/student/main_screen/controller/main_controller.dart';

import '../../../../theme/theme_helper.dart';

class UserMainScreen extends GetWidget<MainController>{
  const UserMainScreen({super.key});

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
          selectedItemColor:  Colors.white,
          currentIndex: controller.currentIndex.value,
          backgroundColor:theme.primaryColor,
          onTap:(value) {
            controller.onItemTapped(value);
          },
          items:   [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'الرئيسية',
              backgroundColor:theme.primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'الطلبات',
              backgroundColor:theme.primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard),
              label: 'شهاداتي',
              backgroundColor:theme.primaryColor,
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'الملف الشخصي',
              backgroundColor:theme.primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: 'تسجيل خروج',
              backgroundColor:theme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
