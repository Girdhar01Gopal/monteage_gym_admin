import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AddMemberController extends GetxController {
  final nameController = TextEditingController();
  final fatherController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final whatsappController = TextEditingController();
  final emergencyController = TextEditingController();
  final addressController = TextEditingController();
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

  final isSameAsPhone = false.obs; // NEW

  final profileImage = Rx<File?>(null);

  final box = GetStorage(); // Store for GymId and AdminId

  final RxList plans = [].obs; // To hold fetched plans

  final isLoading = false.obs; // NEW - Track loading state

  @override
  void onInit() async {
    super.onInit();
    gymid = await box.read('gymId');  // Retrieve Gym ID from GetStorage
    if (gymid == null || gymid == 0) {
      Get.snackbar("Error", "Invalid Gym ID", backgroundColor: Colors.red, colorText: Colors.white);
    }

    // Fetch gym plans from API
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
        _updateNextFeeDate(plan);  // Only update next fee payment date here
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

  // Function to fetch gym plans from the server
  Future<void> fetchGymPlans() async {
    try {
      final response = await http.get(
        Uri.parse("https://montgymapi.eduagentapp.com/api/MonteageGymApp/PlanBind/$gymid"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['statuscode'] == 200) {
          plans.clear(); // Clear any previous data
          plans.addAll(data['data']); // Add the new data
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

  // Function to update next fee payment date based on selected plan
  void _updateNextFeeDate(String selectedPlan) {
    DateTime currentDate = DateTime.now();
    DateTime nextFeeDate;

    switch (selectedPlan) {
      case 'Platinum':
        nextFeeDate = currentDate.add(Duration(days: 90)); // 1 month later
        break;
      case 'Gold':
        nextFeeDate = currentDate.add(Duration(days: 60)); // 1 month later
        break;
      case 'Silver':
        nextFeeDate = currentDate.add(Duration(days: 30)); // 1 month later
        break;
      default:
        nextFeeDate = currentDate;
        break;
    }

    nextFeeDateController.text = DateFormat('yyyy-MM-dd').format(nextFeeDate);
  }

  // Function to handle the date picking logic for Joining Date and Package Expiry Date
  void pickDate(BuildContext context, TextEditingController controller, {bool isJoiningDate = false}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      // Format the date as yyyy-MM-dd and assign it to the controller
      controller.text = DateFormat('yyyy-MM-dd').format(picked);

      // If it's the joining date, set the package expiry date accordingly
      if (isJoiningDate) {
        _updatePackageExpiryDate(picked);
      }
    }
  }

  // Function to update the Package Expiry Date based on the selected plan and Joining Date
  void _updatePackageExpiryDate(DateTime joiningDate) {
    DateTime packageExpiryDate;

    switch (selectedPlan.value) {
      case 'Platinum':
        packageExpiryDate = joiningDate.add(Duration(days: 90)); // 3 months later
        break;
      case 'Gold':
        packageExpiryDate = joiningDate.add(Duration(days: 60)); // 2 months later
        break;
      case 'Silver':
        packageExpiryDate = joiningDate.add(Duration(days: 30)); // 1 month later
        break;
      default:
        packageExpiryDate = joiningDate;
        break;
    }

    packageExpiryController.text = DateFormat('yyyy-MM-dd').format(packageExpiryDate);
  }

  // Function to add member data to the server
  Future<void> addMemberAPI(
      String name,
      int planid,
      String fathername,
      String emailid,
      String phone,
      String whatsppno,
      String emergencyno,
      String address,
      String height,
      String weight,
      String gender,
      String Price,
      String discount,
      String joining,
      String packgeexpiry,
      var gymid,
      String credit, String string, // Admin ID as a string
      ) async {
    // Prevent multiple clicks
    if (isLoading.value) {
      return; // If the request is in progress, return early
    }
    isLoading.value = true; // Start loading

    // Show success snackbar immediately after the button click
    Get.snackbar(
      "Success",
      "Adding member, please wait...",
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
      duration: Duration(seconds: 1), // This will show for 1 second before the actual success message
    );

    // Validate the form fields
    if (name.isEmpty || phone.isEmpty) {
      Get.snackbar("Error", "Name and Phone are required fields.",
          backgroundColor: Colors.red, colorText: Colors.white);
      isLoading.value = false;
      return;
    }

    final member = {
      'Name': name,
      'PlanId': planid.toString(), // Plan ID
      'FatherName': fathername,
      'Emailid': emailid,
      'Phone': phone,
      'WhatsappNo': whatsppno,
      'EmergencyNo': emergencyno,
      'Address': address,
      'Height': height, // Ensure height is an integer
      'Weight': weight, // Ensure weight is an integer
      'Gender': gender,
      'Price': Price,
      'Discount': discount,
      'JoiningDate': joining,
      'PackageExpiryDate': packgeexpiry,
      'GymeId': gymid.toString(), // Gym ID from GetStorage
      'CreateBy': credit.toString(), // Admin ID as string
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
          Get.snackbar(
            "Success",
            "Member added successfully!",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(12),
            borderRadius: 8,
          );

          Get.back();  // Close the AddMemberScreen and go back
        } else {
          Get.snackbar("Error", data['message'] ?? "Failed to add member",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar("Error", "Failed to communicate with the server",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false; // Reset loading state after the request finishes
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

