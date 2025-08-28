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

  // Display date format
  final DateFormat _dfDisplay = DateFormat('dd-MM-yyyy');
  // ISO date format
  final DateFormat _dfIso = DateFormat('yyyy-MM-dd');

  @override
  void onInit() {
    super.onInit();
    gymId = _storage.read('gymId') ?? 1;  // Default to 1 if not found
    fetchGymMemberFeeList(gymId);
  }

  // Fetch Fee List of Members using GymId from storage
  void fetchTrainersFromAPI() {} // (not used here)

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
        memberid = memberIds;
      } else {
        Get.snackbar('Error', 'No data found', backgroundColor: Colors.red, colorText: Colors.white);
      }
    } else {
      Get.snackbar('Error', 'Failed to load data', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Method to format date as dd-MM-yyyy for display
  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    // Try ISO first
    try {
      final date = DateTime.parse(dateStr);
      return _dfDisplay.format(date);
    } catch (_) {
      // Try already display format
      try {
        final date = _dfDisplay.parseStrict(dateStr);
        return _dfDisplay.format(date);
      } catch (_) {
        return dateStr;
      }
    }
  }

  // Convert display (dd-MM-yyyy) or ISO into ISO (yyyy-MM-dd) for API
  String toIsoDate(String? input) {
    if (input == null || input.isEmpty) return '';
    // Already ISO?
    try {
      final parsedIso = DateTime.parse(input);
      return _dfIso.format(parsedIso);
    } catch (_) {}
    // Try display dd-MM-yyyy
    try {
      final parsedDisp = _dfDisplay.parseStrict(input);
      return _dfIso.format(parsedDisp);
    } catch (_) {
      return input; // fall back with original if unknown
    }
  }

  // Utility: add months safely (handles year wrap)
  String addMonthsIso(String isoDate, int months) {
    try {
      final base = DateTime.parse(isoDate);
      final res = DateTime(base.year, base.month + months, base.day);
      return _dfIso.format(res);
    } catch (_) {
      return isoDate;
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
    final priceController = TextEditingController(text: feePayment['Price']?.toString() ?? '');
    final discountController = TextEditingController(text: feePayment['Discount']?.toString() ?? '');
    final receivedAmountController = TextEditingController(text: feePayment['RecivedAmount']?.toString() ?? '');
    final balanceAmountController = TextEditingController(text: feePayment['BalanceAmount']?.toString() ?? '');
    final paymentStatusController = TextEditingController(text: feePayment['PaymentStatus'] ?? '');

    // Use PaymentDate for Joining Date (Date From)
    final dateFromController = TextEditingController(
      text: formatDate(feePayment['PaymentDate'] ?? ''),
    );
    // Use NextPaymentDate for Date To
    final dateToController = TextEditingController(
      text: formatDate(feePayment['NextPaymentDate'] ?? ''),
    );

    // Plan duration (months) to compute Package Expiry
    int planDurationMonths = _inferPlanDuration(feePayment); // try to infer; fallback to 1
    final expiryDisplay = TextEditingController(
      text: formatDate(feePayment['PackageExpiryDate'] ?? ''),
    );

    // Function to update balance amount dynamically
    void updateBalanceAmount() {
      double price = double.tryParse(priceController.text) ?? 0.0;
      double discount = double.tryParse(discountController.text) ?? 0.0;
      double receivedAmount = double.tryParse(receivedAmountController.text) ?? 0.0;
      double balanceAmount = price - discount - receivedAmount;
      balanceAmountController.text = balanceAmount.toStringAsFixed(2);
    }

    // Update expiry on from/duration change
    void updateExpiryFromInputs() {
      final isoFrom = toIsoDate(dateFromController.text);
      if (isoFrom.isEmpty) return;
      final isoExpiry = addMonthsIso(isoFrom, planDurationMonths);
      expiryDisplay.text = formatDate(isoExpiry);
    }

    priceController.addListener(updateBalanceAmount);
    discountController.addListener(updateBalanceAmount);
    receivedAmountController.addListener(updateBalanceAmount);

    // Open AlertDialog to edit fee data
    Get.dialog(
      AlertDialog(
        title: const Text("Edit Fee Payment"),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---- Amounts ----
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
                    readOnly: true,
                  ),
                  TextField(
                    controller: paymentStatusController,
                    decoration: const InputDecoration(labelText: "Payment Status"),
                  ),

                  const SizedBox(height: 8),
                  const Text(
                    "Dates (Joining = Date From, Next Payment = Date To)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  // ---- Plan Duration (months) ----
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text("Plan Duration: "),
                      const SizedBox(width: 12),
                      DropdownButton<int>(
                        value: planDurationMonths,
                        items: const [
                          DropdownMenuItem(value: 1, child: Text("1 month")),
                          DropdownMenuItem(value: 3, child: Text("3 months")),
                          DropdownMenuItem(value: 6, child: Text("6 months")),
                          DropdownMenuItem(value: 12, child: Text("12 months")),
                        ],
                        onChanged: (val) {
                          if (val == null) return;
                          setState(() {
                            planDurationMonths = val;
                            updateExpiryFromInputs();
                          });
                        },
                      ),
                    ],
                  ),

                  // ---- Date From (Joining) ----
                  GestureDetector(
                    onTap: () async {
                      final picked = await _selectDate(
                        context,
                        initial: _tryParseDisplay(dateFromController.text) ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        setState(() {
                          dateFromController.text = _dfDisplay.format(picked);
                          // If Date To is earlier than Date From, clear Date To
                          final to = _tryParseDisplay(dateToController.text);
                          if (to != null && to.isBefore(picked)) {
                            dateToController.text = '';
                          }
                          updateExpiryFromInputs();
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        controller: dateFromController,
                        decoration: const InputDecoration(labelText: "Joining Date (Date From)"),
                      ),
                    ),
                  ),

                  // ---- Date To (Next Payment) with min = Date From ----
                  GestureDetector(
                    onTap: () async {
                      final from = _tryParseDisplay(dateFromController.text);
                      final first = from ?? DateTime(2000);
                      final picked = await _selectDate(
                        context,
                        initial: _tryParseDisplay(dateToController.text) ?? (from ?? DateTime.now()),
                        firstDate: first,
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        setState(() {
                          dateToController.text = _dfDisplay.format(picked);
                        });
                      } else {
                        // no-op
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        controller: dateToController,
                        decoration: const InputDecoration(labelText: "Next Payment Date (Date To)"),
                      ),
                    ),
                  ),

                  // ---- Computed Package Expiry (read-only, from Joining + duration) ----
                  const SizedBox(height: 8),
                  TextField(
                    controller: expiryDisplay,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Package Expiry (auto from Duration & Joining)",
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
              // Collect ISO values for API
              final isoFrom = toIsoDate(dateFromController.text);
              final isoTo = toIsoDate(dateToController.text);

              // Compute & update local expiry date (client-side update for display)
              final isoExpiry = (isoFrom.isNotEmpty)
                  ? addMonthsIso(isoFrom, planDurationMonths)
                  : '';

              // Update local item so card reflects changes immediately
              feePayment['PaymentDate'] = isoFrom;            // Joining Date
              feePayment['NextPaymentDate'] = isoTo;          // Next Payment Date
              feePayment['PackageExpiryDate'] = isoExpiry;    // Computed from duration

              // Send API (doesn't include expiry/duration per current backend contract)
              updateMemberFee(
                feeId: feePayment['MemberId'],
                Price: priceController.text,
                Discount: discountController.text,
                RecivedAmount: int.tryParse(receivedAmountController.text) ?? 0,
                BalanceAmount: balanceAmountController.text,
                PaymentStatus: paymentStatusController.text,
                PaymentDate: isoFrom,
                NextPaymentDate: isoTo,
                UpdateBy: "1",
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
    ).then((_) {
      // After closing, refresh list to reflect possible local edits
      filteredPayments.refresh();
    });
  }

  // Date picker with params
  Future<DateTime?> _selectDate(
      BuildContext context, {
        required DateTime initial,
        required DateTime firstDate,
        required DateTime lastDate,
      }) async {
    return await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: lastDate,
    );
  }

  DateTime? _tryParseDisplay(String text) {
    if (text.isEmpty) return null;
    try {
      return _dfDisplay.parseStrict(text);
    } catch (_) {
      try {
        return DateTime.parse(text);
      } catch (_) {
        return null;
      }
    }
  }

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
        "PaymentDate": PaymentDate,           // ISO yyyy-MM-dd
        "NextPaymentDate": NextPaymentDate,   // ISO yyyy-MM-dd
        "GymeId": gymId.toString(),
        "UpdateBy": UpdateBy,
      }),
    );

    if (response.statusCode == 200) {
      Get.snackbar('Success', 'Fee updated successfully.',
          backgroundColor: Colors.green, colorText: Colors.white);
      // Refresh from server if you want to re-sync. Keeping local refresh for snappy UX.
      // fetchGymMemberFeeList(gymId);
    } else {
      Get.snackbar('Error', 'Failed to update fee.',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // ---------- Helpers ----------
  String capitalizeFirst(String? text) {
    if (text == null || text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Try to infer plan duration from data (optional helper, default 1 month)
  int _inferPlanDuration(Map<String, dynamic> feePayment) {
    // If your API returns a duration field, map it here. Example keys:
    for (final key in ['PlanDuration', 'Duration', 'PlanMonths', 'Months']) {
      final v = feePayment[key];
      if (v == null) continue;
      final m = int.tryParse(v.toString());
      if (m != null && m > 0) return m;
    }
    return 1;
  }
}
