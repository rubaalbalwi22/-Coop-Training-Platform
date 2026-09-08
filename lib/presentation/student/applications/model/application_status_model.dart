// student/models/application_status_model.dart
import 'package:flutter/material.dart';

enum ApplicationStatus {
  pending('قيد المراجعة', Icons.hourglass_top, Colors.orange),
  approved('مقبول', Icons.check_circle, Colors.green),
  rejected('مرفوض', Icons.cancel, Colors.red);

  final String arabicText;
  final IconData icon;
  final Color color;

  const ApplicationStatus(this.arabicText, this.icon, this.color);
}