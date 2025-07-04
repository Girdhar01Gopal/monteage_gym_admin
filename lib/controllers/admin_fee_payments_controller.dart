import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AdminFeePaymentsController extends GetxController {
  var feePayments = <Map<String, dynamic>>[].obs;
  var filteredPayments = <Map<String, dynamic>>[].obs;
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFeePayments();
  }

  void fetchFeePayments() async {
    await Future.delayed(Duration(seconds: 1));

    feePayments.addAll([
      {
        'user': 'John Doe',
        'totalFee': 1000.0,
        'paidAmount': 500.0,
        'discount': 100.0,
        'remainingFee': 400.0,
        'nextFeeDate': '2025-07-10',
        'expiryDate': '2025-08-10',
      },
      {
        'user': 'Jane Smith',
        'totalFee': 1500.0,
        'paidAmount': 1500.0,
        'discount': 0.0,
        'remainingFee': 0.0,
        'nextFeeDate': '2025-08-01',
        'expiryDate': '2025-09-01',
      },
    ]);

    filteredPayments.assignAll(feePayments);
  }

  void applySearch(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredPayments.assignAll(feePayments);
    } else {
      final q = query.toLowerCase();
      filteredPayments.assignAll(feePayments.where((item) =>
          (item['user'] ?? '').toString().toLowerCase().contains(q)));
    }
  }

  void addNewPayment() {
    final newPayment = {
      'user': 'New User',
      'totalFee': 1200.0,
      'paidAmount': 0.0,
      'discount': 0.0,
      'remainingFee': 1200.0,
      'nextFeeDate': '',
      'expiryDate': '',
    };
    feePayments.add(newPayment);
    applySearch(searchQuery.value);
    Get.snackbar("Success", "New payment added",
        backgroundColor: Colors.green, colorText: Colors.white);
  }

  void deletePayment(Map<String, dynamic> feePayment) {
    feePayments.remove(feePayment);
    applySearch(searchQuery.value);
  }

  void openFeePaymentDialog(Map<String, dynamic> feePayment) {
    final paidController =
    TextEditingController(text: feePayment['paidAmount'].toString());
    final totalController =
    TextEditingController(text: feePayment['totalFee'].toString());
    final discountController =
    TextEditingController(text: feePayment['discount'].toString());
    final nextDateController =
    TextEditingController(text: feePayment['nextFeeDate']);
    final expiryController =
    TextEditingController(text: feePayment['expiryDate']);

    Get.dialog(
      AlertDialog(
        title: Text("Edit Fee: ${feePayment['user']}"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: totalController,
                decoration: InputDecoration(labelText: "Total Fee (₹)"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: paidController,
                decoration: InputDecoration(labelText: "Paid Amount (₹)"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: discountController,
                decoration: InputDecoration(labelText: "Discount (₹)"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: nextDateController,
                decoration: InputDecoration(labelText: "Next Fee Date"),
                onTap: () => _pickDate(nextDateController),
                readOnly: true,
              ),
              TextField(
                controller: expiryController,
                decoration: InputDecoration(labelText: "Package Expiry"),
                onTap: () => _pickDate(expiryController),
                readOnly: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              double total = double.tryParse(totalController.text) ?? 0.0;
              double paid = double.tryParse(paidController.text) ?? 0.0;
              double discount = double.tryParse(discountController.text) ?? 0.0;

              feePayment['totalFee'] = total;
              feePayment['paidAmount'] = paid;
              feePayment['discount'] = discount;
              feePayment['nextFeeDate'] = nextDateController.text;
              feePayment['expiryDate'] = expiryController.text;
              feePayment['remainingFee'] = (total - paid - discount).clamp(0.0, total);

              feePayments.refresh();
              applySearch(searchQuery.value);
              Get.back();
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void _pickDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }
}
