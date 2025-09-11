/*import 'dart:convert';
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
  final nameCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final pinCtrl = TextEditingController();
  final contactCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final websiteCtrl = TextEditingController();
  final ownerNameCtrl = TextEditingController();
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

  ///  Pick Image from Gallery
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final file = File(picked.path);
      final bytes = await file.readAsBytes();
      setState(() {
        selectedImage = file;
        base64Image = base64Encode(bytes);
      });
    }
  }

  ///  Decode Image from Path or Base64
  ImageProvider _getProfileImage(String? pathOrBase64) {
    if (selectedImage != null) return FileImage(selectedImage!);

    if (pathOrBase64 == null || pathOrBase64.isEmpty) {
      return const AssetImage('assets/images/logo.jpeg');
    }

    // Check if it's a valid file path
    final file = File(pathOrBase64);
    if (file.existsSync()) return FileImage(file);

    // Try Base64 decoding
    try {
      final bytes = base64Decode(pathOrBase64);
      return MemoryImage(bytes);
    } catch (_) {
      return const AssetImage('assets/images/logo.jpeg');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Gym Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.APP_Color_Indigo,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: Get.back,
        ),
      ),
      body: Obx(() {
        final list = controller.profile['data'] as List<dynamic>?;
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
              child: Column(
                children: [
                  // Profile Image
                  Center(
                    child: GestureDetector(
                      onTap: pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _getProfileImage(data['logo'] as String?),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Gym Information
                  _buildRow("Gym Name", data['GymName'] ?? "N/A", bold: true, fontSize: 20),
                  _buildRow("Owner", data['PersonName'] ?? "N/A", bold: true),
                  _buildRow("Owner Mobile", data['ContactNo'] ?? "N/A"),
                  const SizedBox(height: 16),
                  _buildRow("Address", data['Address'] ?? "N/A"),
                  _buildRow("City", data['City'] ?? "N/A"),
                  _buildRow("State", data['State'] ?? "N/A"),
                  _buildRow("Pincode", data['Pin'] ?? "N/A"),

                  // Contact Information (Clickable links)
                  _buildLinkRow("Contact", data['GymContactNo'] ?? "N/A", "tel:${data['GymContactNo']}"),
                  _buildLinkRow("Email", data['EmailId'] ?? "N/A", "mailto:${data['EmailId']}"),
                  _buildLinkRow("Website", data['Websiteurl'] ?? "N/A", data['Websiteurl'] ?? ""),
                  const SizedBox(height: 10),

                ],
              ),
            ),
          ),
        );
      }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditBottomSheet(context),
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  ///  Info Row
  Widget _buildRow(String label, String value, {bool bold = false, double fontSize = 16}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text("$label:", style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: fontSize, fontWeight: bold ? FontWeight.bold : FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }

  ///  Clickable Info Row (For phone, email, website)
  Widget _buildLinkRow(String label, String value, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 140, child: Text("$label:", style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                if (url.isEmpty) return;
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) await launchUrl(uri);
              },
              child: Text(
                value,
                style: const TextStyle(color: Colors.blue, decoration: TextDecoration.none),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///  Edit Bottom Sheet
  void _openEditBottomSheet(BuildContext context) {
    final data = controller.profile['data'].first as Map<String, dynamic>;

    // Prefill fields
    nameCtrl.text = data['GymName'] ?? "";
    addressCtrl.text = data['Address'] ?? "";
    cityCtrl.text = data['City'] ?? "";
    stateCtrl.text = data['State'] ?? "";
    pinCtrl.text = data['Pin'] ?? "";
    contactCtrl.text = data['GymContactNo'] ?? "";
    emailCtrl.text = data['EmailId'] ?? "";
    websiteCtrl.text = data['Websiteurl'] ?? "";
    ownerNameCtrl.text = data['PersonName'] ?? "";
    ownerMobileCtrl.text = data['ContactNo'] ?? "";

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
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _getProfileImage(data['logo']),
              ),
            ),
            const SizedBox(height: 20),
            _textField("Gym Name", nameCtrl),
            _textField("Owner Name", ownerNameCtrl),
            _textField("Owner Mobile", ownerMobileCtrl),
            _textField("Address", addressCtrl),
            _textField("City", cityCtrl),
            _textField("State", stateCtrl),
            _textField("Pincode", pinCtrl),
            _textField("Contact No", contactCtrl),
            _textField("Email", emailCtrl),
            _textField("Website", websiteCtrl),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              onPressed: () {
                // Update local model
                controller.profile.value = {
                  'data': [
                    {
                      'GymName': nameCtrl.text.trim(),
                      'Address': addressCtrl.text.trim(),
                      'City': cityCtrl.text.trim(),
                      'State': stateCtrl.text.trim(),
                      'Pin': pinCtrl.text.trim(),
                      'GymContactNo': contactCtrl.text.trim(),
                      'EmailId': emailCtrl.text.trim(),
                      'Websiteurl': websiteCtrl.text.trim(),
                      'logo': selectedImage?.path ?? data['logo'],
                      'PersonName': ownerNameCtrl.text.trim(),
                      'ContactNo': ownerMobileCtrl.text.trim(),
                    }
                  ]
                };

                controller.updateGymProfile();
                Get.back();
                Get.snackbar("Updated", "Profile saved successfully",
                    backgroundColor: Colors.green, colorText: Colors.white);
              },
              child: const Text("Save Changes", style: TextStyle(color: Colors.white)),
            ),
          ]),
        ),
      ),
      isScrollControlled: true,
    );
  }

  ///  Reusable Text Field
  Widget _textField(String label, TextEditingController ctl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: ctl,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }
}*/
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final nameCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final pinCtrl = TextEditingController();
  final contactCtrl = TextEditingController(); // Gym contact
  final emailCtrl = TextEditingController();
  final websiteCtrl = TextEditingController();
  final ownerNameCtrl = TextEditingController();
  final ownerMobileCtrl = TextEditingController();

  // Image state
  File? selectedImage;
  String base64Image = '';

  @override
  void dispose() {
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

  /// Pick Image from Gallery
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final file = File(picked.path);
      final bytes = await file.readAsBytes();
      setState(() {
        selectedImage = file;
        base64Image = base64Encode(bytes);
      });
    }
  }

  /// Decode Image from Path or Base64
  ImageProvider _getProfileImage(String? pathOrBase64) {
    if (selectedImage != null) return FileImage(selectedImage!);

    if (pathOrBase64 == null || pathOrBase64.isEmpty) {
      return const AssetImage('assets/images/logo.jpeg');
    }

    final file = File(pathOrBase64);
    if (file.existsSync()) return FileImage(file);

    try {
      final bytes = base64Decode(pathOrBase64);
      return MemoryImage(bytes);
    } catch (_) {
      return const AssetImage('assets/images/logo.jpeg');
    }
  }

  // -------------------- VALIDATION HELPERS --------------------
  final _nameReg = RegExp(r'^[A-Za-z ]+$');
  final _phoneReg = RegExp(r'^\d{10}$');
  final _pinReg = RegExp(r'^\d{6}$');
  final _emailReg =
  RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[A-Za-z]{2,}$'); // basic, pragmatic

  bool _isValidUrl(String url) {
    if (url.trim().isEmpty) return true; // allow empty as optional
    final uri = Uri.tryParse(url.trim());
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https') && uri.hasAuthority;
  }

  List<String> _validateInputs() {
    final errors = <String>[];

    // Gym Name: letters & spaces only
    if (nameCtrl.text.trim().isEmpty || !_nameReg.hasMatch(nameCtrl.text.trim())) {
      errors.add('Gym Name: letters and spaces only (no digits or symbols).');
    }

    // Owner Name: letters & spaces only
    if (ownerNameCtrl.text.trim().isEmpty || !_nameReg.hasMatch(ownerNameCtrl.text.trim())) {
      errors.add('Owner Name: letters and spaces only (no digits or symbols).');
    }

    // Owner Mobile: exactly 10 digits
    if (!_phoneReg.hasMatch(ownerMobileCtrl.text.trim())) {
      errors.add('Owner Mobile: exactly 10 digits required.');
    }

    // Pincode: exactly 6 digits
    if (!_pinReg.hasMatch(pinCtrl.text.trim())) {
      errors.add('Pincode: exactly 6 digits required.');
    }

    // Gym Contact No: exactly 10 digits
    if (!_phoneReg.hasMatch(contactCtrl.text.trim())) {
      errors.add('Gym Contact No: exactly 10 digits required.');
    }

    // Email: valid format
    final email = emailCtrl.text.trim();
    if (email.isNotEmpty && !_emailReg.hasMatch(email)) {
      errors.add('Email: invalid email format.');
    }

    // Website: valid http(s) URL
    if (!_isValidUrl(websiteCtrl.text)) {
      errors.add('Website: must be a valid http/https URL (e.g., https://example.com).');
    }

    return errors;
  }

  void _showErrors(List<String> errors) {
    Get.dialog(
      AlertDialog(
        title: const Text('Please fix the following'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: errors.map((e) => Align(alignment: Alignment.centerLeft, child: Text('• $e'))).toList(),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('OK')),
        ],
      ),
      barrierDismissible: true,
    );
  }
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812), minTextAdapt: true);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Gym Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.APP_Color_Indigo,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: Get.back,
        ),
      ),
      body: Obx(() {
        final list = controller.profile['data'] as List<dynamic>?;

        if (list == null || list.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = list.first as Map<String, dynamic>;

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  // Profile Image
                  Center(
                    child: GestureDetector(
                      onTap: pickImage,
                      child: CircleAvatar(
                        radius: 50.r,
                        backgroundImage: _getProfileImage(data['logo'] as String?),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Gym Information
                  _buildRow("Gym Name", data['GymName'] ?? "N/A", bold: true, fontSize: 20.sp),
                  _buildRow("Owner", data['PersonName'] ?? "N/A", bold: true),
                  _buildRow("Owner Mobile", data['ContactNo'] ?? "N/A"),
                  SizedBox(height: 16.h),
                  _buildRow("Address", data['Address'] ?? "N/A"),
                  _buildRow("City", data['City'] ?? "N/A"),
                  _buildRow("State", data['State'] ?? "N/A"),
                  _buildRow("Pincode", data['Pin'] ?? "N/A"),

                  // Contact Information (Clickable links)
                  _buildLinkRow("Contact", data['GymContactNo'] ?? "N/A", "tel:${data['GymContactNo']}"),
                  _buildLinkRow("Email", data['EmailId'] ?? "N/A", "mailto:${data['EmailId']}"),
                  _buildLinkRow(
                    "Website",
                    data['Websiteurl'] ?? "N/A",
                    _ensureHttpScheme(data['Websiteurl'] ?? ""),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
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

  String _ensureHttpScheme(String url) {
    if (url.isEmpty) return url;
    final uri = Uri.tryParse(url);
    if (uri == null) return url;
    if (uri.scheme.isEmpty) return 'https://$url';
    return url;
  }

  ///  Info Row
  Widget _buildRow(String label, String value, {bool bold = false, double fontSize = 16}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120.w, child: Text("$label:", style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: fontSize, fontWeight: bold ? FontWeight.bold : FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }

  ///  Clickable Info Row (For phone, email, website)
  Widget _buildLinkRow(String label, String value, String url) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 140.w, child: Text("$label:", style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                if (url.isEmpty) return;
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
              },
              child: Text(
                value,
                style: const TextStyle(color: Colors.blue, decoration: TextDecoration.none),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///  Edit Bottom Sheet
  void _openEditBottomSheet(BuildContext context) {
    final data = (controller.profile['data'] as List).first as Map<String, dynamic>;

    // Prefill fields
    nameCtrl.text = data['GymName']?.toString() ?? "";
    addressCtrl.text = data['Address']?.toString() ?? "";
    cityCtrl.text = data['City']?.toString() ?? "";
    stateCtrl.text = data['State']?.toString() ?? "";
    pinCtrl.text = data['Pin']?.toString() ?? "";
    contactCtrl.text = data['GymContactNo']?.toString() ?? "";
    emailCtrl.text = data['EmailId']?.toString() ?? "";
    websiteCtrl.text = data['Websiteurl']?.toString() ?? "";
    ownerNameCtrl.text = data['PersonName']?.toString() ?? "";
    ownerMobileCtrl.text = data['ContactNo']?.toString() ?? "";

    Get.bottomSheet(
      SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 50.r,
                backgroundImage: _getProfileImage(data['logo']?.toString()),
              ),
            ),
            SizedBox(height: 20.h),

            // Fields with inputFormatters to enforce restrictions at typing time
            _textField(
              "Gym Name",
              nameCtrl,
              keyboardType: TextInputType.name,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z ]'))],
            ),
            _textField(
              "Owner Name",
              ownerNameCtrl,
              keyboardType: TextInputType.name,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z ]'))],
            ),
            _textField(
              "Owner Mobile",
              ownerMobileCtrl,
              keyboardType: TextInputType.number,
              maxLength: 10,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            _textField("Address", addressCtrl, keyboardType: TextInputType.streetAddress),
            _textField(
              "City",
              cityCtrl,
              keyboardType: TextInputType.name,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z ]'))],
            ),
            _textField(
              "State",
              stateCtrl,
              keyboardType: TextInputType.name,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z ]'))],
            ),
            _textField(
              "Pincode",
              pinCtrl,
              keyboardType: TextInputType.number,
              maxLength: 6,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            _textField(
              "Contact No (Gym)",
              contactCtrl,
              keyboardType: TextInputType.number,
              maxLength: 10,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            _textField("Email", emailCtrl, keyboardType: TextInputType.emailAddress),
            _textField("Website", websiteCtrl, keyboardType: TextInputType.url),
            SizedBox(height: 20.h),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              onPressed: () {
                final errors = _validateInputs();
                if (errors.isNotEmpty) {
                  _showErrors(errors);
                  return;
                }

                // Update local model in the same structure the controller expects
                final updated = {
                  'GymName': nameCtrl.text.trim(),
                  'Address': addressCtrl.text.trim(),
                  'City': cityCtrl.text.trim(),
                  'State': stateCtrl.text.trim(),
                  'Pin': pinCtrl.text.trim(),
                  'GymContactNo': contactCtrl.text.trim(),
                  'EmailId': emailCtrl.text.trim(),
                  'Websiteurl': websiteCtrl.text.trim(),
                  'logo': selectedImage?.path ?? data['logo'],
                  'PersonName': ownerNameCtrl.text.trim(),
                  'ContactNo': ownerMobileCtrl.text.trim(),
                  'ID': (controller.gymId), // keep ID with record
                };

                controller.profile.value = {
                  'data': [updated]
                };

                controller.updateGymProfile();
                Get.back();
              },
              child: const Text("Save Changes", style: TextStyle(color: Colors.white)),
            ),
          ]),
        ),
      ),
      isScrollControlled: true,
    );
  }

  ///  Reusable Text Field
  Widget _textField(
      String label,
      TextEditingController ctl, {
        TextInputType keyboardType = TextInputType.text,
        List<TextInputFormatter>? inputFormatters,
        int? maxLength,
      }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: TextField(
        controller: ctl,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        decoration: InputDecoration(
          counterText: '', // hide default counter for cleaner UI
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }
}
