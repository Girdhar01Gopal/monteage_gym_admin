import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/constants/color_constants.dart';
import '../controllers/admin_user_list_controller.dart';
import '../models/membermodel.dart';

class AdminUserListScreen extends StatelessWidget {
  final controller = Get.put(AdminUserListController());
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Members List", style: TextStyle(color: Colors.white)),
          backgroundColor: AppColor.APP_Color_Indigo,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              color: Colors.white,
              child: const TabBar(
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black54,
                labelStyle: TextStyle(fontWeight: FontWeight.w600),
                tabs: [
                  Tab(text: "Active"),
                  Tab(text: "Inactive"),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () => _showSearchDialog(context),
            ),
          ],
        ),
        body: Obx(() {
          // Get active and inactive members based on the 'Action' field
          final active = controller.filteredMembers.where((e) => e.action == "Active").toList();
          final inactive = controller.filteredMembers.where((e) => e.action != "Active").toList();

          return TabBarView(
            children: [
              _buildMemberList(context, active),  // Active tab
              _buildMemberList(context, inactive),  // Inactive tab
            ],
          );
        }),
      ),
    );
  }

  // Build the list of members based on status (active/inactive)
  Widget _buildMemberList(BuildContext context, List<Data> members) {
    if (members.isEmpty) {
      return const Center(child: Text("No members found."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        return Obx(() {
          final isExpanded = controller.expandedCardIndex.value == index;

          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                ListTile(
                  title: Text(member.name ?? "", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                        buildRow("Father/Husband Name", member.fatherName ?? ""),
                        buildRow("Email", member.emailid ?? ""),
                        buildRow("Phone", member.phone ?? ""),
                        buildRow("WhatsApp", member.whatsappNo ?? ''),
                        buildRow("Emergency", member.emergencyNo ?? ''),
                        buildRow("Address", member.address ?? ""),
                        buildRow("Gender", member.gender ?? ""),
                        buildRow("Plan", member.planTittle ?? ""),
                        buildRow("Plan Amount", "₹ ${member.price}"),
                        buildRow("Height", member.height ?? ""),
                        buildRow("Weight", member.weight ?? ""),
                        buildRow("Joining Date", formatDate(member.joiningDate ?? "")),
                        buildRow("Discount", "₹ ${member.discount}"),
                        buildRow("Payment", "₹ ${member.price}"),
                        buildRow("Next Fee Date", formatDate(member.packageExpiryDate ?? "")),
                        buildRow("Expiry Date", formatDate(member.packageExpiryDate ?? "")),
                        buildRow("Status", member.action == "Active" ? 'Active' : 'Inactive'),

                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FloatingActionButton.extended(
                            heroTag: null,
                            backgroundColor: Colors.indigo,
                            onPressed: () {
                              Get.toNamed('/assigned-trainer', arguments: {
                                'memberIndex': index,
                                'memberData': member,
                              });
                            },
                            label: const Text("Assign Trainer", style: TextStyle(color: Colors.white)),
                            icon: const Icon(Icons.fitness_center, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
              ],
            ),
          );
        });
      },
    );
  }

  // Build a row for displaying member data
  Widget buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 160, child: Text("$label:", style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  // Show the search dialog for filtering members
  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Search Member"),
        content: TextField(
          controller: searchController,
          autofocus: true,
          onChanged: controller.filterMembers,
          decoration: const InputDecoration(
            hintText: "Search by name, email or phone",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              searchController.clear();
              controller.filterMembers('');
              Get.back();
            },
            child: const Text("Clear"),
          ),
          ElevatedButton(onPressed: () => Get.back(), child: const Text("Close")),
        ],
      ),
    );
  }

  // Format date from string
  String formatDate(String dateStr) {
    try {
      final parts = dateStr.split(RegExp(r'[-/]'));
      if (parts.length == 3) {
        final day = parts[0].length == 4 ? parts[2] : parts[0];
        final month = parts[0].length == 4 ? parts[1] : parts[1];
        final year = parts[0].length == 4 ? parts[0] : parts[2];
        return "$day-$month-$year";
      }
    } catch (_) {}
    return dateStr;
  }
}


