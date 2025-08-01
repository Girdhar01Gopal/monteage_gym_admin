import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/admin_courses_controller.dart';

class AddCourseScreen extends StatelessWidget {
  final controller = Get.find<AdminCoursesController>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final searchController = TextEditingController();

  String formatDate(dynamic date) {
    if (date is DateTime) {
      return DateFormat('dd-MM-yyyy').format(date);
    }
    if (date is String) {
      try {
        return DateFormat('dd-MM-yyyy').format(DateTime.parse(date));
      } catch (_) {
        return date;
      }
    }
    return '-';
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text("Courses", style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () => _showSearchDialog(context),
            )
          ],
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                labelColor: Colors.indigo,
                indicatorColor: Colors.indigo,
                tabs: const [
                  Tab(text: "Active Courses"),
                  Tab(text: "Inactive Courses"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Obx(() => _buildCourseList(context, controller.activeCourses)),
                  Obx(() => _buildCourseList(context, controller.inactiveCourses)),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.indigo,
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () {
            nameController.clear();
            descriptionController.clear();
            _showAddDialog(context);
          },
        ),
      ),
    );
  }

  Widget _buildCourseList(BuildContext context, List<Map<String, dynamic>> courseList) {
    if (courseList.isEmpty) {
      return Center(child: Text("No courses available."));
    }

    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: courseList.length,
      itemBuilder: (context, index) {
        final course = courseList[index];
        return Dismissible(
          key: Key(course['name']),
          direction: DismissDirection.endToStart,
          onDismissed: (_) {
            controller.deleteCourse(course);
            Get.snackbar("Deleted", "Course deleted successfully",
                backgroundColor: Colors.red, colorText: Colors.white);
          },
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 20),
            color: Colors.red,
            child: Icon(Icons.delete, color: Colors.white),
          ),
          child: Card(
            elevation: 3,
            margin: EdgeInsets.only(bottom: 12),
            child: Stack(
              children: [
                ListTile(
                  title: Text(course['name'] ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(course['description'] ?? ''),
                      SizedBox(height: 5),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit, color: Colors.indigo),
                    onPressed: () {
                      nameController.text = course['name'] ?? '';
                      descriptionController.text = course['description'] ?? '';
                      _showEditDialog(context, course);
                    },
                  ),
                ),
                Positioned(
                  right: 50,
                  top: 8,
                  child: Text(
                    "Created: ${formatDate(course['createdAt'])}",
                    style: TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddDialog(BuildContext context) {
    final now = DateTime.now();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Add Course"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
              TextField(controller: descriptionController, decoration: InputDecoration(labelText: "Description")),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
                controller.addCourse({
                  'name': nameController.text,
                  'description': descriptionController.text,
                  'isActive': true,
                  'createdAt': now,
                  'updatedAt': now,
                });
                Get.back();
                Get.snackbar("Added", "Course added successfully",
                    backgroundColor: Colors.green, colorText: Colors.white);
              }
            },
            child: Text("Add", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> course) {
    bool isActive = course['isActive'] ?? true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Edit Course"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
                  TextField(controller: descriptionController, decoration: InputDecoration(labelText: "Description")),
                  SwitchListTile(
                    value: isActive,
                    title: Text("Active"),
                    onChanged: (val) => setState(() => isActive = val),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final now = DateTime.now();
                  controller.updateCourse(course, {
                    'name': nameController.text,
                    'description': descriptionController.text,
                    'isActive': isActive,
                    'createdAt': course['createdAt'],
                    'updatedAt': now,
                  });
                  Get.back();
                  Get.snackbar("Updated", "Course updated",
                      backgroundColor: Colors.green, colorText: Colors.white);
                },
                child: Text("Update", style: TextStyle(color: Colors.blue)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    searchController.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Search Course"),
        content: TextField(
          controller: searchController,
          decoration: InputDecoration(hintText: "Enter name or description..."),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.searchCourses(searchController.text);
              Get.back();
            },
            child: Text("Search", style: TextStyle(color: Colors.indigo)),
          ),
        ],
      ),
    );
  }
}
