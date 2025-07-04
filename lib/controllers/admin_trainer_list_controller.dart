import 'package:get/get.dart';

class AdminTrainerListController extends GetxController {
  var trainers = <Map<String, String>>[].obs;
  var filteredTrainers = <Map<String, String>>[].obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTrainers();
  }

  void fetchTrainers() async {
    await Future.delayed(Duration(seconds: 1));
    trainers.addAll([
      {
        'name': 'John Doe',
        'specialization': 'Yoga',
        'phone': '1234567890',
        'experience': '5',
        'course': 'Yoga Class',
        'startTime': '10:00 AM',
        'endTime': '12:00 PM',
        'photoPath': '',
      },
      {
        'name': 'Jane Smith',
        'specialization': 'Zumba',
        'phone': '9876543210',
        'experience': '3',
        'course': 'Zumba Class',
        'startTime': '1:00 PM',
        'endTime': '3:00 PM',
        'photoPath': '',
      },
    ]);
    filteredTrainers.assignAll(trainers);
  }

  void deleteTrainer(int index) {
    trainers.removeAt(index);
    applySearch(searchQuery.value); // to refresh filtered list
  }

  void addTrainer(Map<String, String> trainer) {
    trainers.add(trainer);
    applySearch(searchQuery.value);
    Get.snackbar("Success", "Trainer added successfully", snackPosition: SnackPosition.TOP);
  }

  void updateTrainer(int index, Map<String, String> updatedTrainer) {
    trainers[index] = updatedTrainer;
    applySearch(searchQuery.value);
    Get.snackbar("Success", "Trainer updated successfully", snackPosition: SnackPosition.TOP);
  }

  void removeTrainer(int index) {
    trainers.removeAt(index);
    applySearch(searchQuery.value);
    Get.snackbar("Success", "Trainer removed successfully", snackPosition: SnackPosition.TOP);
  }

  void applySearch(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredTrainers.assignAll(trainers);
    } else {
      final lower = query.toLowerCase();
      filteredTrainers.assignAll(trainers.where((trainer) {
        return trainer.values.any((value) => value.toLowerCase().contains(lower));
      }));
    }
  }
}
