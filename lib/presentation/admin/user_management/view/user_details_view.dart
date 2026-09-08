import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:get/get.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';
import '../../../../core/app_export.dart';
import '../controller/user_management_controller.dart';
import '../model/user_model.dart';

class UserDetailsView extends StatelessWidget {
  final UserManagementController controller = Get.find();
  final theme = Theme.of(Get.context!);

  @override
  Widget build(BuildContext context) {
    final AppUser user = Get.arguments as AppUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل المستخدم', textDirection: TextDirection.rtl),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.flowState.value.getScreenWidget(_body(user), () {
          controller.flowState.value = ContentState();
        }),
      ),
    );
  }

  _body(user) => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        _buildUserHeader(user),
        const SizedBox(height: 20),

        // Basic Information Card
        _buildCard(
          title: 'المعلومات الأساسية',
          children: [
            _buildListTile(Icons.person, 'الاسم الكامل', user.name),
            _buildListTile(Icons.email, 'البريد الإلكتروني', user.email),
            if (user.phone != null)
              _buildListTile(Icons.phone, 'رقم الهاتف', user.phone!),
            if (user.type == UserType.student && user.university != null)
              _buildListTile(Icons.school, 'الجامعة', user.university!),
            if (user.type == UserType.student && user.specialization != null)
              _buildListTile(Icons.work, 'التخصص', user.specialization!),
          ],
        ),

        // Company Information (if company user)
        if (user.type == UserType.company)
          _buildCard(
            title: 'معلومات الشركة',
            children: [
              if (user.companyName != null)
                _buildListTile(Icons.business, 'اسم الشركة', user.companyName!),
              if (user.companyRegisterNumber != null)
                _buildListTile(
                  Icons.numbers,
                  'رقم السجل التجاري',
                  user.companyRegisterNumber!,
                ),
              if (user.companyAddress != null)
                _buildListTile(
                  Icons.location_on,
                  'عنوان الشركة',
                  user.companyAddress!,
                ),
              if (user.companyWebsite != null)
                _buildListTile(
                  Icons.language,
                  'الموقع الإلكتروني',
                  user.companyWebsite!,
                ),
              if (user.companyDescription != null)
                _buildListTile(
                  Icons.description,
                  'وصف الشركة',
                  user.companyDescription!,
                ),
              if (user.companyLogo != null)
                _buildListTileWithIcon(user.companyLogo),
            ],
          ),

        // Student Information (if student user)
        if (user.type == UserType.student && user.cvUrl != null)
          _buildCard(
            title: 'السيرة الذاتية',
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.file_present, color: Colors.blueGrey),
                title: const Text(
                  'عرض السيرة الذاتية',
                  textDirection: TextDirection.rtl,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () => controller.downloadUserCv(user.cvUrl),
                ),
              ),
            ],
          ),

        // Status and Details Card
        _buildCard(
          title: 'الحالة والتفاصيل',
          children: [
            _buildStatusTile(user),
            _buildListTile(
              Icons.calendar_today,
              'تاريخ الإنشاء',
              intl.DateFormat('yyyy/MM/dd - hh:mm a').format(user.createdAt),
            ),
          ],
        ),

        // Action Buttons
        _buildActionButtons(user),
      ],
    ),
  );

  Widget _buildListTileWithIcon(String? logo) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      subtitle: CustomImageView(imagePath: logo, width: 70, height: 70),
      title: Row(
        spacing: 10.0,
        children: [
          const Icon(Icons.image, color: Colors.blueGrey),
          Text(
            'شعار الشركة',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  Widget _buildUserHeader(AppUser user) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.type == UserType.student ? 'طالب' : 'شركة',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
              textDirection: TextDirection.rtl,
            ),
            const Divider(height: 20, thickness: 1),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(
    IconData icon,
    String label,
    String value, {
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          Icon(icon, size: 24, color: iconColor ?? Colors.blueGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTile(AppUser user) {
    Color statusColor;
    switch (user.status) {
      case UserStatus.pending:
        statusColor = Colors.orange;
        break;
      case UserStatus.approved:
        statusColor = Colors.green;
        break;
      case UserStatus.rejected:
        statusColor = Colors.red;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          const Text(
            'حالة الحساب:',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_getStatusIcon(user.status), size: 16, color: statusColor),
                const SizedBox(width: 6),
                Text(
                  _getStatusText(user.status),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(AppUser user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          if (user.status == UserStatus.pending)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      controller.updateUserStatus(
                        user.id ?? "",
                        UserStatus.approved,
                      );
                      user.status = UserStatus.approved;
                    },
                    icon: const Icon(Icons.check, size: 20),
                    label: const Text('قبول الحساب'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      controller.updateUserStatus(
                        user.id ?? "",
                        UserStatus.rejected,
                      );
                      user.status = UserStatus.rejected;
                    },
                    icon: const Icon(Icons.close, size: 20),
                    label: const Text('رفض الحساب'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              controller.toggleUserActiveStatus(user.id ?? "", !user.isActive);
              user.isActive = !user.isActive;
            },
            icon: Icon(
              user.isActive ? Icons.block : Icons.check_circle,
              size: 20,
            ),
            label: Text(user.isActive ? 'تعطيل الحساب' : 'تفعيل الحساب'),
            style: ElevatedButton.styleFrom(
              backgroundColor: user.isActive ? Colors.red : Colors.green,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  String _getStatusText(UserStatus status) {
    switch (status) {
      case UserStatus.pending:
        return 'قيد المراجعة';
      case UserStatus.approved:
        return 'مقبول';
      case UserStatus.rejected:
        return 'مرفوض';
    }
  }

  IconData _getStatusIcon(UserStatus status) {
    switch (status) {
      case UserStatus.pending:
        return Icons.access_time;
      case UserStatus.approved:
        return Icons.check_circle;
      case UserStatus.rejected:
        return Icons.cancel;
    }
  }
}
