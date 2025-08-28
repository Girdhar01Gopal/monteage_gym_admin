import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/admin_login_controller.dart';
import '../utils/constants/image_constants.dart';
import '../utils/custom_text.dart';

class AdminLoginScreen extends StatelessWidget {
  final AdminLoginController controller = Get.put(AdminLoginController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsive design
    ScreenUtil.init(context, designSize: Size(375, 812), minTextAdapt: true);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/deepak.png',
              fit: BoxFit.cover,
            ),
          ),

          // Login Box
          Center(
            child: Container(
              width: 380.w, // Adjust width using ScreenUtil
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    Image.asset(ImageConstatnts.LOGO, height: 60.h),
                    SizedBox(height: 16.h),

                    // Title
                    AutoSizeText(
                      "THE JUNGLE GYM",
                      style: GoogleFonts.poppins(
                        fontSize: 24.sp, // Responsive font size
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // Login ID
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        data: "Login Id",
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    TextFormField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.white),
                      decoration: _inputDecoration("Enter your Login Id", Icons.person),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your login id';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),

                    // Password
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        data: "Password",
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Obx(
                          () => TextFormField(
                        controller: controller.passwordController,
                        obscureText: controller.obscurePassword.value,
                        style: TextStyle(color: Colors.white),
                        decoration: _inputDecoration(
                          "Enter your Password",
                          controller.obscurePassword.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          isPassword: true,
                          togglePassword: controller.togglePasswordVisibility,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // Login Button
                    Obx(
                          () => InkWell(
                        onTap: controller.isLoading.value
                            ? null
                            : () {
                          if (_formKey.currentState!.validate()) {
                            controller.login(
                              controller.emailController.text.trim(),
                              controller.passwordController.text.trim(),
                            );
                          } else {
                            Get.snackbar(
                              "Error",
                              "Please fill in all fields correctly",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        },
                        child: Container(
                          height: 48.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: controller.isLoading.value
                              ? CircularProgressIndicator(color: Colors.white)
                              : AutoSizeText(
                            "SIGN IN",
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp, // Responsive font size
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Input field style
  InputDecoration _inputDecoration(String hint, IconData icon,
      {bool isPassword = false, VoidCallback? togglePassword}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white),
      suffixIcon: isPassword
          ? IconButton(
        onPressed: togglePassword,
        icon: Icon(icon, color: Colors.white),
      )
          : null,
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.white70),
      ),
    );
  }
}



/*import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/admin_login_controller.dart';
import '../utils/constants/color_constants.dart';
import '../utils/constants/image_constants.dart';
import '../utils/custom_text.dart';

class AdminLoginScreen extends StatelessWidget {
  final AdminLoginController controller = Get.put(AdminLoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.White,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Image.asset(ImageConstatnts.LOGO1, height: 70.h),
              SizedBox(height: 20.h),

              /// Welcome Text
              AutoSizeText(
                "Welcome Back!",
                style: GoogleFonts.aBeeZee(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColor.APP_Color_Indigo,
                ),
              ),
              AutoSizeText(
                "Hello there, login in to continue!",
                style: GoogleFonts.aBeeZee(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColor.black,
                ),
              ),
              SizedBox(height: 50.h),

              /// Email Field
              CustomText(
                data: "Your Login Id",
                fontWeight: FontWeight.w500,
                fontSize: 18.sp,
              ),
              TextFormField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Enter your Login Id",
                  suffixIcon: Icon(Icons.email),
                  filled: true,
                  fillColor: AppColor.grey_100,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15.h,
                    horizontal: 12.w,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: AppColor.grey_100),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: AppColor.grey_100),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: AppColor.APP_Color_Indigo),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!GetUtils.isEmail(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),

              /// Password Field
              CustomText(
                data: "Your Password",
                fontWeight: FontWeight.w500,
                fontSize: 18.sp,
              ),
              Obx(
                    () => TextFormField(
                  controller: controller.passwordController,
                  obscureText: controller.obscurePassword.value,
                  decoration: InputDecoration(
                    hintText: "Enter your Password",
                    filled: true,
                    fillColor: AppColor.grey_100,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15.h,
                      horizontal: 12.w,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: AppColor.grey_100),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: AppColor.grey_100),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: AppColor.APP_Color_Indigo),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscurePassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 50.h),

              /// Login Button
              Obx(
                    () => InkWell(
                  onTap: controller.isLoading.value
                      ? null
                      : () {
                    if (controller.emailController.text.isEmpty ||
                        controller.passwordController.text.isEmpty) {
                      Get.snackbar(
                        "Error",
                        "Please Fill The Credentials",
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    } else {
                      controller.login(
                        controller.emailController.text,
                        controller.passwordController.text,
                      );
                    }
                  },
                  child: Container(
                    height: 50.h,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColor.APP_Color_Indigo,
                          AppColor.APP_Color_Pink,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: controller.isLoading.value
                        ? CircularProgressIndicator(color: Colors.white)
                        : AutoSizeText(
                      "Login",
                      style: GoogleFonts.aBeeZee(
                        fontSize: 18.sp,
                        color: AppColor.White,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}*/