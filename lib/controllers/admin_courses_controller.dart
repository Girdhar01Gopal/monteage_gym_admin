import 'package:get/get.dart';

class AdminCoursesController extends GetxController {
  var courses = <Map<String, dynamic>>[].obs;
  var filteredCourses = <Map<String, dynamic>>[].obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCourses();
  }

  void fetchCourses() async {
    await Future.delayed(Duration(seconds: 1));
    courses.addAll([
      {'name': 'Yoga', 'description': 'A relaxing and mind-body exercise program.', 'isActive': true},
      {'name': 'Zumba', 'description': 'A high-energy dance workout for fitness.', 'isActive': true},
      {'name': 'HIIT', 'description': 'High-intensity interval training to burn fat.', 'isActive': false},
      {'name': 'Pilates', 'description': 'A low-impact exercise focusing on flexibility.', 'isActive': true},
      {'name': 'Cardio', 'description': 'Aerobic exercise to improve cardiovascular health.', 'isActive': true},
      {'name': 'Strength Training', 'description': 'Exercises to increase muscle strength.', 'isActive': false},
      {'name': 'Boxing', 'description': 'A full-body workout through punching exercises.', 'isActive': true},
      {'name': 'Spin Class', 'description': 'Indoor cycling for endurance and strength.', 'isActive': true},
      {'name': 'Crossfit', 'description': 'Functional training for strength and conditioning.', 'isActive': false},
      {'name': 'Kickboxing', 'description': 'A cardio workout combining martial arts with boxing.', 'isActive': true},
    ]);
    filteredCourses.assignAll(courses);
  }

  void addCourse(Map<String, dynamic> course) {
    courses.add(course);
    applySearchFilter(searchQuery.value);
  }

  void updateCourse(Map<String, dynamic> oldCourse, Map<String, dynamic> newCourse) {
    var index = courses.indexOf(oldCourse);
    if (index != -1) {
      courses[index] = newCourse;
      applySearchFilter(searchQuery.value);
    }
  }

  void applySearchFilter(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredCourses.assignAll(courses);
    } else {
      filteredCourses.assignAll(
        courses.where((course) => (course['name'] ?? '')
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase())),
      );
    }
  }
}
