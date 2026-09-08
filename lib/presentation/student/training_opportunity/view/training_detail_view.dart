// student/views/training_detail_view.dart
import 'package:flutter/material.dart';
import 'package:train_link/core/app_export.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';
import '../../../company/training_opportunity/model/training_opportunity_model.dart';
import '../controller/training_application_controller.dart';
import '../model/training_application_model.dart';

class TrainingDetailView extends StatelessWidget {
  final TrainingOpportunity opportunity;
  final TrainingApplicationController controller = Get.put(
    TrainingApplicationController(),
  );
  TrainingDetailView({super.key, required this.opportunity});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تفاصيل الفرصة'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // تفاصيل الفرصة
            _buildOpportunityDetails(),
            SizedBox(height: 24),
            Divider(height: 24, thickness: 1),
            Text(
              'المعاير:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              opportunity.criteria
                      ?.map((String criterion) => '- $criterion')
                      .join('\n') ??
                  "",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            // نموذج التقديم
            _buildApplicationForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildOpportunityDetails() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              opportunity.title ?? "",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.business, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  opportunity.companyName ?? "",
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ],
            ),
            Divider(height: 24, thickness: 1),
            Text('وصف الفرصة:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(opportunity.description ?? ""),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildDetailChip(
                  icon: Icons.timer,
                  label: '${opportunity.durationHours} ساعة',
                ),
                _buildDetailChip(
                  icon: opportunity.mode == 'حضوري'
                      ? Icons.location_on
                      : Icons.wifi,
                  label: opportunity.mode ?? "",
                ),
                _buildDetailChip(
                  icon: Icons.people,
                  label: '${opportunity.capacity} مقاعد',
                ),
                /*_buildDetailChip(
                  icon: Icons.school,
                  label: opportunity.,
                ),*/
                _buildDetailChip(
                  icon: opportunity.type == 'دورة تدريبية'
                      ? Icons.book
                      : Icons.work,
                  label: opportunity.type ?? "",
                ),
                _buildDetailChip(
                  icon: Icons.calendar_today,
                  label:
                      'من ${_formatDate(opportunity.startDate ?? DateTime.now())} إلى ${_formatDate(opportunity.endDate ?? DateTime.now())}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip({required IconData icon, required String label}) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      backgroundColor: Colors.grey[100],
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildApplicationForm() {
    return Obx(()=>controller.flowState.value.getScreenWidget(_body() ,(){
      controller.flowState.value = ContentState();
    }));
  }

  _body() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تقديم الطلب',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'رسالة التقديم (اختياري)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: controller.messageController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'أكتب رسالة توضح سبب اهتمامك بهذه الفرصة...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            if (controller.applicationMessage.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  controller.applicationMessage.value,
                  style: TextStyle(
                    color: controller.applicationMessage.value.contains('خطأ')
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  controller.applyForTraining(opportunity.id ?? "",
                      opportunity.companyId??"",
                      TrainingApplicationType.train,
                    opportunity.title??"",
                    opportunity.durationHours??0,
                    opportunity.endDate??DateTime.now(),
                  );
                },
                child: Text('تقديم الطلب', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
