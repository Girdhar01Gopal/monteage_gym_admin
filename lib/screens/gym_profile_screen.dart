import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/gym_profile_controller.dart';
import '../utils/constants/color_constants.dart';

class GymProfileScreen extends StatefulWidget {
  const GymProfileScreen({Key? key}) : super(key: key);

  @override
  _GymProfileScreenState createState() => _GymProfileScreenState();
}

class _GymProfileScreenState extends State<GymProfileScreen> {
  final controller = Get.find<GymProfileController>();

  // Form controllers
  final nameCtrl        = TextEditingController();
  final addressCtrl     = TextEditingController();
  final cityCtrl        = TextEditingController();
  final stateCtrl       = TextEditingController();
  final pinCtrl         = TextEditingController();
  final contactCtrl     = TextEditingController();
  final emailCtrl       = TextEditingController();
  final websiteCtrl     = TextEditingController();
  final ownerNameCtrl   = TextEditingController();
  final ownerMobileCtrl = TextEditingController();

  // Image state
  File? selectedImage;
  String base64Image = '';

  @override
  void dispose() {
    // Dispose controllers
    nameCtrl.dispose();
    addressCtrl.dispose();
    cityCtrl.dispose();
    stateCtrl.dispose();
    pinCtrl.dispose();
    contactCtrl.dispose();
    emailCtrl.dispose();
    websiteCtrl.dispose();
    ownerNameCtrl.dispose();
    ownerMobileCtrl.dispose();
    super.dispose();
  }

  ///  _pickImage snippet
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final file = File(picked.path);
      final bytes = await file.readAsBytes();
      setState(() {
        selectedImage = file;
        base64Image    = base64Encode(bytes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Gym Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.APP_Color_Indigo,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: Get.back),
      ),
      body: Obx(() {
        final list = controller.profile['data'] as List<dynamic>?; // Get the data
        if (list == null || list.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = list.first as Map<String, dynamic>;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                Center(
                  child: GestureDetector(
                    onTap: pickImage,
                    child: Obx(() {
                      final dataLogo = controller.profile['data'].first['logo'] as String?;
                      final avatar = selectedImage != null
                          ? FileImage(selectedImage!)
                          : (dataLogo != null && dataLogo.isNotEmpty && File(dataLogo).existsSync()
                          ? FileImage(File(dataLogo))
                          : const AssetImage('assets/images/logo.jpeg'));
                      return CircleAvatar(radius: 50, backgroundImage: avatar as ImageProvider);
                    }),
                  ),
                ),
                const SizedBox(height: 16),
                _buildRow("Gym Name",    data['GymName']      ?? "N/A", bold: true, fontSize: 20),
                _buildRow("Owner",       data['PersonName']   ?? "N/A", bold: true),
                _buildLinkRow("Owner Mobile", data['ContactNo']  ?? "N/A", "tel:${data['ContactNo']}"),
                _buildRow("Address",     data['Address']      ?? "N/A"),
                _buildRow("City",        data['City']         ?? "N/A"),
                _buildRow("State",       data['State']        ?? "N/A"),
                _buildRow("Pincode",     data['Pin']          ?? "N/A"),
                _buildLinkRow("Contact", data['GymContactNo'] ?? "N/A", "tel:${data['GymContactNo']}"),
                _buildLinkRow("Email",   data['EmailId']      ?? "N/A", "mailto:${data['EmailId']}"),
                _buildLinkRow("Website", data['Websiteurl']   ?? "N/A", data['Websiteurl'] ?? ""),
              ]),
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditBottomSheet(context),
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  void _openEditBottomSheet(BuildContext context) {
    final data = controller.profile['data'].first as Map<String, dynamic>;

    // prefill
    nameCtrl.text        = data['GymName']      ?? "";
    addressCtrl.text     = data['Address']      ?? "";
    cityCtrl.text        = data['City']         ?? "";
    stateCtrl.text       = data['State']        ?? "";
    pinCtrl.text         = data['Pin']          ?? "";
    contactCtrl.text     = data['GymContactNo'] ?? "";
    emailCtrl.text       = data['EmailId']      ?? "";
    websiteCtrl.text     = data['Websiteurl']   ?? "";
    ownerNameCtrl.text   = data['PersonName']   ?? "";
    ownerMobileCtrl.text = data['ContactNo']    ?? "";

    Get.bottomSheet(
      SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            GestureDetector(
              onTap: pickImage,
              child: Obx(() {
                final dataLogo = controller.profile['data'].first['logo'] as String?;
                final avatar = selectedImage != null
                    ? FileImage(selectedImage!)
                    : (dataLogo != null && dataLogo.isNotEmpty && File(dataLogo).existsSync()
                    ? FileImage(File(dataLogo))
                    : const AssetImage(''));
                return CircleAvatar(radius: 50, backgroundImage: avatar as ImageProvider);
              }),
            ),
            const SizedBox(height: 20),
            _textField("Gym Name",     nameCtrl),
            _textField("Owner Name",   ownerNameCtrl),
            _textField("Owner Mobile", ownerMobileCtrl),
            _textField("Address",      addressCtrl),
            _textField("City",         cityCtrl),
            _textField("State",        stateCtrl),
            _textField("Pincode",      pinCtrl),
            _textField("Contact No",   contactCtrl),
            _textField("Email",        emailCtrl),
            _textField("Website",      websiteCtrl),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // update model
                controller.profile.value = {
                  'data': [
                    {
                      'GymName':      nameCtrl.text.trim(),
                      'Address':      addressCtrl.text.trim(),
                      'City':         cityCtrl.text.trim(),
                      'State':        stateCtrl.text.trim(),
                      'Pin':          pinCtrl.text.trim(),
                      'GymContactNo': contactCtrl.text.trim(),
                      'EmailId':      emailCtrl.text.trim(),
                      'Websiteurl':   websiteCtrl.text.trim(),
                      // if newly picked, persist that path, else keep old
                      'logo':         selectedImage?.path ?? data['logo'],
                      'PersonName':   ownerNameCtrl.text.trim(),
                      'ContactNo':    ownerMobileCtrl.text.trim(),
                    }
                  ]
                };
                controller.updateGymProfile();
                Get.back();
                Get.snackbar("Updated", "Profile saved successfully",
                    backgroundColor: Colors.green, colorText: Colors.white);
              },
              child: const Text("Save Changes", style: TextStyle(color: Colors.black)),
            ),
          ]),

        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildRow(String label, String value, {bool bold = false, double fontSize = 16}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 140, child: Text("$label:", style: const TextStyle(fontWeight: FontWeight.w600))),
        Expanded(child: Text(value, style: TextStyle(fontSize: fontSize, fontWeight: bold ? FontWeight.bold : FontWeight.normal))),
      ]),
    );
  }

  Widget _buildLinkRow(String label, String value, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 140, child: Text("$label:", style: const TextStyle(fontWeight: FontWeight.w600))),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) await launchUrl(uri);
            },
            child: Text(value, style: const TextStyle(color: Colors.blue, decoration: TextDecoration.none)),
          ),
        ),
      ]),
    );
  }

  Widget _textField(String label, TextEditingController ctl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(controller: ctl, decoration: InputDecoration(labelText: label, border: const OutlineInputBorder())),
    );
  }
}
