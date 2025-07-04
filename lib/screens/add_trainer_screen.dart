import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../controllers/admin_add_trainer_controller.dart';

class AddTrainerScreen extends StatelessWidget {
  final controller = Get.find<AdminAddTrainerController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController specializationController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController courseController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();

  final DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");

  final Rx<File?> selectedImage = Rx<File?>(null);

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Trainer", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Trainer Photo Upload
            Obx(() => GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 45,
                backgroundColor: Colors.grey.shade200,
                backgroundImage:
                selectedImage.value != null ? FileImage(selectedImage.value!) : null,
                child: selectedImage.value == null
                    ? Icon(Icons.camera_alt, size: 30, color: Colors.black)
                    : null,
              ),
            )),
            SizedBox(height: 5),

            // Trainer Name Field
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Trainer Name"),
            ),
            SizedBox(height: 5),

            // Specialization Field
            TextField(
              controller: specializationController,
              decoration: InputDecoration(labelText: "Specialization"),
            ),
            SizedBox(height: 5),

            // Phone Number Field
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: "Phone Number"),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 5),

            // Experience Field
            TextField(
              controller: experienceController,
              decoration: InputDecoration(labelText: "Experience (Years)"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 5),

            // Course Field
            TextField(
              controller: courseController,
              decoration: InputDecoration(labelText: "Course"),
            ),
            SizedBox(height: 5),

            // Start Time Field
            TextField(
              controller: startTimeController,
              decoration: InputDecoration(labelText: "Start Time (YYYY-MM-DD HH:mm)"),
              readOnly: true,
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (selectedTime != null) {
                    final fullDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );
                    startTimeController.text = dateFormat.format(fullDateTime);
                  }
                }
              },
            ),
            SizedBox(height: 5),

            // End Time Field
            TextField(
              controller: endTimeController,
              decoration: InputDecoration(labelText: "End Time (YYYY-MM-DD HH:mm)"),
              readOnly: true,
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (selectedTime != null) {
                    final fullDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );
                    endTimeController.text = dateFormat.format(fullDateTime);
                  }
                }
              },
            ),
            SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                if (selectedImage.value == null) {
                  Get.snackbar("Error", "Please select a trainer photo",
                      backgroundColor: Colors.red, colorText: Colors.white);
                  return;
                }

                var trainer = {
                  'name': nameController.text,
                  'specialization': specializationController.text,
                  'phone': phoneController.text,
                  'experience': experienceController.text,
                  'course': courseController.text,
                  'startTime': startTimeController.text,
                  'endTime': endTimeController.text,
                  'photoPath': selectedImage.value!.path,
                };

                controller.addTrainer(trainer);

                Get.back();
              },
              child: Text("Add Trainer", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
