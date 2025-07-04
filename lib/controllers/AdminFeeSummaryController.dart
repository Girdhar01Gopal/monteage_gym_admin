import 'package:get/get.dart';

class AdminFeeSummaryController extends GetxController {
  var userFeeSummary = <RxMap<String, dynamic>>[].obs;
  var filteredUserFeeSummary = <RxMap<String, dynamic>>[].obs;
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFeeSummaryData();
  }

  void fetchFeeSummaryData() async {
    await Future.delayed(Duration(seconds: 1));

    userFeeSummary.addAll([
      {
        'user': 'John Doe',
        'totalPaid': 5000.0,
        'feeDue': 3000.0,
        'feeOutstanding': 2000.0,
        'isExpanded': false,
      }.obs,
      {
        'user': 'Jane Smith',
        'totalPaid': 7000.0,
        'feeDue': 1000.0,
        'feeOutstanding': 2500.0,
        'isExpanded': false,
      }.obs,
      {
        'user': 'Alice Johnson',
        'totalPaid': 6000.0,
        'feeDue': 2000.0,
        'feeOutstanding': 1000.0,
        'isExpanded': false,
      }.obs,
    ]);

    filteredUserFeeSummary.assignAll(userFeeSummary);
  }

  void applySearch(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredUserFeeSummary.assignAll(userFeeSummary);
    } else {
      final lowerQuery = query.toLowerCase();
      filteredUserFeeSummary.assignAll(userFeeSummary.where((item) =>
          item['user'].toString().toLowerCase().contains(lowerQuery)));
    }
  }

  void updateUserFee(int index, String key, double value) {
    if (index < filteredUserFeeSummary.length) {
      filteredUserFeeSummary[index][key] = value;
      update();
    }
  }

  void toggleExpansion(int index) {
    for (int i = 0; i < filteredUserFeeSummary.length; i++) {
      filteredUserFeeSummary[i]['isExpanded'] = i == index
          ? !(filteredUserFeeSummary[i]['isExpanded'] ?? false)
          : false;
    }
    update();
  }
}
