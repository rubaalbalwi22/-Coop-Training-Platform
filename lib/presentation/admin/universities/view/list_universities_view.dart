import 'package:flutter/material.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';

import '../../../../core/app_export.dart';
import '../../../../widgets/drawer/admin_drawer.dart';
import '../controller/university_controller.dart';
import 'add_university_view.dart';

class ListUniversitiesView extends GetWidget<UniversityController> {
  ListUniversitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminDrawer(),
      appBar: AppBar(
        title: Text('إدارة الجامعات', textDirection: TextDirection.rtl),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              controller.clearForm();
              //  Get.toNamed(AppRoutes.addUniversityScreen);
              Get.dialog(AddUniversityView());
            },
          ),
        ],
      ),
      body: Obx(() {
        return controller.flowState.value.getScreenWidget(_body(), () {
          controller.flowState.value = ContentState();
        });
      }),
    );
  }

  _body() => ListView.builder(
    padding: EdgeInsets.all(10),
    itemCount: controller.universities.length,
    itemBuilder: (context, index) {
      final university = controller.universities[index];
      return Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            university.name,
            textDirection: TextDirection.rtl,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.location_on, color: Color(0xFF8417F4), size: 20),
                  SizedBox(width: 5),
                  Text(university.location, textDirection: TextDirection.rtl),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.email, color: Color(0xFF8417F4), size: 20),
                  SizedBox(width: 5),
                  Text(
                    university.contactEmail,

                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Color(0xFF8417F4)),
                onPressed: () => controller.editUniversity(university),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => controller.deleteUniversity(university.id),
              ),
            ],
          ),
        ),
      );
    },
  );
}
