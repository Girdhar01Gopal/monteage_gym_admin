import 'package:get/get.dart';

class AdminCoursesController extends GetxController {
  var courses = <Map<String, dynamic>>[].obs;
  var filteredCourses = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCourses();
  }

  void fetchCourses() async {
    await Future.delayed(Duration(milliseconds: 500));
    final now = DateTime.now();
    courses.addAll([
      {
        'name': 'Yoga',
        'description': 'Relaxing and mindful exercise.',
        'isActive': true,
        'createdAt': now,
        'updatedAt': now,
      },
      {
        'name': 'Zumba',
        'description': 'High-energy dance workout.',
        'isActive': true,
        'createdAt': now,
        'updatedAt': now,
      },
      {
        'name': 'HIIT',
        'description': 'High-intensity interval training.',
        'isActive': false,
        'createdAt': now,
        'updatedAt': now,
      },
    ]);
    filteredCourses.assignAll(courses);
  }

  List<Map<String, dynamic>> get activeCourses =>
      filteredCourses.where((e) => e['isActive'] == true).toList();

  List<Map<String, dynamic>> get inactiveCourses =>
      filteredCourses.where((e) => e['isActive'] == false).toList();

  void addCourse(Map<String, dynamic> course) {
    courses.add(course);
    filteredCourses.assignAll(courses);
  }

  void updateCourse(Map<String, dynamic> oldCourse, Map<String, dynamic> newCourse) {
    final index = courses.indexOf(oldCourse);
    if (index != -1) {
      courses[index] = newCourse;
      filteredCourses.assignAll(courses);
    }
  }

  void deleteCourse(Map<String, dynamic> course) {
    courses.remove(course);
    filteredCourses.assignAll(courses);
  }

  void searchCourses(String query) {
    if (query.trim().isEmpty) {
      filteredCourses.assignAll(courses);
    } else {
      final lower = query.toLowerCase();
      filteredCourses.assignAll(courses.where((c) =>
      (c['name'] ?? '').toString().toLowerCase().contains(lower) ||
          (c['description'] ?? '').toString().toLowerCase().contains(lower)));
    }
  }
}
