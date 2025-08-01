import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AssignedTrainerController extends GetxController {
  var trainerType = "General Trainer".obs;
  var trainerPlan = "Platinum".obs;

  TextEditingController trainerNameController = TextEditingController();
  TextEditingController trainerCourseController = TextEditingController();
  TextEditingController trainerChargeController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController remainingAmountController = TextEditingController();

  // Method to handle submission logic
  void submitTrainerData() {
    String trainerName = trainerNameController.text;
    String trainerCourse = trainerCourseController.text;
    String trainerCharge = trainerChargeController.text;
    String experience = experienceController.text;
    String duration = durationController.text;
    String discount = discountController.text;
    String remainingAmount = remainingAmountController.text;

    // You can send this data to your API or handle any logic needed
    print("Trainer Name: $trainerName");
    print("Trainer Course: $trainerCourse");
    print("Trainer Charge: ₹$trainerCharge");
    print("Experience: $experience years");
    print("Duration: $duration months");
    print("Discount: ₹$discount");
    print("Remaining Amount: ₹$remainingAmount");

    // After processing, you can show a confirmation message or navigate
    Get.snackbar(
      "Success",
      "Assign Trainer Successfully",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
    );
  }
}
