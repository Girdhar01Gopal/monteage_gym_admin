import 'package:get/get.dart';

import '../controllers/admin_courses_controller.dart';

class AddCourseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdminCoursesController());
  }
}
