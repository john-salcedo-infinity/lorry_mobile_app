import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:app_lorry/config/configs.dart';

class MainService {
  static Future<http.Response> post(path, data, {token = ""}) {
    Map<String, String> headers = {"Content-Type": "application/json"};
    if (token != "") {
      headers["Authorization"] = "Bearer $token";
    }
    final url = Uri.parse(Constants.baseUrl + path);
    final resp = http.post(url, body: json.encode(data), headers: headers);
    return resp;
  }

  static Future<http.Response> get(path, data, {token = ""}) {
    Map<String, String> headers = {"Content-Type": "application/json"};
    if (token != "") {
      headers["Authorization"] = "Bearer $token";
    }
 
    final url = Uri.parse(Constants.baseUrl + path).replace(queryParameters: data);
    final resp = http.get(url, headers: headers);
    return resp;
  }

  static Future<http.Response> put(path, data, {token = ""}) {
    Map<String, String> headers = {"Content-Type": "application/json"};
    if (token != "") {
      headers["Authorization"] = "Bearer $token";
    }
    final url = Uri.parse(Constants.baseUrl + path);
    final resp = http.put(url, body: json.encode(data), headers: headers);

    return resp;
  }
}
