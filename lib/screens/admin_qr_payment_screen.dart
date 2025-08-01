import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../utils/constants/color_constants.dart';

class AdminQrPaymentScreen extends StatelessWidget {
  final String upiUrl = "upi://pay?pa=monteage@upi&pn=MonteageGYM&am=0&cu=INR";

  final List<Map<String, dynamic>> paymentHistory = [
    {
      'name': 'Amit Sharma',
      'phone': '9876543210',
      'amount': 500.0,
      'type': 'Credit',
      'date': DateTime.now().subtract(Duration(days: 1))
    },
    {
      'name': 'Neha Gupta',
      'phone': '9876543211',
      'amount': 250.0,
      'type': 'Debit',
      'date': DateTime.now().subtract(Duration(days: 3))
    },
    {
      'name': 'Rahul Mehra',
      'phone': '9876543212',
      'amount': 1200.0,
      'type': 'Credit',
      'date': DateTime.now().subtract(Duration(days: 5))
    },
    {
      'name': 'Priya Das',
      'phone': '9876543213',
      'amount': 100.0,
      'type': 'Debit',
      'date': DateTime.now().subtract(Duration(days: 7))
    },
    {
      'name': 'Vikas Singh',
      'phone': '9876543214',
      'amount': 950.0,
      'type': 'Credit',
      'date': DateTime.now().subtract(Duration(days: 10))
    },
    {
      'name': 'Suman Yadav',
      'phone': '9876543215',
      'amount': 300.0,
      'type': 'Debit',
      'date': DateTime.now().subtract(Duration(days: 15))
    },
    {
      'name': 'Ritika Joshi',
      'phone': '9876543216',
      'amount': 850.0,
      'type': 'Credit',
      'date': DateTime.now().subtract(Duration(days: 18))
    },
    {
      'name': 'Alok Ranjan',
      'phone': '9876543217',
      'amount': 600.0,
      'type': 'Credit',
      'date': DateTime.now().subtract(Duration(days: 25))
    },
    {
      'name': 'Deepika Rao',
      'phone': '9876543218',
      'amount': 400.0,
      'type': 'Debit',
      'date': DateTime.now().subtract(Duration(days: 30))
    },
    {
      'name': 'Mohit Verma',
      'phone': '9876543219',
      'amount': 750.0,
      'type': 'Credit',
      'date': DateTime.now().subtract(Duration(days: 40))
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Receive Payment via QR", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.APP_Color_Indigo,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QrImageView(
                data: upiUrl,
                size: 250,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 30),
              Text("Scan to Pay", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text("UPI ID: monteage@upi", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.history, color: Colors.white),
                label: Text("View Payment History", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  _showPaymentHistoryDialog(context);
                },
              ),
              const SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildPdfButton("10 Days History PDF", () => _generatePdf(context, days: 10)),
                  const SizedBox(height: 12),
                  _buildPdfButton("1 Month History PDF", () => _generatePdf(context, days: 30)),
                  const SizedBox(height: 12),
                  _buildPdfButton("3 Months History PDF", () => _generatePdf(context, days: 90)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPdfButton(String title, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.black, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  void _showPaymentHistoryDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text("Payment History"),
        content: Container(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              children: paymentHistory.take(10).map((entry) {
                return ListTile(
                  title: Text("${entry['name']} (${entry['phone']})"),
                  subtitle: Text(
                    "₹${entry['amount']} - ${entry['type']}",
                    style: TextStyle(
                      color: entry['type'] == 'Credit' ? Colors.green : Colors.red,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Close"),
          )
        ],
      ),
    );
  }

  void _generatePdf(BuildContext context, {required int days}) async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final cutoff = now.subtract(Duration(days: days));

    final filtered = paymentHistory.where((e) {
      final date = e['date'] as DateTime;
      return date.isAfter(cutoff);
    }).toList();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text("Payment History - Last $days Days", style: pw.TextStyle(fontSize: 20)),
          pw.SizedBox(height: 10),
          ...filtered.map((item) => pw.Text(
              "${item['name']} | ${item['phone']} | ₹${item['amount']} | ${item['type']}")),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}
