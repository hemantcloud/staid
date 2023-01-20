class ChatListWIthTaskModel {
  bool? status;
  String? message;
  Data? data;

  ChatListWIthTaskModel({this.status, this.message, this.data});

  ChatListWIthTaskModel.fromJson(Map<String, dynamic> json) {
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
  List<ChatlistWithTask>? chatlistWithTask;

  Data({this.chatlistWithTask});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['Chatlist with task'] != null) {
      chatlistWithTask = <ChatlistWithTask>[];
      json['Chatlist with task'].forEach((v) {
        chatlistWithTask!.add(new ChatlistWithTask.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.chatlistWithTask != null) {
      data['Chatlist with task'] =
          this.chatlistWithTask!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChatlistWithTask {
  int? id;
  String? userId;
  String? categoryId;
  String? name;
  String? description;
  String? duration;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? categoryName;
  String? categoryImage;

  ChatlistWithTask(
      {this.id,
        this.userId,
        this.categoryId,
        this.name,
        this.description,
        this.duration,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.categoryName,
        this.categoryImage});

  ChatlistWithTask.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    categoryId = json['category_id'];
    name = json['name'];
    description = json['description'];
    duration = json['duration'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    categoryName = json['category_name'];
    categoryImage = json['category_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['category_id'] = this.categoryId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['duration'] = this.duration;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['category_name'] = this.categoryName;
    data['category_image'] = this.categoryImage;
    return data;
  }
}
