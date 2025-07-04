import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_courses_controller.dart';
import '../utils/constants/color_constants.dart';

class AddCourseScreen extends StatelessWidget {
  final AdminCoursesController controller = Get.find<AdminCoursesController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Course's/List's", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.APP_Color_Indigo,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              _showSearchDialog(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              _showAddCourseDialog(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.filteredCourses.isEmpty) {
                  return Center(child: Text("No courses found"));
                }
                return ListView.builder(
                  itemCount: controller.filteredCourses.length,
                  itemBuilder: (context, index) {
                    var course = controller.filteredCourses[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                        title: Text(
                          course['name'] ?? 'No Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColor.APP_Color_Indigo,
                          ),
                        ),
                        subtitle: Text(course['description'] ?? 'No Description'),
                        trailing: IconButton(
                          icon: Icon(Icons.edit, color: AppColor.APP_Color_Indigo),
                          onPressed: () {
                            nameController.text = course['name'] ?? '';
                            descriptionController.text = course['description'] ?? '';
                            _showEditCourseDialog(context, course);
                          },
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCourseDialog(BuildContext context) {
    nameController.clear();
    descriptionController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Course"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: "Course Name")),
              SizedBox(height: 10),
              TextField(controller: descriptionController, decoration: InputDecoration(labelText: "Course Description")),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
                  controller.addCourse({
                    'name': nameController.text,
                    'description': descriptionController.text,
                    'isActive': true,
                  });
                  Get.back();
                  Get.snackbar("Success", "Course added successfully",
                      snackPosition: SnackPosition.TOP, backgroundColor: Colors.green, colorText: Colors.white);
                } else {
                  Get.snackbar("Error", "Please fill all fields",
                      snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
                }
              },
              child: Text("Add Course", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _showEditCourseDialog(BuildContext context, Map<String, dynamic> course) {
    showDialog(
      context: context,
      builder: (context) {
        bool isActive = course['isActive'] ?? true;
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text("Edit Course"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: InputDecoration(labelText: "Course Name")),
                SizedBox(height: 10),
                TextField(controller: descriptionController, decoration: InputDecoration(labelText: "Course Description")),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text("Active: "),
                    Switch(
                      value: isActive,
                      onChanged: (val) => setState(() => isActive = val),
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
                    controller.updateCourse(course, {
                      'name': nameController.text,
                      'description': descriptionController.text,
                      'isActive': isActive,
                    });
                    Get.back();
                    Get.snackbar("Success", "Course updated successfully",
                        snackPosition: SnackPosition.TOP, backgroundColor: Colors.green, colorText: Colors.white);
                  } else {
                    Get.snackbar("Error", "Please fill all fields",
                        snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
                  }
                },
                child: Text("Update Course", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        });
      },
    );
  }

  void _showSearchDialog(BuildContext context) {
    searchController.text = controller.searchQuery.value;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Search Courses"),
          content: TextField(
            controller: searchController,
            autofocus: true,
            decoration: InputDecoration(hintText: "Enter course name..."),
            onChanged: (query) => controller.applySearchFilter(query),
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.applySearchFilter(searchController.text);
                Get.back();
              },
              child: Text("Search", style: TextStyle(color: AppColor.APP_Color_Indigo)),
            ),
          ],
        );
      },
    );
  }
}
