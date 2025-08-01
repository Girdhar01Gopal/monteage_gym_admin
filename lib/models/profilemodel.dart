class ProfileModel {
  String? message;
  List<Data>? data;
  int? statuscode;
  int? totalCount;

  ProfileModel({this.message, this.data, this.statuscode, this.totalCount});

  // Factory constructor to create an instance from JSON
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      message: json['message'],
      statuscode: json['statuscode'],
      totalCount: json['totalCount'],
      data: json['data'] != null
          ? List<Data>.from(json['data'].map((v) => Data.fromJson(v)))
          : [],
    );
  }

  // Convert the model to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = this.message;
    data['statuscode'] = this.statuscode;
    data['totalCount'] = this.totalCount;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? iD;
  String? personName;
  String? emailId;
  String? contactNo;
  String? whatsappNo;
  String? emergencyNo;
  String? salary;
  String? joiningDate;
  int? gymeId;
  String? gymName;
  String? userType;
  int? courseId;
  String? courseName;
  String? gender;
  String? experience;
  String? startDate;
  String? endDate;
  String? description;
  String? action;
  String? createBy;
  String? updateBy;
  String? createDate;
  String? address;
  String? city;
  String? state;
  String? pin;
  String? gymContactNo;
  String? websiteurl;
  bool? isActive;
  String? createdDate;
  String? date;
  String? modifiedDate;
  int? createdby;
  int? updatedby;

  // Constructor
  Data({
    this.iD,
    this.personName,
    this.emailId,
    this.contactNo,
    this.whatsappNo,
    this.emergencyNo,
    this.salary,
    this.joiningDate,
    this.gymeId,
    this.gymName,
    this.userType,
    this.courseId,
    this.courseName,
    this.gender,
    this.experience,
    this.startDate,
    this.endDate,
    this.description,
    this.action,
    this.createBy,
    this.updateBy,
    this.createDate,
    this.address,
    this.city,
    this.state,
    this.pin,
    this.gymContactNo,
    this.websiteurl,
    this.isActive,
    this.createdDate,
    this.date,
    this.modifiedDate,
    this.createdby,
    this.updatedby,
  });

  // Factory constructor to create an instance from JSON
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      iD: json['ID'],
      personName: json['PersonName'],
      emailId: json['EmailId'],
      contactNo: json['ContactNo'],
      whatsappNo: json['WhatsappNo'],
      emergencyNo: json['EmergencyNo'],
      salary: json['Salary'],
      joiningDate: json['JoiningDate'],
      gymeId: json['GymeId'],
      gymName: json['GymName'],
      userType: json['UserType'],
      courseId: json['CourseId'],
      courseName: json['CourseName'],
      gender: json['Gender'],
      experience: json['Experience'],
      startDate: json['StartDate'],
      endDate: json['EndDate'],
      description: json['Description'],
      action: json['Action'],
      createBy: json['CreateBy'],
      updateBy: json['UpdateBy'],
      createDate: json['CreateDate'],
      address: json['Address'],
      city: json['City'],
      state: json['State'],
      pin: json['Pin'],
      gymContactNo: json['GymContactNo'],
      websiteurl: json['Websiteurl'],
      isActive: json['IsActive'],
      createdDate: json['CreatedDate'],
      date: json['Date'],
      modifiedDate: json['ModifiedDate'],
      createdby: json['Createdby'],
      updatedby: json['Updatedby'],
    );
  }

  // Convert the Data instance to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = this.iD;
    data['PersonName'] = this.personName;
    data['EmailId'] = this.emailId;
    data['ContactNo'] = this.contactNo;
    data['WhatsappNo'] = this.whatsappNo;
    data['EmergencyNo'] = this.emergencyNo;
    data['Salary'] = this.salary;
    data['JoiningDate'] = this.joiningDate;
    data['GymeId'] = this.gymeId;
    data['GymName'] = this.gymName;
    data['UserType'] = this.userType;
    data['CourseId'] = this.courseId;
    data['CourseName'] = this.courseName;
    data['Gender'] = this.gender;
    data['Experience'] = this.experience;
    data['StartDate'] = this.startDate;
    data['EndDate'] = this.endDate;
    data['Description'] = this.description;
    data['Action'] = this.action;
    data['CreateBy'] = this.createBy;
    data['UpdateBy'] = this.updateBy;
    data['CreateDate'] = this.createDate;
    data['Address'] = this.address;
    data['City'] = this.city;
    data['State'] = this.state;
    data['Pin'] = this.pin;
    data['GymContactNo'] = this.gymContactNo;
    data['Websiteurl'] = this.websiteurl;
    data['IsActive'] = this.isActive;
    data['CreatedDate'] = this.createdDate;
    data['Date'] = this.date;
    data['ModifiedDate'] = this.modifiedDate;
    data['Createdby'] = this.createdby;
    data['Updatedby'] = this.updatedby;
    return data;
  }
}
