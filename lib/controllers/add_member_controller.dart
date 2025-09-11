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
  final heightController = TextEditingController(); // in FEET now
  final weightController = TextEditingController();
  final joinDateController = TextEditingController();
  final discountController = TextEditingController();
  final planAmountController = TextEditingController();
  final nextFeeDateController = TextEditingController();
  final packageExpiryController = TextEditingController();

  final selectedPlan = ''.obs;
  final selectedPlanPrice = 0.obs;
  var gymid;
  final selectedGender = 'Male'.obs;
  final selectedTrainer = 'Personal Trainer'.obs;
  final isSameAsPhone = false.obs;
  final profileImage = Rx<File?>(null);
  final box = GetStorage();
  final RxList plans = [].obs;
  final isLoading = false.obs;

  final nameFormatter = FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'));
  final phoneFormatter = FilteringTextInputFormatter.digitsOnly;
  final whatsappFormatter = FilteringTextInputFormatter.digitsOnly;
  final emergencyFormatter = FilteringTextInputFormatter.digitsOnly;

  @override
  void onInit() async {
    super.onInit();
    gymid = await box.read('gymId');
    await fetchGymPlans();

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
        }
      }
    } catch (_) {}
  }

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

  Future<void> addMemberAPI(
      String name,
      int planid,
      String fathername,
      String emailid,
      String phone,
      String whatsppno,
      String emergencyno,
      String address,
      String heightFeet, // store as feet directly
      String weight,
      String gender,
      String Price,
      String discount,
      String joining,
      String packgeexpiry,
      var gymid,
      String credit,
      ) async {
    if (isLoading.value) return;
    isLoading.value = true;

    final member = {
      'Name': name,
      'PlanId': planid.toString(),
      'FatherName': fathername,
      'Emailid': emailid,
      'Phone': phone,
      'WhatsappNo': whatsppno,
      'EmergencyNo': emergencyno,
      'Address': address,
      'Height': heightFeet, // FEET only
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
      await http.post(
        Uri.parse("https://montgymapi.eduagentapp.com/api/MonteageGymApp/MemberPost"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(member),
      );
    } catch (_) {}
    isLoading.value = false;
  }
}
