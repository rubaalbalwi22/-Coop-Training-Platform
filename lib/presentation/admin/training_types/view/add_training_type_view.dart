import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';
import '../controller/training_type_controller.dart';

class AddTrainingTypeView extends StatelessWidget {
  final TrainingTypeController controller = Get.find();

    AddTrainingTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.isEditing.value
                ? 'تعديل نوع التدريب'
                : 'إضافة نوع تدريب جديد',
            textDirection: TextDirection.rtl,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller.nameController,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  labelText: 'اسم نوع التدريب',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.work),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال اسم نوع التدريب';
                  }
                  return null;
                },
              ),

              SizedBox(height: 30),
              ElevatedButton(
                onPressed: controller.addOrUpdateTrainingType,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  controller.isEditing.value
                      ? 'حفظ التعديلات'
                      : 'إضافة نوع التدريب',
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
