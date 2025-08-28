import 'package:get/get.dart';
import '../../bindings/add_course_binding.dart';
import '../../bindings/add_member_binding.dart';
import '../../bindings/admin_active_users_binding.dart';
import '../../bindings/admin_add_user_binding.dart';
import '../../bindings/admin_daily_collection_binding.dart';
import '../../bindings/admin_dashboard_binding.dart';
import '../../bindings/admin_details_binding.dart';
import '../../bindings/admin_diet_menu_binding.dart';
import '../../bindings/admin_fee_payments_binding.dart';
import '../../bindings/admin_gym_pass_binding.dart';
import '../../bindings/admin_manage_plan_binding.dart';
import '../../bindings/admin_notification_binding.dart';
import '../../bindings/admin_plan_management_binding.dart';
import '../../bindings/admin_qr_payment_binding.dart';
import '../../bindings/admin_reports_binding.dart';
import '../../bindings/admin_user_list_binding.dart';
import '../../bindings/assigned_trainer_binding.dart';
import '../../bindings/feesummarybindind.dart';
import '../../bindings/gym_profile_binding.dart';
import '../../controllers/admin_add_trainer_controller.dart';
import '../../controllers/admin_login_controller.dart';
import '../../controllers/admin_settings_controller.dart';
import '../../controllers/admin_trainer_list_controller.dart';
import '../../screens/AdminFeeSummaryScreen.dart';
import '../../screens/add_course_screen.dart';
import '../../screens/add_member_screen.dart';
import '../../screens/add_trainer_screen.dart';
import '../../screens/admin_active_users_screen.dart';
import '../../screens/admin_add_user_screen.dart';
import '../../screens/admin_daily_collection_screen.dart';
import '../../screens/admin_diet_menu_screen.dart';
import '../../screens/admin_fee_payments_screen.dart';
import '../../screens/admin_manage_plan_screen.dart';
import '../../screens/admin_notifications_screen.dart';
import '../../screens/admin_panel_settings_screen.dart';
import '../../screens/admin_plan_management_screen.dart';
import '../../screens/admin_qr_payment_screen.dart';
import '../../screens/admin_reports_screen.dart';
import '../../screens/admin_splash_screen.dart';
import '../../screens/admin_login_screen.dart';
import '../../screens/admin_dashboard_screen.dart';
import '../../screens/admin_details_screen.dart';
import '../../screens/admin_gym_pass_screen.dart';
import '../../screens/admin_trainer_list_screen.dart';
import '../../screens/admin_user_list_screen.dart';
import '../../screens/assigned_trainer_screen.dart';
import '../../screens/gym_profile_screen.dart';

class AdminRoutes {
  static const ADMIN_SPLASH = '/admin/splash';
  static const ADMIN_LOGIN = '/admin/login';
  static const ADMIN_DASHBOARD = '/admin/dashboard';
  static const ADMIN_DETAILS = '/admin/details';
  static const ADMIN_HOME = '/admin/home';
  static const ADMIN_GYM_PASS = '/admin/gym-pass';
  static const ADMIN_PLAN_MANAGE = '/admin/plan-manage';
  static const ADMIN_SETTINGS = '/admin/settings';
  static const ADMIN_MANAGE_PLAN = '/admin/manage-plan';
  static const ADMIN_SUBSCRIPTION_PLAN = '/admin/subscription-plan';
  static const ADMIN_USER_LIST = '/admin-user-list';
  static const ADMIN_ACTIVE_USERS = '/admin/active-users';
  static const ADD_MEMBER_SCREEN = '/admin/add_member';
  static const ADMIN_FEE_SUMMARY = '/admin_fee_summary';
  static const ADMIN_DIET_MENU = '/admin/diet-menu';
  static const ADD_COURSE = '/add-course';
  static const EDIT_COURSE = '/edit-course';
  static const ADD_TRAINER_SCREEN = '/admin/add-trainer';
  static const ADMIN_TRAINER_LIST = '/admin/trainer-list';
  static const ADD_USER_SCREEN = '/admin/add-user';
  static const ADMIN_FEE_PAYMENTS = '/admin/fee-payments';
  static const ADMIN_REPORTS = '/admin/reports';
  static const ADD_DIET_MENU = '/admin/add-diet-menu';
  static const EDIT_DIET_MENU = '/admin/edit-diet-menu';
  static const DAILY_COLLECTION = '/daily_collection';
  static const ADMIN_QR_PAYMENT = '/admin-qr-payment';
  static const ADMIN_NOTIFICATIONS = '/admin-notifications';
  static const MANAGE_ACCESS_SCREEN = '/manage-access';
  static const GYM_PROFILE = '/gym-profile';
  static const ASSIGNED_TRAINER = '/assigned-trainer';


