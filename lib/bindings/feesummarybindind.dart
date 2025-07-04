import 'package:get/get.dart';
import '../controllers/AdminFeeSummaryController.dart';


class Feesummarybindind extends Bindings {
  @override
  void dependencies() {
    // Lazy loading the controller so it only gets initialized when it's needed
    Get.lazyPut(() => AdminFeeSummaryController());
  }
}
