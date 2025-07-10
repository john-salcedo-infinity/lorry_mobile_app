import 'dart:convert';

import 'package:app_lorry/config/configs.dart';
import 'package:app_lorry/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:app_lorry/services/services.dart';

class Authservice {
  static Future<AuthResponse> login(String email, String password) async {
    final Map<String, String> authData = {'email': email, 'password': password};
    final resp = await MainService.post('/login/', authData);
    final Map<String, dynamic> data = json.decode(resp.body);
    final finals = AuthResponse.fromJson(data);
    return finals;
  }
}
