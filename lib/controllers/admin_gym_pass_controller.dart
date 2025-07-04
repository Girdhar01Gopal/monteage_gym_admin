import 'package:get/get.dart';

class AdminGymPassController extends GetxController {
  var id = "".obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments is List && Get.arguments.isNotEmpty) {
      id.value = Get.arguments[0];
      print("Id ==> ${id.value}");
    } else {
      // Optional: fallback value or error
      id.value = "DEFAULT"; // or show error
      print("No valid arguments passed to AdminGymPassController");
    }
  }
}