  static List<GetPage> routes = [
    GetPage(
      name: ADMIN_SPLASH,
      page: () => AdminSplashScreen(),
    ),
    GetPage(
      name: ASSIGNED_TRAINER,
      page: () => AssignedTrainerScreen(),
      binding: AssignedTrainerBinding(),
    ),
    GetPage(
      name: GYM_PROFILE,
      page: () => GymProfileScreen(),
      binding: GymProfileBinding(),
    ),
    GetPage(
      name: ADMIN_LOGIN,
      page: () => AdminLoginScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AdminLoginController());
      }),
    ),
    GetPage(
      name: ADMIN_DASHBOARD,
      page: () => AdminDashboardScreen(),
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: ADMIN_DETAILS,
      page: () => AdminDetailsScreen(),
      binding: AdminDetailsBinding(),
    ),
    GetPage(
      name: ADD_MEMBER_SCREEN,
      page: () => AddMemberScreen(),
      binding: AddMemberBinding(),
    ),
    GetPage(
      name: ADMIN_GYM_PASS,
      page: () => AdminGymPassScreen(),
      binding: AdminGymPassBinding(),
    ),
    GetPage(
      name: ADMIN_SETTINGS,
      page: () => AdminPanelSettingsScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AdminSettingsController());
      }),
    ),
    GetPage(
      name: ADMIN_MANAGE_PLAN,
      page: () => AdminManagePlanScreen(),
      binding: AdminManagePlanBinding(),
    ),
    GetPage(
      name: ADMIN_USER_LIST,
      page: () => AdminUserListScreen(),
      binding: AdminUserListBinding(),
    ),
    GetPage(
      name: ADMIN_ACTIVE_USERS,
      page: () => AdminActiveUsersScreen(),
      binding: AdminActiveUsersBinding(),
    ),
    GetPage(
      name: ADD_TRAINER_SCREEN,
      page: () => AddTrainerScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AdminAddTrainerController());
      }),
    ),
    GetPage(
      name: ADMIN_TRAINER_LIST,
      page: () => AdminTrainerListScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AdminTrainerListController());
      }),
    ),
    GetPage(
      name: ADD_COURSE,
      page: () => AddCourseScreen(),
      binding: AddCourseBinding(),
    ),
    GetPage(
      name: ADMIN_SUBSCRIPTION_PLAN,
      page: () => SubsciptionPlanScreen(),
      binding: AdminPlanManagementBinding(),
    ),
    GetPage(
      name: ADD_USER_SCREEN,
      page: () => AdminAddUserScreen(),
      binding: AdminAddUserBinding(),
    ),
    GetPage(
      name: ADMIN_FEE_PAYMENTS,
      page: () => AdminFeePaymentsScreen(),
      binding: AdminFeePaymentsBinding(),
    ),
    GetPage(
      name: ADMIN_REPORTS,
      page: () => AdminReportsScreen(),
      binding: AdminReportsBinding(),
    ),
    GetPage(
      name: DAILY_COLLECTION,
      page: () => AdminDailyCollectionScreen(),
      binding: AdminDailyCollectionBinding(),
    ),
    GetPage(
      name: ADMIN_FEE_SUMMARY,
      page: () => AdminFeeSummaryScreen(),
      binding: Feesummarybindind(),
    ),
    GetPage(
      name: ADMIN_NOTIFICATIONS,
      page: () => AdminNotificationsScreen(),
      binding: AdminNotificationBinding(),
    ),
    GetPage(
      name: ADMIN_DIET_MENU,
      page: () => AdminDietMenuScreen(),
      binding: AdminDietMenuBinding(),
    ),
    GetPage(
      name: ADMIN_QR_PAYMENT,
      page: () => AdminQrPaymentScreen(),
      binding: AdminQrPaymentBinding(),
    ),
  ];
}
