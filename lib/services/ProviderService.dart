import 'dart:convert';

import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/models/ProviderResponse.dart';
import 'package:app_lorry/services/services.dart';

class ProviderService {
  static Future<ProviderResponse> getProviders() async {
    Preferences preferences = Preferences();
    await preferences.init();

    String token = preferences.getValue("token");
    final Map<String, String> query = {};
    final resp = await MainService.get('/provider/', query, token: token);
    
    if (resp.statusCode != 200) {
      return ProviderResponse(
        success: false,
        messages: ["Error de conexión"],
        data: ProviderData(
          count: 0,
          next: null,
          previous: null,
          results: [],
        ),
      );
    }
    
    final Map<String, dynamic> responseData = json.decode(utf8.decode(resp.bodyBytes));
    final providerResponse = ProviderResponse.fromJson(responseData);
    return providerResponse;
  }
}
