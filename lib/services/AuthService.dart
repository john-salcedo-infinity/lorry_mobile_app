import 'dart:convert';

import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/services/services.dart';

class Authservice {
  static Future<AuthResponse> login(String email, String password) async {
    final Map<String, String> authData = {'email': email, 'password': password};
    final resp = await MainService.post('/login/', authData);
    final Map<String, dynamic> data = json.decode(resp.body);
    final finals = AuthResponse.fromJson(data);
    return finals;
  }

  static Future<AuthResponse> logout() async {
    Preferences preference = Preferences();
    await preference.init();
    String token = preference.getValue("token");

    final resp = await MainService.delete('/logout/', token: token);
    final Map<String, dynamic> data = json.decode(resp.body);
    final finals = AuthResponse.fromJson(data);
    return finals;
  }

  static Future<AuthResponse> changePassword(
      String new_password, String confirm_password) async {
    Preferences preference = Preferences();
    await preference.init();
    String token = preference.getValue("token");

    final Map<String, String> passwordData = {
      'new_password': new_password,
      'confirm_password': confirm_password,
    };
    final resp =
        await MainService.put('/update-password/', passwordData, token: token);
    final Map<String, dynamic> data = json.decode(resp.body);
    final finals = AuthResponse.fromJson(data);
    return finals;
  }
}
