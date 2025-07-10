import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/config/configs.dart';
import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:app_lorry/routers/app_routes.dart';
import 'package:app_lorry/services/services.dart';

class Homeservice {

 static Future<InspectionHistory> GetInspectionHistory(  ref) async {
  Preferences preference =  Preferences();
  await preference.init();
  String user =preference.getValue("user") ; 
  User datafinalstring = User.fromJson(jsonDecode(user));
    final Map<String, String> authData = {
      'id': "${datafinalstring.id!}"
    };
    String token = preference.getValue("token") ;
    final resp = await MainService.get('/inspection/vehicle-quantity-list-with-tire-inspections/', authData,token: token);

      if (resp.statusCode != 200 ) {
            ref.read(appRouterProvider).go('/login');
            return InspectionHistory(success: false, messages: ["Error de conexion"], data: DataInspectionHistory(count: 0, next: null, previous: null, results: []));
    }
    final Map<String, dynamic> data = json.decode(resp.body);
    final finals = InspectionHistory.fromJson(data);
  
    return finals;
  }
}
