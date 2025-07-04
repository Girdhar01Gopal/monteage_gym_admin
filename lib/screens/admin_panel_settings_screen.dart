import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants/color_constants.dart';
import '../utils/custom_text.dart';
import '../controllers/admin_settings_controller.dart';

class AdminPanelSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminSettingsController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.APP_Color_Indigo,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Admin Settings",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Profile Image
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Obx(() => CircleAvatar(
                    radius: 45.r,
                    backgroundImage: controller.profileImage.value != null
                        ? FileImage(controller.profileImage.value!)
                        : AssetImage("assets/images/person.png") as ImageProvider,
                    backgroundColor: Colors.grey.shade200,
                  )),
                  InkWell(
                    onTap: controller.pickImageFromGallery,
                    child: CircleAvatar(
                      backgroundColor: AppColor.APP_Color_Pink,
                      radius: 16.r,
                      child: Icon(Icons.edit, color: Colors.white, size: 16.r),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20.h),

            /// Profile Settings
            CustomText(
              data: "Profile Settings",
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 20.h),
            TextFormField(
              controller: controller.nameController,
              decoration: InputDecoration(
                labelText: "Admin Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.h),
            TextFormField(
              controller: controller.emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.h),

            /// Password Section
            CustomText(
              data: "Change Password",
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 15.h),

            Obx(() => TextFormField(
              controller: controller.currentPasswordController,
              obscureText: controller.obscureCurrentPassword.value,
              decoration: InputDecoration(
                labelText: "Current Password",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.obscureCurrentPassword.value ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: controller.toggleCurrentPasswordVisibility,
                ),
              ),
            )),
            SizedBox(height: 15.h),

            Obx(() => TextFormField(
              controller: controller.passwordController,
              obscureText: controller.obscurePassword.value,
              decoration: InputDecoration(
                labelText: "New Password",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.obscurePassword.value ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
              ),
            )),
            SizedBox(height: 15.h),

            Obx(() => TextFormField(
              controller: controller.confirmPasswordController,
              obscureText: controller.obscureConfirmPassword.value,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.obscureConfirmPassword.value ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: controller.toggleConfirmPasswordVisibility,
                ),
              ),
            )),

            SizedBox(height: 25.h),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.APP_Color_Pink,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  textStyle: GoogleFonts.roboto(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text("Save Changes", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
