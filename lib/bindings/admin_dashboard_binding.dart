import 'package:get/get.dart';
import '../controllers/admin_dashboard_controller.dart';

class AdminDashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Lazy loading the controller so it only gets initialized when it's needed
    Get.lazyPut(() => AdminDashboardController());

  }
}
