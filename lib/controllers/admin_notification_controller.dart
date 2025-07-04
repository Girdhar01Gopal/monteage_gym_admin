import 'package:get/get.dart';
import '../models/notification_model.dart';

class AdminNotificationController extends GetxController {
  final notifications = <NotificationModel>[].obs;
  final filteredNotifications = <NotificationModel>[].obs;
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      await Future.delayed(Duration(seconds: 0)); // Simulated delay

      final data = [
        NotificationModel(
          title: 'Payment Received',
          message: '₹500 received from John Doe',
          date: DateTime.now().subtract(Duration(hours: 1)),
        ),
        NotificationModel(
          title: 'New Member Joined',
          message: 'Jane Smith joined the gym',
          date: DateTime.now().subtract(Duration(hours: 2)),
        ),
        NotificationModel(
          title: 'Subscription Expired',
          message: 'Alex Johnson’s plan expired',
          date: DateTime.now().subtract(Duration(hours: 3)),
        ),
        NotificationModel(
          title: 'Zumba Class Alert',
          message: 'Zumba session starts in 30 minutes',
          date: DateTime.now().subtract(Duration(hours: 4)),
        ),
      ];

      notifications.assignAll(data);
      filteredNotifications.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch notifications",
          snackPosition: SnackPosition.TOP);
    }
  }

  void applySearch(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredNotifications.assignAll(notifications);
    } else {
      final q = query.toLowerCase();
      filteredNotifications.assignAll(notifications.where((n) =>
      n.title.toLowerCase().contains(q) ||
          n.message.toLowerCase().contains(q)));
    }
  }
}
