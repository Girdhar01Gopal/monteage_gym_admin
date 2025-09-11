import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class AdminDietMenuController extends GetxController {
  // List of all PDFs and filtered PDFs
  var pdfFiles = <File>[].obs;
  var filteredPdfFiles = <File>[].obs;
  var selectedFiles = <File>[].obs; // Track selected files for multi-select

  // Controller for search field
  var searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadPdfFiles();
    searchController.addListener(() {
      filterPdfList(searchController.text);
    });
  }

  // Load PDF files from the app's documents directory
  Future<void> loadPdfFiles() async {
    final dir = await getApplicationDocumentsDirectory();
    final pdfDir = Directory('${dir.path}/diet_pdfs');
    if (await pdfDir.exists()) {
      final files = pdfDir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.pdf'))
          .toList();
      pdfFiles.assignAll(files);
      filteredPdfFiles.assignAll(files); // Initially, show all PDFs
    } else {
      await pdfDir.create(recursive: true);
    }
  }

  // Upload a PDF file
  Future<void> uploadPdf() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final dir = await getApplicationDocumentsDirectory();
      final savePath = '${dir.path}/diet_pdfs/${result.files.single.name}';
      await file.copy(savePath);
      loadPdfFiles();  // Reload PDF list after uploading
    }
  }

  // Open a PDF file
  Future<void> openPdf(File file) async {
    await OpenFile.open(file.path);
  }

  // Delete a PDF file
  Future<void> deletePdf(File file) async {
    await file.delete();
    loadPdfFiles();  // Reload PDF list after deleting
  }

  // Filter PDFs based on search query (searching both by file name and number)
  void filterPdfList(String query) {
    if (query.isEmpty) {
      filteredPdfFiles.assignAll(pdfFiles);  // Show all PDFs when search is cleared
    } else {
      filteredPdfFiles.assignAll(
        pdfFiles.where((file) {
          final fileName = file.path.split('/').last.toLowerCase();
          return fileName.contains(query.toLowerCase()) || fileName.contains(RegExp(r'\d')); // Includes number search
        }).toList(),
      );
    }
  }

  // Toggle file selection for multi-select
  void toggleSelection(File file) {
    if (selectedFiles.contains(file)) {
      selectedFiles.remove(file);
    } else {
      selectedFiles.add(file);
    }
  }

  // Delete selected files in bulk
  void deleteSelectedFiles() {
    for (var file in selectedFiles) {
      deletePdf(file);
    }
    selectedFiles.clear();
  }

  // Share selected files in bulk
  void shareSelectedFiles(dynamic Share) {
    List<String> filePaths = selectedFiles.map((file) => file.path).toList();
    Share.shareFiles(filePaths, text: 'Check out these PDFs!');
    selectedFiles.clear();
  }

  // Sort files based on criteria (name, size, date)
  void sortFiles(String criteria) {
    if (criteria == 'name') {
      pdfFiles.sort((a, b) => a.path.compareTo(b.path)); // Sort by name
    } else if (criteria == 'size') {
      pdfFiles.sort((a, b) => a.lengthSync().compareTo(b.lengthSync())); // Sort by size
    } else if (criteria == 'date') {
      pdfFiles.sort((a, b) => a.lastModifiedSync().compareTo(b.lastModifiedSync())); // Sort by date
    }
    filteredPdfFiles.assignAll(pdfFiles);
  }
}
