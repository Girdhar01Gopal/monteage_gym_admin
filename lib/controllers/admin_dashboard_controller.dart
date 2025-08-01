import 'package:get/get.dart';
import 'admin_daily_collection_controller.dart';

class AdminDashboardController extends GetxController {
  // Reference the existing AdminDailyCollectionController
  final dailyCollectionController = Get.put(AdminDailyCollectionController());

  // Live totals linked to collection controller
  RxDouble get totalFeePaid => dailyCollectionController.todayTotal;
  RxDouble get monthlyCollection => dailyCollectionController.monthlyTotal;

  // Chart data
  final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'].obs;
  final morningUsers = [20, 25, 18, 30, 22, 28].obs;
  final eveningUsers = [15, 20, 12, 18, 17, 19].obs;
  final totalUsersPerMonth = [35, 45, 30, 48, 39, 47].obs;
  final activeUsersPerMonth = [30, 40, 28, 45, 35, 44].obs;
}


