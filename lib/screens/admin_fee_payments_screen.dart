import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/admin_fee_payments_controller.dart';
import '../utils/constants/color_constants.dart';

class AdminFeePaymentsScreen extends StatelessWidget {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminFeePaymentsController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Fee Payment Details", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.APP_Color_Indigo,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back()),
        actions: [
          IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () => _showSearchDialog(context, controller)),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.filteredPayments.isEmpty) {
                  return Center(child: Text("No fee records found."));
                }

                return ListView.builder(
                  itemCount: controller.filteredPayments.length,
                  itemBuilder: (context, index) {
                    final fee = controller.filteredPayments[index];
                    return Dismissible(
                      key: Key(fee['user']),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        controller.deletePayment(fee);
                        Get.snackbar("Deleted", "Fee removed",
                            backgroundColor: Colors.red, colorText: Colors.white);
                      },
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r)),
                        child: ExpansionTile(
                          title: Text(
                            fee['user'],
                            style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColor.APP_Color_Indigo),
                          ),
                          children: [
                            ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildFeeRow("Total Fee", fee['totalFee']),
                                  _buildFeeRow("Paid Amount", fee['paidAmount']),
                                  _buildFeeRow("Discount", fee['discount']),
                                  _buildFeeRow("Remaining", fee['remainingFee']),
                                  _buildTextRow("Next Payment Date", fee['nextFeeDate']),
                                  _buildTextRow("Package Expiry", fee['expiryDate']),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () =>
                                    controller.openFeePaymentDialog(fee),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            SizedBox(height: 10.h),
            ElevatedButton.icon(
              onPressed: controller.addNewPayment,
              icon: Icon(Icons.add, color: Colors.white),
              label:
              Text("Add New Payment", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 14.h),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFeeRow(String label, dynamic value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text("$label: ₹${value.toString()}"),
    );
  }

  Widget _buildTextRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text("$label: $value"),
    );
  }

  void _showSearchDialog(
      BuildContext context, AdminFeePaymentsController controller) {
    searchController.text = controller.searchQuery.value;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Search Payment User"),
        content: TextField(
          controller: searchController,
          autofocus: true,
          decoration: InputDecoration(hintText: "Enter user name"),
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
