import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/admin_trainer_list_controller.dart';

class AdminTrainerListScreen extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminTrainerListController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Trainer List", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => _showSearchDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.filteredTrainers.isEmpty) {
            return const Center(child: Text("No trainers found."));
          }

          return ListView.builder(
            itemCount: controller.filteredTrainers.length,
            itemBuilder: (context, index) {
              var trainer = controller.filteredTrainers[index];
              return Dismissible(
                key: Key(trainer['phone'] ?? index.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  padding: const EdgeInsets.only(right: 20),
                  alignment: Alignment.centerRight,
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Confirm Delete"),
                      content: const Text("Are you sure you want to delete this trainer?"),
                      actions: [
                        TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text("Cancel")),
                        TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text("Delete")),
                      ],
                    ),
                  );
                },
                onDismissed: (direction) {
                  controller.deleteTrainer(index);
                  Get.snackbar("Deleted", "Trainer removed successfully",
                      backgroundColor: Colors.red, colorText: Colors.white);
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ExpansionTile(
                    leading: trainer['photoPath'] != null && trainer['photoPath']!.isNotEmpty
                        ? CircleAvatar(
                      radius: 30,
                      backgroundImage: FileImage(File(trainer['photoPath']!)),
                    )
                        : CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey.shade300,
                      child: const Icon(Icons.person, color: Colors.black),
                    ),
                    title: Text(
                      trainer['name'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow("Specialization", trainer['specialization']),
                            _buildInfoRow("Phone", trainer['phone']),
                            _buildInfoRow("Experience", "${trainer['experience']} years"),
                            _buildInfoRow("Course", trainer['course']),
                            _buildInfoRow("Time", "${trainer['startTime']} - ${trainer['endTime']}"),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: () => _showEditTrainerDialog(context, trainer, index),
                                icon: const Icon(Icons.edit),
                                label: const Text("Edit"),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          Flexible(
            child: Text(value ?? '', style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    final controller = Get.find<AdminTrainerListController>();
    searchController.text = controller.searchQuery.value;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Search Trainers"),
          content: TextField(
            controller: searchController,
            decoration: const InputDecoration(hintText: "Enter name, phone, specialization..."),
            autofocus: true,
            onChanged: (query) => controller.applySearch(query),
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.applySearch(searchController.text);
                Get.back();
              },
              child: const Text("Search"),
            ),
          ],
        );
      },
    );
  }

  void _showEditTrainerDialog(BuildContext context, Map<String, String> trainer, int index) {
    final controller = Get.find<AdminTrainerListController>();

    final nameController = TextEditingController(text: trainer['name']);
    final specializationController = TextEditingController(text: trainer['specialization']);
    final phoneController = TextEditingController(text: trainer['phone']);
    final experienceController = TextEditingController(text: trainer['experience']);
    final courseController = TextEditingController(text: trainer['course']);
    final startTimeController = TextEditingController(text: trainer['startTime']);
    final endTimeController = TextEditingController(text: trainer['endTime']);
    final RxString imagePath = (trainer['photoPath'] ?? '').obs;

    Future<void> pickImage() async {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
      if (pickedFile != null) {
        imagePath.value = pickedFile.path;
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Trainer"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Obx(() => GestureDetector(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage:
                    imagePath.value.isNotEmpty ? FileImage(File(imagePath.value)) : null,
                    child: imagePath.value.isEmpty
                        ? const Icon(Icons.camera_alt, size: 30, color: Colors.black)
                        : null,
                  ),
                )),
                const SizedBox(height: 15),
                TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
                TextField(controller: specializationController, decoration: const InputDecoration(labelText: "Specialization")),
                TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Phone")),
                TextField(controller: experienceController, decoration: const InputDecoration(labelText: "Experience")),
                TextField(controller: courseController, decoration: const InputDecoration(labelText: "Course")),
                TextField(controller: startTimeController, decoration: const InputDecoration(labelText: "Start Time")),
                TextField(controller: endTimeController, decoration: const InputDecoration(labelText: "End Time")),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && specializationController.text.isNotEmpty) {
                  controller.updateTrainer(index, {
                    'name': nameController.text,
                    'specialization': specializationController.text,
                    'phone': phoneController.text,
                    'experience': experienceController.text,
                    'course': courseController.text,
                    'startTime': startTimeController.text,
                    'endTime': endTimeController.text,
                    'photoPath': imagePath.value,
                  });
                  Get.back();
                } else {
                  Get.snackbar("Error", "Please fill all fields",
                      backgroundColor: Colors.red, colorText: Colors.white);
                }
              },
              child: const Text("Save Changes"),
            ),
            TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ],
        );
      },
    );
  }
}
