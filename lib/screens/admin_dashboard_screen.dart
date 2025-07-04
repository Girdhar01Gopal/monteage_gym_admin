import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../controllers/admin_dashboard_controller.dart';
import '../infrastructure/app_drawer/admin_drawer.dart';
import '../infrastructure/routes/admin_routes.dart';
import '../utils/constants/color_constants.dart';
import '../utils/custom_text.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminDashboardController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      drawer: AdminDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3F51B5), Color(0xFFE91E63)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: SafeArea(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.notes, color: Colors.white),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/monteage_logo_white.PNG',
                      height: 50.h,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_on, color: Colors.white),
                          onPressed: () => Get.toNamed(AdminRoutes.ADMIN_NOTIFICATIONS),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings, color: Colors.white),
                          onPressed: () => Get.toNamed(AdminRoutes.ADMIN_SETTINGS),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AdminRoutes.ADD_MEMBER_SCREEN),
        backgroundColor: const Color(0xFFE91E63),
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            SizedBox(height: 16.h),
            _buildProgressIndicators(),
            SizedBox(height: 22.h),
            _buildSectionHeader("Stats Overview"),
            SizedBox(height: 10.h),
            _buildStatsCards(controller),
            SizedBox(height: 20.h),
            _buildSectionHeader("Quick Actions"),
            SizedBox(height: 8.h),
            _buildActionButtons(),
            SizedBox(height: 5.h),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Row(
      children: [
        Text(
          "Monteage GYM!",
          style: GoogleFonts.poppins(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(width: 8.w),
        Icon(Icons.waving_hand, color: Colors.amber.shade700, size: 24.r),
      ],
    );
  }

  Widget _buildProgressIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCircularIndicator("Today's Collection", 0.75, Color(0xFF4CAF50)),
        _buildCircularIndicator("Monthly Collection", 0.55, Color(0xFF2196F3)),
      ],
    );
  }

  Widget _buildCircularIndicator(String label, double percent, Color color) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 52.r,
          lineWidth: 10.w,
          percent: percent,
          center: Text(
            "${(percent * 100).toInt()}%",
            style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          progressColor: color,
          backgroundColor: Colors.grey.shade200,
          circularStrokeCap: CircularStrokeCap.round,
          animation: true,
        ),
        SizedBox(height: 10.h),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildStatsCards(AdminDashboardController controller) {
    return Column(
      children: [
        Obx(() => InkWell(
          onTap: () => Get.toNamed(AdminRoutes.ADMIN_USER_LIST),
          child: _buildStatCard(" Total Users", controller.totalUsers.toString()),
        )),
        SizedBox(height: 10.h),
        Obx(() => InkWell(
          onTap: () => Get.toNamed(AdminRoutes.ADMIN_ACTIVE_USERS),
          child: _buildStatCard(" Active Users", controller.activeUsers.toString()),
        )),
      ],
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        trailing: Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildDashboardButton(
          label: "View Collection's",
          icon: Icons.calendar_today,
          route: AdminRoutes.DAILY_COLLECTION,
          color: Color(0xFF0288D1),
        ),
        SizedBox(height: 12.h),
        _buildDashboardButton(
          label: "Manage GYM/Plans",
          icon: Icons.manage_accounts,
          route: AdminRoutes.ADMIN_MANAGE_PLAN,
          color: Color(0xFFD81B60),
        ),
        SizedBox(height: 12.h),
        _buildDashboardButton(
          label: "Fee Summary",
          icon: Icons.currency_rupee,
          route: AdminRoutes.ADMIN_FEE_SUMMARY,
          color: Color(0xFF388E3C),
        ),
        SizedBox(height: 12.h),
        _buildDashboardButton(
          label: "Receive Payment (QR)",
          icon: Icons.qr_code,
          route: AdminRoutes.ADMIN_QR_PAYMENT,
          color: Color(0xFF512DA8),
        ),
      ],
    );
  }

  Widget _buildDashboardButton({
    required String label,
    required IconData icon,
    required String route,
    required Color color,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => Get.toNamed(route),
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: GoogleFonts.poppins(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 3,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          textStyle: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