/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/constants/color_constants.dart';
import '../controllers/admin_user_list_controller.dart';
import '../models/membermodel.dart';

class AdminUserListScreen extends StatelessWidget {
  final controller = Get.put(AdminUserListController());
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Members List", style: TextStyle(color: Colors.white)),
          backgroundColor: AppColor.APP_Color_Indigo,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              color: Colors.white,
              child: const TabBar(
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black54,
                labelStyle: TextStyle(fontWeight: FontWeight.w600),
                tabs: [
                  Tab(text: "Active"),
                  Tab(text: "Inactive"),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () => _showSearchDialog(context),
            ),
          ],
        ),
        body: Obx(() {
          // Get active and inactive members based on the 'Action' field
          final active = controller.filteredMembers.where((e) => e.action == "Active").toList();
          final inactive = controller.filteredMembers.where((e) => e.action != "Active").toList();

          return TabBarView(
            children: [
              _buildMemberList(context, active),  // Active tab
              _buildMemberList(context, inactive),  // Inactive tab
            ],
          );
        }),
      ),
    );
  }

  // Build the list of members based on status (active/inactive)
  Widget _buildMemberList(BuildContext context, List<Data> members) {
    if (members.isEmpty) {
      return const Center(child: Text("No members found."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        return Obx(() {
          final isExpanded = controller.expandedCardIndex.value == index;

          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.person, size: 24, color: Colors.white), // Simple person icon
                  ),
                  title: Text(member.name ?? "", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                        buildRow("Father/Husband Name", member.fatherName ?? ""),
                        buildRow("Email", member.emailid ?? ""),
                        buildRow("Phone", member.phone ?? ""),
                        buildRow("WhatsApp", member.whatsappNo ?? ''),
                        buildRow("Emergency", member.emergencyNo ?? ''),
                        buildRow("Address", member.address ?? ""),
                        buildRow("Gender", member.gender ?? ""),
                        buildRow("Plan", member.planTittle ?? ""),
                        buildRow("Plan Amount", "₹ ${member.price}"),
                        buildRow("Height", member.height ?? ""),
                        buildRow("Weight", member.weight ?? ""),
                        buildRow("Joining Date", formatDate(member.joiningDate ?? "")),
                        buildRow("Discount", "₹ ${member.discount}"),
                        buildRow("Payment", "₹ ${member.price}"),
                        buildRow("Next Fee Date", formatDate(member.packageExpiryDate ?? "")),
                        buildRow("Expiry Date", formatDate(member.packageExpiryDate ?? "")),
                        buildRow("Status", member.action == "Active" ? 'Active' : 'Inactive'),

                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FloatingActionButton.extended(
                            heroTag: null,
                            backgroundColor: Colors.indigo,
                            onPressed: () {
                              Get.toNamed('/assigned-trainer', arguments: {
                                'memberIndex': index,
                                'memberData': member,
                              });
                            },
                            label: const Text("Assign Trainer", style: TextStyle(color: Colors.white)),
                            icon: const Icon(Icons.fitness_center, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
              ],
            ),
          );
        });
      },
    );
  }

  // Build a row for displaying member data
  Widget buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 160, child: Text("$label:", style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  // Show the search dialog for filtering members
  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Search Member"),
        content: TextField(
          controller: searchController,
          autofocus: true,
          onChanged: controller.filterMembers,
          decoration: const InputDecoration(
            hintText: "Search by name, email or phone",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              searchController.clear();
              controller.filterMembers('');
              Get.back();
            },
            child: const Text("Clear"),
          ),
          ElevatedButton(onPressed: () => Get.back(), child: const Text("Close")),
        ],
      ),
    );
  }

  // Format date from string
  String formatDate(String dateStr) {
    try {
      final parts = dateStr.split(RegExp(r'[-/]'));
      if (parts.length == 3) {
        final day = parts[0].length == 4 ? parts[2] : parts[0];
        final month = parts[0].length == 4 ? parts[1] : parts[1];
        final year = parts[0].length == 4 ? parts[0] : parts[2];
        return "$day-$month-$year";
      }
    } catch (_) {}
    return dateStr;
  }
}
*/