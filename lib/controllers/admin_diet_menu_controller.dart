import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AdminDietMenuController extends GetxController {
  // Observable list of diet menu items categorized by Veg and Non-Veg
  var dietMenuList = {
    'Veg': <Map<String, dynamic>>[].obs,
    'Non-Veg': <Map<String, dynamic>>[].obs,
  };

  // Observable for tracking whether the form for adding a new item is visible
  var isAdding = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Simulate initial fetch of da
    fetchDietMenu();
  }

  // Simulate fetching diet menu data (Replace with actual API call)
  void fetchDietMenu() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay

    dietMenuList['Veg']?.addAll([
      {'name': 'Roti', 'description': 'Delicious Roti', 'nutrition': '250 Cal', 'image': 'image_path'},
    ]);
    dietMenuList['Non-Veg']?.addAll([
      {'name': 'Egg', 'description': 'Delicious Egg', 'nutrition': '300 Cal', 'image': 'image_path'},
    ]);
  }

  // Add a new diet menu item
  void addDietMenuItem(Map<String, dynamic> newItem, String category) {
    dietMenuList[category]?.add(newItem);
    Get.snackbar("Success", "$category Item added successfully", backgroundColor: Colors.green, colorText: Colors.white);
  }

  // Delete a diet menu item
  void deleteDietMenuItem(int index, String category) {
    dietMenuList[category]?.removeAt(index);
    Get.snackbar("Success", "$category Item deleted successfully", backgroundColor: Colors.red, colorText: Colors.white);
  }
}
