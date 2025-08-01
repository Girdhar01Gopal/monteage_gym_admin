import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/admin_notification_controller.dart';


class AdminNotificationsScreen extends StatelessWidget {
  final _ctrl = Get.put(AdminNotificationController());

  AdminNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Notifications",style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white),
          onPressed: Get.back,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search,color: Colors.white,),
            onPressed: () => _showSearchDialog(context),
          ),
        ],
      ),
      body: Obx(() {
        final list = _ctrl.filteredNotifications;
        if (list.isEmpty && _ctrl.searchQuery.isNotEmpty) {
          return Center(child: Text('No notifications for "${_ctrl.searchQuery}"'));
        }
        return ListView.separated(
          itemCount: list.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, i) {
            final item = list[i];
            final ts = item.date ?? item.nextPaymentDate ?? '';
            DateTime dt;
            try {
              dt = DateTime.parse(ts);
            } catch (_) {
              dt = DateTime.now();
            }
            return ListTile(
              leading: const Icon(Icons.notifications_on, color: Colors.pink),
              title: Text(item.name ?? '–', style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(item.message ?? '–'),
              trailing: Text(
                DateFormat('hh:mm a').format(dt),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            );
          },
        );
      }),
    );
  }

  void _showSearchDialog(BuildContext context) {
    final tc = TextEditingController(text: _ctrl.searchQuery.value);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Search Notifications'),
        content: TextField(
          controller: tc,
          decoration: const InputDecoration(hintText: 'Enter keyword'),
          onChanged: _ctrl.applySearch,
        ),
        actions: [
          TextButton(
            onPressed: () {
              tc.clear();
              _ctrl.applySearch('');
            },
            child: const Text('Clear'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
