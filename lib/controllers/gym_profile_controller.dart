import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class GymProfileController extends GetxController {
  final _storage = GetStorage();
  final profile = <String, dynamic>{}.obs;
  final picker = ImagePicker();

  late String gymId;
  late String gymName;

  @override
  void onInit() {
    super.onInit();
    gymId = _storage.read('gymId')?.toString() ?? "0";
    gymName = _storage.read('gymName')?.toString() ?? "Unknown Gym";

    if (gymId == "0") {
      Get.snackbar("Error", "Invalid Gym ID. Please login again.",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final url = Uri.parse('https://montgymapi.eduagentapp.com/api/MonteageGymApp/GymProfile/1/$gymId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['statuscode'] == 200 && data['data'] != null && (data['data'] as List).isNotEmpty) {
          profile.value = {'data': List<Map<String, dynamic>>.from(data['data'])};
        } else {
          Get.snackbar("Error", "Failed to load gym profile",
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        Get.snackbar("Error", "Failed to load data (HTTP ${response.statusCode})",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Save the profile data to local storage
  void _saveToStorage() {
    _storage.write('gym_profile', profile);
  }

  // Pick a logo image from camera or gallery
  Future<void> pickLogoImage({required ImageSource source}) async {
    final picked = await picker.pickImage(source: source, imageQuality: 80);
    if (picked != null) {
      final map = _ensureDataMap();
      map['logo'] = picked.path;
      profile.value = {'data': [map]};
      _saveToStorage();
    }
    Get.back(); // Close sheet/dialog if any
  }

  Map<String, dynamic> _ensureDataMap() {
    final list = profile['data'] as List<dynamic>?;
    if (list != null && list.isNotEmpty && list.first is Map<String, dynamic>) {
      return Map<String, dynamic>.from(list.first as Map);
    }
    // start blank if missing
    return <String, dynamic>{'ID': gymId};
  }

  /// Update gym profile using the POST API
  Future<void> updateGymProfile() async {
    final map = _ensureDataMap();

    final url = Uri.parse("https://montgymapi.eduagentapp.com/api/MonteageGymApp/UpdateGymProfile");

    // Construct payload exactly as backend expects
    final payload = {
      "ID": map['ID']?.toString() ?? gymId,
      "GymName": map['GymName']?.toString() ?? "",
      "PersonName": map['PersonName']?.toString() ?? "",
      "ContactNo": map['ContactNo']?.toString() ?? "",
      "Address": map['Address']?.toString() ?? "",
      "City": map['City']?.toString() ?? "",
      "State": map['State']?.toString() ?? "",
      "Pin": map['Pin']?.toString() ?? "",
      "GymContactNo": map['GymContactNo']?.toString() ?? "",
      "EmailId": map['EmailId']?.toString() ?? "",
      "Websiteurl": map['Websiteurl']?.toString() ?? "",
      "UpdateBy": gymId,
      // If your API supports logo/base64, add here (currently omitted)
      // "LogoBase64": <string?>
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(payload),
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200 && (data['statuscode'] == 200 || data['statuscode'] == '200')) {
        // persist
        profile.value = {'data': [map]};
        _saveToStorage();
        Get.snackbar("Success", "Profile updated successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Error", "Failed to update profile",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
