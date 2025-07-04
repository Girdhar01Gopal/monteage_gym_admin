import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/admin_user_list_controller.dart';
import '../utils/constants/color_constants.dart';
import '../utils/custom_text.dart';

class AdminUserListScreen extends StatelessWidget {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminUserListController());

    return Scaffold(
      appBar: AppBar(
        title: Text("Total Users", style: TextStyle(color: Colors.white)),
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Obx(() {
            if (controller.filteredUsers.isEmpty) {
              return Center(child: Text("No users found."));
            }

            return ListView.builder(
              itemCount: controller.filteredUsers.length,
              itemBuilder: (context, index) {
                final user = controller.filteredUsers[index];
                return UserCard(user: user, index: index);
              },
            );
          }),
        ),
      ),
    );
  }

  void _showSearchDialog(
      BuildContext context, AdminUserListController controller) {
    searchController.text = controller.searchQuery.value;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Search User"),
        content: TextField(
          controller: searchController,
          autofocus: true,
          decoration: InputDecoration(hintText: "Name, email or phone"),
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

class UserCard extends StatelessWidget {
  final Map<String, String> user;
  final int index;

  UserCard({required this.user, required this.index});

  final controller = Get.find<AdminUserListController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isExpanded = controller.expandedIndex.value == index;

      return Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(vertical: 10.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: ExpansionTile(
          onExpansionChanged: (expanded) {
            controller.toggleExpansion(index);
          },
          initiallyExpanded: isExpanded,
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/images/person.png'),
          ),
          title: CustomText(
            data: user['name'] ?? '',
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
          subtitle: Text(
            "${user['email']}\n${user['phone']}",
            style: TextStyle(color: Colors.grey),
          ),
          trailing: Icon(
            isExpanded ? Icons.expand_less : Icons.expand_more,
            color: AppColor.APP_Color_Indigo,
          ),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: ListTile(
                dense: true,
                title: Text("Email: ${user['email']}"),
                trailing: IconButton(
                  icon: Icon(Icons.email, color: Colors.blue),
                  onPressed: () => controller.launchEmail(user['email']!),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: ListTile(
                dense: true,
                title: Text("Phone: ${user['phone']}"),
                trailing: IconButton(
                  icon: Icon(Icons.phone, color: Colors.green),
                  onPressed: () => controller.launchPhone(user['phone']!),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: ListTile(
                dense: true,
                title: Text("Address: ${user['address']}"),
              ),
            ),
          ],
        ),
      );
    });
  }
}
