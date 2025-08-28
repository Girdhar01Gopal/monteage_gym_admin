import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/admin_trainer_list_controller.dart';
import '../utils/constants/color_constants.dart';
import 'package:flutter/services.dart'; // For input formatters

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

  // Build the trainer list
  Widget _buildTrainerList(BuildContext context, AdminTrainerListController controller, List<Map<String, dynamic>> list) {
    if (list.isEmpty) return const Center(child: Text("No trainers found."));

    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth > 600 ? 500 : screenWidth * 0.9;  // Adjust width based on screen size

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final trainer = list[index];
        return Obx(() {
          final isExpanded = controller.expandedCardIndex.value == index;

          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            width: cardWidth, // Use responsive width
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 6,
                  offset: const Offset(3, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row (name + email)
                  Row(
                    children: [
                      _buildTrainerAvatar(trainer),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name (highlight)
                            Text(
                              trainer['name'] ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18, // Increased size
                                color: Colors.black, // Dark green color
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            // 👇 NEW: Email below the name
                            Text(
                              trainer['email'] ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // ===== ExpansionTile starts (replaces static sections) =====
                  ExpansionTile(
                    initiallyExpanded: isExpanded,
                    onExpansionChanged: (expanded) {
                      controller.expandedCardIndex.value = expanded ? index : -1;
                    },
                    tilePadding: EdgeInsets.zero,
                    collapsedIconColor: Colors.black,
                    iconColor: Colors.black,
                    title: const SizedBox.shrink(), // No "More Info" text
                    children: [
                      // Personal Info Section
                      _infoSection("Personal Info", [
                        _info("Name", trainer['name']),
                        _info("Email", trainer['email']),
                        _info("Phone", trainer['phone']),
                        _info("WhatsApp", trainer['whatsapp']),
                        _info("Emergency Contact", trainer['emergency']),
                        _info("Salary", "₹${trainer['salary']}"),
                      ]),
                      const Divider(),

                      // Experience and Availability Section
                      _infoSection("Experience & Others", [
                        _info("Experience", "${trainer['experience']} years"),
                        _info("Gender", trainer['gender']),
                        _info("Joined", formatDate(trainer['joining_Date'])), // Apply date formatting here
                        _info("Courses", (trainer['courses'] as List).join(', ')),
                      ]),
                      const Divider(),

                      // Start Time and End Time Section
                      _infoSection("Availability", [
                        _info("Start Time", formatDate(trainer['start_time'])), // Apply date formatting here
                        _info("End Time", formatDate(trainer['end_time'])), // Apply date formatting here
                      ]),
                      const Divider(),

                      // Description Section
                      _infoSection("Description", [
                        _info("Details", trainer['description']),
                      ]),
                      const SizedBox(height: 12),

                      // Edit button
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: () => _showEditTrainerDialog(context, trainer, index, controller),
                          icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                          label: const Text("Edit", style: TextStyle(fontSize: 13, color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // ===== ExpansionTile ends =====
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildTrainerAvatar(Map<String, dynamic> trainer) {
    return CircleAvatar(
      radius: 28, // Smaller avatar size
      backgroundImage: _getTrainerImage(trainer['photoPath']),
      child: trainer['photoPath'] == null || trainer['photoPath'].toString().isEmpty
          ? const Icon(Icons.person, size: 28, color: Colors.black)
          : null,
    );
  }

  ImageProvider? _getTrainerImage(String? photoPath) {
    if (photoPath != null && photoPath.isNotEmpty) {
      try {
        final bytes = base64Decode(photoPath);
        return MemoryImage(bytes);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Function to create info sections with bold and highlight
  Widget _infoSection(String heading, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: const TextStyle(
            fontWeight: FontWeight.bold, // Make it bold
            fontSize: 18, // Increased font size
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        ...items,
      ],
    );
  }

  // Function to create individual info fields
  Widget _info(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Expanded(
            child: Text(
              value ?? '-',
              style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
            ),
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

  // Format date as dd-mm-yyyy
  String formatDate(String dateStr) {
    try {
      final dateTime = DateTime.parse(dateStr);
      return "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}";
    } catch (e) {
      return dateStr; // Return the original string if parsing fails
    }
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
    final startTimeController = TextEditingController(text: trainer['start_time']);
    final endTimeController = TextEditingController(text: trainer['end_time']);

    final RxString imagePath = RxString(trainer['photoPath'] ?? '');
    final RxList<String> selectedCourses = RxList<String>.from(trainer['courses'] ?? []);

    Future<void> pickImage() async {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) imagePath.value = picked.path;
    }

    Future<void> pickTime(TextEditingController ctrl) async {
      final pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (pickedTime != null) ctrl.text = pickedTime.format(context);
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
              const SizedBox(height: 15),
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              TextField(
                controller: whatsappController,
                decoration: const InputDecoration(labelText: "WhatsApp"),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              TextField(
                controller: emergencyController,
                decoration: const InputDecoration(labelText: "Emergency Contact"),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              TextField(controller: experienceController, decoration: const InputDecoration(labelText: "Experience")),
              TextField(controller: genderController, decoration: const InputDecoration(labelText: "Gender")),
              TextField(controller: salaryController, decoration: const InputDecoration(labelText: "Salary")),
              TextField(controller: joiningDateController, decoration: const InputDecoration(labelText: "Joining Date")),
              // Start & End Time
              TextField(
                controller: startTimeController,
                readOnly: true,
                decoration: const InputDecoration(labelText: "Start Time"),
                onTap: () => pickTime(startTimeController),
              ),
              TextField(
                controller: endTimeController,
                readOnly: true,
                decoration: const InputDecoration(labelText: "End Time"),
                onTap: () => pickTime(endTimeController),
              ),
              TextField(controller: descriptionController, decoration: const InputDecoration(labelText: "Description")),
              const Divider(),
              const Text("Courses", style: TextStyle(fontWeight: FontWeight.bold)),
              ...["Yoga", "Zumba", "Cardio", "Strength Training"].map((course) {
                return Obx(() => CheckboxListTile(
                  value: selectedCourses.contains(course),
                  title: Text(course),
                  onChanged: (val) {
                    if (val == true && !selectedCourses.contains(course)) {
                      selectedCourses.add(course);
                    } else {
                      selectedCourses.remove(course);
                    }
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
                'start_time': startTimeController.text,
                'end_time': endTimeController.text,
                'description': descriptionController.text,
                'photoPath': imagePath.value,
                'courses': selectedCourses.toList(),
              });
              Get.back();
              Get.snackbar(
                "Updated",
                "Trainer updated successfully",
                backgroundColor: Colors.green,
                colorText: Colors.white,
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
