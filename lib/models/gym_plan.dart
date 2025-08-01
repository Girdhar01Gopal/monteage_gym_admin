class GymPlan {
  final int id;
  final String title;
  final String duration;
  final double price;
  final List<String> features;
  final bool isActive;
  final String action; // new field
  final DateTime createdDate;

  GymPlan({
    required this.id,
    required this.title,
    required this.duration,
    required this.price,
    required this.features,
    required this.isActive,
    required this.action,
    required this.createdDate,
  });

  /// ✅ Factory method to parse JSON from API
  factory GymPlan.fromJson(Map<String, dynamic> json) {
    return GymPlan(
      id: json['PlanId'] is int ? json['PlanId'] : int.tryParse(json['PlanId'].toString()) ?? 0,
      title: json['PlanTittle']?.toString().trim() ?? '',
      duration: json['Duration']?.toString().trim() ?? '',
      price: double.tryParse(json['Price'].toString()) ?? 0.0,
      features: (json['Includes'] != null && json['Includes'].toString().trim().isNotEmpty)
          ? json['Includes'].toString().split('+').map((e) => e.trim()).toList()
          : [],
      isActive: json['IsActive'] == true ||
          json['IsActive'] == 1 ||
          json['IsActive']?.toString().toLowerCase() == 'true',
      action: json['Action']?.toString().trim() ?? '',
      createdDate: json['CreatedDate'] != null
          ? DateTime.tryParse(json['CreatedDate'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  /// ✅ Convert GymPlan to JSON for sending to backend
  Map<String, dynamic> toJson() {
    return {
      'PlanId': id,
      'PlanTittle': title,
      'Duration': duration,
      'Price': price.toInt(),
      'Includes': features.join(' + '),
      'IsActive': isActive,
      'Action': action,
      'CreatedDate': createdDate.toIso8601String(),
    };
  }
}
