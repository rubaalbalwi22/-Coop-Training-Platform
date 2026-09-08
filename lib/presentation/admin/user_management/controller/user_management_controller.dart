import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';
import 'package:train_link/data/admin_remote_data_source/admin_remote_data_source.dart';
import 'package:train_link/presentation/admin/user_management/view/user_details_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/app_export.dart';
import '../model/user_model.dart';

class UserManagementController extends GetxController {
  final RxList<AppUser> users = <AppUser>[].obs;
  final RxList<AppUser> filteredUsers = <AppUser>[].obs;
  final selectedUserType = Rx<UserType?>(null);
  final selectedStatus = Rx<UserStatus?>(null);
  final searchQuery = ''.obs;
  final Rx<FlowState> flowState = Rx<FlowState>(
    LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState),
  );
  final AdminRemoteDataSource adminRemoteDataSource =
      Get.find<AdminRemoteDataSourceImpl>();

  @override
  void onInit() {
    fetchUsers();
    super.onInit();
  }

  Future<void> fetchUsers() async {
    flowState.value = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );
    (await adminRemoteDataSource.getAllUsers()).fold(
      (failure) {
        flowState.value = ErrorState(
          StateRendererType.fullScreenErrorState,
          failure.message,
        );
      },
      (users) {
        this.users.assignAll(users);
        filteredUsers.assignAll(users);
        applyFilters();
        flowState.value = ContentState();
      },
    );
  }

  void applyFilters() {
    filteredUsers.assignAll(
      users.where((user) {
        final matchesType =
            selectedUserType.value == null ||
            user.type == selectedUserType.value;
        final matchesStatus =
            selectedStatus.value == null || user.status == selectedStatus.value;
        final matchesSearch =
            searchQuery.value.isEmpty ||
            user.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            user.email.toLowerCase().contains(searchQuery.value.toLowerCase());
        return matchesType && matchesStatus && matchesSearch;
      }),
    );
  }

  Future<void> updateUserStatus(String userId, UserStatus newStatus) async {
    flowState.value = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );

    final index = users.indexWhere((u) => u.id == userId);
    if (index != -1) {
      users[index] = users[index].copyWith(status: newStatus);
      (await adminRemoteDataSource.updateUser(users[index])).fold(
        (l) {
          flowState.value = ErrorState(
            StateRendererType.popupErrorState,
            l.message,
          );
        },
        (r)  async{
          await fetchUsers();
          flowState.value = SuccessState(
            StateRendererType.popupSuccessState,
            'تم تحديث حالة الحساب بنجاح',
          );
        },
      );

    }
  }

  downloadUserCv(cvUrl) async {
    try {
      await canLaunchUrlString(cvUrl)
          ? await launchUrlString(cvUrl)
          : throw Exception('لا يمكن فتح الرابط');
    } catch (e) {
      Get.snackbar('خطاء', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> toggleUserActiveStatus(String userId, bool isActive) async {
    final index = users.indexWhere((u) => u.id == userId);
    if (index != -1) {
      users[index] = users[index].copyWith(isActive: isActive);
      (await adminRemoteDataSource.updateUser(users[index])).fold(
        (l) {
          flowState.value = ErrorState(
            StateRendererType.popupErrorState,
            l.message,
          );
        },
        (r) async{
          await fetchUsers();
          flowState.value = SuccessState(
            StateRendererType.popupSuccessState,
            'تم تحديث حالة الحساب بنجاح',
          );
        },
      );
     }
  }

  void viewUserDetails(AppUser user) {
    // Get.toNamed(Routes.USER_DETAILS, arguments: user);
    Get.to(UserDetailsView(), arguments: user);
  }
}

extension AppUserExtension on AppUser {
  AppUser copyWith({
    String? id,
    UserType? type,
    String? name,
    String? email,
    String? phone,
    String? universityId,
    String? specializationId,
    String? companyName,
    String? companyAddress,
    UserStatus? status,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return AppUser(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      universityId: universityId ?? this.universityId,
      specializationId: specializationId ?? this.specializationId,
      companyName: companyName ?? this.companyName,
      companyAddress: companyAddress ?? this.companyAddress,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
