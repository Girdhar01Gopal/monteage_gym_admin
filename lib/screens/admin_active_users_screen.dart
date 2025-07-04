import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/admin_active_users_controller.dart';
import '../utils/constants/color_constants.dart';
import '../utils/custom_text.dart';

class AdminActiveUsersScreen extends StatelessWidget {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminActiveUsersController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Active Users", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.APP_Color_Indigo,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () => _showSearchDialog(context, controller),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  tabs: [Tab(text: "Morning Users"), Tab(text: "Evening Users")],
                  indicatorColor: AppColor.APP_Color_Pink,
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildUserListView(controller, 'Morning'),
                      _buildUserListView(controller, 'Evening'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserListView(AdminActiveUsersController controller, String timeOfDay) {
    return Obx(() {
      var users = controller.filteredUsers
          .where((user) => user['session_time'] == timeOfDay)
          .toList();

      if (users.isEmpty) {
        return Center(child: Text("No $timeOfDay users found."));
      }

      return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          var user = users[index];
          Color statusColor = user['status'] == 'Active' ? Colors.green : Colors.red;

          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 10.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
            child: ExpansionTile(
              leading: CircleAvatar(backgroundImage: AssetImage('assets/images/person.png')),
              title: CustomText(
                data: user['name'] ?? 'Unknown',
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
              subtitle: Text(
                "${user['email']}\n${user['phone']}",
                style: TextStyle(color: Colors.grey, fontSize: 13.sp),
              ),
              trailing: Icon(Icons.arrow_drop_down, color: AppColor.APP_Color_Indigo),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                  child: Column(
                    children: [
                      _buildTightListTile(
                        "Email: ${user['email']}",
                        trailingIcon: Icons.email,
                        onTap: () => controller.launchEmail(user['email']),
                        color: Colors.blue,
                      ),
                      _buildTightListTile(
                        "Phone: ${user['phone']}",
                        trailingIcon: Icons.phone,
                        onTap: () => controller.launchPhone(user['phone']),
                        color: Colors.green,
                      ),
                      _buildTightListTile("Address: ${user['address']}"),
                      _buildTightListTile(
                        "Status: ${user['status']}",
                        trailingWidget: DropdownButton<String>(
                          value: user['status'],
                          underline: SizedBox(),
                          onChanged: (val) {
                            final userIndex = controller.activeUsers.indexOf(user);
                            controller.updateUserStatus(userIndex, val!);
                          },
                          items: ['Active', 'Inactive'].map((status) {
                            return DropdownMenuItem(value: status, child: Text(status));
                          }).toList(),
                        ),
                        color: statusColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildTightListTile(
      String title, {
        IconData? trailingIcon,
        VoidCallback? onTap,
        Widget? trailingWidget,
        Color? color,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0), // Tighter spacing
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        title: Text(title, style: TextStyle(color: color ?? Colors.black)),
        trailing: trailingWidget ??
            (trailingIcon != null
                ? IconButton(icon: Icon(trailingIcon, color: color), onPressed: onTap)
                : null),
      ),
    );
  }

  void _showSearchDialog(BuildContext context, AdminActiveUsersController controller) {
    searchController.text = controller.searchQuery.value;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Search Users"),
        content: TextField(
          controller: searchController,
          autofocus: true,
          decoration: InputDecoration(hintText: "Name, email, or phone..."),
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
