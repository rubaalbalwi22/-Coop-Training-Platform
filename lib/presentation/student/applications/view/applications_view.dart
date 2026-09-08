// student/views/applications_view.dart
import 'package:flutter/material.dart';
import 'package:train_link/core/app_export.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';

import '../../training_feedback/view/submit_feedback_view.dart';
import '../../training_opportunity/model/training_application_model.dart';
import '../../training_report/view/upload_report_view.dart';
import '../controller/applications_controller.dart';
import '../model/application_status_model.dart';

class ApplicationsView extends GetWidget<ApplicationsController> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'حالة طلباتي',
            style: TextStyle(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          bottom: TabBar(
            tabs: [
              Tab(text: 'الفرص التدريبية'),
              Tab(text: 'الدورات'),
            ],
            labelColor: theme.primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: theme.primaryColor,
          ),
        ),
        body: TabBarView(
          children: [
            // First tab - Training Opportunities
            _buildApplicationsTab(TrainingApplicationType.train),

            // Second tab - Courses
            _buildApplicationsTab(TrainingApplicationType.course),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationsTab(TrainingApplicationType type) {
    return Column(
      children: [
        _buildFilterBar(),
        Expanded(
          child: Obx(
            () => controller.flowState.value.getScreenWidget(_body(type), () {
              controller.fetchApplications();
            }),
          ),
        ),
      ],
    );
  }

  _body(type) {
    // Filter applications by type
    final filteredByType = controller.filteredApplications
        .where((app) => app.type == type)
        .toList();

    if (filteredByType.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.list_alt, size: 60, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              controller.selectedFilter.value == 'الكل'
                  ? 'لا توجد طلبات مقدمه'
                  : 'لا توجد طلبات ${controller.selectedFilter.value}',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.fetchApplications,
      color: theme.primaryColor,
      child: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: filteredByType.length,
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          final application = filteredByType[index];
          return _buildApplicationCard(application,index);
        },
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.filters.length,
        itemBuilder: (context, index) {
          final filter = controller.filters[index];
          return Obx(
            () => Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: FilterChip(
                label: Text(filter),
                selected: controller.selectedFilter.value == filter,
                onSelected: (selected) {
                  controller.changeFilter(filter);
                },
                selectedColor: theme.primaryColor.withOpacity(0.2),
                checkmarkColor: theme.primaryColor,
                labelStyle: TextStyle(
                  color: controller.selectedFilter.value == filter
                      ? theme.primaryColor
                      : Colors.grey[700],
                ),
                shape: StadiumBorder(
                  side: BorderSide(
                    color: controller.selectedFilter.value == filter
                        ? theme.primaryColor
                        : Colors.grey[300]!,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildApplicationCard(TrainingApplication application,int index) {
    final status = ApplicationStatus.values.firstWhere(
      (e) => e.name == application.status,
      orElse: () => ApplicationStatus.pending,
    );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'طلب #${index+1}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: status.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: status.color.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(status.icon, size: 16, color: status.color),
                        SizedBox(width: 4),
                        Text(
                          status.arabicText,
                          style: TextStyle(color: status.color),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(height: 20, thickness: 1),
              SizedBox(height: 5),
              Text(
                'نوع الطلب: ${application.type == TrainingApplicationType.course ? 'دورة' : 'فرصه تدريب '}',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 5),

              if (application.requestMsg?.isNotEmpty ?? false) ...[
                Text('رسالتك:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(application.requestMsg ?? ''),
                SizedBox(height: 12),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تاريخ التقديم:',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        _formatDate(application.appliedAt ?? DateTime.now()),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  if (application.processedAt != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'تاريخ الرد:',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          _formatDate(application.processedAt!),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.0),
                      ],
                    ),
                ],
              ),
              if (application.status == 'approved' &&
                  application.type == TrainingApplicationType.train)
                Row(
                  spacing: 5,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.upload_file),
                        label: Text('رفع تقرير'),
                        onPressed: () {
                          Get.to(
                            () => UploadReportView(
                              training: application,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
