import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/add_member_controller.dart';
import '../infrastructure/routes/admin_routes.dart';
import '../utils/constants/color_constants.dart';

class AddMemberScreen extends StatelessWidget {
  // Initialize the controller from GetX
  final AddMemberController controller = Get.find<AddMemberController>();

  // Reactive image for selected image
  final Rx<File?> selectedImage = Rx<File?>(null);
  String base64Image = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add New Member", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.APP_Color_Indigo,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              Get.dialog(AlertDialog(
                title: const Text("Navigate To"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.people),
                      title: const Text("Total Member's"),
                      onTap: () {
                        Get.back();
                        Get.toNamed(AdminRoutes.ADMIN_USER_LIST);
                      },
                    ),
                  ],
                ),
              ));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Obx(() => GestureDetector(
              onTap: () => _pickImage(context),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: selectedImage.value != null
                    ? FileImage(selectedImage.value!)
                    : null,
                child: selectedImage.value == null
                    ? const Icon(Icons.camera_alt, size: 32)
                    : null,
              ),
            )),
            const SizedBox(height: 16),
            buildTextField("Name", controller.nameController),
            buildReactiveDropdown("Gym Plan", controller.selectedPlan, controller.plans),
            buildTextField("Father / Husband Name", controller.fatherController),
            buildTextField("Email", controller.emailController),
            buildTextField("Phone", controller.phoneController),

            // WhatsApp checkbox logic
            Row(
              children: [
                Obx(() =>
                    Checkbox(
                      value: controller.isSameAsPhone.value,
                      onChanged: (val) => controller.isSameAsPhone.value = val ?? false,
                    )),
                const Text("Same as phone number"),
              ],
            ),
            Obx(() =>
                buildTextField(
                  "WhatsApp Number",
                  controller.whatsappController,
                  readOnly: controller.isSameAsPhone.value,
                )),

            buildTextField("Emergency Number", controller.emergencyController),
            buildTextField("Address", controller.addressController),
            buildTextField("Height (cm)", controller.heightController),
            buildTextField("Weight (kg)", controller.weightController),
            buildReactiveDropdown("Gender", controller.selectedGender, ['Male', 'Female', 'Other']),
            buildTextField("Plan Amount (₹)", controller.planAmountController, readOnly: true),
            buildTextField(
              "Joining Date",
              controller.joinDateController,
              readOnly: true,
              onTap: () => controller.pickDate(context, controller.joinDateController, isJoiningDate: true),
            ),

            buildTextField("Discount (₹)", controller.discountController),

            buildTextField(
              "Next Fee Payment Date",
              controller.nextFeeDateController,
              readOnly: true,
              onTap: () => controller.pickDate(context, controller.nextFeeDateController),
            ),
            buildTextField("Package Expiry Date", controller.packageExpiryController, readOnly: true),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null  // Disable the button when loading
                  : () {
                final gymId = GetStorage().read('gymId') ?? 0;
                // Get the selected plan and retrieve its ID from the plans list
                final selectedPlanData = controller.plans.firstWhere(
                      (plan) => plan['PlanTittle'] == controller.selectedPlan.value,
                  orElse: () => null,
                );
                final planId = selectedPlanData != null ? selectedPlanData['PlanId'] : 0; // Default to 0 if no plan is selected

                // Call addMemberAPI with necessary parameters
                controller.addMemberAPI(
                  controller.nameController.text,
                  planId,
                  controller.fatherController.text,
                  controller.emailController.text,
                  controller.phoneController.text,
                  controller.isSameAsPhone.value ? controller.phoneController.text : controller.whatsappController.text,
                  controller.emergencyController.text,
                  controller.addressController.text,
                  controller.heightController.text,
                  controller.weightController.text,
                  controller.selectedGender.value,
                  controller.planAmountController.text,
                  controller.discountController.text,
                  controller.joinDateController.text,
                  controller.packageExpiryController.text,
                  gymId.toString(),
                  '1', // Assuming admin as the creator, change as needed
                  base64Image.toString(), // Adding base64Image to send with the request
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.APP_Color_Indigo,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: controller.isLoading.value
                  ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
                  : const Text(" Add Member ", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {bool readOnly = false, VoidCallback? onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: "Enter $label",
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  void _pickImage(BuildContext context) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final file = File(picked.path);
      selectedImage.value = file;

      // Convert to base64 string
      List<int> imageBytes = await file.readAsBytes();
      base64Image = base64Encode(imageBytes);
    }
  }

  Widget buildReactiveDropdown(String label, RxString selectedValue, List<dynamic> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Obx(() =>
            DropdownButtonFormField<String>(
              value: selectedValue.value.isEmpty ? null : selectedValue.value,
              items: options.map((e) {
                if (e is Map<String, dynamic>) {
                  return DropdownMenuItem<String>(
                    value: e['PlanTittle'],
                    child: Text(e['PlanTittle']),
                  );
                } else {
                  return DropdownMenuItem<String>(
                    value: e as String,
                    child: Text(e),
                  );
                }
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  selectedValue.value = val; // This will trigger the listener in controller
                }
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            )),
        const SizedBox(height: 12),
      ],
    );
  }
}
