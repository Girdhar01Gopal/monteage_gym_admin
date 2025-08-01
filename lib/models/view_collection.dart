class ViewCollection {
  String message;
  List<Data> data;
  int statuscode;
  int totalCount;

  // Constructor
  ViewCollection({
    required this.message,
    required this.data,
    required this.statuscode,
    required this.totalCount,
  });

  // Factory constructor for JSON deserialization
  ViewCollection.fromJson(Map<String, dynamic> json)
      : message = json['message'],
        statuscode = json['statuscode'],
        totalCount = json['totalCount'],
        data = (json['data'] as List)
            .map((item) => Data.fromJson(item))
            .toList();

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
      'statuscode': statuscode,
      'totalCount': totalCount,
    };
  }
}

class Data {
  int feeId;
  int memberId;
  String name;
  String fatherName;
  String emailid;
  String phone;
  int price;
  int discount;
  int recivedAmount;
  int balanceAmount;
  String paymentStatus;
  String paymentDate;
  String nextPaymentDate;
  String createBy;
  dynamic updateBy; // Use `dynamic` for nullable fields
  String createDate;
  int gymeId;
  bool isActive;
  String createdDate;
  String date;
  String modifiedDate;
  int createdby;
  int updatedby;

  // Constructor
  Data({
    required this.feeId,
    required this.memberId,
    required this.name,
    required this.fatherName,
    required this.emailid,
    required this.phone,
    required this.price,
    required this.discount,
    required this.recivedAmount,
    required this.balanceAmount,
    required this.paymentStatus,
    required this.paymentDate,
    required this.nextPaymentDate,
    required this.createBy,
    this.updateBy, // nullable
    required this.createDate,
    required this.gymeId,
    required this.isActive,
    required this.createdDate,
    required this.date,
    required this.modifiedDate,
    required this.createdby,
    required this.updatedby,
  });

  // Factory constructor for JSON deserialization
  Data.fromJson(Map<String, dynamic> json)
      : feeId = json['FeeId'],
        memberId = json['MemberId'],
        name = json['Name'],
        fatherName = json['FatherName'],
        emailid = json['Emailid'],
        phone = json['Phone'],
        price = json['Price'],
        discount = json['Discount'],
        recivedAmount = json['RecivedAmount'],
        balanceAmount = json['BalanceAmount'],
        paymentStatus = json['PaymentStatus'],
        paymentDate = json['PaymentDate'],
        nextPaymentDate = json['NextPaymentDate'],
        createBy = json['CreateBy'],
        updateBy = json['UpdateBy'], // Can be nullable
        createDate = json['CreateDate'],
        gymeId = json['GymeId'],
        isActive = json['IsActive'],
        createdDate = json['CreatedDate'],
        date = json['Date'],
        modifiedDate = json['ModifiedDate'],
        createdby = json['Createdby'],
        updatedby = json['Updatedby'];

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'FeeId': feeId,
      'MemberId': memberId,
      'Name': name,
      'FatherName': fatherName,
      'Emailid': emailid,
      'Phone': phone,
      'Price': price,
      'Discount': discount,
      'RecivedAmount': recivedAmount,
      'BalanceAmount': balanceAmount,
      'PaymentStatus': paymentStatus,
      'PaymentDate': paymentDate,
      'NextPaymentDate': nextPaymentDate,
      'CreateBy': createBy,
      'UpdateBy': updateBy, // Can be nullable
      'CreateDate': createDate,
      'GymeId': gymeId,
      'IsActive': isActive,
      'CreatedDate': createdDate,
      'Date': date,
      'ModifiedDate': modifiedDate,
      'Createdby': createdby,
      'Updatedby': updatedby,
    };
  }
}
