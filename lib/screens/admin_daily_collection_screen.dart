import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_daily_collection_controller.dart';
import '../utils/constants/color_constants.dart';

class AdminDailyCollectionScreen extends StatelessWidget {
  final controller = Get.find<AdminDailyCollectionController>();
  final searchText = ''.obs;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("View Collection's", style: TextStyle(color: Colors.white)),
          backgroundColor: AppColor.APP_Color_Indigo,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                _showSearchDialog(context);
              },
            )
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Container(
              color: Colors.white,
              child: const TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.indigo,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                indicatorWeight: 3,
                tabs: [
                  Tab(text: "Today's Collection"),
                  Tab(text: "Monthly Collection"),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildCollectionTab(isToday: true),
            _buildCollectionTab(isToday: false),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionTab({required bool isToday}) {
    return Obx(() {
      final allData = isToday ? controller.todayCollection : controller.monthlyCollection;
      final filtered = searchText.value.isEmpty
          ? allData
          : allData.where((item) =>
          item['Name'].toString().toLowerCase().contains(searchText.value.toLowerCase())).toList();

      return Column(
        children: [
          Expanded(
            child: allData.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final data = filtered[index];
                return Dismissible(
                  key: Key(data['Name']),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => isToday
                      ? controller.deleteDailyCollection(data)
                      : controller.deleteMonthlyCollection(data),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(data['Name'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColor.APP_Color_Indigo)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Payment Received: ₹${data['RecivedAmount']}"),
                          Text("Payment Remaining: ₹${data['BalanceAmount']}"),
                          Text("Next Payment Date: ${data['NextPaymentDate']}"),
                          Text("Paid On: ${data['PaymentDate']}"),
                          Text("Progress: ${data['PaymentStatus']}"),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.indigo),
                        onPressed: () => controller.openEditDialog(data, isToday),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Obx(() {
            final total = isToday
                ? controller.todayTotal.value
                : controller.monthlyTotal.value;
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                "Total ${isToday ? "Today's" : "Monthly"} Collection: ₹${total.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
        ],
      );
    });
  }

  void _showSearchDialog(BuildContext context) {
    final tempController = TextEditingController(text: searchText.value);

    Get.dialog(
      AlertDialog(
        title: const Text("Search by Name"),
        content: TextField(
          controller: tempController,
          decoration: const InputDecoration(hintText: "Enter name"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              searchText.value = tempController.text;
              Get.back();
            },
            child: const Text("Search"),
          ),
          TextButton(
            onPressed: () {
              searchText.value = '';
              tempController.clear();
              Get.back();
            },
            child: const Text("Clear"),
          ),
        ],
      ),
    );
  }
}
