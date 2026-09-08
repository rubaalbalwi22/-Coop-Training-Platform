import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import '../../../../core/app_export.dart';
import '../../../company/training_opportunity/model/training_opportunity_model.dart';
import '../controller/training_management_controller.dart';

class TrainingDetailsView extends GetWidget<TrainingManagementController> {
  @override
  Widget build(BuildContext context) {
    final TrainingOpportunity training = Get.arguments as TrainingOpportunity;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل فرصة التدريب', textDirection: TextDirection.rtl),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),

            _buildCard(
              title: 'معلومات الفرصة',
              children: [
                _buildItem(Icons.title, 'العنوان', training.title??""),
                _buildItem(Icons.description, 'الوصف', training.description??""),
                _buildItem(Icons.location_on, 'المكان', training.location??""),
              ],
            ),

            _buildCard(
              title: 'الجدول الزمني',
              children: [
                _buildItem(Icons.date_range, 'تاريخ البدء',
                    intl.DateFormat('yyyy/MM/dd').format(training.startDate??DateTime.now())),
                _buildItem(Icons.event, 'تاريخ الانتهاء',
                    intl.DateFormat('yyyy/MM/dd').format(training.endDate??DateTime.now())),
                _buildItem(Icons.access_time, 'عدد الساعات', '${training.durationHours} ساعة'),
              ],
            ),

            _buildCard(
              title: 'تفاصيل إضافية',
              children: [
                _buildItem(Icons.group, 'السعة', '${training.capacity} متدرب'),
                _buildItem(Icons.info, 'الحالة', _getStatusText(training.status??"pending"),
                    iconColor: _getStatusColor(training.status??'pending')),
              ],
            ),

            const SizedBox(height: 20),

            if (training.status == 'pending')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () =>
                        controller.updateTrainingStatus(training.id??"", 'approved'),
                    icon: const Icon(Icons.check),
                    label: const Text('قبول الفرصة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                     ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () =>
                        controller.updateTrainingStatus(training.id??"", 'rejected'),
                    icon: const Icon(Icons.close),
                    label: const Text('رفض الفرصة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                     ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildItem(IconData icon, String label, String value, {Color? iconColor}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      leading: Icon(icon, color: iconColor ?? Colors.blueGrey),
      title: Text(label, textDirection: TextDirection.rtl),
      subtitle: Text(value, textDirection: TextDirection.rtl, textAlign: TextAlign.right),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case  'pending':
        return 'قيد المراجعة';
      case  'approved':
        return 'مقبولة';
      case 'rejected':
        return 'مرفوضة';
        default:
        return 'غير معروف';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return theme.primaryColor;
      case 'rejected':
        return Colors.red;
        default:
        return Colors.grey;
    }
  }
}
