import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/assigned_trainer_controller.dart';
import '../utils/constants/color_constants.dart';

class AssignedTrainerScreen extends StatelessWidget {
  final controller = Get.put(AssignedTrainerController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Assign Trainer", style: TextStyle(color: Colors.white)),
            backgroundColor: AppColor.APP_Color_Indigo,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
      ),
      body: SingleChildScrollView(  // Added to prevent overflow
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trainer Type Radio Buttons
            Text("Trainer Type"),
            Row(
              children: [

                Radio(
                  value: "Personal Trainer",
                  groupValue: controller.trainerType.value,
                  onChanged: (value) {
                    controller.trainerType.value = value!;
                  },
                ),
                const Text("Personal Trainer"),
              ],
            ),

            // Trainer Name Input
            TextField(
              controller: controller.trainerNameController,
              decoration: const InputDecoration(labelText: "Trainer Name"),
            ),

            // Trainer Course Input
            TextField(
              controller: controller.trainerCourseController,
              decoration: const InputDecoration(labelText: "Trainer Course"),
            ),

            // Trainer Plan Dropdown
            DropdownButton<String>(
              value: controller.trainerPlan.value,
              onChanged: (newValue) {
                controller.trainerPlan.value = newValue!;
              },
              items: <String>['Platinum', 'Gold', 'Silver']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

            // Trainer Charge Input
            TextField(
              controller: controller.trainerChargeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Trainer Charge (₹)"),
            ),

            // Experience Years Input
            TextField(
              controller: controller.experienceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Experience (Years)"),
            ),

            // Duration in Months Input
            TextField(
              controller: controller.durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Duration (Months)"),
            ),

            // Discount Input
            TextField(
              controller: controller.discountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Discount (₹)"),
            ),

            // Remaining Amount Input
            TextField(
              controller: controller.remainingAmountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Remaining Amount (₹)"),
            ),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                controller.submitTrainerData();
              },
              child: const Text("Submit"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color white
              ),
            ),
          ],
        ),
      ),
        ));
  }
}
