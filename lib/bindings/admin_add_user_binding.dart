import 'package:get/get.dart';
import '../controllers/admin_add_user_controller.dart';

class AdminAddUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AdminAddUserController());
  }
}
