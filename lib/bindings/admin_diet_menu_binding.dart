import 'package:get/get.dart';
import '../controllers/admin_diet_menu_controller.dart';

class AdminDietMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AdminDietMenuController());
  }
}
