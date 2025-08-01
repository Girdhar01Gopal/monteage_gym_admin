import 'package:get/get.dart';
import '../controllers/admin_qr_payment_controller.dart';

class AdminQrPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdminQrPaymentController());
  }
}
