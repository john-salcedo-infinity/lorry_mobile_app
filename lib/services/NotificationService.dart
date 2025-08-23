import 'dart:convert';

import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/services/services.dart';

class NotificationService {
  static Future<NotificationResponse> getNotifications(
      ref, Map<String, String>? queryParams) async {
    Preferences preference = Preferences();
    await preference.init();
    final Map<String, String> query = {...?queryParams};
    String token = preference.getValue("token");
    final resp = await MainService.get('/notifications/', query, token: token);

    final Map<String, dynamic> data = json.decode(utf8.decode(resp.bodyBytes));
    final finals = NotificationResponse.fromJson(data);

    return finals;
  }

  static Future<NotificationCountResponse> getNewNotificationsCount(
      ref, Map<String, String>? queryParams) async {
    Preferences preference = Preferences();
    await preference.init();
    String token = preference.getValue("token");

    final resp = await MainService.get(
        '/notifications/list-new-notifications/', {...?queryParams},
        token: token);

    final Map<String, dynamic> data = json.decode(utf8.decode(resp.bodyBytes));
    final finals = NotificationCountResponse.fromJson(data);

    return finals;
  }
}
