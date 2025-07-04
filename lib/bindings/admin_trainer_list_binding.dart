import 'package:get/get.dart';
import '../controllers/admin_trainer_list_controller.dart';

class AdminTrainerListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AdminTrainerListController());
  }
}
