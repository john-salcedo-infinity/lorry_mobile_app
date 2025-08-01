import 'dart:convert';

import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/services/services.dart';

class NoveltyService {
  static Future<NoveltyResponse> getNovelty() async {
    Preferences preferences = Preferences();
    await preferences.init();

    String token = preferences.getValue("token");
    final Map<String, String> query = {};
    final resp = await MainService.get('/novelty', query, token: token);
    if (resp.statusCode != 200) {
      return NoveltyResponse(
        success: false,
        messages: ["Error de conexion"],
        data: NoveltyData(
          count: 0,
          next: null,
          previous: null,
          results: [],
        ),
      );
    }
    final Map<String, dynamic> responseData = json.decode(utf8.decode(resp.bodyBytes));
    final finals = NoveltyResponse.fromJson(responseData);
    return finals;
  }
}
