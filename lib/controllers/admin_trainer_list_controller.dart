import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AdminTrainerListController extends GetxController {
  var trainers = <Map<String, dynamic>>[].obs;
  var filteredTrainers = <Map<String, dynamic>>[].obs;
  var searchQuery = ''.obs;
  var expandedCardIndex = (-1).obs;  // To track expanded card index for showing details

  late String gymId;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    gymId = box.read('gymId')?.toString() ?? "0";

    if (gymId == "0") {
      Get.snackbar("Error", "Invalid Gym ID. Please login again.",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    fetchTrainersFromAPI();
  }

  // Format dates into dd-mm-yyyy
  String formatDate(String dateStr) {
    try {
      final dateTime = DateTime.parse(dateStr);
      return "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}";
    } catch (e) {
      return dateStr;
    }
  }

  Future<void> fetchTrainersFromAPI() async {
      final url = Uri.parse("https://montgymapi.eduagentapp.com/api/MonteageGymApp/GetEmployeelist/$gymId");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic> && decoded['data'] is List) {
          final List<dynamic> data = decoded['data'];
          final parsed = data.map<Map<String, dynamic>>((e) {
            return {
              'id': e['ID'],
              'name': _capitalizeFirst((e['PersonName'] ?? '').toString()), // ✅ ensure capitalized
              'email': e['EmailId'],
              'phone': e['ContactNo'],
              'whatsapp': e['WhatsappNo'],
              'emergency': e['EmergencyNo'],
              'experience': e['Experience']?.replaceAll(" Years", "") ?? '',
              'salary': e['Salary'].toString(),
              'joining_Date': formatDate(e['JoiningDate'] ?? ''),
              'start_time': formatDate(e['StartTime'] ?? ''),
              'end_time': formatDate(e['EndTime'] ?? ''),
              'gender': e['Gender'],
              'description': e['Description'] ?? '',
              'courses': [""],
              'availability': {'Morning': '', 'Evening': ''},
              'photoPath': e['ProfileImage'] ?? '',
              'status': 'Active',
              'created': '',
            };
          }).toList();

          trainers.assignAll(parsed);
          filteredTrainers.assignAll(parsed);
        } else {
          Get.snackbar("Error", "Invalid data format received from server.",
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        Get.snackbar("Error", "Failed to fetch trainers. Status: ${response.statusCode}",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Validate phone, whatsapp, emergency contact (10 digits only)
  bool _isValidPhone(String value) {
    return RegExp(r'^\d{10}$').hasMatch(value);
  }

  // Update Trainer information
  void updateTrainer(int index, Map<String, dynamic> updatedTrainer) {
    final oldTrainer = filteredTrainers[index];
    final originalIndex = trainers.indexWhere((t) => t['id'] == oldTrainer['id']);

    if (originalIndex != -1) {
      if (!_isValidPhone(updatedTrainer['phone'])) {
        Get.snackbar("Invalid Phone", "Phone number must be exactly 10 digits",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
      if (!_isValidPhone(updatedTrainer['whatsapp'])) {
        Get.snackbar("Invalid WhatsApp", "WhatsApp number must be exactly 10 digits",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
      if (!_isValidPhone(updatedTrainer['emergency'])) {
        Get.snackbar("Invalid Emergency Contact", "Emergency contact must be exactly 10 digits",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      // ✅ normalize name before saving
      updatedTrainer['name'] = _capitalizeFirst((updatedTrainer['name'] ?? '').toString());

      trainers[originalIndex] = updatedTrainer;
      applySearch(searchQuery.value);
    }
  }

  // Search
  void applySearch(String query) {
    searchQuery.value = query.trim();
    if (searchQuery.value.isEmpty) {
      filteredTrainers.assignAll(trainers);
    } else {
      final lower = searchQuery.value.toLowerCase();
      filteredTrainers.assignAll(
        trainers.where(
              (trainer) => trainer.entries.any(
                (entry) => entry.value.toString().toLowerCase().contains(lower),
          ),
        ),
      );
    }
  }

  void updateCourses(int index, List<String> selectedCourses) {
    final updatedTrainer = filteredTrainers[index];
    updatedTrainer['courses'] = selectedCourses;
    updateTrainer(index, updatedTrainer);
  }

  List<Map<String, dynamic>> getActiveTrainers() {
    return trainers.where((t) => t['status'].toLowerCase().trim() == 'active').toList();
  }

  List<Map<String, dynamic>> getInactiveTrainers() {
    return trainers.where((t) => t['status'].toLowerCase().trim() != 'active').toList();
  }

  void toggleCardExpansion(int index) {
    expandedCardIndex.value = (expandedCardIndex.value == index) ? -1 : index;
  }

  // ---------- Helper ----------
  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
