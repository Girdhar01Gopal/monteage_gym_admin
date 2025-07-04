import 'package:get/get.dart';
import '../controllers/admin_daily_collection_controller.dart';

class AdminDailyCollectionBinding extends Bindings {
  @override
  void dependencies() {
    // Lazy load the controller when the page is navigated to
    Get.lazyPut<AdminDailyCollectionController>(() => AdminDailyCollectionController());
  }
}
