import 'package:get/get.dart';
import '../controllers/admin_plan_management_controller.dart';


class AdminPlanManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PlanManagementController());
  }
}
