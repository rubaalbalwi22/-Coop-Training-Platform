// models/certificate_model.dart
import 'package:flutter/material.dart';

class Certificate {
  final String id;
  final String studentId;
  final String trainingId;
  final String title;
  final String description;
  final DateTime issueDate;
  final String downloadUrl;
  final String fileType; // pdf, png, jpg
  final double fileSize; // in MB

  Certificate({
    required this.id,
    required this.studentId,
    required this.trainingId,
    required this.title,
    required this.description,
    required this.issueDate,
    required this.downloadUrl,
    required this.fileType,
    required this.fileSize,
  });

  String get formattedFileSize {
    return fileSize < 1
        ? '${(fileSize * 1024).toStringAsFixed(0)} KB'
        : '${fileSize.toStringAsFixed(1)} MB';
  }

  IconData get fileTypeIcon {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'png':
      case 'jpg':
      case 'jpeg':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }
}