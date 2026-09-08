import 'package:flutter/material.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';
import 'package:train_link/widgets/drawer/admin_drawer.dart';

import '../../../../core/app_export.dart';
import '../controller/training_type_controller.dart';
import 'add_training_type_view.dart';

class ListTrainingTypesView extends GetWidget<TrainingTypeController> {

    const ListTrainingTypesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminDrawer(),
      appBar: AppBar(
        title: Text('إدارة أنواع التدريب', textDirection: TextDirection.rtl),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              controller.clearForm();
             // Get.toNamed(AppRoutes.addTrainingTypeScreen);
              Get.dialog(AddTrainingTypeView());
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

  _body() =>ListView.builder(
    padding: EdgeInsets.all(10),
    itemCount: controller.trainingTypes.length,
    itemBuilder: (context, index) {
      final trainingType = controller.trainingTypes[index];
      return Card(
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          title: Text(
            trainingType.name,
            textDirection: TextDirection.rtl,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Color(0xFF8417F4)),
                onPressed: () => controller.editTrainingType(trainingType),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => controller.deleteTrainingType(trainingType.id),
              ),
            ],
          ),
        ),
      );
    },
  );
}