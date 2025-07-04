import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/admin_notification_controller.dart';
import '../utils/constants/color_constants.dart';

class AdminNotificationsScreen extends StatelessWidget {
  final controller = Get.find<AdminNotificationController>();
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification's", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.APP_Color_Indigo,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back()),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () => _showSearchDialog(context),
          )
        ],
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchNotifications();
          },
          child: controller.filteredNotifications.isEmpty
              ? ListView(
            children: [
              SizedBox(height: 100),
              Center(child: Text("No notifications available")),
            ],
          )
              : ListView.separated(
            padding: EdgeInsets.only(top: 10),
            itemCount: controller.filteredNotifications.length,
            separatorBuilder: (_, __) => Divider(height: 1),
            itemBuilder: (context, index) {
              final notification = controller.filteredNotifications[index];
              return ListTile(
                leading: Icon(Icons.notifications_active,
                    color: AppColor.APP_Color_Pink),
                title: Text(notification.title),
                subtitle: Text(notification.message),
                trailing: Text(
                  DateFormat('hh:mm a').format(notification.date),
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void _showSearchDialog(BuildContext context) {
    searchController.text = controller.searchQuery.value;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Search Notifications"),
        content: TextField(
          controller: searchController,
          autofocus: true,
          decoration: InputDecoration(hintText: "Search by title/message"),
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
