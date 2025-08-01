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
        title: Text("Admin Report's", style: TextStyle(color: Colors.white)),
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
                        Text("Father Name: ${ux.fatherName}"),
                        Text("Email: ${ux.email}"),
                        Text("Phone: ${ux.phone}"),
                        Text("Address: ${ux.address}"),
                        Text("Plan: ${ux.plan}"),
                        Text("Total Payment: ₹${ux.totalPayment}"),
                        Text("Due Payment: ₹${ux.duePayment}"),
                        Text("Discount: ₹${ux.discount}"),
                        SizedBox(height: 10.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton.icon(
                            icon: Icon(Icons.picture_as_pdf, color: Colors.red),
                            label: Text("Export PDF", style: TextStyle(color: Colors.red)),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.black),
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
}
