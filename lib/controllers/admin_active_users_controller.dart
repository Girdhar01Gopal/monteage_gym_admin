import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AdminActiveUsersController extends GetxController {
  var users = <Map<String, dynamic>>[].obs;
  var filteredUsers = <Map<String, dynamic>>[].obs;
  var imageFile = Rx<File?>(null);

  final expandedCardIndex = RxnInt(); // 🔸 To track expanded card

  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final joinDateController = TextEditingController();
  final discountController = TextEditingController();
  final paymentController = TextEditingController();
  final nextFeeDateController = TextEditingController();
  final expiryDateController = TextEditingController();

  // Dropdown selections
  final gender = ''.obs;
  final trainerType = ''.obs;
  final trainerGender = ''.obs;
  final plan = ''.obs;

  int? editingIndex;

  @override
  void onInit() {
    super.onInit();
    _loadSampleUsers();
  }

  void _loadSampleUsers() {
    users.assignAll([
      {
        'name': 'Amit Sharma',
        'email': 'amit@example.com',
        'phone': '9876543210',
        'address': 'Delhi',
        'height': '175',
        'weight': '70',
        'gender': 'Male',
        'trainer': 'Personal Trainer',
        'trainer_gender': 'Male',
        'plan': 'Gold',
        'joining_date': '01 July 2025',
        'discount': '10',
        'payment': '5000',
        'next_fee_date': '01 Oct 2025',
        'expiry_date': '30 Sep 2025',
        'avatar': 'assets/images/person.png',
        'status': 'Active',
        'session_time': 'Morning',
      },
      {
        'name': 'Priya Sen',
        'email': 'priya@example.com',
        'phone': '9898989898',
        'address': 'Mumbai',
        'height': '160',
        'weight': '58',
        'gender': 'Female',
        'trainer': 'General Trainer',
        'trainer_gender': 'Female',
        'plan': 'Platinum',
        'joining_date': '15 June 2025',
        'discount': '5',
        'payment': '6000',
        'next_fee_date': '15 Sep 2025',
        'expiry_date': '14 Sep 2025',
        'avatar': 'assets/images/person.png',
        'status': 'Active',
        'session_time': 'Evening',
      },
      {
        'name': 'Ravi Patel',
        'email': 'ravi@example.com',
        'phone': '9123456789',
        'address': 'Ahmedabad',
        'height': '172',
        'weight': '68',
        'gender': 'Male',
        'trainer': 'Personal Trainer',
        'trainer_gender': 'Male',
        'plan': 'Silver',
        'joining_date': '20 May 2025',
        'discount': '0',
        'payment': '4000',
        'next_fee_date': '20 Aug 2025',
        'expiry_date': '19 Aug 2025',
        'avatar': 'assets/images/person.png',
        'status': 'Active',
        'session_time': 'Morning',
      },
      {
        'name': 'Neha Mehta',
        'email': 'neha@example.com',
        'phone': '9871122334',
        'address': 'Bangalore',
        'height': '158',
        'weight': '54',
        'gender': 'Female',
        'trainer': 'General Trainer',
        'trainer_gender': 'Female',
        'plan': 'Gold',
        'joining_date': '10 April 2025',
        'discount': '15',
        'payment': '5500',
        'next_fee_date': '10 July 2025',
        'expiry_date': '09 July 2025',
        'avatar': 'assets/images/person.png',
        'status': 'Active',
        'session_time': 'Evening',
      },
    ]);
    filteredUsers.assignAll(users);
  }

  void filterUsers(String query) {
    if (query.isEmpty) {
      filteredUsers.assignAll(users);
    } else {
      final lower = query.toLowerCase();
      filteredUsers.assignAll(users.where((user) {
        final name = user['name'].toString().toLowerCase();
        final email = user['email'].toString().toLowerCase();
        final phone = user['phone'].toString().toLowerCase();
        return name.contains(lower) || email.contains(lower) || phone.contains(lower);
      }).toList());
    }
  }

  void toggleCardExpansion(int index) {
    expandedCardIndex.value = expandedCardIndex.value == index ? null : index;
  }

  void populateFields(Map<String, dynamic> user, int index) {
    editingIndex = index;
    nameController.text = user['name'];
    emailController.text = user['email'];
    phoneController.text = user['phone'];
    addressController.text = user['address'];
    heightController.text = user['height'];
    weightController.text = user['weight'];
    joinDateController.text = user['joining_date'];
    discountController.text = user['discount'];
    paymentController.text = user['payment'];
    nextFeeDateController.text = user['next_fee_date'];
    expiryDateController.text = user['expiry_date'];
    gender.value = user['gender'];
    trainerType.value = user['trainer'];
    trainerGender.value = user['trainer_gender'];
    plan.value = user['plan'];
    imageFile.value = null;
  }

  void updateUser() {
    if (editingIndex != null && editingIndex! < users.length) {
      final updated = {
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'address': addressController.text,
        'height': heightController.text,
        'weight': weightController.text,
        'gender': gender.value,
        'trainer': trainerType.value,
        'trainer_gender': trainerGender.value,
        'plan': plan.value,
        'joining_date': joinDateController.text,
        'discount': discountController.text,
        'payment': paymentController.text,
        'next_fee_date': nextFeeDateController.text,
        'expiry_date': expiryDateController.text,
        'avatar': imageFile.value?.path ?? users[editingIndex!]['avatar'],
        'status': 'Active',
        'session_time': users[editingIndex!]['session_time'],
      };
      users[editingIndex!] = updated;
      filterUsers('');
      Get.back();
      Get.snackbar(
        "Updated",
        "User details saved",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 10,
      );
    }
  }

  void deleteUser(int index) {
    users.removeAt(index);
    filterUsers('');
  }

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
              onTap: () {
                _pickImage(ImageSource.camera);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Gallery"),
              onTap: () {
                _pickImage(ImageSource.gallery);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 80);
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }
}
