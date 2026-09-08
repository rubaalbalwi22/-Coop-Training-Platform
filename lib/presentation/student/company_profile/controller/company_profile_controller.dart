import '../../../../core/app_export.dart';
import '../model/company_model.dart';

class CompanyProfileController extends GetxController {
  final Rx<CompanyProfile?> companyProfile = Rx<CompanyProfile?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isSubmittingRating = false.obs;

  Future<void> fetchCompanyProfile(String companyId) async {
    try {
      isLoading(true);
      // Replace with actual API call
      await Future.delayed(Duration(seconds: 1));

      // Mock data
      companyProfile.value = CompanyProfile(
        id: companyId,
        name: 'شركة التقنية الحديثة',
        description: 'شركة رائدة في مجال التدريب التقني وتطوير البرمجيات',
        logoUrl: ImageConstant.imgLogo,
        website: 'https://tech-company.com',
        phone: '+966501234567',
        email: 'info@tech-company.com',
        ratings: [
          CompanyRating(
            id: 'rating1',
            studentName: 'أحمد محمد',
            studentId: 'stu001',
            studentImage: 'https://example.com/profiles/ahmed.jpg',
            rating: 4.5,
            comment: 'تجربة رائعة مع فرص التدريب المقدمة',
            date: DateTime.now().subtract(Duration(days: 10)),
          ),
          CompanyRating(
            id: 'rating2',
            studentName: 'سارة عبدالله',
            studentId: 'stu002',
            rating: 5.0,
            comment: 'دورات ممتازة بمعايير عالية الجودة',
            date: DateTime.now().subtract(Duration(days: 5)),
          ),
        ],
        averageRating: 4.75,
        opportunitiesCount: 12,
        trainingsCount: 8,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> submitRating({
    required String companyId,
    required double rating,
    required String comment,
  }) async {
    try {
      isSubmittingRating(true);
      // Replace with actual API call
      await Future.delayed(Duration(seconds: 2));

      // Add the new rating locally
      final newRating = CompanyRating(
        id: 'rating-${DateTime.now().millisecondsSinceEpoch}',
        studentName: 'الطالب الحالي', // Replace with actual student name
        studentId: 'current-student-id', // Replace with actual student ID
        rating: rating,
        comment: comment,
        date: DateTime.now(),
      );

      companyProfile.update((profile) {
        profile?.ratings.insert(0, newRating);
        // Recalculate average
        final total = profile!.ratings.fold(0.0, (sum, r) => sum + r.rating);
        profile.averageRating = total / profile.ratings.length;
      });

      Get.back();
      Get.snackbar('تمت الإضافة', 'شكراً لتقييمك للشركة');
    } finally {
      isSubmittingRating(false);
    }
  }
}
