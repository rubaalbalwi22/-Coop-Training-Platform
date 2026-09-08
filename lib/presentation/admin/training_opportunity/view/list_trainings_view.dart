import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';
import 'package:train_link/widgets/drawer/admin_drawer.dart';
import '../../../../core/app_export.dart';
import '../../../company/training_opportunity/model/training_opportunity_model.dart';
import '../controller/training_management_controller.dart';

class ListTrainingsView extends StatelessWidget {
  final controller = Get.put(TrainingManagementController());
  final theme = Theme.of(Get.context!);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminDrawer(),
      appBar: AppBar(
        title: Text('إدارة فرص التدريب', textDirection: TextDirection.rtl),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: Obx(()=>controller.flowState.value.getScreenWidget(_body(), (){
              controller.fetchTrainings();
            })),
          ),
        ],
      ),
    );
  }

  _body(){
    if (controller.filteredTrainings.isEmpty) {
      return Center(
        child: Text(
          'لا توجد فرص تدريب متاحة',
          textDirection: TextDirection.rtl,
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: controller.filteredTrainings.length,
      itemBuilder: (context, index) {
        final training = controller.filteredTrainings[index];
        return _buildTrainingCard(training);
      },
    );
  }

  Widget _buildFilters() {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            TextField(
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                labelText: 'بحث',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                controller.searchQuery.value = value;
                controller.applyFilters();
              },
            ),
            SizedBox(height: 10),
            Obx(() => DropdownButtonFormField<String>(
              value: controller.selectedStatus.value,
              decoration: InputDecoration(
                labelText: 'حالة الفرصة',
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text('الكل',
                      style: TextStyle(color: Colors.black),
                      textDirection: TextDirection.rtl),
                ),
                ...[
                  'pending',
                  'approved',
                  'rejected',
                ].map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(
                      status == 'pending'? 'قيد المراجعة' :
                      status == 'approved' ? 'مقبولة' : 'مرفوضة',
                      style: TextStyle(color: _getStatusColor(status)),
                      textDirection: TextDirection.rtl,
                    ),
                  );
                }),
              ],
              onChanged: (value) {
                controller.selectedStatus.value = value;
                controller.applyFilters();
              },
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingCard(TrainingOpportunity training) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: () => controller.viewTrainingDetails(training),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      training.title??"",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  _buildStatusBadge(training.status??""),
                ],
              ),
              SizedBox(height: 8),

              // Description
              Text(
                training.description??"",
                textDirection: TextDirection.rtl,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 8),

              // Location and Dates
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    training.location??"",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    '${intl.DateFormat('yyyy/MM/dd').format(training.startDate??DateTime.now())} - ${intl.DateFormat('yyyy/MM/dd').format(training.endDate??DateTime.now())}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),

              // Action Buttons
              if (training.status == 'pending')
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => controller.updateTrainingStatus(training.id??"", 'approved'),
                      icon: Icon(Icons.check, size: 18),
                      label: Text('قبول'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => controller.updateTrainingStatus(training.id??"", 'rejected'),
                      icon: Icon(Icons.close, size: 18),
                      label: Text('رفض'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color statusColor = _getStatusColor(status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor),
      ),
      child: Text(
        _getStatusText(status),
        style: TextStyle(
          color: statusColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending': return 'قيد المراجعة';
      case 'approved': return 'مقبولة';
      case 'rejected': return 'مرفوضة';
      default: return '';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'approved': return Colors.green;
      case 'rejected': return Colors.red;
      default: return Colors.grey;
    }
  }
}