import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminUserListController extends GetxController {
  var users = <Map<String, String>>[].obs;
  var filteredUsers = <Map<String, String>>[].obs;
  var expandedIndex = RxInt(-1);
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserList();
  }

  void fetchUserList() async {
    await Future.delayed(Duration(seconds: 2));

    users.addAll([
      {'name': 'John Doe', 'email': 'john.doe@example.com', 'phone': '9876543210', 'address': '123 Main St'},
      {'name': 'Jane Smith', 'email': 'jane.smith@example.com', 'phone': '9123456789', 'address': '456 Elm St'},
      {'name': 'Alex Johnson', 'email': 'alex.johnson@example.com', 'phone': '9988776655', 'address': '789 Oak St'},
      {'name': 'Sophia Brown', 'email': 'sophia.brown@example.com', 'phone': '9988776655', 'address': '321 Pine St'},
    ]);

    filteredUsers.assignAll(users);
  }

  void applySearch(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredUsers.assignAll(users);
    } else {
      final lower = query.toLowerCase();
      filteredUsers.assignAll(users.where((user) =>
      (user['name'] ?? '').toLowerCase().contains(lower) ||
          (user['email'] ?? '').toLowerCase().contains(lower) ||
          (user['phone'] ?? '').toLowerCase().contains(lower)));
    }
  }

  void toggleExpansion(int index) {
    expandedIndex.value = expandedIndex.value == index ? -1 : index;
  }

  Future<void> launchEmail(String email) async {
    final url = 'mailto:$email';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Get.snackbar("Error", "Could not open email client.");
    }
  }

  Future<void> launchPhone(String phone) async {
    final url = 'tel:$phone';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Get.snackbar("Error", "Could not make a phone call.");
    }
  }
}
