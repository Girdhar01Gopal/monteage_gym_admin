import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../infrastructure/routes/admin_routes.dart';

class AdminSplashController extends GetxController {
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 5), () {
      bool isLoggedIn = box.read('isLoggedIn') ?? false;
      if (isLoggedIn) {
        Get.offAllNamed(AdminRoutes.ADMIN_DASHBOARD);
      } else {
        Get.offAllNamed(AdminRoutes.ADMIN_LOGIN);
      }
    }
    );
  }
}
