class TaskListModel {
  bool? status;
  String? message;
  Data? data;

  TaskListModel({this.status, this.message, this.data});

  TaskListModel.fromJson(Map<String, dynamic> json) {
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
  List<Task>? task;

  Data({this.task});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['Task'] != null) {
      task = <Task>[];
      json['Task'].forEach((v) {
        task!.add(new Task.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.task != null) {
      data['Task'] = this.task!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Task {
  int? id;
  String? userId;
  String? categoryId;
  String? name;
  String? description;
  String? duration;
  String? amount;
  String? payAmount;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? categoryName;

  Task(
      {this.id,
        this.userId,
        this.categoryId,
        this.name,
        this.description,
        this.duration,
        this.amount,
        this.payAmount,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.categoryName});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    categoryId = json['category_id'];
    name = json['name'];
    description = json['description'];
    duration = json['duration'];
    amount = json['amount'];
    payAmount = json['pay_amount'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['category_id'] = this.categoryId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['duration'] = this.duration;
    data['amount'] = this.amount;
    data['pay_amount'] = this.payAmount;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['category_name'] = this.categoryName;
    return data;
  }
}
