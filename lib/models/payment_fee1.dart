class feepayment {
  String? message;
  List<Data>? data;
  int? statuscode;
  int? totalCount;

  feepayment({this.message, this.data, this.statuscode, this.totalCount});

  feepayment.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    statuscode = json['statuscode'];
    totalCount = json['totalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['statuscode'] = this.statuscode;
    data['totalCount'] = this.totalCount;
    return data;
  }
}

class Data {
  int? feeId;
  int? memberId;
  String? name;
  String? fatherName;
  String? emailid;
  String? phone;
  int? price;
  int? discount;
  int? recivedAmount;
  int? balanceAmount;
  String? paymentStatus;
  String? paymentDate;
  String? nextPaymentDate;
  String? createBy;
  Null? updateBy;
  String? createDate;
  int? gymeId;
  bool? isActive;
  String? createdDate;
  String? date;
  String? modifiedDate;
  int? createdby;
  int? updatedby;

  Data(
      {this.feeId,
        this.memberId,
        this.name,
        this.fatherName,
        this.emailid,
        this.phone,
        this.price,
        this.discount,
        this.recivedAmount,
        this.balanceAmount,
        this.paymentStatus,
        this.paymentDate,
        this.nextPaymentDate,
        this.createBy,
        this.updateBy,
        this.createDate,
        this.gymeId,
        this.isActive,
        this.createdDate,
        this.date,
        this.modifiedDate,
        this.createdby,
        this.updatedby});

  Data.fromJson(Map<String, dynamic> json) {
    feeId = json['FeeId'];
    memberId = json['MemberId'];
    name = json['Name'];
    fatherName = json['FatherName'];
    emailid = json['Emailid'];
    phone = json['Phone'];
    price = json['Price'];
    discount = json['Discount'];
    recivedAmount = json['RecivedAmount'];
    balanceAmount = json['BalanceAmount'];
    paymentStatus = json['PaymentStatus'];
    paymentDate = json['PaymentDate'];
    nextPaymentDate = json['NextPaymentDate'];
    createBy = json['CreateBy'];
    updateBy = json['UpdateBy'];
    createDate = json['CreateDate'];
    gymeId = json['GymeId'];
    isActive = json['IsActive'];
    createdDate = json['CreatedDate'];
    date = json['Date'];
    modifiedDate = json['ModifiedDate'];
    createdby = json['Createdby'];
    updatedby = json['Updatedby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FeeId'] = this.feeId;
    data['MemberId'] = this.memberId;
    data['Name'] = this.name;
    data['FatherName'] = this.fatherName;
    data['Emailid'] = this.emailid;
    data['Phone'] = this.phone;
    data['Price'] = this.price;
    data['Discount'] = this.discount;
    data['RecivedAmount'] = this.recivedAmount;
    data['BalanceAmount'] = this.balanceAmount;
    data['PaymentStatus'] = this.paymentStatus;
    data['PaymentDate'] = this.paymentDate;
    data['NextPaymentDate'] = this.nextPaymentDate;
    data['CreateBy'] = this.createBy;
    data['UpdateBy'] = this.updateBy;
    data['CreateDate'] = this.createDate;
    data['GymeId'] = this.gymeId;
    data['IsActive'] = this.isActive;
    data['CreatedDate'] = this.createdDate;
    data['Date'] = this.date;
    data['ModifiedDate'] = this.modifiedDate;
    data['Createdby'] = this.createdby;
    data['Updatedby'] = this.updatedby;
    return data;
  }
}