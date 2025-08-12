import 'dart:convert';

import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/routers/app_routes.dart';
import 'package:app_lorry/services/services.dart';

class Homeservice {
  static Future<InspectionHistory> GetInspectionHistory(
      ref, Map<String, String>? queryParams) async {
    Preferences preference = Preferences();
    await preference.init();
    final Map<String, String> query = {...?queryParams};
    String token = preference.getValue("token");
    final resp = await MainService.get(
        '/inspection/vehicle-last-with-tire-inspections/', query,
        token: token);

    if (resp.statusCode != 200) {
      ref.read(appRouterProvider).go('/login');
      return InspectionHistory(
          success: false,
          messages: ["Error de conexion"],
          data: DataInspectionHistory(
              count: 0, next: null, previous: null, results: []));
    }
    final Map<String, dynamic> data = json.decode(utf8.decode(resp.bodyBytes));
    final finals = InspectionHistory.fromJson(data);

    return finals;
  }
}
