import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:train_link/presentation/company/ex_certificate/view/certificates_management_view.dart';
import 'package:train_link/presentation/company/my_profile_company/view/my_profile_company.dart';
import 'package:train_link/presentation/company/training_course/view/courses_list_view.dart';
import 'package:train_link/presentation/company/training_opportunity/view/opportunities_list_view.dart';
import 'package:train_link/presentation/company/training_request/view/requests_list_view.dart';
import '../../../../core/app_export.dart';

class CompanyMainController extends GetxController {
  final List<Widget> screens = [
 OpportunitiesListView(),
    CoursesListView(),
    RequestsListView(),
    CertificatesManagementView(),
    CompanyProfileView()
  ];

  final PageController pageController = PageController(initialPage: 0);
  RxInt currentIndex = 0.obs;

  void onItemTapped(int index) {
    currentIndex.value = index;
    if(index != 5) {
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