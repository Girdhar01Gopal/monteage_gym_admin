import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class GymProfileController extends GetxController {
  final _storage = GetStorage();
  final profile = <String, dynamic>{}.obs;  // Reactive profile data
  final picker = ImagePicker();

  late String gymId;
  late String gymName;

  @override
  void onInit() {
    super.onInit();

    // Read gymId and gymName from GetStorage
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
    print("Fetching profile data from: $url");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("API Response Data: $data");

        if (data['statuscode'] == 200 && data['data'] != null && data['data'].isNotEmpty) {
          // Correctly wrap the data
          profile.value = {'data': List<Map<String, dynamic>>.from(data['data'])};
          print("Profile data updated: ${profile.value}");
        } else {
          Get.snackbar("Error", "Failed to load gym profile", backgroundColor: Colors.red, colorText: Colors.white);
        }

      } else {
        Get.snackbar("Error", "Failed to load data with status code: ${response.statusCode}", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Save the profile data to local storage
  void saveProfile() {
    _saveToStorage(); // Save locally after updating
  }

  // Save the profile to storage
  void _saveToStorage() {
    _storage.write('gym_profile', profile);
  }

  // Pick a logo image from camera or gallery
  Future<void> pickLogoImage({required ImageSource source}) async {
    final picked = await picker.pickImage(source: source, imageQuality: 80);
    if (picked != null) {
      profile['logo'] = picked.path;
      _saveToStorage(); // Save after picking the new image
    }
    Get.back(); // Close bottom sheet
  }

  // Update gym profile using the POST API
  Future<void> updateGymProfile() async {
    final url = Uri.parse("https://montgymapi.eduagentapp.com/api/MonteageGymApp/UpdateGymProfile");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "ID": gymId,
          "GymName": profile['gymName'],
          "PersonName": profile['ownerName'],
          "ContactNo": profile['contact'],
          "Address": profile['address'],
          "City": profile['city'],
          "State": profile['state'],
          "Pin": profile['pincode'],
          "GymContactNo": profile['contact'],
          "EmailId": profile['email'],
          "Websiteurl": profile['website'],
          "UpdateBy": gymId,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['statuscode'] == 200) {
        _storage.write('gym_profile', profile); // Save updated data
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
