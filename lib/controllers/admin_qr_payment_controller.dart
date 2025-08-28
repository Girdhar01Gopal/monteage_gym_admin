import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminQrPaymentController extends GetxController {
  // Observable state
  final RxList<Map<String, dynamic>> paymentHistory = <Map<String, dynamic>>[].obs;

  // Centralized payment context
  final RxString memberName = 'Raghav Singh'.obs;
  final RxDouble amountDue = 1200.0.obs;

  // UPI constants
  final String upiId = 'monteage@upi';
  final String upiName = 'MonteageGYM';

  @override
  void onInit() {
    super.onInit();
    _loadSampleHistory();
  }

  void setMember(String name, double amount) {
    memberName.value = name;
    amountDue.value = amount;
  }

  // ---------- History ----------
  void _loadSampleHistory() {
    paymentHistory.assignAll([
      {
        "name": "Amit Sharma",
        "phone": "9876543210",
        "amount": 500.0,
        "type": "Credit",
        "date": DateTime.now().subtract(const Duration(days: 1))
      },
      {
        "name": "Neha Gupta",
        "phone": "9876543211",
        "amount": 250.0,
        "type": "Debit",
        "date": DateTime.now().subtract(const Duration(days: 3))
      },
      {
        "name": "Rahul Mehra",
        "phone": "9876543212",
        "amount": 1200.0,
        "type": "Credit",
        "date": DateTime.now().subtract(const Duration(days: 5))
      },
      {
        "name": "Priya Das",
        "phone": "9876543213",
        "amount": 100.0,
        "type": "Debit",
        "date": DateTime.now().subtract(const Duration(days: 7))
      },
      {
        "name": "Vikas Singh",
        "phone": "9876543214",
        "amount": 950.0,
        "type": "Credit",
        "date": DateTime.now().subtract(const Duration(days: 10))
      },
      {
        "name": "Suman Yadav",
        "phone": "9876543215",
        "amount": 300.0,
        "type": "Debit",
        "date": DateTime.now().subtract(const Duration(days: 15))
      },
      {
        "name": "Ritika Joshi",
        "phone": "9876543216",
        "amount": 850.0,
        "type": "Credit",
        "date": DateTime.now().subtract(const Duration(days: 18))
      },
      {
        "name": "Alok Ranjan",
        "phone": "9876543217",
        "amount": 600.0,
        "type": "Credit",
        "date": DateTime.now().subtract(const Duration(days: 25))
      },
      {
        "name": "Deepika Rao",
        "phone": "9876543218",
        "amount": 400.0,
        "type": "Debit",
        "date": DateTime.now().subtract(const Duration(days: 30))
      },
      {
        "name": "Mohit Verma",
        "phone": "9876543219",
        "amount": 750.0,
        "type": "Credit",
        "date": DateTime.now().subtract(const Duration(days: 40))
      },
    ]);
  }

  List<Map<String, dynamic>> getFilteredHistory(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return paymentHistory.where((entry) {
      final DateTime d = entry['date'] as DateTime;
      return d.isAfter(cutoff);
    }).toList();
  }

  // ---------- Formatting ----------
  String formatDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  String formatAmount(num amount) =>
      NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(amount);

  // ---------- UPI ----------
  /// Launches a UPI intent with the current amountDue.
  Future<bool> openInUpiApp({double? overrideAmount}) async {
    final double amt = (overrideAmount ?? amountDue.value).clamp(0, double.infinity);
    // Construct UPI URI per NPCI spec
    final uri = Uri.parse(
      'upi://pay?pa=$upiId&pn=$upiName&am=${amt.toStringAsFixed(2)}&cu=INR',
    );

    // Use url_launcher modern API
    final can = await canLaunchUrl(uri);
    if (!can) return false;

    return launchUrl(
      uri,
      mode: LaunchMode.externalNonBrowserApplication,
    );
  }
}
