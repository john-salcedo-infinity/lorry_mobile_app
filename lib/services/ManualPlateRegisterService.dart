import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/services/services.dart';

class ManualPlateRegisterService {
  static Future<ManualPlateRegisterResponse> getMountingByPlate(
      String licensePlate, WidgetRef ref) async {
    final Preferences preference = Preferences();
    await preference.init();

    final String token = preference.getValue("token");

    final response = await MainService.get(
      '/mounting/mounting-per-license-plate',
      {'license_plate': licensePlate},
      token: token,
    );


    // const String response = '''
    // {
    //   "success": true,
    //   "messages": [
    //     "Listado de montajes de llantas con éxito"
    //   ],
    //   "data": {
    //     "count": 2870,
    //     "next": "https://backend.lorry.la/mounting/?page=2",
    //     "previous": null,
    //     "results": [
    //       {
    //         "license_plate": "KOK147",
    //         "number_lorry": null,
    //         "type_vehicle_name": "Volqueta doble troque",
    //         "business_name": "Engineering Solutions ICC",
    //         "axle_name": "6x2 dual",
    //         "work_line_name": "Puerto Barranquilla",
    //         "mileage": 136712.0,
    //         "tires": [
    //           {
    //             "tir_id": 10,
    //             "integration_code": "100",
    //             "design": "diseño 1",
    //             "brand": "marca",
    //             "band": "banda",
    //             "positions": "P4"
    //           },
    //           {
    //             "tir_id": 3,
    //             "integration_code": "100",
    //             "design": "diseño 1",
    //             "brand": "marca",
    //             "band": "banda",
    //             "positions": "P3"

    //           },
    //           {
    //             "tir_id": 21,
    //             "integration_code": "100",
    //             "design": "diseño 1",
    //             "brand": "marca",
    //             "band": "banda",
    //             "positions": "P2"
    //           },
    //            {
    //             "tir_id": 4,
    //             "integration_code": "100",
    //             "design": "diseño 1",
    //             "brand": "marca",
    //             "band": "banda",
    //             "positions": "P1"

    //           }
    //         ]
    //       }
    //     ]
    //   }
    // }
    // ''';

    final Map<String, dynamic> data = json.decode(response.body);
    // final Map<String, dynamic> data = json.decode(response);
    return ManualPlateRegisterResponse.fromJson(data);
  }
}
