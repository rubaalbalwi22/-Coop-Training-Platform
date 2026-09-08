// controllers/certificate_controller.dart
import '../../../../core/app_export.dart';
import '../model/certificate_model.dart';

class MyCertificateController extends GetxController {
  final RxList<Certificate> certificates = <Certificate>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    fetchCertificates();
    super.onInit();
  }

  Future<void> fetchCertificates() async {
    try {
      isLoading(true);
      // استبدل هذا باستدعاء API حقيقي
      await Future.delayed(Duration(seconds: 1));

      // بيانات وهمية للعرض
      certificates.assignAll([
        Certificate(
          id: 'cert-001',
          studentId: 'stu-001',
          trainingId: 'train-001',
          title: 'شهادة إتمام تدريب تطوير الويب',
          description: 'تم منح هذه الشهادة لإتمام متطلبات تدريب تطوير الويب بنجاح',
          issueDate: DateTime.now().subtract(Duration(days: 10)),
          downloadUrl: 'https://example.com/certificates/web-cert.pdf',
          fileType: 'pdf',
          fileSize: 2.5,
        ),
        Certificate(
          id: 'cert-002',
          studentId: 'stu-001',
          trainingId: 'train-002',
          title: 'شهادة مشاركة في ورشة الذكاء الاصطناعي',
          description: 'شهادة مشاركة في ورشة عمل الذكاء الاصطناعي التي عقدت في جامعة الملك سعود',
          issueDate: DateTime.now().subtract(Duration(days: 5)),
          downloadUrl: 'https://example.com/certificates/ai-workshop.png',
          fileType: 'png',
          fileSize: 1.8,
        ),
      ]);
    } finally {
      isLoading(false);
    }
  }


 }