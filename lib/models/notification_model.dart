import 'dart:convert';

NotificationData notificationDataFromJson(String str) =>
    NotificationData.fromJson(json.decode(str));

class NotificationData {
  String? message;
  int? statuscode;
  int? totalCount;
  List<NotificationItem>? data;

  NotificationData({this.message, this.statuscode, this.totalCount, this.data});

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      message: json['message'] as String?,
      statuscode: json['statuscode'] as int?,
      totalCount: json['totalCount'] as int?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class NotificationItem {
  String? name;
  int? balanceAmount;
  String? nextPaymentDate;
  String? message;       // renamed from 'massage'
  bool? isActive;
  String? createdDate;
  String? date;          // your timestamp field
  String? modifiedDate;
  int? createdby;
  int? updatedby;

  NotificationItem({
    this.name,
    this.balanceAmount,
    this.nextPaymentDate,
    this.message,
    this.isActive,
    this.createdDate,
    this.date,
    this.modifiedDate,
    this.createdby,
    this.updatedby,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      name: json['Name'] as String?,
      balanceAmount: json['BalanceAmount'] as int?,
      nextPaymentDate: json['NextPaymentDate'] as String?,
      message: json['Massage'] as String?,    // API uses 'Massage'
      isActive: json['IsActive'] as bool?,
      createdDate: json['CreatedDate'] as String?,
      date: json['Date'] as String?,
      modifiedDate: json['ModifiedDate'] as String?,
      createdby: json['Createdby'] as int?,
      updatedby: json['Updatedby'] as int?,
    );
  }
}
