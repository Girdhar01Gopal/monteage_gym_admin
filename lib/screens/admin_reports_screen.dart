import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/admin_reports_controller.dart';
import '../utils/constants/color_constants.dart';
import '../utils/custom_text.dart';

class AdminReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<AdminReportsController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Admin Reports", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.APP_Color_Indigo,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back()),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(children: [
          TextField(
            controller: ctrl.searchController,
            onChanged: ctrl.updateSearch,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.indigo),
              hintText: "Search by name or user type...",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: Obx(() => DropdownButton<String>(
                  value: ctrl.selectedUserType.value,
                  isExpanded: true,
                  items: ['All', 'Member', 'Trainer']
                      .map((e) => DropdownMenuItem(child: Text(e), value: e))
                      .toList(),
                  onChanged: ctrl.setUserType,
                )),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          CustomText(
            data: "User's Reports",
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.APP_Color_Indigo,
          ),
          SizedBox(height: 10.h),
          Expanded(child: Obx(() {
            if (ctrl.filteredUsers.isEmpty) {
              return Center(child: Text("No data available."));
            }
            return ListView.builder(
              itemCount: ctrl.filteredUsers.length,
              itemBuilder: (ctx, i) {
                final ux = ctrl.filteredUsers[i];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${ux.name} (${ux.type})",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColor.APP_Color_Indigo,
                          ),
                        ),
                        SizedBox(height: 8.h),

                        // Email with email icon (blue)
                        _buildIconRow(Icons.email, "Email: ${ux.email}", color: Colors.black),

                        // Phone with phone icon (green)
                        _buildIconRow(Icons.phone, "Phone: ${ux.phone}", color: Colors.black),

                        // Address with location pin icon (orange)
                        _buildIconRow(Icons.location_on, "Address: ${ux.address}", color: Colors.black),

                        // Father's Name with man emoji (purple)
                        _buildIconRow(Icons.person, "Father Name: ${ux.fatherName}", color: Colors.black),

                        // Plan with card icon (yellow)
                        _buildIconRow(Icons.credit_card, "Plan: ${ux.plan}", color: Colors.black),

                        // Total Payment with small bag icon (black)
                        _buildIconRow(Icons.shopping_bag, "Total Payment: ₹${ux.totalPayment.toStringAsFixed(0)}", color: Colors.black),

                        // Due Payment with red dot icon (red)
                        _buildIconRow(Icons.circle, "Due Payment: ₹${ux.duePayment.toStringAsFixed(0)}", color: ux.duePayment > 0 ? Colors.red : Colors.black),

                        // Discount with green dot icon (green)
                        _buildIconRow(Icons.circle, "Discount: ₹${ux.discount.toStringAsFixed(0)}", color: Colors.green),

                        SizedBox(height: 10.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton.icon(
                            icon: Icon(Icons.arrow_forward, color: Colors.white),
                            label: Text("Export PDF", style: TextStyle(color: Colors.white)),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.red),
                              backgroundColor: Colors.red, // Set background to red
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Reduce the button size
                            ),
                            onPressed: () => ctrl.exportUserReportPDF(ux),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          })),
        ]),
      ),
    );
  }

  // Helper function to build icon rows with color
  Widget _buildIconRow(IconData icon, String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color ?? Colors.black, size: 20),
          SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 16.sp)),
        ],
      ),
    );
  }
}
