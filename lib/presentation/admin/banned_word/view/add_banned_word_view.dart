import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';
import '../controller/banned_word_controller.dart';

class AddBannedWordView extends StatelessWidget {
  final BannedWordController controller = Get.find();

  AddBannedWordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller.wordController,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  labelText: 'الكلمة المحظورة',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.block),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال الكلمة المحظورة';
                  }
                  return null;
                },
              ),

              SizedBox(height: 30),
              ElevatedButton(
                onPressed: controller.addOrUpdateBannedWord,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  controller.isEditing.value ? 'حفظ التعديلات' : 'إضافة الكلمة',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
