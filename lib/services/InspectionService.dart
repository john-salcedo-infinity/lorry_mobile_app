import 'dart:convert';

import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/services/services.dart';

class InspectionService {
  static Future<InspectionResponse> createInspection(
      Map<String, Object> data) async {
    Preferences preferences = Preferences();
    await preferences.init();
    String token = preferences.getValue("token");

    final resp = await MainService.post('/inspection/', data, token: token);
    final Map<String, dynamic> responseData = json.decode(resp.body);
    final inspectionResponse = InspectionResponse.fromJson(responseData);
    return inspectionResponse;
  }
}
