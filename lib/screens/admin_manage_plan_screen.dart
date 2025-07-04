import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_manage_plan_controller.dart';
import '../models/gym_plan.dart';
import '../utils/constants/color_constants.dart';

class AdminManagePlanScreen extends StatelessWidget {
  final controller = Get.put(AdminManagePlanController());
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Manage Gym Package's", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.APP_Color_Indigo,
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
      body: Obx(() {
        if (controller.filteredPlans.isEmpty) {
          return Center(child: Text("No plans found."));
        }
        return ListView.builder(
          controller: controller.scrollController,
          padding: EdgeInsets.all(16),
          itemCount: controller.filteredPlans.length,
          itemBuilder: (context, index) {
            final plan = controller.filteredPlans[index];
            return Dismissible(
              key: Key(plan.id.toString()),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (_) => controller.deletePlan(index),
              child: Card(
                elevation: 4,
                child: ListTile(
                  title: Text('${plan.title} Plan', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Duration: ${plan.duration}'),
                        Text('Price: ₹${plan.price.toStringAsFixed(2)}'),
                        SizedBox(height: 4),
                        Text('Includes:', style: TextStyle(fontWeight: FontWeight.bold)),
                        ...plan.features.map((f) => Text('• $f')).toList(),
                      ],
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit, color: Colors.indigo),
                    onPressed: () => _showEditDialog(context, controller, index, plan),
                  ),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        backgroundColor: Colors.indigo,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    final controller = Get.find<AdminManagePlanController>();
    searchController.text = controller.searchQuery.value;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Search Plans"),
        content: TextField(
          controller: searchController,
          autofocus: true,
          decoration: InputDecoration(hintText: "Search by title, duration, or feature"),
          onChanged: controller.applySearch,
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.applySearch(searchController.text);
              Get.back();
            },
            child: Text("Search", style: TextStyle(color: AppColor.APP_Color_Indigo)),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final titleController = TextEditingController();
    final durationController = TextEditingController();
    final priceController = TextEditingController();
    final featuresController = TextEditingController();

    Get.defaultDialog(
      title: 'Add New Plan',
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: 'Plan Title')),
            TextField(controller: durationController, decoration: InputDecoration(labelText: 'Duration')),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price (₹)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: featuresController,
              decoration: InputDecoration(labelText: 'Features (comma separated)'),
              maxLines: 3,
            ),
          ],
        ),
      ),
      textConfirm: 'Add',
      textCancel: 'Cancel',
      onConfirm: () {
        final plan = GymPlan(
          id: DateTime.now().millisecondsSinceEpoch,
          title: titleController.text.trim(),
          duration: durationController.text.trim(),
          price: double.tryParse(priceController.text.trim()) ?? 0,
          features: featuresController.text.split(',').map((e) => e.trim()).toList(),
        );
        controller.addPlan(plan);
        Get.back();
      },
    );
  }

  void _showEditDialog(BuildContext context, AdminManagePlanController controller, int index, GymPlan plan) {
    final titleController = TextEditingController(text: plan.title);
    final durationController = TextEditingController(text: plan.duration);
    final priceController = TextEditingController(text: plan.price.toString());
    final featuresController = TextEditingController(text: plan.features.join(', '));

    Get.defaultDialog(
      title: 'Edit Plan',
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: 'Plan Title')),
            TextField(controller: durationController, decoration: InputDecoration(labelText: 'Duration')),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price (₹)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: featuresController,
              decoration: InputDecoration(labelText: 'Features (comma separated)'),
              maxLines: 3,
            ),
          ],
        ),
      ),
      textConfirm: 'Update',
      textCancel: 'Cancel',
      onConfirm: () {
        final updatedPlan = GymPlan(
          id: plan.id,
          title: titleController.text.trim(),
          duration: durationController.text.trim(),
          price: double.tryParse(priceController.text.trim()) ?? plan.price,
          features: featuresController.text.split(',').map((e) => e.trim()).toList(),
        );
        controller.editPlan(index, updatedPlan);
        Get.back();
      },
    );
  }
}
