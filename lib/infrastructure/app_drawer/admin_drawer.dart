import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../infrastructure/routes/admin_routes.dart';
import '../../utils/constants/color_constants.dart';

class AdminDrawer extends StatefulWidget {
  @override
  _AdminDrawerState createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  String? hoveredRoute;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final currentRoute = Get.currentRoute;

    return SafeArea(
      child: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColor.APP_Color_Indigo, AppColor.APP_Color_Pink],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Center(
                      child: Image.asset(
                        'assets/images/logo.jpeg', // Increased logo size
                        height: 100, // Adjust logo size as needed
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: Text(
                      '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildDrawerItem("Dashboard", Icons.dashboard, AdminRoutes.ADMIN_DASHBOARD, currentRoute),
                    _buildDrawerItem("Gym Profile", Icons.sports_gymnastics, AdminRoutes.GYM_PROFILE, currentRoute),
                    _buildDrawerItem("Package's", Icons.account_balance_wallet, AdminRoutes.ADMIN_MANAGE_PLAN, currentRoute),
                    _buildDrawerItem("Add Trainer", Icons.add_circle, AdminRoutes.ADD_TRAINER_SCREEN, currentRoute),
                    _buildDrawerItem("Trainer List", Icons.list, AdminRoutes.ADMIN_TRAINER_LIST, currentRoute),
                    _buildDrawerItem("Add Member's", Icons.person_add, AdminRoutes.ADD_MEMBER_SCREEN, currentRoute),
                    _buildDrawerItem("Total Member's", Icons.group, AdminRoutes.ADMIN_USER_LIST, currentRoute),
                    _buildDrawerItem("Fee Payments", Icons.payment, AdminRoutes.ADMIN_FEE_PAYMENTS, currentRoute),
                    _buildDrawerItem("Reports", Icons.insert_chart, AdminRoutes.ADMIN_REPORTS, currentRoute),
                    _buildDrawerItem("Diet Menu", Icons.restaurant_menu, AdminRoutes.ADMIN_DIET_MENU, currentRoute),
                    Divider(),
                    _buildDrawerItem("Logout", Icons.logout, AdminRoutes.ADMIN_LOGIN, currentRoute, isLogout: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Container(
        padding: EdgeInsets.all(16),
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: Colors.indigo),
              title: Text("Take Photo"),
              onTap: () async {
                final pickedFile = await _picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  setState(() => _selectedImage = File(pickedFile.path));
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: Colors.pink),
              title: Text("Choose from Gallery"),
              onTap: () async {
                final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() => _selectedImage = File(pickedFile.path));
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      String title,
      IconData icon,
      String route,
      String currentRoute, {
        bool isLogout = false,
      }) {
    final isSelected = currentRoute == route;
    final isHovered = hoveredRoute == route;

    return MouseRegion(
      onEnter: (_) => setState(() => hoveredRoute = route),
      onExit: (_) => setState(() => hoveredRoute = null),
      child: Container(
        color: isSelected
            ? AppColor.grey_200
            : isHovered
            ? AppColor.grey_100
            : null,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          leading: Icon(
            icon,
            color: isLogout
                ? Colors.red
                : isSelected
                ? AppColor.APP_Color_Indigo
                : isHovered
                ? AppColor.APP_Color_Pink
                : Colors.grey[800],
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isLogout
                  ? Colors.red
                  : isSelected
                  ? AppColor.APP_Color_Indigo
                  : isHovered
                  ? AppColor.APP_Color_Pink
                  : Colors.black,
              fontWeight: isLogout || isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          onTap: () {
            if (isLogout) {
              GetStorage().erase();
              Get.offAllNamed(AdminRoutes.ADMIN_LOGIN);
            } else if (!isSelected) {
              Get.toNamed(route);
            } else {
              Get.back();
            }
          },
        ),
      ),
    );
  }
}
