import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class AdminDailyCollectionController extends GetxController {
  var todayCollection = <Map<String, dynamic>>[].obs;
  var monthlyCollection = <Map<String, dynamic>>[].obs;

  var todayTotal = 0.0.obs;
  var monthlyTotal = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTodayCollectionData();
    fetchMonthlyCollectionData();
  }

  void fetchTodayCollectionData() async {
    await Future.delayed(Duration(seconds: 1));
    todayCollection.value = [
      {'name': 'John Doe', 'attendance': true, 'paymentReceived': 500.0, 'progress': 'Good', 'date': '2025-06-25'},
      {'name': 'Jane Smith', 'attendance': true, 'paymentReceived': 1500.0, 'progress': 'Excellent', 'date': '2025-06-25'},
    ];
    updateTodayTotal();
  }

  void fetchMonthlyCollectionData() async {
    await Future.delayed(Duration(seconds: 1));
    monthlyCollection.value = [
      {'name': 'Alex Johnson', 'attendance': true, 'paymentReceived': 2500.0, 'progress': 'Excellent', 'date': '2025-06-01'},
      {'name': 'Emma Watson', 'attendance': false, 'paymentReceived': 0.0, 'progress': 'Needs Improvement', 'date': '2025-06-01'},
    ];
    updateMonthlyTotal();
  }

  void updateTodayTotal() {
    todayTotal.value = todayCollection.fold(0.0, (sum, item) => sum + (item['paymentReceived'] ?? 0.0));
  }

  void updateMonthlyTotal() {
    monthlyTotal.value = monthlyCollection.fold(0.0, (sum, item) => sum + (item['paymentReceived'] ?? 0.0));
  }

  void openEditDialog(Map<String, dynamic> data) {
    final paymentController = TextEditingController(text: data['paymentReceived'].toString());
    final progressController = TextEditingController(text: data['progress']);

    Get.dialog(
      AlertDialog(
        title: Text("Edit Collection: ${data['name']}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: paymentController,
              decoration: InputDecoration(labelText: 'Payment Received'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: progressController,
              decoration: InputDecoration(labelText: 'Progress/Notes'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              data['paymentReceived'] = double.tryParse(paymentController.text) ?? 0.0;
              data['progress'] = progressController.text;

              if (todayCollection.contains(data)) {
                todayCollection.refresh();
                updateTodayTotal();
              } else {
                monthlyCollection.refresh();
                updateMonthlyTotal();
              }

              Get.back();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void deleteDailyCollection(Map<String, dynamic> data) {
    todayCollection.remove(data);
    updateTodayTotal();
    Get.snackbar("Success", "Daily data deleted", backgroundColor: Colors.red, colorText: Colors.white);
  }

  void deleteMonthlyCollection(Map<String, dynamic> data) {
    monthlyCollection.remove(data);
    updateMonthlyTotal();
    Get.snackbar("Success", "Monthly data deleted", backgroundColor: Colors.red, colorText: Colors.white);
  }
}
