import 'package:get/get.dart';
import '../controllers/admin_fee_payments_controller.dart';

class AdminFeePaymentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AdminFeePaymentsController());
  }
}
