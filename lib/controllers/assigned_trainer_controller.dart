import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssignedTrainerController extends GetxController {
  // ----- State -----
  var trainerPlan = "Platinum".obs; // still available if you need it
  final trainerNames = <String>[].obs;

  // Text controllers
  final trainerNameController = TextEditingController();
  final trainerCourseController = TextEditingController();
  final trainerChargeController = TextEditingController();
  final experienceController = TextEditingController();
  final durationController = TextEditingController();
  final discountController = TextEditingController();
  final remainingAmountController = TextEditingController();

  // Dropdown visibility (for Course list)
  var isCourseDropdownVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initTrainerNamesFromArgs();
    // Auto-calc remaining whenever charge/discount changes
    trainerChargeController.addListener(_recalcRemaining);
    discountController.addListener(_recalcRemaining);
  }

  void _initTrainerNamesFromArgs() {
    final args = Get.arguments;
    List<String> names = [];
    if (args is Map && args['trainerNames'] is List) {
      names = (args['trainerNames'] as List).map((e) => e.toString()).toList();
    }

    if (names.isEmpty) {
      // Fallback sample list (replace with API-fed list if you have one)
      names = const ['Aman Verma', 'Priya Singh', 'Rahul Mehta', 'Kavya Rao'];
    }
    trainerNames.assignAll(names);

    // Preselect first trainer for convenience
    if (trainerNames.isNotEmpty && trainerNameController.text.trim().isEmpty) {
      trainerNameController.text = trainerNames.first;
    }
  }

  // ---- Dropdown handlers ----
  void toggleCourseDropdown() {
    isCourseDropdownVisible.value = !isCourseDropdownVisible.value;
  }

  void selectTrainerCourse(String selectedCourse) {
    trainerCourseController.text = selectedCourse;
    isCourseDropdownVisible.value = false;
  }

  void selectTrainerName(String name) {
    trainerNameController.text = name;
  }

  // ---- Remaining amount logic ----
  void _recalcRemaining() {
    final charge = double.tryParse(trainerChargeController.text.trim()) ?? 0.0;
    final disc = double.tryParse(discountController.text.trim()) ?? 0.0;
    final remain = charge - disc;
    remainingAmountController.text =
        (remain < 0 ? 0.0 : remain).toStringAsFixed(2);
  }

  // ---- Submit ----
  void submitTrainerData() {
    // Optional: basic validation
    if (trainerNameController.text.trim().isEmpty) {
      Get.snackbar("Validation", "Please select a trainer name",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }
    if (trainerCourseController.text.trim().isEmpty) {
      Get.snackbar("Validation", "Please select a trainer course",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    // Ensure remaining is up-to-date
    _recalcRemaining();

    // TODO: send to API here if needed

    Get.snackbar(
      "Success",
      "Trainer Assigned Successfully",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
    );

    // return success to previous screen
    Get.back(result: true);
  }

  @override
  void onClose() {
    // Clean up listeners & controllers
    trainerChargeController.removeListener(_recalcRemaining);
    discountController.removeListener(_recalcRemaining);

    trainerNameController.dispose();
    trainerCourseController.dispose();
    trainerChargeController.dispose();
    experienceController.dispose();
    durationController.dispose();
    discountController.dispose();
    remainingAmountController.dispose();
    super.onClose();
  }
}
