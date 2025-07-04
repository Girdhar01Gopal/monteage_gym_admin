import 'package:get/get.dart';

class AdminAddTrainerController extends GetxController {
  var trainers = <Map<String, dynamic>>[].obs;

  void addTrainer(Map<String, dynamic> trainer) {
    trainers.add(trainer);
    Get.snackbar("Success", "Trainer added successfully",
        snackPosition: SnackPosition.BOTTOM);
  }

  void updateTrainer(int index, Map<String, dynamic> updatedTrainer) {
    trainers[index] = updatedTrainer;
    Get.snackbar("Success", "Trainer updated successfully",
        snackPosition: SnackPosition.BOTTOM);
  }

  void removeTrainer(int index) {
    trainers.removeAt(index);
    Get.snackbar("Success", "Trainer removed successfully",
        snackPosition: SnackPosition.BOTTOM);
  }
}
