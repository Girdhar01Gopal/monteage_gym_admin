import 'dart:io';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class AdminDietMenuController extends GetxController {
  var pdfFiles = <File>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPdfFiles();
  }

  Future<void> loadPdfFiles() async {
    final dir = await getApplicationDocumentsDirectory();
    final pdfDir = Directory('${dir.path}/diet_pdfs');
    if (await pdfDir.exists()) {
      final files = pdfDir.listSync().whereType<File>().where((f) => f.path.endsWith('.pdf')).toList();
      pdfFiles.assignAll(files);
    } else {
      await pdfDir.create(recursive: true);
    }
  }

  Future<void> uploadPdf() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final dir = await getApplicationDocumentsDirectory();
      final savePath = '${dir.path}/diet_pdfs/${result.files.single.name}';
      await file.copy(savePath);
      loadPdfFiles();
    }
  }

  Future<void> openPdf(File file) async {
    await OpenFile.open(file.path);
  }

  Future<void> deletePdf(File file) async {
    await file.delete();
    loadPdfFiles();
  }
}
