import 'package:auto_size_text/auto_size_text.dart';
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
}
