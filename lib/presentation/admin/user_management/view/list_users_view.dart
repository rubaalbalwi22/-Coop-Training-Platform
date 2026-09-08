import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';
import 'package:train_link/widgets/drawer/admin_drawer.dart';
import '../../../../theme/theme_helper.dart';
import '../controller/user_management_controller.dart';
import '../model/user_model.dart';

class ListUsersView extends GetWidget<UserManagementController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminDrawer(),
      appBar: AppBar(
        title: Text('إدارة المستخدمين', textDirection: TextDirection.rtl),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: Obx(
              () => controller.flowState.value.getScreenWidget(_body(), () {
                controller.flowState.value = ContentState();
              }),
            ),
          ),
        ],
      ),
    );
  }

  _body() => ListView.builder(
    padding: EdgeInsets.all(8),
    itemCount: controller.filteredUsers.length,
    itemBuilder: (context, index) {
      final user = controller.filteredUsers[index];
      return _buildUserCard(user);
    },
  );

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
                labelText: 'بحث بالاسم',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                controller.searchQuery.value = value;
                controller.applyFilters();
              },
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<UserType>(
                      value: controller.selectedUserType.value,
                      decoration: InputDecoration(
                        labelText: 'نوع المستخدم',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: null,
                          child: Text(
                            'الكل',
                            style: TextStyle(color: Colors.black),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                        ...UserType.values.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(
                              type == UserType.student
                                  ? 'طالب'
                                  : type == UserType.company
                                  ? 'شركة'
                                  : 'مدير النظام',
                              style: TextStyle(color: Colors.black),
                              textDirection: TextDirection.rtl,
                            ),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        controller.selectedUserType.value = value;
                        controller.applyFilters();
                      },
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<UserStatus>(
                      value: controller.selectedStatus.value,
                      decoration: InputDecoration(
                        labelText: 'حالة الحساب',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: null,
                          child: Text(
                            'الكل',
                            style: TextStyle(color: Colors.black),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                        ...UserStatus.values.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(
                              status == UserStatus.pending
                                  ? 'قيد المراجعة'
                                  : status == UserStatus.approved
                                  ? 'مقبول'
                                  : 'مرفوض',
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
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(AppUser user) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: () => controller.viewUserDetails(user),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // User Type Icon
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  user.type == UserType.student
                      ? Icons.person
                      : user.type == UserType.company
                      ? Icons.business
                      : Icons.admin_panel_settings,
                  color: theme.primaryColor,
                ),
              ),
              SizedBox(width: 12),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            user.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              user.status,
                            ).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _getStatusColor(user.status),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            _getStatusText(user.status),
                            style: TextStyle(
                              color: _getStatusColor(user.status),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      user.email,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (user.status == UserStatus.pending) ...[
                          IconButton(
                            icon: Icon(Icons.check, color: Colors.green),
                            onPressed: () => controller.updateUserStatus(
                              user.id??"",
                              UserStatus.approved,
                            ),
                            tooltip: 'قبول',
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.red),
                            onPressed: () => controller.updateUserStatus(
                              user.id??"",
                              UserStatus.rejected,
                            ),
                            tooltip: 'رفض',
                          ),
                        ],
                        IconButton(
                          icon: Icon(
                            user.isActive ? Icons.toggle_on : Icons.toggle_off,
                            color: user.isActive
                                ? theme.primaryColor
                                : Colors.grey,
                          ),
                          onPressed: () => controller.toggleUserActiveStatus(
                            user.id??"",
                            !user.isActive,
                          ),
                          tooltip: user.isActive ? 'تعطيل' : 'تفعيل',
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: theme.primaryColor,
                          ),
                          onPressed: () => controller.viewUserDetails(user),
                          tooltip: 'عرض الملف الشخصي',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action Buttons
            ],
          ),
        ),
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

  Color _getStatusColor(UserStatus status) {
    switch (status) {
      case UserStatus.pending:
        return Colors.orange;
      case UserStatus.approved:
        return Colors.green;
      case UserStatus.rejected:
        return Colors.red;
    }
  }
}
