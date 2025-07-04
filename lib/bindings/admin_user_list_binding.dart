import 'package:get/get.dart';
import '../controllers/admin_user_list_controller.dart';

class AdminUserListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdminUserListController());
  }
}
