import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controllers/admin_splash_controller.dart';
import '../utils/constants/image_constants.dart';
import '../utils/constants/color_constants.dart';

class AdminSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Register the splash controller
    Get.put(AdminSplashController());

    return Scaffold(
      backgroundColor: AppColor.White,
      body: Center(
        child: Image.asset(
          ImageConstatnts.LOGO,
          height: 120.h,
        ),
      ),
    );
  }
}
