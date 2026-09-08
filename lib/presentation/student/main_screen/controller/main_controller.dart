import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:train_link/presentation/student/applications/view/applications_view.dart';
import 'package:train_link/presentation/student/myprofile/view/my_profile.dart';
 import 'package:train_link/presentation/student/training_opportunity/view/training_opportunities_view.dart';
import 'package:train_link/presentation/student/training_report/view/reports_list_view.dart';

import '../../../../core/app_export.dart';
import '../../training_report/controller/training_report_controller.dart';

class MainController extends GetxController {
 final TrainingReportController _klcontroller = Get.find();

  final List<Widget> screens = [
    TrainingOpportunitiesView(),
    ApplicationsView(),
    ReportsListView(),
    StudentProfileScreen()
   ];

  final PageController pageController = PageController(initialPage: 0);
  RxInt currentIndex = 0.obs;

  void onItemTapped(int index) {
    currentIndex.value = index;
    if(index != 4) {
      pageController.jumpToPage(index);
    }else {
      Get.defaultDialog(
        title: 'هل انت متاكد من تسجيل الخروج؟',
        middleText: '',
        textConfirm: 'نعم',
        textCancel: 'لا',
        onConfirm: () {
          FirebaseAuth.instance.signOut();
          Get.offAllNamed(AppRoutes.loginScreen);
        },
      );
    }
  }







}