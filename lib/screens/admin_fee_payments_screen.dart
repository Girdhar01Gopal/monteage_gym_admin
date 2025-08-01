import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/admin_fee_payments_controller.dart';
import '../utils/constants/color_constants.dart';

class AdminFeePaymentsScreen extends StatelessWidget {
  final searchController = TextEditingController();
  final controller = Get.find<AdminFeePaymentsController>();
  final _storage = GetStorage(); // GetStorage instance

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Fee Payment Detail's", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.APP_Color_Indigo,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => _showSearchDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          if (controller.filteredPayments.isEmpty) {
            return const Center(child: Text("No fee records found."));
          }
          return ListView.builder(
            itemCount: controller.filteredPayments.length,
            itemBuilder: (context, index) {
              final fee = controller.filteredPayments[index];

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ExpansionTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        fee['Name'] ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColor.APP_Color_Indigo,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFeeRow("Price", fee['Price']),
                          _buildFeeRow("Discount", fee['Discount']),
                          _buildFeeRow("Received Amount", fee['RecivedAmount']),
                          _buildFeeRow("Balance Amount", fee['BalanceAmount']),
                          _buildTextRow("Next Payment Date", controller.formatDate(fee['NextPaymentDate'])),
                          _buildTextRow("Package Expiry", controller.formatDate(fee['CreateDate'])),
                          // Moved Joining Date to the bottom in red
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              "Joining Date: ${controller.formatDate(fee['CreateDate'])}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => controller.openFeePaymentDialog(fee),
                            ),
                          ),
                          // Pay Now Button (Green) - Now with navigation
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                              icon: const Icon(Icons.arrow_forward, color: Colors.white),
                              label: const Text("Pay Now", style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                // Navigate to the QR Payment screen
                                Get.toNamed('/admin-qr-payment');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }

  // Helper function to build the fee rows
  Widget _buildFeeRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text("$label: ₹${(value ?? 0).toString()}"),
    );
  }

  // Helper function to build the text rows
  Widget _buildTextRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text("$label: ${value ?? '-'}"),
    );
  }

  // Show search dialog
  void _showSearchDialog(BuildContext context) {
    searchController.text = controller.searchQuery.value;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Search Payment User"),
        content: TextField(
          controller: searchController,
          autofocus: true,
          decoration: const InputDecoration(hintText: "Enter user name"),
          onChanged: controller.applySearch,
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.applySearch(searchController.text);
              Get.back();
            },
            child: Text("Search", style: TextStyle(color: AppColor.APP_Color_Indigo)),
          ),
        ],
      ),
    );
  }
}
