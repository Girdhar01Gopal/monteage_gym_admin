import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../infrastructure/routes/admin_routes.dart';

class AdminLoginController extends GetxController {
  RxBool obscurePassword = true.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rememberMe = false.obs;
  final isLoading = false.obs;
  final formkey = GlobalKey<FormState>();

  final box = GetStorage();

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;

    final uri = "https://montgymapi.eduagentapp.com/api/MonteageGymApp/Logins";
    try {
      final response = await http.post(
        Uri.parse(uri),
        body: json.encode({"Email": email, "Password": password}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['statuscode'] == 200) {
          final gymId = data['data']['GymeId'];


          box.write('isLoggedIn', true);
          box.write('adminEmail', email);
          box.write('gymId', gymId);

          Get.snackbar("Success", "Login Successful",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          // Navigate to dashboard
          Get.offAllNamed(AdminRoutes.ADMIN_DASHBOARD);
        } else {
          Get.snackbar("Error", data['message'] ?? "Login Failed",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar("Error", "Server error: ${response.statusCode}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }


  void logout() {
    box.erase(); // Clear cache
    Get.offAllNamed(AdminRoutes.ADMIN_LOGIN);
  }
}
