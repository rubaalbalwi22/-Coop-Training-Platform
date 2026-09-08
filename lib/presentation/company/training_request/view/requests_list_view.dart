// company/views/requests_list_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:train_link/core/app_export.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';
import 'package:train_link/presentation/company/training_request/model/student_model.dart';

import '../../../student/training_opportunity/model/training_application_model.dart';
import '../controller/training_request_controller.dart';
import '../model/training_request_model.dart';
import 'pdf_viewer_screen.dart';

class RequestsListView extends GetWidget<TrainingRequestController> {
  const RequestsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('طلبات التدريب'),
        backgroundColor: theme.primaryColor,
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: Obx(
              () => controller.flowState.value.getScreenWidget(
                _buildRequestsList(),
                () {
                  controller.fetchRequests();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        children: [
          SizedBox(height: 12),
          Obx(() {
            return Wrap(
              spacing: 8,
              children: controller.filters.map((filter) {
                return ChoiceChip(
                  label: Text(filter),
                  selected: controller.selectedFilter.value == filter,
                  onSelected: (selected) {
                    controller.selectedFilter.value = filter;
                  },
                  selectedColor: theme.primaryColor.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: controller.selectedFilter.value == filter
                        ? theme.primaryColor
                        : Colors.grey[700],
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRequestsList() {
    if (controller.filteredRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.list_alt, size: 60, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'لا توجد طلبات متاحة',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.fetchRequests,
      color: theme.primaryColor,
      child: ListView.separated(
        padding: EdgeInsets.all(12),
        itemCount: controller.filteredRequests.length,
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          final request = controller.filteredRequests[index];
          return _buildRequestCard(request);
        },
      ),
    );
  }

  Widget _buildRequestCard(TrainingApplication request) {
    final statusColor = request.status == 'approved' || request.status == 'rated' || request.status == 'unrated'
        ? Colors.green
        : request.status == 'rejected'
        ? Colors.red
        : Colors.orange;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  request.student?.name ?? "",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    request.status == 'approved' || request.status == 'rated' || request.status == 'unrated'
                        ? 'مقبولة'
                        : request.status == 'rejected'
                        ? 'مرفوضة'
                        : 'قيد المراجعة',
                    style: TextStyle(color: statusColor),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              request.title ?? "",
              style: TextStyle(color: theme.primaryColor),
            ),
            SizedBox(height: 8),
            Text(
              'نوع الطلب: ${request.type == TrainingApplicationType.train ? 'دورة' : 'فرصة تدريب'}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Divider(height: 20, thickness: 1),
            Text(
              'الجامعة: ${request.student?.university ?? 'غير محدد'}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 4),
            Text(
              'التخصص: ${request.student?.specialization ?? 'غير محدد'}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              'رسالة الطالب:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(request.requestMsg ?? ""),
            SizedBox(height: 12),
            if (request.status != 'pending') ...[
              Text('رد الشركة:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(request.responseMessage ?? ''),
              SizedBox(height: 12),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  icon: Icon(Icons.person_pin),
                  label: Text('عرض السيرة الذاتية'),
                  onPressed: () {
                    Get.to(
                          () => ViewStudentProfileScreen(
                        student: StudentModel(
                          id: '0',
                          fullName: request.student?.name ?? "",
                          email: '${request.student?.email}',
                          phone:'${request.student?.phone}',
                          cvUrl: request.student?.cvUrl,
                          universityId:'${request.student?.universityId}',
                          universityName: '${request.student?.university}',
                          specializationId:'${request.student?.specializationId}',
                          specializationName: '${request.student?.specialization}',
                          createdAt:request.student?.createdAt??DateTime.now(),
                        ),
                      ),
                    );
                  },
                ),
                if (request.status == 'pending') ...[
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          _showResponseDialog(request.id ?? "", true);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          _showResponseDialog(request.id ?? "", false);
                        },
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showResponseDialog(String requestId, bool isApprove) {
    Get.dialog(
      AlertDialog(
        title: Text(isApprove ? 'قبول الطلب' : 'رفض الطلب'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isApprove
                  ? 'أكتب رسالة القبول (اختياري)'
                  : 'أكتب سبب الرفض (اختياري)',
            ),
            SizedBox(height: 12),
            TextField(
              controller: controller.responseController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: isApprove ? 'رسالة القبول...' : 'سبب الرفض...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('إلغاء')),
          TextButton(
            onPressed: () {
              if (isApprove) {
                controller.approveRequest(
                  requestId,
                  controller.responseController.text,
                );
              } else {
                controller.rejectRequest(
                  requestId,
                  controller.responseController.text,
                );
              }
            },
            child: Text(
              isApprove ? 'قبول' : 'رفض',
              style: TextStyle(color: isApprove ? Colors.green : Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
