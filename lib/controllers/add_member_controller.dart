import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddMemberController extends GetxController {
  // Controllers for the input fields
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final joinDateController = TextEditingController();
  final discountController = TextEditingController();
  final nextFeeDateController = TextEditingController();
  final packageExpiryController = TextEditingController();

  // Observable values for dropdown selections
  final selectedPlan = 'Platinum'.obs;
  final selectedGender = 'Male'.obs;  // Member's gender
  final selectedTrainer = 'Personal Trainer'.obs;
  final selectedTrainerGender = 'Male'.obs; // Gender of the selected trainer
  final profileImage = Rx<File?>(null);

  // List to store active users
  final activeUsers = <Map<String, dynamic>>[].obs;

  // Method to add the member to the active users list
  void addMember() {
    if (_areFieldsValid()) {
      final formattedJoinDate = joinDateController.text;
      final formattedFeeDate = nextFeeDateController.text;
      final formattedExpiry = packageExpiryController.text;

      // Add new member data
      activeUsers.add({
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'address': addressController.text,
        'plan': selectedPlan.value,
        'gender': selectedGender.value,
        'trainer': selectedTrainer.value,
        'trainer_gender': selectedTrainerGender.value,
        'join_date': formattedJoinDate,
        'discount': discountController.text,
        'next_fee_date': formattedFeeDate,
        'expiry_date': formattedExpiry,
        'avatar': profileImage.value?.path ?? 'assets/images/person.png',
        'status': 'Active',
      });

      // Clear fields after submission
      _clearFields();
      Get.snackbar("Success", "Member added successfully!",
          backgroundColor: Colors.green, colorText: Colors.white);
      Get.back();
    } else {
      Get.snackbar("Error", "Please fill in all the fields",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Validation method to ensure no fields are empty
  bool _areFieldsValid() {
    return nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        joinDateController.text.isNotEmpty &&
        nextFeeDateController.text.isNotEmpty &&
        packageExpiryController.text.isNotEmpty;
  }

  // Clear all input fields after a successful submission
  void _clearFields() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    addressController.clear();
    joinDateController.clear();
    discountController.clear();
    nextFeeDateController.clear();
    packageExpiryController.clear();
    profileImage.value = null;
  }

  // Pick image from gallery and set it in the profile
  Future<void> pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
    }
  }

  // Pick date and automatically update expiry date based on the join date
  void pickDate(BuildContext context, TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
      _updatePackageExpiryDate(picked); // Automatically update package expiry date
    }
  }

  // Update package expiry date based on the join date (3 months after join date)
  void _updatePackageExpiryDate(DateTime joinDate) {
    DateTime expiryDate = joinDate.add(Duration(days: 90));  // 3 Months expiry

    packageExpiryController.text = DateFormat('yyyy-MM-dd').format(expiryDate);
  }
}
