import 'package:flutter/material.dart';

class OnboardingContent {
  final IconData icon;
  final String title;
  final String description;

  OnboardingContent({
    required this.icon,
    required this.title,
    required this.description,
  });

  static List<OnboardingContent> contents = [
    OnboardingContent(
      icon: Icons.search,
      title: 'ابحث عن فرص التدريب المثالية',
      description: 'اكتشف برامج التدريب الداخلي حسب تخصصك',
    ),
    OnboardingContent(
      icon: Icons.business_center,
      title: 'تواصل مع أفضل الشركات',
      description: 'تقدم مباشرة إلى فرص التدريب من شركات موثوقة',
    ),
    OnboardingContent(
      icon: Icons.check_circle_outline,
      title: 'تابع تقدمك',
      description: 'إدارة جميع طلباتك في مكان واحد واحصل على شهادات معتمدة',
    ),
  ];
}
