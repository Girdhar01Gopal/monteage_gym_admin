import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'infrastructure/routes/admin_routes.dart';

void main() => runApp( AdminApp());

class AdminApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(411.42, 890.28),
      builder: (_, __) {
        return GetMaterialApp(
          title: 'Monteage Gym — Admin',
          debugShowCheckedModeBanner: false,
          getPages: AdminRoutes.routes,
          initialRoute: AdminRoutes.ADMIN_SPLASH,
          theme: ThemeData(useMaterial3: true),
        );
      },
    );
  }
}
