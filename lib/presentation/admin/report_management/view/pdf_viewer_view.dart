import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import '../../../../core/app_export.dart';

class PdfViewerView extends StatelessWidget {
  final String pdfUrl;

  const PdfViewerView({required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('عرض التقرير', textDirection: TextDirection.rtl),
        centerTitle: true,
      ),
      body: PDFView(
        filePath: pdfUrl,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
        onError: (error) {
          Get.snackbar('خطأ', 'فشل في عرض الملف');
        },
        onPageError: (page, error) {
          Get.snackbar('خطأ', 'فشل في تحميل الصفحة $page');
        },
      ),
    );
  }
}