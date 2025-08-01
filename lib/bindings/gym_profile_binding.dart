import 'package:get/get.dart';
import '../controllers/gym_profile_controller.dart';

class GymProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GymProfileController>(() => GymProfileController());
  }
}
