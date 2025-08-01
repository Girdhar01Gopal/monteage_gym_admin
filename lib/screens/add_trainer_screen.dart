import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../controllers/admin_add_trainer_controller.dart';
import '../infrastructure/routes/admin_routes.dart';
import '../utils/constants/color_constants.dart';

class AddTrainerScreen extends StatelessWidget {
  final controller = Get.find<AdminAddTrainerController>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final emergencyController = TextEditingController();
  final experienceController = TextEditingController();
  final salaryController = TextEditingController();
  final descriptionController = TextEditingController();
  final joinDateController = TextEditingController();
  final startDateController = TextEditingController();  // Start Time Controller
  final endDateController = TextEditingController();    // End Date Controller
  final newCourseController = TextEditingController();
  final Rx<File?> selectedImage = Rx<File?>(null);
  String base64Image = '';
  final List<String> genders = ["Male", "Female", "Other"];

  @override
  Widget build(BuildContext context) {
    controller.fetchCoursesFromAPI(); // Refresh course list

    // Fetch gymId from GetStorage (which is saved during login)
    final gymId = GetStorage().read('gymId') ?? 0; // Default to 0 if gymId is not found

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add Trainer", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.APP_Color_Indigo,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Get.back()),
        actions: [
          IconButton(icon: const Icon(Icons.group, color: Colors.white), onPressed: () => Get.toNamed(AdminRoutes.ADMIN_TRAINER_LIST)),
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
                backgroundImage: selectedImage.value != null ? FileImage(selectedImage.value!) : null,
                child: selectedImage.value == null ? const Icon(Icons.camera_alt, size: 32) : null,
              ),

            )),
            const SizedBox(height: 20),
            _buildTextField("Name", nameController),
            _buildDropdown("Select Gender", controller.selectedGender, genders),
            _buildTextField("Email (Gmail only)", emailController, keyboard: TextInputType.emailAddress),
            _buildTextField("Phone Number", controller.phoneController, keyboard: TextInputType.phone),
            Row(
              children: [
                Obx(() => Checkbox(
                  value: controller.isSameAsPhone.value,
                  onChanged: (val) => controller.isSameAsPhone.value = val ?? false,
                )),
                const Text("Same as phone number"),
              ],
            ),
            Obx(() => _buildTextField("WhatsApp Number", controller.whatsappController, keyboard: TextInputType.phone, readOnly: controller.isSameAsPhone.value)),
            _buildTextField("Emergency Contact No", emergencyController, keyboard: TextInputType.phone),
            _buildTextField("Experience (Years)", experienceController, keyboard: TextInputType.number),
            _buildTextField("Add Salary ₹", salaryController, keyboard: TextInputType.number),
            TextField(
              controller: joinDateController,
              readOnly: true,
              onTap: () => _pickDate(joinDateController, context),
              decoration: const InputDecoration(labelText: "Joining Date"),
            ),
            const SizedBox(height: 20),
            // Start Date Picker
            TextField(
              controller: startDateController,
              readOnly: true,
              onTap: () => _pickDate(startDateController, context),
              decoration: const InputDecoration(labelText: "Start Time"),
            ),
            // End Date Picker
            TextField(
              controller: endDateController,
              readOnly: true,
              onTap: () => _pickDate(endDateController, context),
              decoration: const InputDecoration(labelText: "End Time"),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Gym Courses", style: TextStyle(fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: () => _addCustomCourseDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text("Add Custom"),
                ),
              ],
            ),
            Obx(() => controller.courseMap.isEmpty
                ? const Text("Loading courses...")
                : Column(
              children: controller.courseMap.entries.map((entry) {
                final courseName = entry.key;
                final courseId = entry.value;
                return CheckboxListTile(
                  title: Text(courseName),
                  value: controller.selectedCourseIds.contains(courseId),
                  onChanged: (val) {
                    if (val == true) {
                      controller.selectedCourseIds.add(courseId);
                    } else {
                      controller.selectedCourseIds.remove(courseId);
                    }
                  },
                );
              }).toList(),
            )),
            const SizedBox(height: 10),
            _buildTextField("Trainer Description", descriptionController, maxLines: 3),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () async {
                // Pass gymId from GetStorage
                final gymId = GetStorage().read('gymId') ?? 0;

                // Format the start and end dates
                final startDate = startDateController.text.trim();
                final endDate = endDateController.text.trim();

                await controller.submitTrainerData(
                  name: nameController.text.trim(),
                  email: emailController.text.trim(),
                  phone: controller.phoneController.text.trim(),
                  whatsapp: controller.whatsappController.text.trim(),
                  emergency: emergencyController.text.trim(),
                  experience: experienceController.text.trim(),
                  salary: salaryController.text.trim(),
                  joiningDate: joinDateController.text.trim(),
                  description: descriptionController.text.trim(),
                  newcourse: controller.selectedCourseIds.join(","),
                  gender: controller.selectedGender.value,
                  startdate: startDate,
                  enddate: endDate,
                  usertype: 'Trainer',
                  gymid: gymId.toString(),
                  createdby: 'admin', image: base64Image,
                );

              //  final trainerListController = Get.find<AdminTrainerListController>();
                //await trainerListController.fetchTrainersFromAPI();
                Get.offAllNamed(AdminRoutes.ADMIN_TRAINER_LIST);
              },
              child: const Text("Add Trainer", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboard = TextInputType.text, int maxLines = 1, bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboard,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      ),
    );
  }

  Widget _buildDropdown(String label, RxString selected, List<String> options) {
    return Obx(() => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: selected.value.isNotEmpty ? selected.value : null,
        hint: Text(label),
        decoration: const InputDecoration(border: OutlineInputBorder()),
        items: options.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
        onChanged: (val) => selected.value = val!,
      ),
    ));
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

  void _pickDate(TextEditingController controller, BuildContext context) async {
    final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
    if (date != null) controller.text = DateFormat('yyyy-MM-dd').format(date);
  }

  Widget _buildAvailabilitySection(String label, RxList<String> slots, BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.blue),
              onPressed: () => _showTimeSlotDialog(label, slots, context),
            ),
          ],
        ),
        Wrap(
          spacing: 8,
          children: slots.map((slot) =>
              Chip(label: Text(slot), onDeleted: () => slots.remove(slot))).toList(),
        )
      ],
    ));
  }

  void _showTimeSlotDialog(String label, RxList<String> slotList, BuildContext context) {
    TimeOfDay? fromTime;
    TimeOfDay? toTime;
    Get.dialog(StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text("Add $label Slot"),
          content: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                    if (picked != null) setState(() => fromTime = picked);
                  },
                  child: Text(fromTime != null ? fromTime!.format(context) : "From"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                    if (picked != null) setState(() => toTime = picked);
                  },
                  child: Text(toTime != null ? toTime!.format(context) : "To"),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                if (fromTime != null && toTime != null) {
                  final slot = "${fromTime!.format(context)} - ${toTime!.format(context)}";
                  if (!slotList.contains(slot)) slotList.add(slot);
                }
                Get.back();
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    ));
  }

  void _addCustomCourseDialog(BuildContext context) {
    newCourseController.clear();
    Get.dialog(AlertDialog(
      title: const Text("Add Custom Course"),
      content: TextField(controller: newCourseController),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () async {
            final course = newCourseController.text.trim();
            if (course.isNotEmpty) {
              await controller.submitCustomCourseToAPI(course);
            }
            Get.back();
          },
          child: const Text("Add"),
        )
      ],
    ));
  }
}
