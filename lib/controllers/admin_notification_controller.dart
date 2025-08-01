import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../models/notification_model.dart';

class AdminNotificationController extends GetxController {
  final notifications       = <NotificationItem>[].obs;
  final filteredNotifications = <NotificationItem>[].obs;
  final searchQuery         = ''.obs;
  final _storage = GetStorage();
  var gymId;  // or read from storage

  @override
  void onInit() {
    super.onInit();
    gymId = _storage.read('gymId') ?? 1;  // Default to 1 if not found
    fetchNotifications(gymId);
  }

  Future<void> fetchNotifications(var gym) async {
    final url = Uri.parse(
        'https://montgymapi.eduagentapp.com/api/MonteageGymApp/GetNotification/$gym'

    );
    print(url);
    try {
      final resp = await http.get(url);
      if (resp.statusCode == 200) {
        final wrapper = NotificationData.fromJson(jsonDecode(resp.body));
        if (wrapper.data != null) {
          notifications.assignAll(wrapper.data!);
          filteredNotifications.assignAll(wrapper.data!);
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to load (${resp.statusCode})',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to fetch notifications: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void applySearch(String query) {
    searchQuery.value = query.trim();
    if (query.isEmpty) {
      filteredNotifications.assignAll(notifications);
    } else {
      final q = query.toLowerCase();
      filteredNotifications.assignAll(
          notifications.where((n) {
            return (n.name?.toLowerCase().contains(q) ?? false) ||
                (n.message?.toLowerCase().contains(q) ?? false);
          })
      );
    }
  }
}
