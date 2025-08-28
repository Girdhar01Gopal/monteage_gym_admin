import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AdminAddTrainerController extends GetxController {
  final phoneController = TextEditingController();
  final whatsappController = TextEditingController();
  final isSameAsPhone = false.obs;
  final selectedGender = ''.obs;
  final selectedCourseIds = <int>[].obs;
  final courseMap = <String, int>{}.obs;

  late int gymId;
  final box = GetStorage();

  // Validate if phone number is exactly 10 digits
  bool _isValidPhone(String phone) => RegExp(r'^\d{10}$').hasMatch(phone);

  // Validate Gmail format
  bool _isValidGmail(String email) => email.toLowerCase().endsWith('@gmail.com');

  @override
  void onInit() {
    super.onInit();
    gymId = box.read('gymId') ?? 0;

    if (gymId == 0) {
      Get.snackbar("Error", "Invalid Gym ID", backgroundColor: Colors.red, colorText: Colors.white);
    } else {
      fetchCoursesFromAPI();
    }

    phoneController.addListener(() {
      if (isSameAsPhone.value) {
        whatsappController.text = phoneController.text;
      }
    });

    isSameAsPhone.listen((val) {
      if (val) {
        whatsappController.text = phoneController.text;
      }
    });
  }

  // Submit Trainer data
  Future<void> submitTrainerData({
    required String name,
    required String gender,
    required String email,
    required String phone,
    required String whatsapp,
    required String emergency,
    required String experience,
    required String salary,
    required String joiningDate,
    required String starttime,
    required String endtime,
    required String newcourse,
    required String description,
    required String usertype,
    required String gymid,
    required String createdby,
    required var image,
  }) async {
    // Validate fields
    if (name.isEmpty || email.isEmpty || phone.isEmpty || whatsapp.isEmpty || experience.isEmpty || salary.isEmpty) {
      Get.snackbar("Error", "Please fill all required fields", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (!_isValidPhone(phone) || !_isValidPhone(whatsapp)) {
      Get.snackbar("Invalid", "Phone/WhatsApp must be 10-digit numbers", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (!_isValidGmail(email)) {
      Get.snackbar("Invalid", "Email must be a valid Gmail address", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final Map<String, dynamic> body = {
      "PersonName": name,
      "Gender": gender,
      "EmailId": email,
      "ContactNo": phone,
      "WhatsappNo": whatsapp,
      "EmergencyNo": emergency,
      "Experience": experience,
      "Salary": salary,
      "JoiningDate": joiningDate,
      "StartTime": starttime,
      "EndTime": endtime,
      "CourseId": newcourse,
      "Description": description,
      "UserType": usertype,
      "GymeId": gymid,
      "CreateBy": createdby,
      "ProfileImage": image,
    };

    try {
      final response = await http.post(
        Uri.parse("https://montgymapi.eduagentapp.com/api/MonteageGymApp/AddEmployee"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Trainer added successfully", backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Error", "Failed to add trainer: ${response.body}", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Exception: $e", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Submit Custom Course to API
  Future<void> submitCustomCourseToAPI(String courseName) async {
    final url = Uri.parse("https://montgymapi.eduagentapp.com/api/MonteageGymApp/AddCourse");

    final body = {
      "CourseName": courseName,
      "GymeId": gymId,
      "CreateBy": "admin",
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["data"] != null && data["data"]["CourseId"] != null) {
          final newCourseId = data["data"]["CourseId"];
          courseMap[courseName] = newCourseId;
          selectedCourseIds.add(newCourseId);

          Get.snackbar("Success", "Course added successfully", backgroundColor: Colors.green, colorText: Colors.white);
        } else {
          await fetchCoursesFromAPI();
        }
      } else {
        Get.snackbar("Error", "Course addition failed: ${response.body}", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Exception: $e", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Fetch courses from API
  Future<void> fetchCoursesFromAPI() async {
    final url = Uri.parse("https://montgymapi.eduagentapp.com/api/MonteageGymApp/CourseBind/$gymId");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse["data"] != null) {
          courseMap.clear();
          for (var item in jsonResponse["data"]) {
            if (item["CourseName"] != null && item["CourseId"] != null) {
              courseMap[item["CourseName"]] = item["CourseId"];
            }
          }
        }
      } else {
        Get.snackbar("Error", "Failed to load courses", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Course fetch error: $e", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    whatsappController.dispose();
    super.onClose();
  }
}
