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

  // Store trainer assignment by a stable member key
  final assignedTrainerKeys = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _restoreAssignedState();
    _loadGymId();
  }

  void _restoreAssignedState() {
    final saved = _storage.read<List>('assignedTrainerKeys') ?? [];
    assignedTrainerKeys.addAll(saved.map((e) => e.toString()));
  }

  void _persistAssignedState() {
    _storage.write('assignedTrainerKeys', assignedTrainerKeys.toList());
  }

  /// Generate a stable key for a member without using `id`
  String _memberKey(Data m) {
    String lc(String? s) => (s ?? '').trim().toLowerCase();
    final phone = lc(m.phone);
    final email = lc(m.emailid);
    final name = lc(m.name);
    final join = (m.joiningDate ?? '').trim();

    if (phone.isNotEmpty) return 'phone:$phone|join:$join';
    if (email.isNotEmpty) return 'email:$email|join:$join';
    return 'name:$name|join:$join';
  }

  void _loadGymId() async {
    gymId = await _storage.read('gymId');
    if (gymId == null || gymId == 0) {
      Get.snackbar("Error", "Invalid Gym ID", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    _loadMembersFromAPI();
  }

  Future<void> _loadMembersFromAPI() async {
    final url = Uri.parse("https://montgymapi.eduagentapp.com/api/MonteageGymApp/ViewMember/$gymId");

    try {
      final response = await http.get(url, headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['statuscode'] == 200) {
          members.assignAll(
            List<Data>.from(
              data['data'].map((v) {
                final member = Data.fromJson(v);
                member.name = capitalizeFirst(member.name ?? "");
                return member;
              }),
            ),
          );
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

    filteredMembers.assignAll(members);
  }

  void addMember(Data newMember) {
    newMember.action = "Active";
    newMember.name = capitalizeFirst(newMember.name ?? "");
    members.add(newMember);
    filteredMembers.assignAll(members);
    _storage.write('members', members.toList());
  }

  void saveMembers() {
    _storage.write('members', members.toList());
  }

  void filterMembers(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredMembers.assignAll(members);
    } else {
      final lower = query.toLowerCase();
      filteredMembers.assignAll(members.where((member) {
        final name = member.name ?? '';
        final email = member.emailid ?? '';
        final phone = member.phone ?? '';
        return name.toLowerCase().contains(lower) ||
            email.toLowerCase().contains(lower) ||
            phone.toLowerCase().contains(lower);
      }).toList());
    }
  }

  void toggleCardExpansion(int index) {
    expandedCardIndex.value = (expandedCardIndex.value == index) ? -1 : index;
  }

  void deleteMember(int index) {
    final m = members[index];
    final key = _memberKey(m);

    members.removeAt(index);
    saveMembers();

    assignedTrainerKeys.remove(key);
    _persistAssignedState();

    filterMembers(searchQuery.value);
    Get.snackbar("Deleted", "Member removed", backgroundColor: Colors.red, colorText: Colors.white);
  }

  // ---------- Trainer assignment ----------
  bool isTrainerAssignedForMember(Data member) {
    return assignedTrainerKeys.contains(_memberKey(member));
  }

  void markTrainerAssignedForMember(Data member) {
    assignedTrainerKeys.add(_memberKey(member));
    _persistAssignedState();
  }

  // ---------- Image helpers ----------
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

  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source, imageQuality: 80);
    if (picked != null) {
      imageFile.value = File(picked.path);
    }
    Get.back();
  }

  // ---------- Helpers ----------
  // Height is saved as feet, no conversion needed.
  String heightInFeet(String? feetStr) => feetStr?.trim() ?? "";

  String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
