import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';
import '../controller/specialization_controller.dart';

class AddSpecializationView extends StatelessWidget {
  final SpecializationController controller = Get.find();

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
                controller: controller.nameController,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  labelText: 'اسم التخصص',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال اسم التخصص';
                  }
                  return null;
                },
              ),

              SizedBox(height: 30),
              ElevatedButton(
                onPressed: controller.addOrUpdateSpecialization,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  controller.isEditing.value ? 'حفظ التعديلات' : 'إضافة التخصص',
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
