import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class AddMemberController extends GetxController {
  final nameController = TextEditingController();
  final fatherController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final whatsappController = TextEditingController();
  final emergencyController = TextEditingController();
  final addressController = TextEditingController();

  // Height now entered in FEET on the UI
  final heightController = TextEditingController();

  final weightController = TextEditingController();
  final joinDateController = TextEditingController();
  final discountController = TextEditingController();
  final planAmountController = TextEditingController();
  final nextFeeDateController = TextEditingController();
  final packageExpiryController = TextEditingController();

  final selectedPlan = ''.obs;
  final selectedPlanPrice = 0.obs; // Store the selected plan's price
  var gymid;
  final selectedGender = 'Male'.obs;
  final selectedTrainer = 'Personal Trainer'.obs;

  final isSameAsPhone = false.obs;

  final profileImage = Rx<File?>(null);
  final box = GetStorage();

  final RxList plans = [].obs;
  final isLoading = false.obs;

  // Restrict name to letters and spaces only
  final nameFormatter = FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'));

  // Restrict phone, whatsapp, and emergency to 10 digits only
  final phoneFormatter = FilteringTextInputFormatter.digitsOnly;
  final whatsappFormatter = FilteringTextInputFormatter.digitsOnly;
  final emergencyFormatter = FilteringTextInputFormatter.digitsOnly;

  @override
  void onInit() async {
    super.onInit();
    gymid = await box.read('gymId');
    if (gymid == null || gymid == 0) {
      Get.snackbar("Error", "Invalid Gym ID", backgroundColor: Colors.red, colorText: Colors.white);
    }

    await fetchGymPlans();

    if (selectedPlan.value.isNotEmpty) {
      selectedPlan.value = selectedPlan.value; // retrigger price update
    }

    selectedPlan.listen((plan) {
      final selectedPlanData = plans.firstWhere(
            (element) => element['PlanTittle'] == plan,
        orElse: () => null,
      );
      if (selectedPlanData != null) {
        selectedPlanPrice.value = selectedPlanData['Price'];
        planAmountController.text = selectedPlanPrice.value.toString();
        _updateNextFeeDate(plan);
      }
    });

    phoneController.addListener(() {
      if (isSameAsPhone.value) {
        whatsappController.text = phoneController.text;
      }
    });

    isSameAsPhone.listen((isChecked) {
      if (isChecked) {
        whatsappController.text = phoneController.text;
      }
    });
  }

  // Fetch gym plans
  Future<void> fetchGymPlans() async {
    try {
      final response = await http.get(
        Uri.parse("https://montgymapi.eduagentapp.com/api/MonteageGymApp/PlanBind/$gymid"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['statuscode'] == 200) {
          plans.clear();
          plans.addAll(data['data']);
        } else {
          Get.snackbar("Error", "Failed to fetch gym plans", backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        Get.snackbar("Error", "Failed to connect to the server", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred while fetching plans: $e", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Update next fee date based on selected plan
  void _updateNextFeeDate(String selectedPlan) {
    DateTime currentDate = DateTime.now();
    DateTime nextFeeDate;

    switch (selectedPlan) {
      case 'Platinum':
        nextFeeDate = currentDate.add(const Duration(days: 90));
        break;
      case 'Gold':
        nextFeeDate = currentDate.add(const Duration(days: 60));
        break;
      case 'Silver':
        nextFeeDate = currentDate.add(const Duration(days: 30));
        break;
      default:
        nextFeeDate = currentDate;
        break;
    }

    nextFeeDateController.text = DateFormat('yyyy-MM-dd').format(nextFeeDate);
  }

  // Date picker for Join / NextFee / Expiry
  void pickDate(BuildContext context, TextEditingController controller, {bool isJoiningDate = false}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      controller.text = DateFormat('dd-MM-yyyy').format(picked);
      if (isJoiningDate) {
        _updatePackageExpiryDate(picked);
      }
    }
  }

  // Update package expiry based on selected plan and joining date
  void _updatePackageExpiryDate(DateTime joiningDate) {
    DateTime packageExpiryDate;

    switch (selectedPlan.value) {
      case 'Platinum':
        packageExpiryDate = joiningDate.add(const Duration(days: 90));
        break;
      case 'Gold':
        packageExpiryDate = joiningDate.add(const Duration(days: 60));
        break;
      case 'Silver':
        packageExpiryDate = joiningDate.add(const Duration(days: 30));
        break;
      default:
        packageExpiryDate = joiningDate;
        break;
    }

    packageExpiryController.text = DateFormat('dd-MM-yyyy').format(packageExpiryDate);
  }

  // Add member
  Future<void> addMemberAPI(
      String name,
      int planid,
      String fathername,
      String emailid,
      String phone,
      String whatsppno,
      String emergencyno,
      String address,
      String heightFeet, // height entered in FEET (string)
      String weight,
      String gender,
      String Price,
      String discount,
      String joining,
      String packgeexpiry,
      var gymid,
      String credit, // creator/admin id
      String imageBase64, // kept for future use if backend supports
      ) async {
    if (isLoading.value) return;
    isLoading.value = true;

    Get.snackbar(
      "Success",
      "Adding member, please wait...",
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
      duration: const Duration(seconds: 1),
    );

    if (name.isEmpty || phone.isEmpty) {
      Get.snackbar("Error", "Name and Phone are required fields.", backgroundColor: Colors.red, colorText: Colors.white);
      isLoading.value = false;
      return;
    }

    // Convert FEET → CM before sending to API
    final double heightFt = double.tryParse(heightFeet.trim()) ?? 0.0;
    final String heightInCm = (heightFt * 30.48).toStringAsFixed(2);

    final member = {
      'Name': name,
      'PlanId': planid.toString(),
      'FatherName': fathername,
      'Emailid': emailid,
      'Phone': phone,
      'WhatsappNo': whatsppno,
      'EmergencyNo': emergencyno,
      'Address': address,
      'Height': heightInCm,
      'Weight': weight,
      'Gender': gender,
      'Price': Price,
      'Discount': discount,
      'JoiningDate': joining,
      'PackageExpiryDate': packgeexpiry,
      'GymeId': gymid.toString(),
      'CreateBy': credit.toString(),
    };

    try {
      final response = await http.post(
        Uri.parse("https://montgymapi.eduagentapp.com/api/MonteageGymApp/MemberPost"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(member),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['statuscode'] == 200) {
          Get.snackbar("Success", "Member added successfully!", backgroundColor: Colors.green, colorText: Colors.white, snackPosition: SnackPosition.TOP);
          Get.back();
        } else {
          Get.snackbar("Error", data['message'] ?? "Failed to add member", backgroundColor: Colors.red, colorText: Colors.white);
        }
      } else {
        Get.snackbar("Error", "Failed to communicate with the server", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}


// Method to pick a date and set it in the given controller
  void pickDate(BuildContext context, TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      // Format the date as yyyy-MM-dd and assign it to the controller
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

