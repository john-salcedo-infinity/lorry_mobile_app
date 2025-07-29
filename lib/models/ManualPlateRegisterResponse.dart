import 'dart:convert';
import 'package:app_lorry/models/models.dart';

class ManualPlateRegisterResponse {
  bool? success;
  List<String>? messages;
  MountingData? data;

  ManualPlateRegisterResponse({
    this.success,
    this.messages,
    this.data,
  });

  factory ManualPlateRegisterResponse.fromRawJson(String str) =>
      ManualPlateRegisterResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ManualPlateRegisterResponse.fromJson(Map<String, dynamic> json) =>
      ManualPlateRegisterResponse(
        success: json["success"],
        messages: json["messages"] == null
            ? []
            : List<String>.from(json["messages"].map((x) => x)),
        data: json["data"] == null
            ? null
            : MountingData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "messages":
            messages == null ? [] : List<dynamic>.from(messages!.map((x) => x)),
        "data": data?.toJson(),
      };
}

class MountingData {
  int? count;
  String? next;
  String? previous;
  List<MountingResult>? results;

  MountingData({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory MountingData.fromJson(Map<String, dynamic> json) => MountingData(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null
            ? []
            : List<MountingResult>.from(
                json["results"].map((x) => MountingResult.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}

class MountingResult {
  int? id;
  int? position;
  TypeAxle? typeAxle;
  Vehicle? vehicle;
  Tire? tire;
  String? creationDate;
  String? lastUpdate;
  String? date;

  MountingResult({
    this.id,
    this.position,
    this.typeAxle,
    this.vehicle,
    this.tire,
    this.creationDate,
    this.lastUpdate,
    this.date,
  });

  factory MountingResult.fromJson(Map<String, dynamic> json) => MountingResult(
        id: json["id"],
        position: json["position"],
        typeAxle: json["type_axle"] == null ? null : TypeAxle.fromJson(json["type_axle"]),
        vehicle: json["vehicle"] == null ? null : Vehicle.fromJson(json["vehicle"]),
        tire: json["tire"] == null ? null : Tire.fromJson(json["tire"]),
        creationDate: json["creation_date"],
        lastUpdate: json["last_update"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "position": position,
        "type_axle": typeAxle?.toJson(),
        "vehicle": vehicle?.toJson(),
        "tire": tire?.toJson(),
        "creation_date": creationDate,
        "last_update": lastUpdate,
        "date": date,
      };
}

// Ejemplo de uso:
// void testModel() {
//   const jsonString = '''
//   {
//     "success": true,
//     "messages": ["Listado de montajes de llantas con éxito"],
//     "data": {
//       "count": 12,
//       "next": null,
//       "previous": null,
//       "results": [
//         {
//           "id": 2699,
//           "position": 101,
//           "type_axle": {
//             "id": 60,
//             "name": "Repuesto",
//             "parameter": 15,
//             "parameter_name": "Tipo de eje"
//           },
//           "vehicle": {
//             "id": 215,
//             "license_plate": "AVO111",
//             "number_lorry": null,
//             "status": true
//           },
//           "tire": null,
//           "creation_date": "2025-07-29T08:17:59.451439",
//           "last_update": "2025-07-29T08:17:59.586712",
//           "date": null
//         }
//       ]
//     }
//   }
//   ''';
//   
//   final response = ManualPlateRegisterResponse.fromRawJson(jsonString);
//   print('Success: ${response.success}');
//   print('Messages: ${response.messages}');
//   print('Count: ${response.data?.count}');
//   print('First result ID: ${response.data?.results?.first.id}');
// }
