import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminActiveUsersController extends GetxController {
  var activeUsers = <Map<String, dynamic>>[].obs;
  var filteredUsers = <Map<String, dynamic>>[].obs;
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchActiveUsers();
  }

  void fetchActiveUsers() async {
    await Future.delayed(Duration(seconds: 1));
    activeUsers.addAll([
      {'name': 'John Doe', 'email': 'john.doe@example.com', 'phone': '9876543210', 'address': '123 Main St', 'status': 'Active', 'session_time': 'Morning'},
      {'name': 'Jane Smith', 'email': 'jane.smith@example.com', 'phone': '9123456789', 'address': '456 Oak St', 'status': 'Active', 'session_time': 'Evening'},
      {'name': 'Alex Johnson', 'email': 'alex.johnson@example.com', 'phone': '9988776655', 'address': '789 Pine St', 'status': 'Inactive', 'session_time': 'Morning'},
    ]);
    filteredUsers.assignAll(activeUsers);
  }

  void updateUserStatus(int index, String newStatus) {
    activeUsers[index]['status'] = newStatus;
    applySearch(searchQuery.value); // Re-apply filter
  }

  Future<void> launchEmail(String email) async {
    final emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      Get.snackbar("Error", "Could not open email client.");
    }
  }

  Future<void> launchPhone(String phone) async {
    final phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      Get.snackbar("Error", "Could not make a phone call.");
    }
  }

  void applySearch(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredUsers.assignAll(activeUsers);
    } else {
      final lower = query.toLowerCase();
      filteredUsers.assignAll(activeUsers.where((user) =>
      user['name']!.toLowerCase().contains(lower) ||
          user['email']!.toLowerCase().contains(lower) ||
          user['phone']!.contains(lower)
      ));
    }
  }
}
