// company/views/course_form_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:train_link/core/app_export.dart';

import '../controller/training_course_controller.dart';
import '../model/training_course_model.dart';

class CourseFormView extends GetWidget<TrainingCourseController> {
  final TrainingCourse? course;

  const CourseFormView({super.key, this.course});

  @override
  Widget build(BuildContext context) {
    final isEdit = course != null;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEdit ? 'تعديل الدورة' : 'إضافة دورة جديدة'),
          backgroundColor: theme.primaryColor,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'معلومات أساسية',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: controller.titleController,
                  decoration: InputDecoration(
                    labelText: 'عنوان الدورة',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: controller.descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'وصف الدورة',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'التصنيف',
                    border: OutlineInputBorder(),
                  ),
                  value: controller.selectedCategory.value.isEmpty
                      ? null
                      : controller.selectedCategory.value,
                  items: controller.categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(
                        category,
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.selectedCategory.value = value!;
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'المستوى',
                          border: OutlineInputBorder(),
                        ),
                        value: controller.selectedLevel.value,
                        items: controller.levels.map((level) {
                          return DropdownMenuItem(
                            value: level,
                            child: Text(
                              level,
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          controller.selectedLevel.value = value!;
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'وضع الدورة',
                          border: OutlineInputBorder(),
                        ),
                        value: controller.selectedMode.value,
                        items: controller.modes.map((mode) {
                          return DropdownMenuItem(
                            value: mode,
                            child: Text(
                              mode,
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          controller.selectedMode.value = value!;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                if (controller.selectedMode.value == 'حضوري')
                  TextField(
                    controller: controller.locationController,
                    decoration: InputDecoration(
                      labelText: 'موقع الدورة',
                      border: OutlineInputBorder(),
                    ),
                  ),
                SizedBox(height: 24),
                Text(
                  'التفاصيل الزمنية',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.durationController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'عدد الأسابيع',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: controller.hoursController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'ساعات أسبوعية',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => controller.selectStartDate(context),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'تاريخ البدء',
                            border: OutlineInputBorder(),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                controller.startDate.value != null
                                    ? '${controller.startDate.value!.day}/${controller.startDate.value!.month}/${controller.startDate.value!.year}'
                                    : 'اختر التاريخ',
                              ),
                              Icon(Icons.calendar_today),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () => controller.selectEndDate(context),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'تاريخ الانتهاء',
                            border: OutlineInputBorder(),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                controller.endDate.value != null
                                    ? '${controller.endDate.value!.day}/${controller.endDate.value!.month}/${controller.endDate.value!.year}'
                                    : 'اختر التاريخ',
                              ),
                              Icon(Icons.calendar_today),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),
                TextField(
                  controller: controller.participantsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'عدد المقاعد',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Obx(
                  () =>  Visibility(
                    visible:controller.selectedMode.value == 'حضوري',
                    child: TextField(
                      controller: controller.locationController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'موقع الدورة',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'صورة الدورة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
                SizedBox(height: 8),
                InkWell(
                  onTap: controller.pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[100],
                    ),
                    child: controller.imagePath.value.isNotEmpty
                        ? CustomImageView(
                            imagePath:controller.imagePath.value,
                            fit: BoxFit.cover,
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              Text('اضغط لإضافة صورة للدورة'),
                            ],
                          ),
                  ),
                ),
                SizedBox(height: 16),
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'المعايير المضافة:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...controller.criteriaList.map(
                        (criterion) => ListTile(
                          title: Text(criterion),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () =>
                                controller.criteriaList.remove(criterion),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.criteriaController,
                        decoration: InputDecoration(labelText: 'أدخل معيارًا'),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        final text = controller.criteriaController.text.trim();
                        if (text.isNotEmpty) {
                          controller.criteriaList.add(text);
                          controller.criteriaController.clear();
                        }
                      },
                    ),
                  ],
                ),

                SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: controller.isActive.value,
                      onChanged: (value) {
                        controller.isActive.value = value!;
                      },
                    ),
                    Text('تفعيل الدورة'),
                  ],
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (isEdit) {
                        controller.updateCourse(course!);
                      } else {
                        controller.addCourse();
                      }
                    },
                    child: Text(
                      isEdit ? 'حفظ التعديلات' : 'إضافة الدورة',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
