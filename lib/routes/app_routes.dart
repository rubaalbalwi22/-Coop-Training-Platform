import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:train_link/presentation/admin/comment_management/binding/list_comments_binding.dart';
import 'package:train_link/presentation/admin/comment_management/view/list_comments_view.dart';
import 'package:train_link/presentation/admin/specialization/binding/specialization_binding.dart';
import 'package:train_link/presentation/admin/specialization/view/list_specializations_view.dart';
import 'package:train_link/presentation/admin/training_opportunity/binding/training_binding.dart';
import 'package:train_link/presentation/admin/training_opportunity/view/list_trainings_view.dart';
import 'package:train_link/presentation/admin/training_types/binding/training_type_view_binding.dart';
import 'package:train_link/presentation/admin/training_types/view/list_training_types_view.dart';
import 'package:train_link/presentation/admin/universities/view/add_university_view.dart';
import 'package:train_link/presentation/auth/binding/auth_binding.dart';
import 'package:train_link/presentation/auth/view/forget_password_view.dart';
import 'package:train_link/presentation/auth/view/login_view.dart';
import 'package:train_link/presentation/company/company_main_screen/binding/main_binding.dart';
import 'package:train_link/presentation/company/ex_certificate/binding/certificates_management_binding.dart';
import 'package:train_link/presentation/company/my_profile_company/view/my_profile_company.dart';
import 'package:train_link/presentation/company/training_course/binding/training_course_binding.dart';
import 'package:train_link/presentation/company/training_opportunity/binding/training_opportunity_binding.dart';
import 'package:train_link/presentation/company/training_request/binding/requests_list_binding.dart';
import 'package:train_link/presentation/onboarding/binding/onboarding_bindiing.dart';
import 'package:train_link/presentation/student/certificates/binding/certificates_binding.dart';
import 'package:train_link/presentation/student/company_profile/binding/company_profile_binding.dart';
import 'package:train_link/presentation/student/main_screen/binding/main_binding.dart';
import 'package:train_link/presentation/student/training_opportunity/binding/training_opportunities_binding.dart';
import 'package:train_link/presentation/student/training_report/binding/training_report_binding.dart';

import '../presentation/admin/banned_word/binding/banned_word_binding.dart';
import '../presentation/admin/banned_word/view/list_banned_words_view.dart';
import '../presentation/admin/course_management/binding/course_management_binding.dart';
import '../presentation/admin/course_management/view/list_courses_view.dart';
import '../presentation/admin/report_management/binding/report_management_binding.dart';
import '../presentation/admin/report_management/view/list_reports_view.dart';
import '../presentation/admin/universities/binding/universities_binding.dart';
import '../presentation/admin/universities/view/list_universities_view.dart';
import '../presentation/admin/user_management/binding/user_management_binding.dart';
import '../presentation/admin/user_management/view/list_users_view.dart';
import '../presentation/auth/view/register_view.dart';
import '../presentation/company/company_main_screen/view/company_main_screen.dart';
import '../presentation/onboarding/view/onboarding_view.dart';
import '../presentation/splash_screen/binding/splash_binding.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/student/applications/binding/applications_binding.dart';
import '../presentation/student/applications/view/applications_view.dart';
import '../presentation/student/certificates/view/certificates_list_view.dart';
import '../presentation/student/main_screen/view/main_screen.dart';
import '../presentation/student/training_opportunity/view/training_opportunities_view.dart';
import '../presentation/student/training_report/view/upload_report_view.dart';

class AppRoutes {
  static const String splashScreen = '/splash_screen';
  static const String loginScreen = '/login_screen';
  static const String forgotPasswordScreen = '/forgot_password_screen';
  static const String registerScreen = '/register_screen';
  static const String onboardingScreen = '/onboarding_screen';

  static const String addUniversityScreen = '/add_university_screen';
  static const String listOfUniversityScreen = '/list_of_university_screen';
  static const String listOfTrainingTypeScreen = '/add_training_type_screen';
  static const String listOfSpecializationScreen =
      '/list_of_specialization_screen';
  static const String listOfBannedWordScreen = '/list_of_banned_word_screen';
  static const String listOfUsersScreen = '/list_of_users_screen';
  static const String listOfTrainingScreen = '/list_of_training_screen';
  static const String listOfCommentsScreen = '/list_of_comments_screen';
  static const String listOfCertificatesScreen = '/list_of_certificates_screen';
  static const String listOfCoursesScreen = '/list_of_courses_screen';

