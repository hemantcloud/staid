class ProfileModel {
  bool? status;
  String? message;
  Data? data;

  ProfileModel({this.status, this.message, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  UserData? userData;

  Data({this.userData});

  Data.fromJson(Map<String, dynamic> json) {
    userData = json['userData'] != null
        ? new UserData.fromJson(json['userData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userData != null) {
      data['userData'] = this.userData!.toJson();
    }
    return data;
  }
}

class UserData {
  int? id;
  String? uniqueId;
  String? name;
  String? email;
  String? mobileNumber;
  String? countryCode;
  String? isDelete;
  String? isBlocked;
  String? mobileVerify;
  String? emailVerify;
  Null? emailVerifiedAt;
  String? profileImage;
  String? providerId;
  String? provider;
  String? timezone;
  String? createdAt;
  String? updatedAt;

  UserData(
      {this.id,
        this.uniqueId,
        this.name,
        this.email,
        this.mobileNumber,
        this.countryCode,
        this.isDelete,
        this.isBlocked,
        this.mobileVerify,
        this.emailVerify,
        this.emailVerifiedAt,
        this.profileImage,
        this.providerId,
        this.provider,
        this.timezone,
        this.createdAt,
        this.updatedAt});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uniqueId = json['unique_id'];
    name = json['name'];
    email = json['email'];
    mobileNumber = json['mobile_number'];
    countryCode = json['country_code'];
    isDelete = json['is_delete'];
    isBlocked = json['is_blocked'];
    mobileVerify = json['mobile_verify'];
    emailVerify = json['email_verify'];
    emailVerifiedAt = json['email_verified_at'];
    profileImage = json['profileImage'];
    providerId = json['provider_id'];
    provider = json['provider'];
    timezone = json['timezone'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['unique_id'] = this.uniqueId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile_number'] = this.mobileNumber;
    data['country_code'] = this.countryCode;
    data['is_delete'] = this.isDelete;
    data['is_blocked'] = this.isBlocked;
    data['mobile_verify'] = this.mobileVerify;
    data['email_verify'] = this.emailVerify;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['profileImage'] = this.profileImage;
    data['provider_id'] = this.providerId;
    data['provider'] = this.provider;
    data['timezone'] = this.timezone;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
