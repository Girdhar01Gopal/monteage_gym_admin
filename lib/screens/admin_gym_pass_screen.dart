import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/admin_gym_pass_controller.dart';
import '../infrastructure/routes/admin_routes.dart';
import '../utils/constants/color_constants.dart';
import '../utils/constants/image_constants.dart' show ImageConstatnts;
import '../utils/custom_text.dart';


class AdminGymPassScreen extends GetView<AdminGymPassController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.White,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              ImageConstatnts.BACKGOUND,
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                      height: 40.h,
                      width: 45.w,
                      margin: EdgeInsets.only(top: 60.h, left: 20.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: controller.id.value == "PLATINUM"
                            ? AppColor.Platinum_1
                            : controller.id.value == "GOLD"
                            ? AppColor.Gold_2
                            : AppColor.Silver_2,
                      ),
                      child: Icon(
                        Icons.arrow_back, color: Colors.white
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 40.w, right: 40.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                            data: "Gym Pass",
                            fontSize: 18.sp,
                            color: AppColor.White),
                        controller.id.value == "PLATINUM"
                            ? AutoSizeText(
                          " PLATINUM",
                          style: GoogleFonts.merriweather(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColor.Platinum_1),
                        )
                            : controller.id.value == "GOLD"
                            ? AutoSizeText(
                          " GOLD",
                          style: GoogleFonts.merriweather(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColor.Gold_2),
                        )
                            : AutoSizeText(
                          " SILVER",
                          style: GoogleFonts.merriweather(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColor.Silver_4),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomText(
                      data: "Unlimited access to private sections",
                      fontSize: 16.sp,
                      textAlign: TextAlign.center,
                      color: AppColor.White,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      height: 0.5.h,
                      margin: EdgeInsets.symmetric(vertical: 5.h),
                      width: MediaQuery.of(context).size.width / 1.5,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColor.White,
                            AppColor.APP_Color_Indigo,
                            AppColor.APP_Color_Pink,
                            AppColor.White,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.r),
                          bottomRight: Radius.circular(15.r),
                        ),
                      ),
                    ),
                    CustomText(
                      data: "Get free Diet plan from day one",
                      fontSize: 16.sp,
                      textAlign: TextAlign.center,
                      color: AppColor.White,
                    ),
                    CustomText(
                      data: "Check Progress Report",
                      fontSize: 16.sp,
                      textAlign: TextAlign.center,
                      color: AppColor.White,
                    ),
                    CustomText(
                      data: "Get private coach",
                      fontSize: 16.sp,
                      textAlign: TextAlign.center,
                      color: AppColor.White,
                    ),
                    Container(
                      height: 0.5.h,
                      margin: EdgeInsets.symmetric(vertical: 5.h),
                      width: MediaQuery.of(context).size.width / 1.5,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColor.White,
                            AppColor.APP_Color_Indigo,
                            AppColor.APP_Color_Pink,
                            AppColor.White,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.r),
                          bottomRight: Radius.circular(15.r),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: AppColor.White,
                        gradient: controller.id.value == "GOLD"
                            ? LinearGradient(
                          colors: [
                            AppColor.Gold_2,
                            AppColor.Gold_4,
                            AppColor.Gold_2,
                            AppColor.Gold_1,
                            AppColor.Gold_4,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                            : controller.id.value == "PLATINUM"
                            ? LinearGradient(
                          colors: [
                            AppColor.Platinum_3,
                            AppColor.Platinum_2,
                            AppColor.Platinum_1,
                            AppColor.Platinum_2,
                            AppColor.Platinum_1,
                            AppColor.Platinum_2,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                            : LinearGradient(
                          colors: [
                            AppColor.Silver_4,
                            AppColor.Silver_3,
                            AppColor.Silver_2,
                            AppColor.Silver_2,
                            AppColor.Silver_2,
                            AppColor.Silver_3,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        // boxShadow: [
                        //   BoxShadow(
                        //     offset: Offset(00, 6),
                        //     blurRadius: 7.r,
                        //     color: AppColor.box_shadow_black,
                        //   ),
                        //   BoxShadow(
                        //     offset: Offset(00, -1),
                        //     blurRadius: 4.r,
                        //     color: AppColor.box_shadow_black,
                        //   ),
                        // ],
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.r, vertical: 6.h),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColor.APP_Color_Indigo,
                                      AppColor.APP_Color_Pink,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.r),
                                    bottomRight: Radius.circular(15.r),
                                  ),
                                ),
                                child: AutoSizeText(
                                  "Yealy Plan",
                                  style: GoogleFonts.bitter(
                                    fontSize: 16.sp,
                                    color: AppColor.White,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.h,
                              vertical: 7.h,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    AutoSizeText(
                                      "12 MONTHS",
                                      style: GoogleFonts.bitter(
                                        fontSize: 20.sp,
                                        color: AppColor.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 0.5.h,
                                  width: MediaQuery.of(context).size.width / 2,
                                  margin: EdgeInsets.symmetric(vertical: 10.h),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColor.White,
                                        AppColor.APP_Color_Indigo,
                                        AppColor.APP_Color_Pink,
                                        AppColor.White,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15.r),
                                      bottomRight: Radius.circular(15.r),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      "₹14,499",
                                      style: GoogleFonts.bitter(
                                        fontSize: 24.sp,
                                        color: AppColor.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40.w,
                                    ),
                                    AutoSizeText(
                                      "₹15,588",
                                      style: GoogleFonts.bitter(
                                        fontSize: 24.sp,
                                        color: AppColor.black,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    CustomText(
                                      data: "₹1209 / month",
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    Container(
                                      height: 15.h,
                                      width: 1.w,
                                      color: AppColor.black,
                                    ),
                                    CustomText(
                                      data: "No-cost EMI available",
                                      fontSize: 14.sp,
                                      color: AppColor.grey,
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 0.5.h,
                                  width: MediaQuery.of(context).size.width / 2,
                                  margin: EdgeInsets.symmetric(vertical: 10.h),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColor.White,
                                        AppColor.APP_Color_Indigo,
                                        AppColor.APP_Color_Pink,
                                        AppColor.White,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15.r),
                                      bottomRight: Radius.circular(15.r),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.notifications_active,
                                              color: AppColor.APP_Color_Pink,
                                            ),
                                            CustomText(
                                              data: "  ONLY TODAY",
                                              fontWeight: FontWeight.w500,
                                              color: AppColor.black,
                                              fontSize: 16.sp,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              maxRadius: 10.r,
                                              backgroundColor:
                                              AppColor.APP_Color_Indigo,
                                              child: Icon(
                                                Icons.add,
                                                color: AppColor.White,
                                                size: 15.r,
                                              ),
                                            ),
                                            CustomText(
                                              data: "  Extra ₹200 OFF",
                                              fontWeight: FontWeight.w500,
                                              color: AppColor.black,
                                              fontSize: 16.sp,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              maxRadius: 10.r,
                                              backgroundColor:
                                              AppColor.APP_Color_Pink,
                                              child: Icon(
                                                Icons.add,
                                                color: AppColor.White,
                                                size: 15.r,
                                              ),
                                            ),
                                            CustomText(
                                              data: "  FREE 2 months extention",
                                              fontWeight: FontWeight.w500,
                                              color: AppColor.black,
                                              fontSize: 16.sp,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              maxRadius: 10.r,
                                              backgroundColor: AppColor.grey,
                                              child: Icon(
                                                Icons.add,
                                                color: AppColor.White,
                                                size: 15.r,
                                              ),
                                            ),
                                            CustomText(
                                              data:
                                              "  ₹1089 OFF on purchasing yealry",
                                              fontWeight: FontWeight.w500,
                                              color: AppColor.black,
                                              fontSize: 16.sp,
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.toNamed(AdminRoutes.ADMIN_LOGIN);
                                  },
                                  child: Container(
                                    width: Get.width,
                                    alignment: Alignment.center,
                                    padding:
                                    EdgeInsets.symmetric(vertical: 5.h),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 10.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColor.APP_Color_Indigo,
                                          AppColor.APP_Color_Pink,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: CustomText(
                                      data: "BUY NOW",
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.White,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomText(
                      data: "BUY NOW, START ANYTIME",
                      fontSize: 18.sp,
                      color: AppColor.White,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(


                        gradient: controller.id.value == "GOLD"
                            ? LinearGradient(
                          colors: [
                            AppColor.Gold_2,
                            AppColor.Gold_4,
                            AppColor.Gold_2,
                            AppColor.Gold_1,
                            AppColor.Gold_4,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                            : controller.id.value == "PLATINUM"
                            ? LinearGradient(
                          colors: [
                            AppColor.Platinum_3,
                            AppColor.Platinum_2,
                            AppColor.Platinum_1,
                            AppColor.Platinum_2,
                            AppColor.Platinum_1,
                            AppColor.Platinum_2,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                            : LinearGradient(
                          colors: [
                            AppColor.Silver_4,
                            AppColor.Silver_3,
                            AppColor.Silver_2,
                            AppColor.Silver_2,
                            AppColor.Silver_2,
                            AppColor.Silver_3,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        // boxShadow: [
                        //   BoxShadow(
                        //     offset: Offset(00, 6),
                        //     blurRadius: 7.r,
                        //     color: AppColor.box_shadow_black,
                        //   ),
                        //   BoxShadow(
                        //     offset: Offset(00, -1),
                        //     blurRadius: 4.r,
                        //     color: AppColor.box_shadow_black,
                        //   ),
                        // ],
                        //
                        // border:Border.all(color: AppColor.White,width: 0.5.w),
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.r, vertical: 6.h),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColor.APP_Color_Indigo,
                                      AppColor.APP_Color_Pink,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.r),
                                    bottomRight: Radius.circular(15.r),
                                  ),
                                  // border: Border.all(
                                  //     color: AppColor.White, width: 0.5.w),
                                ),
                                child: AutoSizeText(
                                  "Half Year Plan",
                                  style: GoogleFonts.bitter(
                                    fontSize: 16.sp,
                                    color: AppColor.White,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.h,
                              vertical: 7.h,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    AutoSizeText(
                                      "6 MONTHS",
                                      style: GoogleFonts.bitter(
                                        fontSize: 20.sp,
                                        color: AppColor.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 0.5.h,
                                  width: MediaQuery.of(context).size.width / 2,
                                  margin: EdgeInsets.symmetric(vertical: 10.h),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColor.White,
                                        AppColor.APP_Color_Indigo,
                                        AppColor.APP_Color_Pink,
                                        AppColor.White,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15.r),
                                      bottomRight: Radius.circular(15.r),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      "₹7499",
                                      style: GoogleFonts.bitter(
                                        fontSize: 24.sp,
                                        color: AppColor.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40.w,
                                    ),
                                    AutoSizeText(
                                      "₹7794",
                                      style: GoogleFonts.bitter(
                                        fontSize: 24.sp,
                                        color: AppColor.black,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    CustomText(
                                      data: "₹1249 / month",
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    Container(
                                      height: 15.h,
                                      width: 1.w,
                                      color: AppColor.black,
                                    ),
                                    CustomText(
                                      data: "No-cost EMI available",
                                      fontSize: 14.sp,
                                      color: AppColor.grey,
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 0.5.h,
                                  width: MediaQuery.of(context).size.width / 2,
                                  margin: EdgeInsets.symmetric(vertical: 10.h),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColor.White,
                                        AppColor.APP_Color_Indigo,
                                        AppColor.APP_Color_Pink,
                                        AppColor.White,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15.r),
                                      bottomRight: Radius.circular(15.r),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.notifications_active,
                                              color: AppColor.APP_Color_Pink,
                                            ),
                                            CustomText(
                                              data: "  ONLY TODAY",
                                              fontWeight: FontWeight.w500,
                                              color: AppColor.black,
                                              fontSize: 16.sp,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              maxRadius: 10.r,
                                              backgroundColor:
                                              AppColor.APP_Color_Indigo,
                                              child: Icon(
                                                Icons.add,
                                                color: AppColor.White,
                                                size: 15.r,
                                              ),
                                            ),
                                            CustomText(
                                              data: "  Extra ₹200 OFF",
                                              fontWeight: FontWeight.w500,
                                              color: AppColor.black,
                                              fontSize: 16.sp,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              maxRadius: 10.r,
                                              backgroundColor:
                                              AppColor.APP_Color_Pink,
                                              child: Icon(
                                                Icons.add,
                                                color: AppColor.White,
                                                size: 15.r,
                                              ),
                                            ),
                                            CustomText(
                                              data: "  FREE 1 months extention",
                                              fontWeight: FontWeight.w500,
                                              color: AppColor.black,
                                              fontSize: 16.sp,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              maxRadius: 10.r,
                                              backgroundColor: AppColor.grey,
                                              child: Icon(
                                                Icons.add,
                                                color: AppColor.White,
                                                size: 15.r,
                                              ),
                                            ),
                                            CustomText(
                                              data:
                                              "  ₹295 OFF on purchasing yealry",
                                              fontWeight: FontWeight.w500,
                                              color: AppColor.black,
                                              fontSize: 16.sp,
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.toNamed(AdminRoutes.ADMIN_LOGIN);
                                  },
                                  child: Container(
                                    width: Get.width,
                                    alignment: Alignment.center,
                                    padding:
                                    EdgeInsets.symmetric(vertical: 5.h),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 10.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColor.APP_Color_Indigo,
                                          AppColor.APP_Color_Pink,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: CustomText(
                                      data: "BUY NOW",
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.White,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomText(
                      data: "BUY NOW, START ANYTIME",
                      fontSize: 18.sp,
                      color: AppColor.White,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        // color: AppColor.White,
                        gradient: controller.id.value == "GOLD"
                            ? LinearGradient(
                          colors: [
                            AppColor.Gold_2,
                            AppColor.Gold_4,
                            AppColor.Gold_2,
                            AppColor.Gold_1,
                            AppColor.Gold_4,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                            : controller.id.value == "PLATINUM"
                            ? LinearGradient(
                          colors: [
                            AppColor.Platinum_3,
                            AppColor.Platinum_2,
                            AppColor.Platinum_1,
                            AppColor.Platinum_2,
                            AppColor.Platinum_1,
                            AppColor.Platinum_2,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                            : LinearGradient(
                          colors: [
                            AppColor.Silver_4,
                            AppColor.Silver_3,
                            AppColor.Silver_2,
                            AppColor.Silver_2,
                            AppColor.Silver_2,
                            AppColor.Silver_3,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        // boxShadow: [
                        //   BoxShadow(
                        //     offset: Offset(00, 6),
                        //     blurRadius: 7.r,
                        //     color: AppColor.box_shadow_black,
                        //   ),
                        //   BoxShadow(
                        //     offset: Offset(00, -1),
                        //     blurRadius: 4.r,
                        //     color: AppColor.box_shadow_black,
                        //   ),
                        // ],
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.r, vertical: 6.h),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColor.APP_Color_Indigo,
                                      AppColor.APP_Color_Pink,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.r),
                                    bottomRight: Radius.circular(15.r),
                                  ),
                                ),
                                child: AutoSizeText(
                                  "Quarter Year Plan",
                                  style: GoogleFonts.bitter(
                                    fontSize: 16.sp,
                                    color: AppColor.White,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.h,
                              vertical: 7.h,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    AutoSizeText(
                                      "3 MONTHS",
                                      style: GoogleFonts.bitter(
                                        fontSize: 20.sp,
                                        color: AppColor.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 0.5.h,
                                  width: MediaQuery.of(context).size.width / 2,
                                  margin: EdgeInsets.symmetric(vertical: 10.h),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColor.White,
                                        AppColor.APP_Color_Indigo,
                                        AppColor.APP_Color_Pink,
                                        AppColor.White,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15.r),
                                      bottomRight: Radius.circular(15.r),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      "₹3699",
                                      style: GoogleFonts.bitter(
                                        fontSize: 24.sp,
                                        color: AppColor.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40.w,
                                    ),
                                    AutoSizeText(
                                      "₹3897",
                                      style: GoogleFonts.bitter(
                                        fontSize: 24.sp,
                                        color: AppColor.black,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    CustomText(
                                      data: "₹1233 / month",
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    Container(
                                      height: 15.h,
                                      width: 1.w,
                                      color: AppColor.black,
                                    ),
                                    CustomText(
                                      data: "No-cost EMI available",
                                      fontSize: 14.sp,
                                      color: AppColor.grey,
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 0.5.h,
                                  width: MediaQuery.of(context).size.width / 2,
                                  margin: EdgeInsets.symmetric(vertical: 10.h),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColor.White,
                                        AppColor.APP_Color_Indigo,
                                        AppColor.APP_Color_Pink,
                                        AppColor.White,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15.r),
                                      bottomRight: Radius.circular(15.r),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.notifications_active,
                                              color: AppColor.APP_Color_Pink,
                                            ),
                                            CustomText(
                                              data: "  ONLY TODAY",
                                              fontWeight: FontWeight.w500,
                                              color: AppColor.black,
                                              fontSize: 16.sp,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              maxRadius: 10.r,
                                              backgroundColor:
                                              AppColor.APP_Color_Indigo,
                                              child: Icon(
                                                Icons.add,
                                                color: AppColor.White,
                                                size: 15.r,
                                              ),
                                            ),
                                            CustomText(
                                              data: "  Extra ₹200 OFF",
                                              fontWeight: FontWeight.w500,
                                              color: AppColor.black,
                                              fontSize: 16.sp,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              maxRadius: 10.r,
                                              backgroundColor: AppColor.grey,
                                              child: Icon(
                                                Icons.add,
                                                color: AppColor.White,
                                                size: 15.r,
                                              ),
                                            ),
                                            CustomText(
                                              data:
                                              "  ₹198 OFF on purchasing yealry",
                                              fontWeight: FontWeight.w500,
                                              color: AppColor.black,
                                              fontSize: 16.sp,
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.toNamed(AdminRoutes.ADMIN_LOGIN);
                                  },
                                  child: Container(
                                    width: Get.width,
                                    alignment: Alignment.center,
                                    padding:
                                    EdgeInsets.symmetric(vertical: 5.h),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 10.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColor.APP_Color_Indigo,
                                          AppColor.APP_Color_Pink,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: CustomText(
                                      data: "BUY NOW",
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.White,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomText(
                      data: "BUY NOW, START ANYTIME",
                      fontSize: 18.sp,
                      color: AppColor.White,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: AppColor.White,
                        gradient: controller.id.value == "GOLD"
                            ? LinearGradient(
                          colors: [
                            AppColor.Gold_2,
                            AppColor.Gold_4,
                            AppColor.Gold_2,
                            AppColor.Gold_1,
                            AppColor.Gold_4,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                            : controller.id.value == "PLATINUM"
                            ? LinearGradient(
                          colors: [
                            AppColor.Platinum_3,
                            AppColor.Platinum_2,
                            AppColor.Platinum_1,
                            AppColor.Platinum_2,
                            AppColor.Platinum_1,
                            AppColor.Platinum_2,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                            : LinearGradient(
                          colors: [
                            AppColor.Silver_4,
                            AppColor.Silver_3,
                            AppColor.Silver_2,
                            AppColor.Silver_2,
                            AppColor.Silver_2,
                            AppColor.Silver_3,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        // boxShadow: [
                        //   BoxShadow(
                        //     offset: Offset(00, 6),
                        //     blurRadius: 7.r,
                        //     color: AppColor.box_shadow_black,
                        //   ),
                        //   BoxShadow(
                        //     offset: Offset(00, -1),
                        //     blurRadius: 4.r,
                        //     color: AppColor.box_shadow_black,
                        //   ),
                        // ],
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.r, vertical: 6.h),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColor.APP_Color_Indigo,
                                      AppColor.APP_Color_Pink,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.r),
                                    bottomRight: Radius.circular(15.r),
                                  ),
                                ),
                                child: AutoSizeText(
                                  "Single Month",
                                  style: GoogleFonts.bitter(
                                    fontSize: 16.sp,
                                    color: AppColor.White,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.h,
                              vertical: 7.h,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    AutoSizeText(
                                      "1 MONTH",
                                      style: GoogleFonts.bitter(
                                        fontSize: 20.sp,
                                        color: AppColor.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 0.5.h,
                                  width: MediaQuery.of(context).size.width / 2,
                                  margin: EdgeInsets.symmetric(vertical: 10.h),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColor.White,
                                        AppColor.APP_Color_Indigo,
                                        AppColor.APP_Color_Pink,
                                        AppColor.White,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15.r),
                                      bottomRight: Radius.circular(15.r),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      "₹1299",
                                      style: GoogleFonts.bitter(
                                        fontSize: 24.sp,
                                        color: AppColor.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      data: "₹1233 / month",
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 0.5.h,
                                  width: MediaQuery.of(context).size.width / 2,
                                  margin: EdgeInsets.symmetric(vertical: 10.h),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColor.White,
                                        AppColor.APP_Color_Indigo,
                                        AppColor.APP_Color_Pink,
                                        AppColor.White,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15.r),
                                      bottomRight: Radius.circular(15.r),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.notifications_active,
                                              color: AppColor.APP_Color_Pink,
                                            ),
                                            CustomText(
                                              data: "  ONLY TODAY",
                                              fontWeight: FontWeight.w500,
                                              color: AppColor.black,
                                              fontSize: 16.sp,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              maxRadius: 10.r,
                                              backgroundColor:
                                              AppColor.APP_Color_Indigo,
                                              child: Icon(
                                                Icons.add,
                                                color: AppColor.White,
                                                size: 15.r,
                                              ),
                                            ),
                                            CustomText(
                                              data: "  Extra ₹50 OFF",
                                              fontWeight: FontWeight.w500,
                                              color: AppColor.black,
                                              fontSize: 16.sp,
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.toNamed(AdminRoutes.ADMIN_LOGIN);
                                  },
                                  child: Container(
                                    width: Get.width,
                                    alignment: Alignment.center,
                                    padding:
                                    EdgeInsets.symmetric(vertical: 5.h),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 10.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColor.APP_Color_Indigo,
                                          AppColor.APP_Color_Pink,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: CustomText(
                                      data: "BUY NOW",
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.White,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
