class feeslist {
  String? message;
  List<Data>? data;
  int? statuscode;
  int? totalCount;

  feeslist({this.message, this.data, this.statuscode, this.totalCount});

  feeslist.fromJson(Map<String, dynamic> json) {
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
  int? memberId;
  String? name;
  int? planId;
  String? planTittle;
  String? fatherName;
  String? emailid;
  String? phone;
  String? whatsappNo;
  String? emergencyNo;
  String? address;
  String? height;
  String? weight;
  String? gender;
  int? price;
  int? discount;
  String? joiningDate;
  String? packageExpiryDate;
  String? action;
  String? createBy;
  Null? updateBy;
  String? createDate;
  int? gymeId;
  int? recivedAmount;
  int? balanceAmount;
  bool? isActive;
  String? createdDate;
  String? date;
  String? modifiedDate;
  int? createdby;
  int? updatedby;

  Data(
      {this.memberId,
        this.name,
        this.planId,
        this.planTittle,
        this.fatherName,
        this.emailid,
        this.phone,
        this.whatsappNo,
        this.emergencyNo,
        this.address,
        this.height,
        this.weight,
        this.gender,
        this.price,
        this.discount,
        this.joiningDate,
        this.packageExpiryDate,
        this.action,
        this.createBy,
        this.updateBy,
        this.createDate,
        this.gymeId,
        this.recivedAmount,
        this.balanceAmount,
        this.isActive,
        this.createdDate,
        this.date,
        this.modifiedDate,
        this.createdby,
        this.updatedby});

  Data.fromJson(Map<String, dynamic> json) {
    memberId = json['MemberId'];
    name = json['Name'];
    planId = json['PlanId'];
    planTittle = json['PlanTittle'];
    fatherName = json['FatherName'];
    emailid = json['Emailid'];
    phone = json['Phone'];
    whatsappNo = json['WhatsappNo'];
    emergencyNo = json['EmergencyNo'];
    address = json['Address'];
    height = json['Height'];
    weight = json['Weight'];
    gender = json['Gender'];
    price = json['Price'];
    discount = json['Discount'];
    joiningDate = json['JoiningDate'];
    packageExpiryDate = json['PackageExpiryDate'];
    action = json['Action'];
    createBy = json['CreateBy'];
    updateBy = json['UpdateBy'];
    createDate = json['CreateDate'];
    gymeId = json['GymeId'];
    recivedAmount = json['RecivedAmount'];
    balanceAmount = json['BalanceAmount'];
    isActive = json['IsActive'];
    createdDate = json['CreatedDate'];
    date = json['Date'];
    modifiedDate = json['ModifiedDate'];
    createdby = json['Createdby'];
    updatedby = json['Updatedby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MemberId'] = this.memberId;
    data['Name'] = this.name;
    data['PlanId'] = this.planId;
    data['PlanTittle'] = this.planTittle;
    data['FatherName'] = this.fatherName;
    data['Emailid'] = this.emailid;
    data['Phone'] = this.phone;
    data['WhatsappNo'] = this.whatsappNo;
    data['EmergencyNo'] = this.emergencyNo;
    data['Address'] = this.address;
    data['Height'] = this.height;
    data['Weight'] = this.weight;
    data['Gender'] = this.gender;
    data['Price'] = this.price;
    data['Discount'] = this.discount;
    data['JoiningDate'] = this.joiningDate;
    data['PackageExpiryDate'] = this.packageExpiryDate;
    data['Action'] = this.action;
    data['CreateBy'] = this.createBy;
    data['UpdateBy'] = this.updateBy;
    data['CreateDate'] = this.createDate;
    data['GymeId'] = this.gymeId;
    data['RecivedAmount'] = this.recivedAmount;
    data['BalanceAmount'] = this.balanceAmount;
    data['IsActive'] = this.isActive;
    data['CreatedDate'] = this.createdDate;
    data['Date'] = this.date;
    data['ModifiedDate'] = this.modifiedDate;
    data['Createdby'] = this.createdby;
    data['Updatedby'] = this.updatedby;
    return data;
  }
}