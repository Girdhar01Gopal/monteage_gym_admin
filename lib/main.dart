import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'infrastructure/routes/admin_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); //  Initialize GetStorage for local cache
  runApp(AdminApp());
}

class AdminApp extends StatelessWidget {
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = box.read('isLoggedIn') ?? false;

    return ScreenUtilInit(
      designSize: Size(411.42, 890.28),
      builder: (_, __) {
        return GetMaterialApp(
          title: 'Monteage Gym — Admin',
          debugShowCheckedModeBanner: false,
          getPages: AdminRoutes.routes,
          initialRoute: isLoggedIn
              ?AdminRoutes.ADMIN_SPLASH
              : AdminRoutes.ADMIN_SPLASH, //  Conditional entry
          theme: ThemeData(useMaterial3: true),
        );
      },
    );
  }
}
