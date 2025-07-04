import 'package:get/get.dart';
import '../controllers/admin_add_trainer_controller.dart';

class AddTrainerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AdminAddTrainerController());
  }
}
