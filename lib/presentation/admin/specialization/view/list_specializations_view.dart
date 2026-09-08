import 'package:flutter/material.dart';
import 'package:train_link/presentation/admin/specialization/view/add_specialization_view.dart';
import 'package:train_link/widgets/drawer/admin_drawer.dart';

import '../../../../core/app_export.dart';
import '../../../../core/utils/state_renderer/state_renderer_impl.dart';
import '../controller/specialization_controller.dart';

class ListSpecializationsView extends GetWidget<SpecializationController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminDrawer(),
      appBar: AppBar(
        title: Text('إدارة التخصصات', textDirection: TextDirection.rtl),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              controller.clearForm();
          //    Get.toNamed(Routes.ADD_SPECIALIZATION);
              Get.dialog(AddSpecializationView());
            },
          ),
        ],
      ),
      body: Obx(() => controller.flowState.value.getScreenWidget(_body(), () => controller.flowState.value = ContentState()),),
    );
  }

  _body()=>ListView.builder(
    padding: EdgeInsets.all(10),
    itemCount: controller.specializations.length,
    itemBuilder: (context, index) {
      final specialization = controller.specializations[index];
      return Card(
        margin: EdgeInsets.only(bottom: 10),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          title: Row(
            children: [

              Expanded(
                child: Text(
                  specialization.name,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [

              IconButton(
                icon: Icon(Icons.edit, color: Color(0xFF8417F4)),
                onPressed: () => controller.editSpecialization(specialization),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => controller.deleteSpecialization(specialization.id),
              ),
            ],
          ),
        ),
      );
    },
  );
}