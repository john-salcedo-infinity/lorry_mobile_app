import 'package:app_lorry/models/models.dart';
import 'dart:convert';

class NotificationResponse {
  bool success;
  List<String> messages;
  NotificationData data;

  NotificationResponse({
    required this.success,
    required this.messages,
    required this.data,
  });

  factory NotificationResponse.fromRawJson(String str) =>
      NotificationResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      NotificationResponse(
        success: json["success"],
        messages: List<String>.from(json["messages"].map((x) => x)),
        data: NotificationData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "messages": List<dynamic>.from(messages.map((x) => x)),
        "data": data.toJson(),
      };
}

class NotificationData {
  int? count;
  String? next;
  String? previous;
  List<Notification>? results;

  NotificationData(
      {required this.count,
      required this.next,
      required this.previous,
      required this.results});

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<Notification>.from(
            json["results"].map((x) => Notification.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}

class Notification {
  int? id;
  User? senderUser;
  User? receivingUser;
  String? title;
  String? message;
  String? buttonText;
  String? icon;
  String? actionUrl;
  bool? viewed;
  int? modelId;
  String? displayDate;
  bool? status;
  User? creationUser;
  User? userUpdate;
  DateTime? creationDate;
  DateTime? lastUpdate;
  int? notificationType;

  Notification({
    this.id,
    this.senderUser,
    this.receivingUser,
    this.title,
    this.message,
    this.buttonText,
    this.icon,
    this.actionUrl,
    this.viewed,
    this.modelId,
    this.displayDate,
    this.status,
    this.creationUser,
    this.userUpdate,
    this.creationDate,
    this.lastUpdate,
    this.notificationType,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        id: json["id"],
        senderUser: json["sender_user"] != null
            ? User.fromJson(json["sender_user"])
            : null,
        receivingUser: json["receiving_user"] != null
            ? User.fromJson(json["receiving_user"])
            : null,
        title: json["title"],
        message: json["message"],
        buttonText: json["button_text"],
        icon: json["icon"],
        actionUrl: json["action_url"],
        viewed: json["viewed"],
        modelId: json["model_id"],
        displayDate: json["display_date"],
        status: json["status"],
        creationUser: json["creation_user"] != null
            ? User.fromJson(json["creation_user"])
            : null,
        userUpdate: json["user_update"] != null
            ? User.fromJson(json["user_update"])
            : null,
        creationDate: DateTime.parse(json["creation_date"]),
        lastUpdate: DateTime.parse(json["last_update"]),
        notificationType: json["notification_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sender_user": senderUser?.toJson(),
        "receiving_user": receivingUser?.toJson(),
        "title": title,
        "message": message,
        "button_text": buttonText,
        "icon": icon,
        "action_url": actionUrl,
        "viewed": viewed,
        "model_id": modelId,
        "display_date": displayDate,
        "status": status,
        "creation_user": creationUser?.toJson(),
        "user_update": userUpdate?.toJson(),
        "creation_date": creationDate,
        "last_update": lastUpdate,
        "notification_type": notificationType,
      };
}

class NotificationCountResponse {
  bool success;
  List<String> messages;
  NotificationCountData data;

  NotificationCountResponse({
    required this.success,
    required this.messages,
    required this.data,
  });

  factory NotificationCountResponse.fromRawJson(String str) =>
      NotificationCountResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationCountResponse.fromJson(Map<String, dynamic> json) =>
      NotificationCountResponse(
        success: json["success"],
        messages: List<String>.from(json["messages"].map((x) => x)),
        data: NotificationCountData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "messages": List<dynamic>.from(messages.map((x) => x)),
        "data": data.toJson(),
      };
}

class NotificationCountData {
  int totalNotificationsToSee;

  NotificationCountData({
    required this.totalNotificationsToSee,
  });

  factory NotificationCountData.fromJson(Map<String, dynamic> json) =>
      NotificationCountData(
        totalNotificationsToSee: json["total_notifications_to_see"],
      );

  Map<String, dynamic> toJson() => {
        "total_notifications_to_see": totalNotificationsToSee,
      };
}
