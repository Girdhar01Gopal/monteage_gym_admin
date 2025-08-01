  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:get_storage/get_storage.dart';
  import 'dart:convert';
  import 'package:http/http.dart' as http;

  class AdminDailyCollectionController extends GetxController {
    var todayCollection = <Map<String, dynamic>>[].obs;
    var monthlyCollection = <Map<String, dynamic>>[].obs;

    var todayTotal = 0.0.obs;
    var monthlyTotal = 0.0.obs;

    final _storage = GetStorage(); // GetStorage instance to access GymId

    @override
    void onInit() {
      super.onInit();
      fetchCollectionData('today'); // Fetch today's collection
      fetchCollectionData('monthly'); // Fetch monthly collection
    }
    void fetchCollectionData(String collectionType) async {
      var gymId = _storage.read('gymId') ?? '1'; // Get GymId from GetStorage (default 1)
      final String url = collectionType == 'today'
          ? 'https://montgymapi.eduagentapp.com/api/MonteageGymApp/GymMemberFeeListToday/$gymId'
          : 'https://montgymapi.eduagentapp.com/api/MonteageGymApp/GymMemberFeeListMontly/$gymId';

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(response.body);
        if (data['statuscode'] == 200 && data['data'] != null) {
          // Explicitly cast the 'data' field to List<Map<String, dynamic>>
          List<Map<String, dynamic>> collectionData = List<Map<String, dynamic>>.from(data['data']);

          if (collectionType == 'today') {
            todayCollection.assignAll(collectionData); // Assign the casted data
            updateTodayTotal();
          } else {
            monthlyCollection.assignAll(collectionData); // Assign the casted data
            updateMonthlyTotal();
          }
        } else {
          Get.snackbar('Error', 'No data found for $collectionType\'s collection',
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        Get.snackbar('Error', 'Failed to load $collectionType\'s collection data',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }

    // Update total for today's collection
    void updateTodayTotal() {
      todayTotal.value = todayCollection.fold(
          0.0, (sum, item) => sum + (item['RecivedAmount'] ?? 0.0));
    }

    // Update total for monthly collection
    void updateMonthlyTotal() {
      monthlyTotal.value = monthlyCollection.fold(
          0.0, (sum, item) => sum + (item['RecivedAmount'] ?? 0.0));
    }

    // Method to delete an entry from the "Today Collection" list
    void deleteDailyCollection(Map<String, dynamic> data) {
      todayCollection.remove(data);
      updateTodayTotal();
      Get.snackbar("Deleted", "Daily entry removed",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
    }

    // Method to delete an entry from the "Monthly Collection" list
    void deleteMonthlyCollection(Map<String, dynamic> data) {
      monthlyCollection.remove(data);
      updateMonthlyTotal();
      Get.snackbar("Deleted", "Monthly entry removed",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
    }

    // Open edit dialog for collection (Today or Monthly)
    void openEditDialog(Map<String, dynamic> data, bool isToday) {
      final nameController = TextEditingController(text: data['Name']);
      final paymentController = TextEditingController(text: data['RecivedAmount'].toString());
      final paymentRemainingController = TextEditingController(text: data['BalanceAmount'].toString());
      final nextPaymentController = TextEditingController(text: data['NextPaymentDate']);
      final progressController = TextEditingController(text: data['PaymentStatus']);
      final dateController = TextEditingController(text: data['PaymentDate']);

      Get.dialog(
        AlertDialog(
          title: const Text("Edit Collection"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
                TextField(controller: paymentController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Payment Received")),
                TextField(controller: paymentRemainingController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Payment Remaining")),
                TextField(controller: nextPaymentController, decoration: const InputDecoration(labelText: "Next Payment Date")),
                TextField(controller: progressController, decoration: const InputDecoration(labelText: "Progress/Notes")),
                TextField(controller: dateController, decoration: const InputDecoration(labelText: "Date (Paid On)")),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                data['Name'] = nameController.text;
                data['RecivedAmount'] = double.tryParse(paymentController.text) ?? 0.0;
                data['BalanceAmount'] = double.tryParse(paymentRemainingController.text) ?? 0.0;
                data['NextPaymentDate'] = nextPaymentController.text;
                data['PaymentStatus'] = progressController.text;
                data['PaymentDate'] = dateController.text;

                if (isToday) {
                  todayCollection.refresh();
                  updateTodayTotal();
                } else {
                  monthlyCollection.refresh();
                  updateMonthlyTotal();
                }

                Get.back();
                Get.snackbar("Updated", "Collection details saved", backgroundColor: Colors.green, colorText: Colors.white, snackPosition: SnackPosition.TOP);
              },
              child: const Text("Save"),
            ),
          ],
        ),
      );
    }
  }
