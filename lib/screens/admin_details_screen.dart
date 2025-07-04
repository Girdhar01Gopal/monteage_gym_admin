import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_monteage_admin/infrastructure/routes/admin_routes.dart';

import '../controllers/admin_details_controller.dart';
import '../utils/constants/color_constants.dart';
import '../utils/constants/image_constants.dart';
import '../utils/custom_text.dart';


class AdminDetailsScreen extends GetView<AdminDetailsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.White,

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 80.h,
            ),
            Row(
              children: [
                SizedBox(
                  width: 30.w,
                ),
                Image.asset(
                  ImageConstatnts.LOGO,
                  height: 50.h,
                ),
              ],
            ),
            SizedBox(
              height: 70.h,
            ),
            Row(
              children: [
                SizedBox(
                  width: 10.w,
                ),
                Image.asset(
                  ImageConstatnts.PERSON,
                  height: 500.h,
                ),
                SizedBox(
                  width: 20.w,
                ),
                SizedBox(
                  height: 500.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        data: "Gender",
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.APP_Color_Indigo,
                      ),
                      // Row(
                      //   children: [
                      //     Container(
                      //       height: 40.h,
                      //       width: 45.w,
                      //       margin: EdgeInsets.only(top: 10.h),
                      //       decoration: BoxDecoration(
                      //         border: Border.all(color: Colors.grey),
                      //         borderRadius: BorderRadius.only(
                      //           topLeft: Radius.circular(5.r),
                      //           bottomLeft: Radius.circular(5.r),
                      //         ),
                      //       ),
                      //       child: Icon(
                      //         Icons.male,
                      //         color: Colors.grey,
                      //       ),
                      //     ),
                      //     Container(
                      //       height: 40.h,
                      //       width: 45.w,
                      //       margin: EdgeInsets.only(top: 10.h),
                      //       decoration: BoxDecoration(
                      //         border: Border.all(color: Colors.grey),
                      //       ),
                      //       child: Icon(
                      //         Icons.female,
                      //         color: Colors.grey,
                      //       ),
                      //     ),
                      //     Container(
                      //       height: 40.h,
                      //       width: 45.w,
                      //       margin: EdgeInsets.only(top: 10.h),
                      //       decoration: BoxDecoration(
                      //         border: Border.all(color: Colors.grey),
                      //         borderRadius: BorderRadius.only(
                      //           topRight: Radius.circular(5.r),
                      //           bottomRight: Radius.circular(5.r),
                      //         ),
                      //       ),
                      //       child: Icon(
                      //         Icons.transgender,
                      //         color: Colors.grey,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 8),
                              color: AppColor.box_shadow_black,
                              blurRadius: 8.r,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            buildGenderContainer(Icons.male, 'Male', 'male'),
                            buildGenderContainer(
                                Icons.female, 'Female', 'female'),
                            buildGenderContainer(
                                Icons.transgender, 'Others', 'others'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      CustomText(
                        data: "Age",
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.APP_Color_Indigo,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        width: 150.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 8),
                                color: AppColor.box_shadow_black,
                                blurRadius: 8.r),
                            BoxShadow(
                                offset: Offset(0, -4),
                                color: AppColor.box_shadow_black,
                                blurRadius: 8.r)
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: controller.ageController,
                          maxLength: 2,
                          style: TextStyle(
                              fontSize: 18.sp,
                              color: AppColor.APP_Color_Indigo,
                              fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "Age in Year",
                            hintStyle: TextStyle(fontSize: 14.sp),
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                color: AppColor.APP_Color_Indigo,
                                width: 1.5.w,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                  color: AppColor.White, width: 1.5.w),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      CustomText(
                        data: "Height",
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.APP_Color_Indigo,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        width: 150.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 8),
                                color: AppColor.box_shadow_black,
                                blurRadius: 8.r),
                            BoxShadow(
                                offset: Offset(0, -4),
                                color: AppColor.box_shadow_black,
                                blurRadius: 8.r)
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: controller.heightController,
                          maxLength: 3,
                          style: TextStyle(
                              fontSize: 18.sp,
                              color: AppColor.APP_Color_Indigo,
                              fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "Height in cm",
                            hintStyle: TextStyle(fontSize: 14.sp),
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                color: AppColor.APP_Color_Indigo,
                                width: 1.5.w,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                  color: AppColor.White, width: 1.5.w),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      CustomText(
                        data: "Weight",
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.APP_Color_Indigo,
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        width: 150.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 8),
                                color: AppColor.box_shadow_black,
                                blurRadius: 8.r),
                            BoxShadow(
                                offset: Offset(0, -4),
                                color: AppColor.box_shadow_black,
                                blurRadius: 8.r)
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: controller.weightController,
                          maxLength: 3,
                          style: TextStyle(
                              fontSize: 18.sp,
                              color: AppColor.APP_Color_Indigo,
                              fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "Weight in Kg",
                            hintStyle: TextStyle(fontSize: 14.sp),
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                color: AppColor.APP_Color_Indigo,
                                width: 1.5.w,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                  color: AppColor.White, width: 1.5.w),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50.h,
            ),
            InkWell(
              onTap: () {
                Get.toNamed(AdminRoutes.ADMIN_DASHBOARD);
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Container(
                height: 50.h,
                width: Get.width,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 20.r),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomLeft,
                    colors: [
                      AppColor.APP_Color_Indigo,
                      AppColor.APP_Color_Pink,
                    ],
                    tileMode: TileMode.mirror,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: CustomText(
                  data: "Complete",
                  color: AppColor.White,
                  fontSize: 20.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGenderContainer(IconData icon, String text, String gender) {
    return GestureDetector(
      onTap: () {
        controller.selectGender(gender);
        print("Text===> ${text}");
      },
      child: Obx(
            () => Container(
          height: 50.h,
          width: 60.w,
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 10.h),
          decoration: BoxDecoration(
            // border: Border.all(
            //     color: controller.selectedGender.value == gender
            //         ? Colors.blue
            //         : Colors.grey),
            borderRadius: BorderRadius.only(
              topLeft: gender == 'male' ? Radius.circular(10.r) : Radius.zero,
              bottomLeft:
              gender == 'male' ? Radius.circular(10.r) : Radius.zero,
              topRight:
              gender == 'others' ? Radius.circular(10.r) : Radius.zero,
              bottomRight:
              gender == 'others' ? Radius.circular(10.r) : Radius.zero,
            ),
            color: controller.selectedGender.value == gender
                ? Colors.blue
                : Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: controller.selectedGender.value == gender
                    ? Colors.white
                    : Colors.grey,
              ),
              CustomText(
                data: text,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: controller.selectedGender.value == gender
                    ? Colors.white
                    : Colors.grey,
              )
            ],
          ),
        ),
      ),
    );
  }
}
