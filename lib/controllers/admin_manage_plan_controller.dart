import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/gym_plan.dart';

class AdminManagePlanController extends GetxController {
  var plans = <GymPlan>[].obs;
  var filteredPlans = <GymPlan>[].obs;
  final scrollController = ScrollController();
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPlans();
  }

  void fetchPlans() {
    plans.value = [
      GymPlan(
        id: 1,
        title: 'Platinum',
        duration: '6 Months',
        price: 5999,
        features: ['Personal Trainer', 'Diet Plan', 'Steam Bath'],
      ),
      GymPlan(
        id: 2,
        title: 'Gold',
        duration: '3 Months',
        price: 3499,
        features: ['Trainer Support', 'Cardio Zone Access'],
      ),
      GymPlan(
        id: 3,
        title: 'Silver',
        duration: '1 Month',
        price: 1499,
        features: ['Gym Access', 'Locker Facility'],
      ),
    ];
    filteredPlans.assignAll(plans);
  }

  void addPlan(GymPlan plan) {
    plans.add(plan);
    applySearch(searchQuery.value); // re-filter after add
  }

  void deletePlan(int index) {
    plans.remove(filteredPlans[index]);
    applySearch(searchQuery.value); // re-filter after delete
  }

  void editPlan(int index, GymPlan updatedPlan) {
    final originalIndex = plans.indexWhere((p) => p.id == filteredPlans[index].id);
    if (originalIndex != -1) {
      plans[originalIndex] = updatedPlan;
      applySearch(searchQuery.value); // re-filter after edit
    }
  }

  void applySearch(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredPlans.assignAll(plans);
    } else {
      final q = query.toLowerCase();
      filteredPlans.assignAll(plans.where((plan) =>
      plan.title.toLowerCase().contains(q) ||
          plan.duration.toLowerCase().contains(q) ||
          plan.features.any((f) => f.toLowerCase().contains(q))
      ));
    }
  }
}
