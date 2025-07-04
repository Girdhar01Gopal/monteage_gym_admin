import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/AdminFeeSummaryController.dart';
import '../utils/constants/color_constants.dart';
import '../utils/custom_text.dart';

class AdminFeeSummaryScreen extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminFeeSummaryController());

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Fee Summary", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.APP_Color_Indigo,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () => _showSearchDialog(context, controller),
          )
        ],
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                data: "Fee Summary",
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColor.APP_Color_Indigo,
              ),
              SizedBox(height: 20.h),
              ...List.generate(controller.filteredUserFeeSummary.length, (index) {
                final user = controller.filteredUserFeeSummary[index];
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () => controller.toggleExpansion(index),
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r)),
                        color: AppColor.APP_Color_Pink,
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                          title: CustomText(
                            data: user['user'],
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          trailing: Icon(
                            user['isExpanded'] ? Icons.expand_less : Icons.expand_more,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    if (user['isExpanded']) ...[
                      buildEditableRow(
                        label: 'Total Fee Paid',
                        value: user['totalPaid'],
                        onChanged: (val) =>
                            controller.updateUserFee(index, 'totalPaid', val),
                      ),
                      buildEditableRow(
                        label: 'Fee Due',
                        value: user['feeDue'],
                        onChanged: (val) =>
                            controller.updateUserFee(index, 'feeDue', val),
                      ),
                      buildEditableRow(
                        label: 'Fee Outstanding',
                        value: user['feeOutstanding'],
                        onChanged: (val) =>
                            controller.updateUserFee(index, 'feeOutstanding', val),
                      ),
                      SizedBox(height: 15.h),
                    ]
                  ],
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget buildEditableRow({
    required String label,
    required double value,
    required Function(double) onChanged,
  }) {
    final TextEditingController controller =
    TextEditingController(text: value.toString());

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            width: 120.w,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              onChanged: (val) => onChanged(double.tryParse(val) ?? value),
              decoration: InputDecoration(
                hintText: "₹",
                contentPadding:
                EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog(
      BuildContext context, AdminFeeSummaryController controller) {
    searchController.text = controller.searchQuery.value;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Search User"),
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
