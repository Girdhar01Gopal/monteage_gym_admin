import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
class  AdminSettingsController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RxBool obscureCurrentPassword = true.obs;
  RxBool obscurePassword = true.obs;
  RxBool obscureConfirmPassword = true.obs;

  final ImagePicker picker = ImagePicker();
  Rx<File?> profileImage = Rx<File?>(null);

  final _storage = GetStorage(); // GetStorage to access GymId
  String get gymId => (_storage.read('gymId') ?? 1).toString(); // Ensure gymId is treated as String

  // Variable to store the current password fetched from the API
  String currentPassword = "";

  @override
  void onInit() {
    super.onInit();
    fetchCurrentPassword();  // Fetch current password when the controller is initialized
  }

  // Fetch current password from the API
  Future<void> fetchCurrentPassword() async {
    final response = await http.get(
      Uri.parse('https://montgymapi.eduagentapp.com/api/MonteageGymApp/GetCurrentPassword/1/$gymId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['statuscode'] == 200 && data['data'] != null && data['data'].isNotEmpty) {
        currentPassword = data['data'][0]['Password'];  // Store the current password
        currentPasswordController.text = currentPassword;  // Populate currentPasswordController
        print("Current password fetched: $currentPassword");
      } else {
        Get.snackbar('Error', 'No data found or password retrieval failed.',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } else {
      Get.snackbar('Error', 'Failed to fetch current password',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Toggle password visibility
  void toggleCurrentPasswordVisibility() => obscureCurrentPassword.toggle();
  void togglePasswordVisibility() => obscurePassword.toggle();
  void toggleConfirmPasswordVisibility() => obscureConfirmPassword.toggle();

  // Update password
  Future<void> updatePassword() async {
    final current = currentPasswordController.text;
    final newPass = passwordController.text;
    final confirmPass = confirmPasswordController.text;

    if (current.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      Get.snackbar("Error", "All password fields are required.",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    // Check if the current password entered matches the fetched password
    if (current != currentPassword) {
      Get.snackbar("Error", "Current password is incorrect.",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    if (newPass != confirmPass) {
      Get.snackbar("Error", "New passwords do not match.",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    // Prepare the payload for the update password API
    final payload = {
      'ID': 1,  // Example ID, you can fetch it from the response if needed
      'Password': newPass,
    };

    // Call the Update Password API
    final response = await http.post(
      Uri.parse('https://montgymapi.eduagentapp.com/api/MonteageGymApp/UpdateGymPassword'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      Get.back();
      if (data['statuscode'] == 200) {
        Get.snackbar("Success", "Password updated successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Error", "Failed to update password",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } else {
      Get.snackbar("Error", "Failed to update password",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Method to pick an image from gallery
  Future<void> pickImageFromGallery() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      profileImage.value = File(picked.path);
    }
  }

  // Save profile settings (you can include other profile-related settings here)
  void saveSettings() {
    updatePassword();  // Update password
  }
}
