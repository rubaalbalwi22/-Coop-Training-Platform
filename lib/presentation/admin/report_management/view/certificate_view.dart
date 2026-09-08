import 'package:flutter/material.dart';
import 'package:gallery_saver_plus/gallery_saver.dart' show GallerySaver;
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:train_link/core/app_export.dart';

class CertificateView extends StatelessWidget {
  final String studentName;
  final String trainingTitle;
  final String duration;
  final DateTime endDate;

  // لأخذ لقطة للشاشة
  final screenshotController = ScreenshotController();

  CertificateView({
    required this.studentName,
    required this.trainingTitle,
    required this.duration,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('شهادة التدريب', textDirection: TextDirection.rtl),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () => _saveCertificateAsPng(),
            tooltip: 'حفظ كصورة',
          ),
        ],
      ),
      body: Center(
        child: Screenshot(
          controller: screenshotController,
          child: CertificateWidget(
            endDate: endDate ,
            studentName: studentName,
            trainingTitle: trainingTitle,
            duration: duration,
          ),
        ),
      ),
    );
  }

  Future<void> _saveCertificateAsPng() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/شهادة_${DateTime.now().millisecondsSinceEpoch}.png';

      // أخذ لقطة للشاشة وحفظها
      await screenshotController.captureAndSave(
        directory.path,
        fileName: 'شهادة_${DateTime.now().millisecondsSinceEpoch}.png',
      );

      // حفظ الصورة في معرض الصور
      await GallerySaver.saveImage(imagePath);

      Get.snackbar(
        'نجاح',
        'تم حفظ الشهادة في المعرض',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في حفظ الشهادة: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

class CertificateWidget extends StatelessWidget {
  final String studentName;
  final String trainingTitle;
  final String duration;
  final DateTime endDate;
  const CertificateWidget({
    required this.studentName,
    required this.trainingTitle,
    required this.duration,
    required this.endDate,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'شهادة إتمام التدريب',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color:theme.primaryColor,
            ),
          ),
          SizedBox(height: 40),
          Text(
            'يُشهد أن',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            studentName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'قد أتم بنجاح برنامج التدريب',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            trainingTitle,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'لمدة $duration',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('التاريخ: ${intl.DateFormat('yyyy/MM/dd').format(endDate)}'),
                  SizedBox(height: 20),
                  Text('مدير البرنامج'),
                ],
              ),
              Column(
                children: [
                  Text('التوقيع'),
                  Container(
                    width: 150,
                    height: 2,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}