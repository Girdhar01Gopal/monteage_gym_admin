// admin_splash_controller.dart
import 'package:get/get.dart';
import '../infrastructure/routes/admin_routes.dart';

class AdminSplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed(AdminRoutes.ADMIN_LOGIN);
    });
  }
}
