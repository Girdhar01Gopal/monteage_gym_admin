import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/add_member_controller.dart';
import '../utils/constants/color_constants.dart';

class AddMemberScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddMemberController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Member", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.APP_Color_Indigo,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image with Edit Option
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Obx(() => CircleAvatar(
                    radius: 50.r,
                    backgroundImage: controller.profileImage.value != null
                        ? FileImage(controller.profileImage.value!)
                        : AssetImage("assets/images/person.png") as ImageProvider,
                    backgroundColor: Colors.grey.shade200,
                  )),
                  InkWell(
                    onTap: controller.pickImageFromGallery,
                    child: CircleAvatar(
                      backgroundColor: AppColor.APP_Color_Pink,
                      radius: 22.r,
                      child: Icon(Icons.edit, color: Colors.white, size: 18.r),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),

            // Name Input Field
            buildTextField("Name", controller.nameController),
            buildTextField("Email", controller.emailController),
            buildTextField("Phone", controller.phoneController),
            buildTextField("Address", controller.addressController),

            // Gender Dropdown
            buildGenderDropdown(controller),

            // Trainer Type Dropdown
            buildTrainerTypeDropdown(controller),

            // Gender for Personal Trainer
            buildTrainerGenderDropdown(controller),

            // Gym Plan Dropdown
            Text("Select Gym Plan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            DropdownButton<String>(
              value: controller.selectedPlan.value,
              onChanged: (newPlan) => controller.selectedPlan.value = newPlan!,
              items: ['Platinum', 'Gold', 'Silver'].map((plan) {
                return DropdownMenuItem(value: plan, child: Text(plan));
              }).toList(),
              isExpanded: true,
              style: TextStyle(fontSize: 16.sp, color: Colors.black),
              dropdownColor: Colors.grey.shade100,
            ),
            SizedBox(height: 10),

            // Join Date
            buildDateField(context, "Join Date", controller.joinDateController, controller),

            // Discount Field (Now in Rupees)
            buildTextField("Discount (₹)", controller.discountController),

            // Next Fee Payment Date
            buildDateField(context, "Next Fee Payment Date", controller.nextFeeDateController, controller),

            // Package Expiry Date (Auto-filled after Join Date)
            buildTextField("Package Expiry Date", controller.packageExpiryController),

            // Add Member Button
            SizedBox(height: 2.h),
            ElevatedButton(
              onPressed: controller.addMember,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.APP_Color_Indigo,
                padding: EdgeInsets.symmetric(vertical: 18.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
              child: Text("  Add Member  ", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  /// Custom TextField for Better UI
  Widget buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black)),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Enter $label",
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  /// Custom Date Picker Field
  Widget buildDateField(BuildContext context, String label, TextEditingController controller, AddMemberController addController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black)),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          readOnly: true,
          onTap: () => addController.pickDate(context, controller),
          decoration: InputDecoration(
            hintText: "Select $label",
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  /// Custom Dropdown for Gender Selection
  Widget buildGenderDropdown(AddMemberController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Gender", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black)),
        SizedBox(height: 8.h),
        DropdownButton<String>(
          value: controller.selectedGender.value,
          onChanged: (newGender) => controller.selectedGender.value = newGender!,
          items: ['Male', 'Female', 'Other'].map((gender) {
            return DropdownMenuItem(value: gender, child: Text(gender));
          }).toList(),
          isExpanded: true,
          style: TextStyle(fontSize: 16.sp, color: Colors.black),
          dropdownColor: Colors.grey.shade100,
        ),
        SizedBox(height: 10),
      ],
    );
  }

  /// Custom Dropdown for Trainer Type Selection
  Widget buildTrainerTypeDropdown(AddMemberController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Trainer Type", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black)),
        SizedBox(height: 8.h),
        DropdownButton<String>(
          value: controller.selectedTrainer.value,
          onChanged: (newTrainer) => controller.selectedTrainer.value = newTrainer!,
          items: ['Personal Trainer', 'General Trainer'].map((trainer) {
            return DropdownMenuItem(value: trainer, child: Text(trainer));
          }).toList(),
          isExpanded: true,
          style: TextStyle(fontSize: 16.sp, color: Colors.black),
          dropdownColor: Colors.grey.shade100,
        ),
        SizedBox(height: 20),
      ],
    );
  }

  /// Custom Dropdown for Personal Trainer's Gender Selection
  Widget buildTrainerGenderDropdown(AddMemberController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Gender for Trainer", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black)),
        SizedBox(height: 8.h),
        DropdownButton<String>(
          value: controller.selectedTrainerGender.value,
          onChanged: (newTrainerGender) => controller.selectedTrainerGender.value = newTrainerGender!,
          items: ['Male', 'Female'].map((gender) {
            return DropdownMenuItem(value: gender, child: Text(gender));
          }).toList(),
          isExpanded: true,
          style: TextStyle(fontSize: 16.sp, color: Colors.black),
          dropdownColor: Colors.grey.shade100,
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
