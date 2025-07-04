import 'package:get/get.dart';
import '../controllers/admin_details_controller.dart';

class AdminDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdminDetailsController());
  }
}
