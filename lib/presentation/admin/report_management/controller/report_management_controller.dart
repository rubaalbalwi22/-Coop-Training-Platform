import 'package:train_link/core/utils/state_renderer/state_renderer.dart';
import 'package:train_link/core/utils/state_renderer/state_renderer_impl.dart';
import 'package:train_link/data/admin_remote_data_source/admin_remote_data_source.dart';
import 'package:train_link/presentation/admin/report_management/view/certificate_view.dart';
import 'package:train_link/presentation/admin/report_management/view/pdf_viewer_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../../core/app_export.dart';
import '../../../student/training_report/model/training_report_model.dart';

class ReportManagementController extends GetxController {
  final RxList<TrainingReport> reports = <TrainingReport>[].obs;
  //final RxList<Certificate> certificates = <Certificate>[].obs;
  final searchQuery = ''.obs;
  final AdminRemoteDataSource adminRemoteDataSource =
      Get.find<AdminRemoteDataSourceImpl>();
  final Rx<FlowState> flowState = Rx<FlowState>(
    LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState),
  );

  @override
  void onInit() {
    fetchReports();
    super.onInit();
  }

  Future<void> fetchReports() async {
    flowState.value = LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    );
    (await adminRemoteDataSource.getAllTrainingReports()).fold(
      (l) {
        flowState.value = ErrorState(
          StateRendererType.popupErrorState,
          l.message,
        );
      },
      (r) {
        reports.assignAll(r);
        flowState.value = ContentState();
      },
    );
  }

  // In lib/app/controllers/admin/report_management_controller.dart

  Future<void> viewReport(TrainingReport report) async {
    try {
      // Check if PDF URL is valid
      if (report.filePath?.isEmpty ?? false) {
        Get.snackbar(
          'خطأ',
          'لا يوجد رابط للتقرير',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }



      await canLaunchUrlString(report.filePath ?? "")
          ? await launchUrlString(report.filePath ?? "")
          : Get.snackbar(
              'خطاء',
              'لا يمكن فتح التقرير',
              snackPosition: SnackPosition.BOTTOM,
            );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'تعذر فتح التقرير: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {

    }
  }

  Future<void> viewCertificate(TrainingReport report) async {
    try {
      Get.to(
        CertificateView(
          duration: '${report.trainingApplication?.duration??0} ساعة',
          studentName: report.student?.name??"",
          trainingTitle: report.trainingApplication?.title??"",
          endDate: report.trainingApplication?.endDate??DateTime.now(),
        ),
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'تعذر عرض الشهادة',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> downloadCertificate(String url, String format) async {
    try {

      final dir = await getApplicationDocumentsDirectory();
      final fileName =
          'شهادة_تدريب_${DateTime.now().millisecondsSinceEpoch}.$format';
      final filePath = '${dir.path}/$fileName';

      await Dio().download(url, filePath);

      await OpenFile.open(filePath);

      Get.snackbar(
        'نجاح',
        'تم تنزيل الشهادة بنجاح',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في تنزيل الشهادة: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
     }
  }
}
