import 'package:get/get.dart';
import '../controllers/admin_manage_plan_controller.dart';


class AdminManagePlanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminManagePlanController>(() => AdminManagePlanController());
  }
}
