import 'package:get/get.dart';
import '../controllers/admin_gym_pass_controller.dart';

class AdminGymPassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdminGymPassController());
  }
}
