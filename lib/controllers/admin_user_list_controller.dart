import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart' hide Data;
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../models/membermodel.dart';

class AdminUserListController extends GetxController {
  final _storage = GetStorage();
  var members = <Data>[].obs;
  var filteredMembers = <Data>[].obs;
  var searchQuery = ''.obs;
  final imageFile = Rx<File?>(null);
  final expandedCardIndex = (-1).obs;
  var gymId;

  @override
  void onInit() {
    super.onInit();
    _loadGymId();
  }

  // Load the Gym ID from storage or fallback if invalid
  void _loadGymId() async {
    gymId = await _storage.read('gymId');
    if (gymId == null || gymId == 0) {
      Get.snackbar("Error", "Invalid Gym ID", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    _loadMembersFromAPI();
  }

  // Fetch members from API using Gym ID
  Future<void> _loadMembersFromAPI() async {
    final url = Uri.parse("https://montgymapi.eduagentapp.com/api/MonteageGymApp/ViewMember/$gymId");
    print("Fetching data from URL: $url");

    try {
      final response = await http.get(url, headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['statuscode'] == 200) {
          members.assignAll(
            List<Data>.from(data['data'].map((v) => Data.fromJson(v))),
          );
          // Save the fetched data to local storage
          _storage.write('members', members.toList());
        } else {
          Get.snackbar("Error", "Failed to load members", backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        Get.snackbar("Error", "Failed to fetch members from server", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e", backgroundColor: Colors.red, colorText: Colors.white);
    }

    // Update the filtered list after loading the data, filtering based on 'Action'
    filteredMembers.assignAll(members);
  }

  // Add a new member to the Active list
  void addMember(Data newMember) {
    newMember.action = "Active";  // Ensure the new member is added as Active
    members.add(newMember);  // Add to the list
    filteredMembers.assignAll(members);  // Update the filtered list to include the new member
  }

  void saveMembers() {
    _storage.write('members', members.toList());  // Save updated list to local storage
  }

  // Filter members by name, email, or phone
  void filterMembers(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredMembers.assignAll(members);
    } else {
      final lower = query.toLowerCase();
      filteredMembers.assignAll(members.where((member) {
        return member.name!.toLowerCase().contains(lower) ||
            member.emailid!.toLowerCase().contains(lower) ||
            member.phone!.toLowerCase().contains(lower);
      }).toList());
    }
  }

  // Toggle card expansion
  void toggleCardExpansion(int index) {
    expandedCardIndex.value = (expandedCardIndex.value == index) ? -1 : index;
  }

  // Delete a member from the list
  void deleteMember(int index) {
    members.removeAt(index);  // Remove member from list
    saveMembers();  // Save the updated list to storage
    filterMembers(searchQuery.value);  // Reapply filter (if any)
    Get.snackbar("Deleted", "Member removed", backgroundColor: Colors.red, colorText: Colors.white);
  }

  // Confirm deletion of a member
  void deleteMemberWithConfirmation(int index) {
    Get.defaultDialog(
      title: "Confirm Deletion",
      middleText: "Are you sure you want to delete this member?",
      textCancel: "No",
      textConfirm: "Yes",
      confirmTextColor: Colors.white,
      onConfirm: () {
        deleteMember(index);
        Get.back();
      },
    );
  }

  // Show image picker options (Camera/Gallery)
  void showImagePickerOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () => _pickImage(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Gallery"),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  // Pick an image (either from camera or gallery)
  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source, imageQuality: 80);
    if (picked != null) {
      imageFile.value = File(picked.path);
    }
    Get.back();
  }
}
