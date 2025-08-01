import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/admin_trainer_list_controller.dart';
import '../utils/constants/color_constants.dart';

class AdminTrainerListScreen extends StatelessWidget {
  final searchController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminTrainerListController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Trainer List", style: TextStyle(color: Colors.white)),
          backgroundColor: AppColor.APP_Color_Indigo,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              color: Colors.white,
              child: const TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black,
                indicatorColor: Colors.blue,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                tabs: [Tab(text: "Active"), Tab(text: "Inactive")],
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () => _showSearchDialog(context),
            ),
          ],
        ),
        body: Obx(() {
          final active = controller.filteredTrainers.where((t) => t['status'] == 'Active').toList();
          final inactive = controller.filteredTrainers.where((t) => t['status'] == 'Inactive').toList();
          return TabBarView(
            children: [
              _buildTrainerList(context, controller, active),
              _buildTrainerList(context, controller, inactive),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTrainerList(BuildContext context, AdminTrainerListController controller, List<Map<String, dynamic>> list) {
    if (list.isEmpty) return const Center(child: Text("No trainers found."));
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final trainer = list[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.pink.shade50,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildTrainerAvatar(trainer),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trainer['name'] ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            trainer['email'] ?? '',
                            style: const TextStyle(fontSize: 12, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: const EdgeInsets.symmetric(horizontal: 0),
                  title: const Text(
                    "More Info",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  collapsedIconColor: Colors.black,
                  iconColor: Colors.black,
                  children: [
                    const SizedBox(height: 2),
                    _info("Phone", trainer['phone']),
                    _info("WhatsApp", trainer['whatsapp']),
                    _info("Emergency Contact", trainer['emergency']),
                    _info("Experience", "${trainer['experience']} years"),
                    _info("Gender", trainer['gender']),
                    _info("Salary", "₹${trainer['salary']}"),
                    _info("Joined", trainer['joining_Date']),
                    if ((trainer['availability']?['Morning'] ?? '').toString().isNotEmpty)
                      _info("Morning Availability", trainer['availability']['Morning']),
                    if ((trainer['availability']?['Evening'] ?? '').toString().isNotEmpty)
                      _info("Evening Availability", trainer['availability']['Evening']),
                    _info("Courses", (trainer['courses'] as List).join(', ')),
                    _info("Description", trainer['description']),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: () => _showEditTrainerDialog(context, trainer, index, controller),
                        icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                        label: const Text("Edit", style: TextStyle(fontSize: 13, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrainerAvatar(Map<String, dynamic> trainer) {
    return CircleAvatar(
      radius: 24,
      backgroundImage: _getTrainerImage(trainer['photoPath']),
      child: trainer['photoPath'] == null || trainer['photoPath'].toString().isEmpty
          ? const Icon(Icons.person, size: 24, color: Colors.white)
          : null,
    );
  }

  ImageProvider? _getTrainerImage(String? photoPath) {
    if (photoPath != null && photoPath.isNotEmpty) {
      try {
        final bytes = base64Decode(photoPath);
        return MemoryImage(bytes);
      } catch (e) {
        // Handle decoding errors, fallback to default image
        return null;
      }
    }
    return null; // Return default image if no photoPath or error occurs
  }

  Widget _info(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Expanded(child: Text(value ?? '-', style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    final controller = Get.find<AdminTrainerListController>();
    searchController.text = controller.searchQuery.value;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Search Trainers"),
        content: TextField(
          controller: searchController,
          decoration: const InputDecoration(hintText: "Search by name, phone, etc."),
          onChanged: controller.applySearch,
          autofocus: true,
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
      ),
    );
  }

  void _showEditTrainerDialog(BuildContext context, Map<String, dynamic> trainer, int index, AdminTrainerListController controller) {
    final nameController = TextEditingController(text: trainer['name']);
    final emailController = TextEditingController(text: trainer['email']);
    final phoneController = TextEditingController(text: trainer['phone']);
    final whatsappController = TextEditingController(text: trainer['whatsapp']);
    final emergencyController = TextEditingController(text: trainer['emergency']);
    final experienceController = TextEditingController(text: trainer['experience']);
    final genderController = TextEditingController(text: trainer['gender']);
    final salaryController = TextEditingController(text: trainer['salary']);
    final descriptionController = TextEditingController(text: trainer['description']);
    final joiningDateController = TextEditingController(text: trainer['joining_Date']);
    final RxString imagePath = RxString(trainer['photoPath'] ?? '');
    final RxList<String> selectedCourses = RxList<String>.from(trainer['courses'] ?? []);

    Future<void> pickImage() async {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) imagePath.value = picked.path;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        scrollable: true,
        title: const Text("Edit Trainer"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() => GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: imagePath.value.isNotEmpty ? FileImage(File(imagePath.value)) : null,
                  child: imagePath.value.isEmpty ? const Icon(Icons.camera_alt) : null,
                ),
              )),
              const SizedBox(height: 10),
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
              TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Phone")),
              TextField(controller: whatsappController, decoration: const InputDecoration(labelText: "WhatsApp")),
              TextField(controller: emergencyController, decoration: const InputDecoration(labelText: "Emergency Contact")),
              TextField(controller: experienceController, decoration: const InputDecoration(labelText: "Experience")),
              TextField(controller: genderController, decoration: const InputDecoration(labelText: "Gender")),
              TextField(controller: salaryController, decoration: const InputDecoration(labelText: "Salary")),
              TextField(controller: joiningDateController, decoration: const InputDecoration(labelText: "Joining Date")),
              TextField(controller: descriptionController, decoration: const InputDecoration(labelText: "Description")),
              const Divider(),
              const Text("Courses", style: TextStyle(fontWeight: FontWeight.bold)),
              ...["Yoga", "Zumba", "Cardio", "Strength Training"].map((course) {
                return Obx(() => CheckboxListTile(
                  value: selectedCourses.contains(course),
                  title: Text(course),
                  onChanged: (val) {
                    if (val == true && !selectedCourses.contains(course)) selectedCourses.add(course);
                    else selectedCourses.remove(course);
                  },
                ));
              }).toList(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.updateTrainer(index, {
                ...trainer,
                'name': nameController.text,
                'email': emailController.text,
                'phone': phoneController.text,
                'whatsapp': whatsappController.text,
                'emergency': emergencyController.text,
                'experience': experienceController.text,
                'gender': genderController.text,
                'salary': salaryController.text,
                'joining_Date': joiningDateController.text,
                'description': descriptionController.text,
                'photoPath': imagePath.value,
                'courses': selectedCourses.toList(),
              });
              Get.back();
              Get.snackbar("Updated", "Trainer updated successfully",
                backgroundColor: Colors.green, colorText: Colors.white,
              );
            },
            child: const Text("Save"),
          ),
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
        ],
      ),
    );
  }
}
