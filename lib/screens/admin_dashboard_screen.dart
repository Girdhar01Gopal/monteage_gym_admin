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
    // Initialize ScreenUtil
    ScreenUtil.init(context, designSize: Size(375, 812), minTextAdapt: true);

    final controller = Get.find<AdminDashboardController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      drawer: AdminDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h), // Adjusted for responsiveness
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
            padding: EdgeInsets.symmetric(horizontal: 12.w), // Scaled padding
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
                      'assets/images/girdhar.png',
                      height: 50.h, // Scaled image height
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
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h), // Scaled padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            SizedBox(height: 8.h), // Scaled gap
            _buildCollectionIndicators(controller),
            SizedBox(height: 16.h), // Scaled gap
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader("User Overview"),
                SizedBox(width: 6.w), // Scaled gap
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _legendBox(Colors.amber, "Morning"),
                        SizedBox(width: 4.w), // Scaled gap
                        _legendBox(Colors.deepOrange, "Evening"),
                        SizedBox(width: 4.w), // Scaled gap
                        _legendBox(Colors.blue, "Total"),
                        SizedBox(width: 4.w), // Scaled gap
                        _legendBox(Colors.green, "Active"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h), // Scaled gap
            _buildCombinedChart(controller),
            SizedBox(height: 16.h), // Scaled gap
            _buildSectionHeader("Quick Actions"),
            SizedBox(height: 6.h), // Scaled gap
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "THE JUNGLE GYM!",
              style: GoogleFonts.poppins(
                fontSize: 22.sp, // Scaled font size
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(width: 6.w), // Scaled gap
            Icon(Icons.waving_hand, color: Colors.amber.shade700, size: 22.r), // Scaled icon size
          ],
        ),
        SizedBox(height: 2.h), // Reduced gap
        Text(
          "Manage your gym effortlessly",  // ✅ New subtitle
          style: GoogleFonts.poppins(
            fontSize: 14.sp, // Scaled font size
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildCollectionIndicators(AdminDashboardController controller) {
    final currentMonth = DateFormat.MMMM().format(DateTime.now());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Obx(() => _buildClickableIndicator(
            "Today Collection", controller.totalFeePaid.value, AdminRoutes.DAILY_COLLECTION)),
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
      width: 150.w, // Scaled width
      padding: EdgeInsets.all(14.w), // Scaled padding
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w), // Scaled margin
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r), // Scaled border radius
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
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
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          SizedBox(height: 6.h), // Scaled gap
          Text(label, style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade800)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16.sp, // Scaled font size
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _legendBox(Color color, String label) {
    return Row(
      children: [
        Container(width: 8.w, height: 8.h, color: color, margin: const EdgeInsets.only(right: 4)),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget _buildCombinedChart(AdminDashboardController controller) {
    return AspectRatio(
      aspectRatio: 1.5, // Adjusted aspect ratio for responsiveness
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
                      width: 12.w, // Scaled width
                      borderRadius: BorderRadius.zero,
                    ),
                    BarChartRodData(
                      fromY: morning,
                      toY: morning + evening,
                      color: Colors.deepOrange,
                      width: 12.w, // Scaled width
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
                            ?  controller.months[index]
                            : '',
                        style: TextStyle(fontSize: 8.sp),  // Scaled font size
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
        _dashboardButton("View Collections", Icons.calendar_today, AdminRoutes.DAILY_COLLECTION, Color(0xFF0288D1)),
        SizedBox(height: 6.h), // Scaled gap
        _dashboardButton("Manage packages", Icons.manage_accounts, AdminRoutes.ADMIN_MANAGE_PLAN, Color(0xFFD81B60)),
        SizedBox(height: 6.h), // Scaled gap
        _dashboardButton("Total Payment Details", Icons.currency_rupee, AdminRoutes.ADMIN_FEE_PAYMENTS, Color(0xFF388E3C)),
        SizedBox(height: 6.h), // Scaled gap
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
          padding: EdgeInsets.symmetric(vertical: 12.h), // Scaled padding
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
      ),
    );
  }
}
