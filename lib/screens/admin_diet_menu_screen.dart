import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_diet_menu_controller.dart';

class AdminDietMenuScreen extends StatelessWidget {
  final controller = Get.put(AdminDietMenuController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text("View Diet Pdf", style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          actions: [
            TextButton.icon(
              onPressed: controller.uploadPdf,
              icon: Icon(Icons.upload_file, color: Colors.white),
              label: Text("Upload PDF", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  labelText: 'Search PDF...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) => controller.filterPdfList(value),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.pdfFiles.isEmpty) {
                  return Center(child: Text("No PDFs uploaded Yet."));
                }
                return ListView.builder(
                  itemCount: controller.filteredPdfFiles.length,
                  itemBuilder: (context, index) {
                    final file = controller.filteredPdfFiles[index];
                    final fileSize = File(file.path).lengthSync();
                    final fileSizeInMB = fileSize / (1024 * 1024);
                    final formattedSize = fileSizeInMB.toStringAsFixed(2);

                    return ListTile(
                      title: Text(file.path.split('/').last),
                      subtitle: Text("Size: $formattedSize MB"),
                      leading: Icon(Icons.picture_as_pdf),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await Get.dialog(
                            AlertDialog(
                              title: Text("Confirm Delete"),
                              content: Text("Are you sure you want to delete this PDF?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(result: false),
                                  child: Text("No"),
                                ),
                                TextButton(
                                  onPressed: () => Get.back(result: true),
                                  child: Text("Yes"),
                                ),
                              ],
                            ),
                          );

                          if (confirm) {
                            controller.deletePdf(file);
                          }
                        },
                      ),
                      onTap: () => controller.openPdf(file),
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
}
