import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../infrastructure/routes/admin_routes.dart';
import '../../utils/constants/color_constants.dart';

class AdminDrawer extends StatefulWidget {
  @override
  _AdminDrawerState createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  String? hoveredRoute;
  File? _selectedImage; // To store the selected image
  final ImagePicker _picker = ImagePicker(); // Initialize ImagePicker

  @override
  Widget build(BuildContext context) {
    final currentRoute = Get.currentRoute;

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Drawer Header
          DrawerHeader(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColor.APP_Color_Indigo, AppColor.APP_Color_Pink],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: ListTile(
                leading: GestureDetector(
                  onTap: _pickImage, // Open image picker when avatar is clicked
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: _selectedImage == null
                        ? AssetImage('assets/images/person.png') // Default image
                        : FileImage(_selectedImage!) as ImageProvider,
                  ),
                ),
                title: Text(
                  'Monteage GYM',
                   style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // Wrap the drawer items with an Expanded widget to avoid overflow
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Drawer Items with reduced gaps
                  _buildDrawerItem("Dashboard", Icons.dashboard, AdminRoutes.ADMIN_DASHBOARD, currentRoute),
                  _buildDrawerItem("Courses", Icons.fitness_center, AdminRoutes.ADD_COURSE, currentRoute),
                  _buildDrawerItem("Package's", Icons.account_balance_wallet, AdminRoutes.ADMIN_MANAGE_PLAN, currentRoute),
                  _buildDrawerItem("Add Trainer", Icons.add_circle, AdminRoutes.ADD_TRAINER_SCREEN, currentRoute),
                  _buildDrawerItem("Trainer List", Icons.list, AdminRoutes.ADMIN_TRAINER_LIST, currentRoute),
                  _buildDrawerItem("Add Member's", Icons.person_add, AdminRoutes.ADD_MEMBER_SCREEN, currentRoute),
                  _buildDrawerItem("Fee Payments", Icons.payment, AdminRoutes.ADMIN_FEE_PAYMENTS, currentRoute),
                  _buildDrawerItem("Reports", Icons.insert_chart, AdminRoutes.ADMIN_REPORTS, currentRoute),
                  _buildDrawerItem("Diet Menu", Icons.restaurant_menu, AdminRoutes.ADMIN_DIET_MENU, currentRoute),

                  _buildDrawerItem("Logout", Icons.logout, AdminRoutes.ADMIN_LOGIN, currentRoute, replace: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // Store the selected image
      });
    }
  }

  // Helper method to build drawer items dynamically with reduced gap
  Widget _buildDrawerItem(
      String title,
      IconData icon,
      String route,
      String currentRoute, {
        bool replace = false,
      }) {
    final isSelected = currentRoute == route;
    final isHovered = hoveredRoute == route;

    // Check if the title is "Logout" to apply red color and bold font
    final isLogout = title == "Logout";

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
          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0), // Reduced padding
          leading: Icon(
            icon,
            color: isLogout
                ? Colors.red  // Set color to red for "Logout"
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
                  ? Colors.red  // Set color to red for "Logout"
                  : isSelected
                  ? AppColor.APP_Color_Indigo
                  : isHovered
                  ? AppColor.APP_Color_Pink
                  : Colors.black,
              fontWeight: isLogout
                  ? FontWeight.bold // Make "Logout" text bold
                  : isSelected
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
          onTap: () {
            if (!isSelected) {
              if (replace) {
                Get.offAllNamed(route); // Replace the current route
              } else {
                Get.toNamed(route); // Navigate to the selected route
              }
            } else {
              Get.back(); // Close drawer if same route
            }
          },
        ),
      ),
    );
  }
}
