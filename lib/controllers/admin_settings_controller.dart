import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AdminSettingsController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  final currentPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RxBool notificationsEnabled = true.obs;
  RxBool darkModeEnabled = false.obs;
  Rx<File?> profileImage = Rx<File?>(null);

  RxBool obscureCurrentPassword = true.obs;
  RxBool obscurePassword = true.obs;
  RxBool obscureConfirmPassword = true.obs;

  final ImagePicker picker = ImagePicker();

  /// Dummy current password for comparison
  final String storedPassword = "admin@123"; // Replace with secure logic in production

  void toggleNotifications() => notificationsEnabled.toggle();
  void toggleDarkMode() => darkModeEnabled.toggle();
  void toggleCurrentPasswordVisibility() => obscureCurrentPassword.toggle();
  void togglePasswordVisibility() => obscurePassword.toggle();
  void toggleConfirmPasswordVisibility() => obscureConfirmPassword.toggle();

  Future<void> pickImageFromGallery() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      profileImage.value = File(picked.path);
    }
  }

  void saveSettings() {
    final current = currentPasswordController.text;
    final newPass = passwordController.text;
    final confirmPass = confirmPasswordController.text;

    if (current.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      Get.snackbar("Error", "All password fields are required.",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    if (current != storedPassword) {
      Get.snackbar("Error", "Current password is incorrect.",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    if (newPass != confirmPass) {
      Get.snackbar("Error", "New passwords do not match.",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    // Perform save logic here
    Get.snackbar("Success", "Settings saved successfully",
        backgroundColor: Colors.green, colorText: Colors.white);
  }
}
