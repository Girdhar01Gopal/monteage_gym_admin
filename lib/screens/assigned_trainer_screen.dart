import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/assigned_trainer_controller.dart';
import '../utils/constants/color_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AssignedTrainerScreen extends StatelessWidget {
  final controller = Get.put(AssignedTrainerController());

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsiveness
    ScreenUtil.init(context, designSize: const Size(375, 812), minTextAdapt: true);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Personal Trainer", style: TextStyle(color: Colors.white)),
          backgroundColor: AppColor.APP_Color_Indigo,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---- Trainer Name (Dropdown) ----
              Obx(() {
                return DropdownButtonFormField<String>(
                  value: controller.trainerNames.contains(controller.trainerNameController.text)
                      ? controller.trainerNameController.text
                      : (controller.trainerNames.isNotEmpty ? controller.trainerNames.first : null),
                  items: controller.trainerNames
                      .map((name) => DropdownMenuItem(value: name, child: Text(name)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) controller.selectTrainerName(val);
                  },
                  decoration: const InputDecoration(
                    labelText: "Trainer Name",
                    border: OutlineInputBorder(),
                  ),
                );
              }),

              SizedBox(height: 14.h),

              // ---- Trainer Course (Dropdown-like text field with custom list) ----
              GestureDetector(
                onTap: controller.toggleCourseDropdown,
                child: AbsorbPointer(
                  child: TextField(
                    controller: controller.trainerCourseController,
                    decoration: const InputDecoration(
                      labelText: "Trainer Course",
                      hintText: "Select Plan (Platinum, Gold, Silver)",
                      suffixIcon: Icon(Icons.arrow_drop_down),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),

              // Inline dropdown
              Obx(() {
                return Visibility(
                  visible: controller.isCourseDropdownVisible.value,
                  child: Card(
                    margin: EdgeInsets.only(top: 8.h, bottom: 4.h),
                    elevation: 2,
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text("Platinum"),
                          onTap: () => controller.selectTrainerCourse("Platinum"),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          title: const Text("Gold"),
                          onTap: () => controller.selectTrainerCourse("Gold"),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          title: const Text("Silver"),
                          onTap: () => controller.selectTrainerCourse("Silver"),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              SizedBox(height: 14.h),

              // ---- Trainer Charge ----
              TextField(
                controller: controller.trainerChargeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Trainer Charge (₹)",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 12.h),

              // ---- Discount ----
              TextField(
                controller: controller.discountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Discount (₹)",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 12.h),

              // ---- Remaining Amount (auto-calculated, read-only) ----
              TextField(
                controller: controller.remainingAmountController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Remaining Amount (₹)",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 12.h),

              // ---- Duration (Months) ----
              TextField(
                controller: controller.durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Duration (Months)",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 12.h),

              // ---- Experience (Years) ----
              TextField(
                controller: controller.experienceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Experience (Years)",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20.h),

              // ---- Submit ----
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.submitTrainerData,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  child: const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
