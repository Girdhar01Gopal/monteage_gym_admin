import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_active_users_controller.dart';
import '../../utils/constants/color_constants.dart';

class AdminActiveUsersScreen extends StatelessWidget {
  final controller = Get.put(AdminActiveUsersController());
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Active Users", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.APP_Color_Indigo,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => _showSearchDialog(context),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: const [
            TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.pink,
              tabs: [
                Tab(text: "Morning Users"),
                Tab(text: "Evening Users"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _SessionUserList(session: "Morning"),
                  _SessionUserList(session: "Evening"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Search User"),
        content: TextField(
          controller: searchController,
          autofocus: true,
          onChanged: controller.filterUsers,
          decoration: const InputDecoration(
            hintText: "Search by name, email or phone",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              searchController.clear();
              controller.filterUsers('');
              Get.back();
            },
            child: const Text("Clear"),
          ),
          ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Edit User"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Obx(() => Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: controller.imageFile.value != null
                          ? FileImage(controller.imageFile.value!)
                          : const AssetImage("assets/images/person.png") as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: controller.showImagePickerOptions,
                        child: const CircleAvatar(
                          backgroundColor: Colors.indigo,
                          radius: 14,
                          child: Icon(Icons.edit, size: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )),
                const SizedBox(height: 10),
                _textField("Name", controller.nameController),
                _textField("Email", controller.emailController),
                _textField("Phone", controller.phoneController),
                _textField("Address", controller.addressController),
                _textField("Height", controller.heightController),
                _textField("Weight", controller.weightController),
                _dropdown("Gender", controller.gender, ['Male', 'Female', 'Other']),
                _dropdown("Trainer", controller.trainerType, ['Personal Trainer', 'General Trainer']),
                _dropdown("Trainer Gender", controller.trainerGender, ['Male', 'Female']),
                _dropdown("Plan", controller.plan, ['Platinum', 'Gold', 'Silver']),
                _textField("Joining Date", controller.joinDateController),
                _textField("Discount", controller.discountController),
                _textField("Payment", controller.paymentController),
                _textField("Next Fee Date", controller.nextFeeDateController),
                _textField("Expiry Date", controller.expiryDateController),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
            ElevatedButton(onPressed: controller.updateUser, child: const Text("Save")),
          ],
        );
      },
    );
  }

  Widget _textField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }

  Widget _dropdown(String label, RxString selected, List<String> items) {
    return Obx(() => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: DropdownButtonFormField<String>(
        value: selected.value.isEmpty ? null : selected.value,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (val) => selected.value = val ?? '',
      ),
    ));
  }
}

class _SessionUserList extends StatelessWidget {
  final String session;
  const _SessionUserList({required this.session});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminActiveUsersController>();

    return Obx(() {
      final users = controller.filteredUsers
          .where((user) => user['session_time'] == session)
          .toList();

      if (users.isEmpty) {
        return Center(child: Text("No $session users found."));
      }

      return ListView.builder(
        itemCount: users.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final user = users[index];
          final isExpanded = controller.expandedCardIndex.value == index;

          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: user['avatar'].toString().startsWith('assets')
                        ? AssetImage(user['avatar']) as ImageProvider
                        : FileImage(File(user['avatar'])),
                  ),
                  title: Text(user['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  trailing: IconButton(
                    icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                    onPressed: () => controller.toggleCardExpansion(index),
                  ),
                ),
                if (isExpanded)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRow("Email", user['email']),
                        _buildRow("Phone", user['phone']),
                        _buildRow("Address", user['address']),
                        _buildRow("Gender", user['gender']),
                        _buildRow("Trainer Type", user['trainer']),
                        _buildRow("Trainer Gender", user['trainer_gender']),
                        _buildRow("Plan", user['plan']),
                        _buildRow("Height", "${user['height']} cm"),
                        _buildRow("Weight", "${user['weight']} kg"),
                        _buildRow("Joining Date", user['joining_date']),
                        _buildRow("Discount", "₹ ${user['discount']}"),
                        _buildRow("Payment", "₹ ${user['payment']}"),
                        _buildRow("Next Fee Date", user['next_fee_date']),
                        _buildRow("Expiry Date", user['expiry_date']),
                        _buildRow("Status", user['status']),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.populateFields(user, index);
                              final parent = context.findAncestorWidgetOfExactType<AdminActiveUsersScreen>();
                              parent?._showEditDialog(context);
                            },
                            child: const Text("Edit"),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      );
    });
  }

  static Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(width: 160, child: Text("$label:", style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
