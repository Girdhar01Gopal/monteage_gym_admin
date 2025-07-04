import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CircularStatCard extends StatelessWidget {
  final double percent;
  final String title;
  final Color progressColor;

  const CircularStatCard({
    required this.percent,
    required this.title,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 45.r,
          lineWidth: 8.w,
          percent: percent,
          center: Text("${(percent * 100).toInt()}%", style: TextStyle(fontWeight: FontWeight.bold)),
          progressColor: progressColor,
          backgroundColor: Colors.grey.shade200,
          circularStrokeCap: CircularStrokeCap.round,
        ),
        SizedBox(height: 6.h),
        Text(title, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
