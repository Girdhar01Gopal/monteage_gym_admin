import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart' hide Data;
import 'package:image_picker/image_picker.dart';
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
          final active = controller.filteredMembers.where((e) => e.action == "Active").toList();
          final inactive = controller.filteredMembers.where((e) => e.action != "Active").toList();

          return TabBarView(
            children: [
              _buildMemberList(context, active),
              _buildMemberList(context, inactive),
            ],
          );
        }),
      ),
    );
  }

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
                  title: Text(
                    capitalizeFirst(member.name ?? ""),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
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
                        // ---------------- Personal Info ----------------
                        _infoSection("Personal Info", [
                          _info("Name", capitalizeFirst(member.name ?? "")),
                          _info("Father/Husband Name", member.fatherName ?? ""),
                          _info("Email", member.emailid ?? ""),
                          _info("Phone", member.phone ?? ""),
                          _info("WhatsApp", member.whatsappNo ?? ''),
                          _info("Emergency", member.emergencyNo ?? ''),
                          _info("Address", member.address ?? ""),
                          _info("Gender", member.gender ?? ""),
                        ]),
                        const Divider(),

                        // ---------------- Plan Info ----------------
                        _infoSection("Plan Info", [
                          _info("Plan", member.planTittle ?? ""),
                          _info("Plan Amount", "₹ ${member.price}"),
                          _info("Discount", "₹ ${member.discount}"),
                          _info("Payment", "₹ ${member.price}"),
                          _info("Joining Date", formatDate(member.joiningDate ?? "")),
                          _info("Next Fee Date", formatDate(member.packageExpiryDate ?? "")),
                          _info("Expiry Date", formatDate(member.packageExpiryDate ?? "")),
                          _info("Status", (member.action == "Active") ? "Active" : "Inactive"),
                        ]),
                        const Divider(),

                        // ---------------- Health Info ----------------
                        _infoSection("Health Info", [
                          _info("Height (ft)", member.height ?? ""),
                          _info("Weight", member.weight ?? ""),
                        ]),
                        const Divider(),

                        // ---------------- Trainer Info ----------------
                        _infoSection("Trainer Info", [
                          Obx(() => Text(
                            controller.isTrainerAssignedForMember(member)
                                ? "Trainer: Assigned"
                                : "Trainer: Not assigned",
                            style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
                          )),
                        ]),

                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FloatingActionButton.extended(
                            heroTag: null,
                            backgroundColor: Colors.indigo,
                            onPressed: () async {
                              final result = await Get.toNamed('/assigned-trainer', arguments: {
                                'memberData': member,
                              });

                              final assigned = (result == true) ||
                                  (result is Map && result['assigned'] == true);

                              if (assigned) {
                                controller.markTrainerAssignedForMember(member);
                              }
                            },
                            label: const Text("Personal Trainer", style: TextStyle(color: Colors.white)),
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

  Widget _infoSection(String heading, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        ...items,
      ],
    );
  }

  Widget _info(String label, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Expanded(
          child: Text(
            value ?? '-',
            style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
          ),
        ),
      ],
    );
  }

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

  String formatDate(String dateStr) {
    try {
      final dateTime = DateTime.parse(dateStr);
      return "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}";
    } catch (e) {
      return dateStr;
    }
  }

  String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
