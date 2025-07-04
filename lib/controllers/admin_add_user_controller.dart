import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminAddUserController extends GetxController {
  // TextEditingControllers for user input fields
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Observable for selected role
  var selectedRole = 'User'.obs;

  // Function to handle user addition
  void addUser() {
    // Validate input fields
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty ||
        selectedRole.value.isEmpty) {
      Get.snackbar("Error", "Please fill in all fields", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Simulate user addition logic
    // You can replace this with actual API calls or DB operations.
    Map<String, String> newUser = {
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'password': passwordController.text,
      'role': selectedRole.value,
    };

    // Add the new user (e.g., save it to a database or API)
    Get.snackbar("Success", "User Added Successfully", snackPosition: SnackPosition.BOTTOM);

    // Clear input fields after adding the user
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
  }
}
