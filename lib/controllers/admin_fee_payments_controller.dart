import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';  // For date formatting

class AdminFeePaymentsController extends GetxController {
  var feePayments = <Map<String, dynamic>>[].obs;
  var filteredPayments = <Map<String, dynamic>>[].obs;
  RxString searchQuery = ''.obs;
  var memberid;
  final _storage = GetStorage();
  var gymId;

  @override
  void onInit() {
    super.onInit();
    gymId = _storage.read('gymId') ?? 1;  // Default to 1 if not found
    fetchGymMemberFeeList(gymId);
  }

  // Fetch Fee List of Members using GymId from storage
  void fetchGymMemberFeeList(int gymId) async {
    final response = await http.get(
      Uri.parse('https://montgymapi.eduagentapp.com/api/MonteageGymApp/ViewMember/$gymId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['statuscode'] == 200) {
        feePayments.assignAll(List<Map<String, dynamic>>.from(data['data']));
        filteredPayments.assignAll(feePayments);

        List<int> memberIds = feePayments.map((payment) => payment['MemberId'] as int).toList();
        memberid = memberIds; // If you want to store a list of member IDs
      } else {
        Get.snackbar('Error', 'No data found', backgroundColor: Colors.red, colorText: Colors.white);
      }
    } else {
      Get.snackbar('Error', 'Failed to load data', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Method to format date as dd-MM-yyyy
  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '01-01-2024';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy').format(date);  // Format as dd-MM-yyyy
    } catch (e) {
      return dateStr;  // Return original value if parsing fails
    }
  }

  // Apply search
  void applySearch(String query) {
    searchQuery.value = query;
    final lowerQuery = query.toLowerCase();
    filteredPayments.assignAll(
      feePayments.where((fee) => (fee['Name'] ?? '').toString().toLowerCase().contains(lowerQuery)),
    );
  }

  // Open fee payment dialog
  void openFeePaymentDialog(Map<String, dynamic> feePayment) {
    // Controllers for each input field
    final priceController = TextEditingController(text: feePayment['Price'].toString());
    final discountController = TextEditingController(text: feePayment['Discount'].toString());
    final receivedAmountController = TextEditingController(text: feePayment['RecivedAmount'].toString());
    final balanceAmountController = TextEditingController(text: feePayment['BalanceAmount'].toString());
    final paymentStatusController = TextEditingController(text: feePayment['PaymentStatus']);

    // Controllers for the date fields
    final dateFromController = TextEditingController(text: feePayment['DateFrom'] ?? '');
    final dateToController = TextEditingController(text: feePayment['DateTo'] ?? '');

    // Open AlertDialog to edit fee data
    Get.dialog(
      AlertDialog(
        title: const Text("Edit Fee Payment"),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Price (₹)"),
                  ),
                  TextField(
                    controller: discountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Discount (₹)"),
                  ),
                  TextField(
                    controller: receivedAmountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Received Amount (₹)"),
                  ),
                  TextField(
                    controller: balanceAmountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Balance Amount (₹)"),
                  ),
                  TextField(
                    controller: paymentStatusController,
                    decoration: const InputDecoration(labelText: "Payment Status"),
                  ),
                  // Date From Picker
                  GestureDetector(
                    onTap: () => _selectDate(context, dateFromController),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: dateFromController,
                        decoration: const InputDecoration(labelText: "Date From"),
                      ),
                    ),
                  ),
                  // Date To Picker
                  GestureDetector(
                    onTap: () => _selectDate(context, dateToController),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: dateToController,
                        decoration: const InputDecoration(labelText: "Date To"),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Collect the updated values and prepare the data for the API call
              updateMemberFee(
                feeId: feePayment['MemberId'],
                Price: priceController.text,
                Discount: discountController.text,
                RecivedAmount: int.parse(receivedAmountController.text),
                BalanceAmount: balanceAmountController.text,
                PaymentStatus: paymentStatusController.text,
                PaymentDate: dateFromController.text,
                NextPaymentDate: dateToController.text,
                UpdateBy: "1", // Assuming '1' is the user updating the fee
              );

              Get.back(); // Close the dialog
            },
            child: const Text("Save Changes", style: TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () => Get.back(), // Close the dialog without saving
            child: const Text("Cancel", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Method to show Date Picker
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      controller.text = "${picked.toLocal()}".split(' ')[0]; // Format date as YYYY-MM-DD
    }
  }

  // Method to update member fee details
  Future<void> updateMemberFee({
    var feeId,
    var Price,
    var Discount,
    required int RecivedAmount,
    var BalanceAmount,
    var PaymentStatus,
    var PaymentDate,
    var NextPaymentDate,
    var UpdateBy,
  }) async {
    final response = await http.post(
      Uri.parse('https://montgymapi.eduagentapp.com/api/MonteageGymApp/MemberFeePost'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode({
        "MemberId": feeId,
        "Price": Price,
        "Discount": Discount,
        "RecivedAmount": RecivedAmount,
        "BalanceAmount": BalanceAmount,
        "PaymentStatus": PaymentStatus,
        "PaymentDate": PaymentDate,
        "NextPaymentDate": NextPaymentDate,
        "GymeId": gymId.toString(),
        "UpdateBy": UpdateBy,
      }),
    );

    if (response.statusCode == 200) {
      Get.snackbar('Success', 'Fee updated successfully.',
          backgroundColor: Colors.green, colorText: Colors.white);

      // Optionally, refresh data
      fetchGymMemberFeeList(1);  // Refresh the data after update
    } else {
      Get.snackbar('Error', 'Failed to update fee.',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
