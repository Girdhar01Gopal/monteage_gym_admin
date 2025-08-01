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
            TextButton(
              onPressed: controller.uploadPdf,
              child: Row(
                children: const [
                  Text("Upload pdf", style: TextStyle(color: Colors.white)),
                  SizedBox(width: 4),
                  Icon(Icons.upload_file, color: Colors.white),
                ],
              ),
            ),
          ],

        ),
      body: Obx(() {
        if (controller.pdfFiles.isEmpty) {
          return Center(child: Text("No PDFs uploaded Yet."));
        }

        return ListView.builder(
          itemCount: controller.pdfFiles.length,
          itemBuilder: (context, index) {
            final file = controller.pdfFiles[index];
            return ListTile(
              title: Text(file.path.split('/').last),
              leading: Icon(Icons.picture_as_pdf),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => controller.deletePdf(file),
              ),
              onTap: () => controller.openPdf(file),
            );
          },
        );
      }),
    ));
  }
}
