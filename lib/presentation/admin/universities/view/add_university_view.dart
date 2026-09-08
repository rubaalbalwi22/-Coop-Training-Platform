import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';
import '../controller/university_controller.dart';

class AddUniversityView extends StatelessWidget {
  final UniversityController controller = Get.find();

  AddUniversityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(30),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller.nameController,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  labelText: 'اسم الجامعة',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.school),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال اسم الجامعة';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: controller.locationController,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  labelText: 'المدينة',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال موقع الجامعة';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: controller.emailController,
                textDirection: TextDirection.rtl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال البريد الإلكتروني';
                  }
                  if (!value.isEmail) {
                    return 'يرجى إدخال بريد إلكتروني صحيح';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: controller.addOrUpdateUniversity,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  controller.isEditing.value
                      ? 'حفظ التعديلات'
                      : 'إضافة الجامعة',
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
