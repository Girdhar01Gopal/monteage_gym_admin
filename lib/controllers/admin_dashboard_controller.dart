import 'package:get/get.dart';
import 'dart:async';  // For simulating delays

class AdminDashboardController extends GetxController {
  // Observables for dashboard stats
  final RxInt totalUsers = 0.obs;
  final RxInt activeUsers = 0.obs;

  // Fee related stats
  final RxDouble totalFeePaid = 0.0.obs;
  final RxDouble feeDue = 0.0.obs;
  final RxDouble feeOutstanding = 0.0.obs;

  // Simulated list of users with daily data collection
  var usersList = <Map<String, dynamic>>[].obs;

  // Daily collection data (could be a model that is dynamically updated)
  var dailyCollectionData = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardStats(); // Initial data fetch
    fetchDailyCollectionData();  // Fetch daily data collection for members
  }

  // Simulated API call to fetch data for users, active users, and fee data
  void fetchDashboardStats() async {
    try {
      await Future.delayed(Duration(seconds: 1)); // Simulate network delay

      // Simulating Total Users Count
      totalUsers.value = 150;
      // Simulating Active Users Count
      activeUsers.value = 100;

      // Fee Summary Data (These values should be fetched from your backend)
      totalFeePaid.value = 10000.0;  // Total fee paid
      feeDue.value = 5000.0;         // Fee due
      feeOutstanding.value = 2000.0; // Outstanding fee

      // Adding sample user data (to be replaced with real API data)
      usersList.addAll([
        {'name': 'John Doe', 'email': 'john.doe@example.com', 'phone': '9876543210'},
        {'name': 'Jane Smith', 'email': 'jane.smith@example.com', 'phone': '9123456789'},
        {'name': 'Alex Johnson', 'email': 'alex.johnson@example.com', 'phone': '9988776655'},
      ]);
    } catch (e) {
      Get.snackbar("Error", "Failed to load dashboard data", snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Simulate fetching daily collection data for each member
  void fetchDailyCollectionData() async {
    await Future.delayed(Duration(seconds: 1));  // Simulating network delay
    dailyCollectionData.addAll([
      {
        'name': 'John Doe',
        'date': '2025-06-25',
        'attendance': true,
        'paymentsReceived': 100.0,
        'progress': 'Good',
      },
      {
        'name': 'Jane Smith',
        'date': '2025-06-25',
        'attendance': true,
        'paymentsReceived': 150.0,
        'progress': 'Excellent',
      },
      {
        'name': 'Alex Johnson',
        'date': '2025-06-25',
        'attendance': false,
        'paymentsReceived': 0.0,
        'progress': 'Needs Improvement',
      },
    ]);
  }
}


