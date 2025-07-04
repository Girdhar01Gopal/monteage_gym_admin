import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controllers/admin_plan_management_controller.dart';
import '../utils/constants/color_constants.dart';

class SubsciptionPlanScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlanManagementController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.APP_Color_Indigo,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),  // White back arrow
          onPressed: () => Get.back(),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Plan Management",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => showPlanDialog(controller),
          ),
        ],
      ),
      body: Obx(() => controller.plans.isEmpty
          ? Center(child: Text("No plans available"))
          : ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: controller.plans.length,
        itemBuilder: (context, index) {
          final plan = controller.plans[index];
          return Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 10.h),
            child: ListTile(
              title: Text(
                plan.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              subtitle: Text("₹${plan.price} - ${plan.description}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () =>
                        showPlanDialog(controller, isEdit: true, index: index, plan: plan),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => controller.deletePlan(index),
                  ),
                ],
              ),
            ),
          );
        },
      )),
    );
  }

  void showPlanDialog(PlanManagementController controller,
      {bool isEdit = false, int? index, Plan? plan}) {
    if (isEdit && plan != null) {
      nameController.text = plan.name;
      priceController.text = plan.price.toString();
      descController.text = plan.description;
    } else {
      nameController.clear();
      priceController.clear();
      descController.clear();
    }

    Get.defaultDialog(
      title: isEdit ? "Edit Plan" : "Add New Plan",
      content: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: "Plan Name"),
          ),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Price (INR)"),
          ),
          TextField(
            controller: descController,
            decoration: InputDecoration(labelText: "Description"),
          ),
        ],
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.APP_Color_Indigo,
        ),
        onPressed: () {
          if (nameController.text.isNotEmpty &&
              priceController.text.isNotEmpty) {
            final newPlan = Plan(
              name: nameController.text,
              price: int.tryParse(priceController.text) ?? 0,
              description: descController.text,
            );
            if (isEdit && index != null) {
              controller.updatePlan(index, newPlan);
            } else {
              controller.addPlan(newPlan);
            }
            Get.back();
          }
        },
        child: Text(
          isEdit ? "Update" : "Add",
          style: TextStyle(color: Colors.white),
        ),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: Text("Cancel"),
      ),
    );
  }
}
