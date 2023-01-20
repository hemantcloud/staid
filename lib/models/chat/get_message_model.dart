class GetMessageModel {
  bool? status;
  String? message;
  Data? data;

  GetMessageModel({this.status, this.message, this.data});

  GetMessageModel.fromJson(Map<String, dynamic> json) {
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
  List<Messages>? messages;

  Data({this.messages});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['Messages'] != null) {
      messages = <Messages>[];
      json['Messages'].forEach((v) {
        messages!.add(new Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.messages != null) {
      data['Messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Messages {
  int? id;
  String? taskId;
  String? receiverId;
  String? receiverType;
  String? senderId;
  String? senderType;
  String? message;
  String? file;
  String? isRead;
  String? createdAt;
  String? updatedAt;

  Messages(
      {this.id,
        this.taskId,
        this.receiverId,
        this.receiverType,
        this.senderId,
        this.senderType,
        this.message,
        this.file,
        this.isRead,
        this.createdAt,
        this.updatedAt});

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskId = json['task_id'];
    receiverId = json['receiver_id'];
    receiverType = json['receiver_type'];
    senderId = json['sender_id'];
    senderType = json['sender_type'];
    message = json['message'];
    file = json['file'];
    isRead = json['is_read'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['task_id'] = this.taskId;
    data['receiver_id'] = this.receiverId;
    data['receiver_type'] = this.receiverType;
    data['sender_id'] = this.senderId;
    data['sender_type'] = this.senderType;
    data['message'] = this.message;
    data['file'] = this.file;
    data['is_read'] = this.isRead;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
