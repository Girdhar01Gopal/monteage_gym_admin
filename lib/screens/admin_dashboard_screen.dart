import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../controllers/admin_dashboard_controller.dart';
import '../infrastructure/app_drawer/admin_drawer.dart';
import '../infrastructure/routes/admin_routes.dart';

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
                      'assets/images/logo.jpeg',
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
            _buildCollectionIndicators(controller),
            SizedBox(height: 20.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader("User Overview"),
                SizedBox(width: 8.w),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _legendBox(Colors.amber, "Morning"),
                        SizedBox(width: 6),
                        _legendBox(Colors.deepOrange, "Evening"),
                        SizedBox(width: 6),
                        _legendBox(Colors.blue, "Total"),
                        SizedBox(width: 6),
                        _legendBox(Colors.green, "Active"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            _buildCombinedChart(controller),
            SizedBox(height: 20.h),
            _buildSectionHeader("Quick Actions"),
            SizedBox(height: 10.h),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Row(
      children: [
        Text(
          "THE JUNGLE GYM!",
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

  Widget _buildCollectionIndicators(AdminDashboardController controller) {
    final currentMonth = DateFormat.MMMM().format(DateTime.now());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Obx(() => _buildClickableIndicator(
            "Today's Collection", controller.totalFeePaid.value, AdminRoutes.DAILY_COLLECTION)),
        Obx(() => _buildClickableIndicator(
            "$currentMonth Collection", controller.monthlyCollection.value, AdminRoutes.DAILY_COLLECTION)),
      ],
    );

  }

  // Adding click functionality to the indicator cards
  Widget _buildClickableIndicator(String label, double amount, String route) {
    return GestureDetector(
      onTap: () => Get.toNamed(route), // Navigate to View Collection screen
      child: _styledIndicator(label, amount),
    );
  }

  Widget _styledIndicator(String label, double amount) {
    return Container(
      width: 160.w,
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "₹ ${amount.toStringAsFixed(2)}",
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          SizedBox(height: 8.h),
          Text(label, style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade800)),
        ],
      ),
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

  Widget _legendBox(Color color, String label) {
    return Row(
      children: [
        Container(width: 10, height: 10, color: color, margin: const EdgeInsets.only(right: 4)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildCombinedChart(AdminDashboardController controller) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: Stack(
        children: [
          Obx(() => BarChart(
            BarChartData(
              barGroups: List.generate(controller.months.length, (index) {
                final morning = controller.morningUsers[index].toDouble();
                final evening = controller.eveningUsers[index].toDouble();
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      fromY: 0,
                      toY: morning,
                      color: Colors.amber,
                      width: 14,
                      borderRadius: BorderRadius.zero,
                    ),
                    BarChartRodData(
                      fromY: morning,
                      toY: morning + evening,
                      color: Colors.deepOrange,
                      width: 14,
                      borderRadius: BorderRadius.zero,
                    ),
                  ],
                );
              }),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      final index = value.toInt();
                      return Text(
                        index >= 0 && index < controller.months.length
                            ? controller.months[index]
                            : '',
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 30, interval: 20),
                ),
                topTitles: AxisTitles(),
                rightTitles: AxisTitles(),
              ),
              gridData: FlGridData(show: true),
              barTouchData: BarTouchData(enabled: false),
              borderData: FlBorderData(show: false),
            ),
          )),
          Obx(() => LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(
                    controller.totalUsersPerMonth.length,
                        (i) => FlSpot(i.toDouble(), controller.totalUsersPerMonth[i].toDouble()),
                  ),
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 2,
                  dotData: FlDotData(show: true),
                ),
                LineChartBarData(
                  spots: List.generate(
                    controller.activeUsersPerMonth.length,
                        (i) => FlSpot(i.toDouble(), controller.activeUsersPerMonth[i].toDouble()),
                  ),
                  isCurved: true,
                  color: Colors.green,
                  barWidth: 2,
                  dotData: FlDotData(show: true),
                ),
              ],
              titlesData: FlTitlesData(show: false),
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _dashboardButton("View Collection's", Icons.calendar_today, AdminRoutes.DAILY_COLLECTION, Color(0xFF0288D1)),
        SizedBox(height: 12.h),
        _dashboardButton("Manage package's", Icons.manage_accounts, AdminRoutes.ADMIN_MANAGE_PLAN, Color(0xFFD81B60)),
        SizedBox(height: 12.h),
        _dashboardButton("Total Payment Details", Icons.currency_rupee, AdminRoutes.ADMIN_FEE_PAYMENTS, Color(0xFF388E3C)),
        SizedBox(height: 12.h),
        _dashboardButton("Receive Payment (QR)", Icons.qr_code, AdminRoutes.ADMIN_QR_PAYMENT, Color(0xFF512DA8)),
      ],
    );
  }

  Widget _dashboardButton(String label, IconData icon, String route, Color color) {
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
      ),
    );
  }
}
