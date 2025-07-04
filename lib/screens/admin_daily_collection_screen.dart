import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/admin_daily_collection_controller.dart';
import '../utils/constants/color_constants.dart';

class AdminDailyCollectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminDailyCollectionController>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("View Collection's", style: TextStyle(color: Colors.white)),
          backgroundColor: AppColor.APP_Color_Indigo,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: AppColor.APP_Color_Pink,
            tabs: [
              Tab(text: "Today's Collection"),
              Tab(text: "Monthly Collection"),
            ],
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: TabBarView(
              children: [
                _buildCollectionTab(
                  controller: controller,
                  isToday: true,
                ),
                _buildCollectionTab(
                  controller: controller,
                  isToday: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCollectionTab({
    required AdminDailyCollectionController controller,
    required bool isToday,
  }) {
    return Column(
      children: [
        Expanded(
          child: Obx(() {
            final collection = isToday ? controller.todayCollection : controller.monthlyCollection;

            if (collection.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              itemCount: collection.length,
              itemBuilder: (context, index) {
                final data = collection[index];
                return Dismissible(
                  key: Key(data['name']),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => isToday
                      ? controller.deleteDailyCollection(data)
                      : controller.deleteMonthlyCollection(data),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    child: ListTile(
                      title: Text(data['name'], style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColor.APP_Color_Indigo)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Attendance: ${data['attendance'] ? 'Present' : 'Absent'}"),
                          Text("Payment: ₹${data['paymentReceived']}"),
                          Text("Progress: ${data['progress']}"),
                          Text("Date: ${data['date']}"),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => controller.openEditDialog(data),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
        Obx(() {
          final total = isToday ? controller.todayTotal.value : controller.monthlyTotal.value;
          return Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Text(
              "Total ${isToday ? "Today's" : "Monthly"} Collection: ₹${total.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.green),
            ),
          );
        }),
        SizedBox(height: 10.h),
        ElevatedButton(
          onPressed: () {
            Get.snackbar(
              "Add New Collection",
              "New ${isToday ? "daily" : "monthly"} collection added",
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          },
          child: Text("Add New ${isToday ? "Daily" : "Monthly"} Collection", style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(backgroundColor: AppColor.APP_Color_Indigo),
        ),
      ],
    );
  }
}
