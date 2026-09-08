import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../model/onboarding_content.dart';

class OnboardingView extends StatelessWidget {
  final RxInt _currentPage = 0.obs;

  OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () => Get.offAllNamed(AppRoutes.loginScreen),
            child: Text(
              'تخطي',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
        elevation: 0,

      ),
      body: Obx(() {
        final content = OnboardingContent.contents[_currentPage.value];
        return Container(
          width: double.infinity ,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Icon(
                content.icon,
                size: MediaQuery.of(context).size.height * 0.25,
                color: Color(0xFF8417F4),
              ),
              SizedBox(height: 40),
              Text(
                content.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: 20),
              Text(
                content.description,
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
                SizedBox(height: 10),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: _currentPage.value,
          onTap: (index) => _currentPage.value = index,
          selectedItemColor: Color(0xFF8417F4),
          unselectedItemColor: Colors.grey,
          items: List.generate(
            OnboardingContent.contents.length,
                (index) => BottomNavigationBarItem(
              icon: Icon(OnboardingContent.contents[index].icon),
              label: '',
            ),
          ),
        );
      }),
    );
  }

 }
