import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AdminTrainerListController extends GetxController {
  var trainers = <Map<String, dynamic>>[].obs;
  var filteredTrainers = <Map<String, dynamic>>[].obs;
  var searchQuery = ''.obs;

  late String gymId;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();

    // 🔁 Read gymId from GetStorage
    gymId = box.read('gymId')?.toString() ?? "0";

    if (gymId == "0") {
      Get.snackbar("Error", "Invalid Gym ID. Please login again.",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    fetchTrainersFromAPI();
  }

  Future<void> fetchTrainersFromAPI() async {
    final url = Uri.parse("https://montgymapi.eduagentapp.com/api/MonteageGymApp/GetEmployeelist/$gymId");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic> && decoded['data'] is List) {
          final List<dynamic> data = decoded['data'];
          final parsed = data.map<Map<String, dynamic>>((e) => {
            'id': e['ID'],
            'name': e['PersonName'],
            'email': e['EmailId'],
            'phone': e['ContactNo'],
            'whatsapp': e['WhatsappNo'],
            'emergency': e['EmergencyNo'],
            'experience': e['Experience']?.replaceAll(" Years", "") ?? '',
            'salary': e['Salary'].toString(),
            'joining_Date': e['JoiningDate'] ?? '',
            'gender': e['Gender'],
            'description': e['Description'] ?? '',
            'courses': [""], // You can map actual course info here
            'availability': {'Morning': '', 'Evening': ''},
            'photoPath': e['ProfileImage'] ?? '',
            'status': 'Active',
            'created': '',
          }).toList();

          trainers.assignAll(parsed);
          filteredTrainers.assignAll(parsed);
        } else {
          Get.snackbar(
            "Error",
            "Invalid data format received from server.",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            margin: EdgeInsets.all(10),
            borderRadius: 8,
            duration: Duration(seconds: 3),
          );
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

  void updateTrainer(int index, Map<String, dynamic> updatedTrainer) {
    final oldTrainer = filteredTrainers[index];
    final originalIndex = trainers.indexWhere((t) => t['id'] == oldTrainer['id']);
    if (originalIndex != -1) {
      trainers[originalIndex] = updatedTrainer;
      applySearch(searchQuery.value);
    }
  }

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
}
