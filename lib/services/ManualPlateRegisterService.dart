import 'dart:convert';

import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/services/services.dart';

class ManualPlateRegisterService {
  static Future<ManualPlateRegisterResponse> getMountingByPlate(
      String licensePlate, ref) async {
    final Preferences preference = Preferences();
    await preference.init();

    final String token = preference.getValue("token");

    final response = await MainService.get(
      '/mounting',
      {'license_plate': licensePlate},
      token: token,
    );

    final Map<String, dynamic> data =
        json.decode(utf8.decode(response.bodyBytes));
    // final Map<String, dynamic> data = json.decode(response);
    return ManualPlateRegisterResponse.fromJson(data);
  }
}
