import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_courses_controller.dart';
import '../utils/constants/color_constants.dart';
import '../utils/custom_text.dart';

class AdminCoursesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminCoursesController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Courses", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.APP_Color_Indigo,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(data: "Courses List", fontSize: 24.0, fontWeight: FontWeight.bold),
            SizedBox(height: 20.0),
            // List of courses will be shown here
            Obx(() {
              if (controller.courses.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: controller.courses.length,
                itemBuilder: (context, index) {
                  var course = controller.courses[index];
                  return ListTile(
                    title: Text(course['name']!),
                    subtitle: Text(course['description']!),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Navigate to edit course page
                        Get.toNamed('/edit-course', arguments: course);
                      },
                    ),
                  );
                },
              );
            }),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => Get.toNamed('/add-course'),
              child: Text("Add New Course"),
            ),
          ],
        ),
      ),
    );
  }
}
