import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/gym_plan.dart';

class AdminManagePlanController extends GetxController {
  var plans = <GymPlan>[].obs;
  var filteredPlans = <GymPlan>[].obs;
  final scrollController = ScrollController();
  RxString searchQuery = ''.obs;

  final String gymId = "1";        // Static, can be dynamic
  final String createBy = "Admin"; // Default creator
  final String updateBy = "1";     // Updater identifier

  List<GymPlan> get activePlans =>
      filteredPlans.where((p) => p.action.toLowerCase() == "active").toList();

  List<GymPlan> get inactivePlans =>
      filteredPlans.where((p) => p.action.toLowerCase() != "active").toList();

  @override
  void onInit() {
    super.onInit();
    fetchPlansFromAPI();
  }

  Future<void> fetchPlansFromAPI() async {
    try {
      final response = await http.get(
        Uri.parse('https://montgymapi.eduagentapp.com/api/MonteageGymApp/ViewPlan/$gymId'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> planList = jsonData['data'];

        plans.value = planList.map((item) {
          return GymPlan(
            id: item['PlanId'],
            title: item['PlanTittle'],
            duration: item['Duration'],
            price: double.tryParse(item['Price'].toString()) ?? 0,
            features: (item['Includes'] as String).split('+').map((f) => f.trim()).toList(),
            isActive: item['IsActive'] == true || item['IsActive'] == 1,
            action: item['Action'] ?? '',
            createdDate: DateTime.tryParse(item['CreatedDate'] ?? '') ?? DateTime.now(),
          );
        }).toList();

        filteredPlans.assignAll(plans);
      } else {
        throw Exception('Failed to load plans (code ${response.statusCode})');
      }
    } catch (e) {
      Get.snackbar("Error", "Error fetching plans: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> addPlanAPI(GymPlan plan) async {
    final url = Uri.parse("https://montgymapi.eduagentapp.com/api/MonteageGymApp/PlanPost");

    final body = {
      "PlanTittle": plan.title,
      "Duration": plan.duration,
      "Price": plan.price.toInt(),
      "Includes": plan.features.join(' + '),
      "GymeId": gymId,
      "CreateBy": createBy,
      "IsActive": plan.isActive,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Plan added successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
        fetchPlansFromAPI();
      } else {
        Get.snackbar("Error", "Failed to add plan: ${response.body}",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Exception: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> editPlanAPI(GymPlan updatedPlan) async {
    final url = Uri.parse("https://montgymapi.eduagentapp.com/api/MonteageGymApp/PlanEdit");

    final body = {
      "PlanId": updatedPlan.id,
      "PlanTittle": updatedPlan.title,
      "Duration": updatedPlan.duration,
      "Price": updatedPlan.price.toInt(),
      "Includes": updatedPlan.features.join(' + '),
      "UpdateBy": updateBy,
      "IsActive": updatedPlan.isActive,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Plan updated successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
        fetchPlansFromAPI();
      } else {
        Get.snackbar("Error", "Failed to update: ${response.body}",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Exception: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void addPlan(GymPlan plan) async {
    await addPlanAPI(plan);
  }

  void editPlan(int index, GymPlan updatedPlan) async {
    await editPlanAPI(updatedPlan);
    applySearch(searchQuery.value);
  }

  void deletePlanById(int id) {
    plans.removeWhere((p) => p.id == id);
    applySearch(searchQuery.value);
  }

  void moveToInactive(GymPlan updatedPlan) {
    if (!updatedPlan.isActive) {
      // Move the plan to the inactive list if it's marked inactive
      filteredPlans.removeWhere((plan) => plan.id == updatedPlan.id);
      filteredPlans.add(updatedPlan);
    }
  }

  void applySearch(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredPlans.assignAll(plans);
    } else {
      final q = query.toLowerCase();
      filteredPlans.assignAll(
        plans.where((plan) =>
        plan.title.toLowerCase().contains(q) ||
            plan.duration.toLowerCase().contains(q) ||
            plan.features.any((f) => f.toLowerCase().contains(q))),
      );
    }
  }
}
