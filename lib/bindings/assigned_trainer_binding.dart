import 'package:get/get.dart';
import '../controllers/assigned_trainer_controller.dart';

class AssignedTrainerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssignedTrainerController>(() => AssignedTrainerController());
  }
}
