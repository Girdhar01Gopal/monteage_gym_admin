class LoginModel {
  bool? isSuccess;
  String? message;
  int? code;
  int? totalCount;
  Data? data;

  LoginModel(
      {this.isSuccess, this.message, this.code, this.totalCount, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    code = json['code'];
    totalCount = json['totalCount'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['code'] = this.code;
    data['totalCount'] = this.totalCount;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? userId;
  String? name;
  String? phoneNo;
  String? email;
  var address;
  String? password;
  String? createBy;
  String? createDate;
  var updateBy;
  int? action;
  int? status;
  int? totalCount;
  int? statusCode;
  bool? isActive;
  String? createdDate;
  String? date;
  String? modifiedDate;
  int? createdby;
  int? updatedby;

  Data(
      {this.userId,
        this.name,
        this.phoneNo,
        this.email,
        this.address,
        this.password,
        this.createBy,
        this.createDate,
        this.updateBy,
        this.action,
        this.status,
        this.totalCount,
        this.statusCode,
        this.isActive,
        this.createdDate,
        this.date,
        this.modifiedDate,
        this.createdby,
        this.updatedby});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    name = json['name'];
    phoneNo = json['phoneNo'];
    email = json['email'];
    address = json['address'];
    password = json['password'];
    createBy = json['createBy'];
    createDate = json['createDate'];
    updateBy = json['updateBy'];
    action = json['action'];
    status = json['status'];
    totalCount = json['totalCount'];
    statusCode = json['statusCode'];
    isActive = json['isActive'];
    createdDate = json['createdDate'];
    date = json['date'];
    modifiedDate = json['modifiedDate'];
    createdby = json['createdby'];
    updatedby = json['updatedby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['phoneNo'] = this.phoneNo;
    data['email'] = this.email;
    data['address'] = this.address;
    data['password'] = this.password;
    data['createBy'] = this.createBy;
    data['createDate'] = this.createDate;
    data['updateBy'] = this.updateBy;
    data['action'] = this.action;
    data['status'] = this.status;
    data['totalCount'] = this.totalCount;
    data['statusCode'] = this.statusCode;
    data['isActive'] = this.isActive;
    data['createdDate'] = this.createdDate;
    data['date'] = this.date;
    data['modifiedDate'] = this.modifiedDate;
    data['createdby'] = this.createdby;
    data['updatedby'] = this.updatedby;
    return data;
  }
}
