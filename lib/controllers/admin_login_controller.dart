import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../infrastructure/routes/admin_routes.dart';


class AdminLoginController extends GetxController {
  RxBool obscurePassword = true.obs;

  // Method to toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rememberMe = false.obs;
  final isLoading = false.obs;
  final formkey = GlobalKey<FormState>();

  // ---------------------------------------
  // 🔐 Email/Password Login
  // ---------------------------------------
  Future<void> login(var email, var password) async {
    final uri = "https://montgymapi.eduagentapp.com/api/MonteageGymApp/Logins";
    try {
      final response = await http.post(
        Uri.parse(uri),
        body: json.encode({
          "Email": email.toString(),
          "Password": password.toString(),
        }),
        headers: {
          "Content-Type": "application/json", // Proper content-type for JSON
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Login Successful", backgroundColor: Colors.green, colorText: Colors.white);

        // Navigate to Admin Dashboard screen after successful login
        Get.toNamed(AdminRoutes.ADMIN_DASHBOARD); // Navigate using the defined route

      } else {
        // Handle unsuccessful login (e.g., wrong credentials)
        Get.snackbar("Error", "Login Failed. Please try again.", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      // Handle errors like network issues
      Get.snackbar("Error", "An error occurred: $e", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