  // user
  static const String userMainScreen = '/user_main_screen';
  static const String listOfTrainingOpportunitiesScreen =
      '/list_of_training_opportunities_screen';
  static const String listOfApplicationsScreen = '/list_of_applications_screen';
  static const String listOfReportsScreen = '/list_of_reports_screen';
  static const String listOfMyCertificatesScreen = '/list_of_my_certificates_screen';
  static const String showCompanyProfileScreen = '/show_company_profile_screen';

  static const String initialRoute = '/initialRoute';
  // company
  static const String companyMainScreen = '/company_main_screen';

  static List<GetPage> pages = [
    GetPage(
      name: splashScreen,
      page: () => SplashScreen(),
      bindings: [SplashBinding()],
    ),

    GetPage(
      name: initialRoute,
      page: () => SplashScreen(),
      bindings: [SplashBinding()],
    ),

    GetPage(
      name: onboardingScreen,
      page: () => OnboardingView(),
      binding: OnBoardingBindings(),
    ),

    GetPage(name: loginScreen, page: () => LoginView(), binding: AuthBinding()),
    GetPage(
      name: registerScreen,
      page: () => RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: forgotPasswordScreen,
      page: () => ForgetPasswordView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: addUniversityScreen,
      binding: UniversitiesBinding(),
      page: () => AddUniversityView(),
    ),
    GetPage(
      name: listOfUniversityScreen,
      binding: UniversitiesBinding(),
      page: () => ListUniversitiesView(),
    ),
    GetPage(
      name: listOfTrainingTypeScreen,
      binding: TrainingTypeViewBinding(),
      page: () => ListTrainingTypesView(),
    ),
    GetPage(
      name: listOfSpecializationScreen,
      binding: SpecializationBinding(),
      page: () => ListSpecializationsView(),
    ),
    GetPage(
      name: listOfBannedWordScreen,
      binding: BannedWordBinding(),
      page: () => ListBannedWordsView(),
    ),
    GetPage(
      name: listOfUsersScreen,
      binding: UserManagementBinding(),
      page: () => ListUsersView(),
    ),
    GetPage(
      name: listOfTrainingScreen,
      binding: TrainingBinding(),
      page: () => ListTrainingsView(),
    ),
    GetPage(
      name: listOfCommentsScreen,
      binding: ListCommentsBinding(),
      page: () => ListCommentsView(),
    ),
    GetPage(
      name: listOfCertificatesScreen,
      binding: ReportManagementBinding(),
      page: () => ListReportsView(),
    ),
    GetPage(
      name: listOfCoursesScreen,
      binding: CourseManagementBinding(),
      page: () => ListCoursesView(),
    ),
    // user
    GetPage(
      name: userMainScreen,
      page: () => UserMainScreen(),
      bindings: [
        MainBinding(),
        TrainingOpportunitiesBinding(),
        ApplicationsBinding(),

       ],
    ),
    GetPage(
      name: listOfMyCertificatesScreen,
      page: () => MyCertificatesListView(),
      binding: MyCertificatesBinding(),
    ),
    GetPage(
      name: listOfTrainingOpportunitiesScreen,
      page: () => TrainingOpportunitiesView(),
      binding: TrainingOpportunitiesBinding(),
    ),
    GetPage(
      name: listOfApplicationsScreen,
      page: () => ApplicationsView(),
      binding: ApplicationsBinding(),
    ),


    GetPage(
      name: showCompanyProfileScreen,
      page: () => CompanyProfileView(),
      binding:  CompanyProfileBinding(),
    ),
    // company
    GetPage(
      name: companyMainScreen,
      page: () => CompanyMainScreen(),
      bindings: [
      CompanyMainBinding(),
       CompanyTrainingOpportunityBinding(),
        TrainingCourseBinding(),
        RequestsListBinding(),
        ManageCertificatesBinding()
      ],
    ),
  ];
}
