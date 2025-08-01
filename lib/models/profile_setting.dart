class ProfileSetting {
  String? message;
  List<Data> data;
  int? statuscode;
  int? totalCount;

  // Constructor with null safety
  ProfileSetting({
    this.message,
    required this.data,
    this.statuscode,
    this.totalCount,
  });

  // Factory constructor to handle JSON to Dart object mapping
  factory ProfileSetting.fromJson(Map<String, dynamic> json) {
    return ProfileSetting(
      message: json['message'],
      data: (json['data'] as List)
          .map((v) => Data.fromJson(v))
          .toList(), // Convert List of dynamic to List<Data>
      statuscode: json['statuscode'],
      totalCount: json['totalCount'],
    );
  }

  // Method to convert the Dart object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.map((v) => v.toJson()).toList(),
      'statuscode': statuscode,
      'totalCount': totalCount,
    };
  }
}

class Data {
  int? id;
  String? password;
  bool? isActive;
  String? createdDate;
  String? date;
  String? modifiedDate;
  int? createdby;
  int? updatedby;

  // Constructor with null safety
  Data({
    this.id,
    this.password,
    this.isActive,
    this.createdDate,
    this.date,
    this.modifiedDate,
    this.createdby,
    this.updatedby,
  });

  // Factory constructor to handle JSON to Dart object mapping
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['ID'],
      password: json['Password'],
      isActive: json['IsActive'],
      createdDate: json['CreatedDate'],
      date: json['Date'],
      modifiedDate: json['ModifiedDate'],
      createdby: json['Createdby'],
      updatedby: json['Updatedby'],
    );
  }

  // Method to convert the Dart object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Password': password,
      'IsActive': isActive,
      'CreatedDate': createdDate,
      'Date': date,
      'ModifiedDate': modifiedDate,
      'Createdby': createdby,
      'Updatedby': updatedby,
    };
  }
}
