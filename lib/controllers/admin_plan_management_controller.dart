import 'package:get/get.dart';

class Plan {
  String name;
  int price;
  String description;

  Plan({
    required this.name,
    required this.price,
    required this.description,
  });
}

class PlanManagementController extends GetxController {
  var plans = <Plan>[
    Plan(name: 'Platinum', price: 1299, description: 'Full access'),
    Plan(name: 'Gold', price: 999, description: 'Partial access'),
    Plan(name: 'Silver', price: 699, description: 'Limited access'),
  ].obs;

  void addPlan(Plan plan) {
    plans.add(plan);
  }

  void deletePlan(int index) {
    plans.removeAt(index);
  }

  void updatePlan(int index, Plan plan) {
    plans[index] = plan;
  }
}
