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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Manage Gym Package's", style: TextStyle(color: Colors.white)),
          backgroundColor: AppColor.APP_Color_Indigo,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () => _showSearchDialog(context),
            )
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              color: Colors.white, // White background for the TabBar
              child: const TabBar(
                labelColor: AppColor.APP_Color_Indigo, // Selected tab text color
                unselectedLabelColor: Colors.grey,     // Unselected tab text color
                indicatorColor: AppColor.APP_Color_Indigo, // Indicator color
                indicatorWeight: 3,
                tabs: [
                  Tab(text: "Active Plans"),
                  Tab(text: "Inactive Plans"),
                ],
              ),
            ),
          ),
        ),

        body: TabBarView(
          children: [
            Obx(() => _buildPlanList(context, controller.activePlans)),
            Obx(() => _buildPlanList(context, controller.inactivePlans)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.indigo,
          onPressed: () => _showAddDialog(context),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildPlanList(BuildContext context, List<GymPlan> plans) {
    if (plans.isEmpty) {
      return const Center(child: Text("No plans found."));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        final fullIndex = controller.plans.indexWhere((p) => p.id == plan.id);
        return Dismissible(
          key: Key(plan.id.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) => controller.deletePlanById(plan.id),
          child: Card(
            elevation: 4,
            color: _getCardColor(plan.title),
            child: ListTile(
              title: Text('${plan.title} Plan', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Duration: ${plan.duration}'),
                  Text('Price: ₹${plan.price.toStringAsFixed(2)}'),
                  const SizedBox(height: 4),
                  const Text('Includes:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...plan.features.map((f) => Text('• $f')).toList(),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.indigo),
                onPressed: () => _showEditDialog(context, fullIndex, plan),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getCardColor(String title) {
    switch (title.toLowerCase()) {
      case 'gold':
        return const Color(0xFFFFD700);
      case 'silver':
        return const Color(0xFFC0C0C0);
      case 'platinum':
        return Colors.white;
      default:
        return Colors.grey.shade100;
    }
  }

  void _showSearchDialog(BuildContext context) {
    searchController.text = controller.searchQuery.value;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Search Plans"),
        content: TextField(
          controller: searchController,
          autofocus: true,
          decoration: const InputDecoration(hintText: "Search by title, duration, or feature"),
          onChanged: controller.applySearch,
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.applySearch(searchController.text);
              Get.back();
            },
            child: const Text("Search", style: TextStyle(color: AppColor.APP_Color_Indigo)),
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
    RxBool isActive = true.obs;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 20,
          left: 16,
          right: 16,
        ),
        child: SingleChildScrollView(
          child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Add New Plan", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Plan Title')),
              TextField(controller: durationController, decoration: const InputDecoration(labelText: 'Duration')),
              TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
              TextField(controller: featuresController, decoration: const InputDecoration(labelText: 'Includes (comma-separated)'), maxLines: 3),
              SwitchListTile(
                value: isActive.value,
                onChanged: (val) {
                  isActive.value = val;
                },
                title: const Text("Mark as Active"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  final plan = GymPlan(
                    id: DateTime.now().millisecondsSinceEpoch,
                    title: titleController.text.trim(),
                    duration: durationController.text.trim(),
                    price: double.tryParse(priceController.text.trim()) ?? 0,
                    features: featuresController.text.split(',').map((e) => e.trim()).toList(),
                    isActive: isActive.value,
                    action: isActive.value ? "Active" : "Inactive",
                    createdDate: DateTime.now(),
                  );
                  controller.addPlan(plan);
                  Get.back();
                },
                child: const Text("Add"),
              ),
              const SizedBox(height: 10),
            ],
          )),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, int index, GymPlan plan) {
    final titleController = TextEditingController(text: plan.title);
    final durationController = TextEditingController(text: plan.duration);
    final priceController = TextEditingController(text: plan.price.toString());
    final featuresController = TextEditingController(text: plan.features.join(', '));
    RxBool isActive = (plan.action.toLowerCase() == "active").obs;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 20,
          left: 16,
          right: 16,
        ),
        child: SingleChildScrollView(
          child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Edit Plan", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Plan Title')),
              TextField(controller: durationController, decoration: const InputDecoration(labelText: 'Duration')),
              TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
              TextField(controller: featuresController, decoration: const InputDecoration(labelText: 'Includes (comma-separated)'), maxLines: 3),
              SwitchListTile(
                value: isActive.value,
                onChanged: (val) {
                  isActive.value = val;
                },
                title: const Text("Mark as Active"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  final updatedPlan = GymPlan(
                    id: plan.id,
                    title: titleController.text.trim(),
                    duration: durationController.text.trim(),
                    price: double.tryParse(priceController.text.trim()) ?? plan.price,
                    features: featuresController.text.split(',').map((e) => e.trim()).toList(),
                    isActive: isActive.value,
                    action: isActive.value ? "Active" : "Inactive",
                    createdDate: plan.createdDate,
                  );

                  // Update the plan using the controller and ensure the tab is updated
                  controller.editPlan(index, updatedPlan);

                  // If the plan was made inactive, ensure it moves to the inactive tab
                  if (!isActive.value) {
                    controller.moveToInactive(updatedPlan);
                  }
                  Get.back();
                },
                child: const Text("Update"),
              ),
              const SizedBox(height: 10),
            ],
          )),
        ),
      ),
    );
  }}

