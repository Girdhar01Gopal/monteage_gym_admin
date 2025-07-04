import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../utils/constants/color_constants.dart';

class AdminQrPaymentScreen extends StatelessWidget {
  final String upiUrl = "upi://pay?pa=monteage@upi&pn=MonteageGYM&am=0&cu=INR";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receive Payment via QR", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.APP_Color_Indigo,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QrImageView(
                data: upiUrl,
                size: 250,
                backgroundColor: Colors.white,
              ),
              SizedBox(height: 30),
              Text("Scan to Pay", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("UPI ID: monteage@upi", style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.history, color: Colors.white),
                label: Text(
                  "View Payment History",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Get.snackbar(
                    "Coming Soon",
                    "Payment history integration in progress",
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                    margin: EdgeInsets.all(12),
                    borderRadius: 8,
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
