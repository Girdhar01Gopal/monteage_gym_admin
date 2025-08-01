import 'package:get/get.dart';

class AdminQrPaymentController extends GetxController {
  var paymentHistory = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSampleHistory();
  }

  void loadSampleHistory() {
    paymentHistory.assignAll([
      {"name": "Amit Sharma", "phone": "9876543210", "type": "Credit"},
      {"name": "Pooja Verma", "phone": "9123456789", "type": "Debit"},
      {"name": "Ravi Kumar", "phone": "9988776655", "type": "Credit"},
      {"name": "Neha Singh", "phone": "9988221144", "type": "Credit"},
      {"name": "Manish Tiwari", "phone": "8877665544", "type": "Debit"},
      {"name": "Sneha Joshi", "phone": "7766554433", "type": "Credit"},
      {"name": "Rahul Yadav", "phone": "7654321098", "type": "Debit"},
      {"name": "Kiran Patel", "phone": "7345678901", "type": "Credit"},
      {"name": "Vinod Sahu", "phone": "7000123456", "type": "Credit"},
      {"name": "Payal Rana", "phone": "9871234567", "type": "Debit"},
    ]);
  }
}
