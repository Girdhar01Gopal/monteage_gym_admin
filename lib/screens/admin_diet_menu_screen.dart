import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/admin_diet_menu_controller.dart';
import '../utils/constants/color_constants.dart';

class AdminDietMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminDietMenuController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Diet Menu", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.APP_Color_Indigo,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [

            SizedBox(height: 20.h),

            // Veg and Non-Veg Categories
            Expanded(
              child: ListView(
                children: [
                  // Veg Section
                  _buildDietSection("Veg", controller),
                  SizedBox(height: 20.h),

                  // Non-Veg Section
                  _buildDietSection("Non-Veg", controller),
                ],
              ),
            ),

            // Add Diet Item Form Section (Initially Hidden)
            Obx(() {
              return controller.isAdding.value
                  ? _buildAddDietForm(controller)
                  : Container();
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.isAdding.value = !controller.isAdding.value; // Toggle to show/hide the add form
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: AppColor.APP_Color_Indigo,
      ),
    );
  }

  // Helper method to build each diet section (Veg or Non-Veg)
  Widget _buildDietSection(String category, AdminDietMenuController controller) {
    return Obx(() {
      var items = controller.dietMenuList[category]!;
      return ExpansionTile(
        title: Text(
          category,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        children: items.map((item) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: item['image'] != null
                    ? NetworkImage(item['image'])
                    : null, // Show the image if available
                child: item['image'] == null
                    ? Icon(Icons.person)
                    : null, // Default icon if no image
              ),
              title: Text(item['name']),
              subtitle: Text(item['description']),
            ),
          );
        }).toList(),
      );
    });
  }

  // Method to build the add diet form
  Widget _buildAddDietForm(AdminDietMenuController controller) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final nutritionController = TextEditingController();
    String category = 'Veg'; // Default category

    // Picked image for the diet menu item
    XFile? pickedImage;

    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: "Name"),
          ),
          SizedBox(height: 20.h),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: "Enter Diet Here"),
          ),
          SizedBox(height: 20.h),
          TextField(
            controller: nutritionController,
            decoration: InputDecoration(labelText: "Nutrition (Calories, Protein, etc.)"),
          ),
          SizedBox(height: 20.h),

          // Category Dropdown (Veg or Non-Veg)
          DropdownButton<String>(
            value: category,
            items: <String>['Veg', 'Non-Veg']
                .map((category) => DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            ))
                .toList(),
            onChanged: (value) {
              category = value!;
            },
          ),
          SizedBox(height: 20.h),

          // Image Picker Button
          ElevatedButton(
            onPressed: () async {
              final ImagePicker _picker = ImagePicker();
              pickedImage = await _picker.pickImage(source: ImageSource.gallery);
            },
            child: Text("Pick an Image"),
          ),
          SizedBox(height: 20.h),

          // Add New Diet Item Button
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty &&
                  nutritionController.text.isNotEmpty &&
                  pickedImage != null) {
                var newItem = {
                  'name': nameController.text,
                  'description': descriptionController.text,
                  'nutrition': nutritionController.text,
                  'image': pickedImage!.path,
                };
                controller.addDietMenuItem(newItem, category);
                Get.snackbar("Success", "$category Item added successfully", backgroundColor: Colors.green, colorText: Colors.white);
                Get.back(); // Go back after adding the item
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.APP_Color_Pink,
              padding: EdgeInsets.symmetric(vertical: 15.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
            ),
            child: Text("Add Diet", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
