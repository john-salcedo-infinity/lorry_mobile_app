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
        data: json["data"] == null ? null : MountingData.fromJson(json["data"]),
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
  String? licensePlate;
  dynamic numberLorry;
  String? typeVehicleName;
  String? businessName;
  String? axleName;
  String? workLineName;
  double? mileage;
  Tire? tire;

  MountingResult({
    this.id,
    this.position,
    this.typeAxle,
    this.vehicle,
    this.licensePlate,
    this.numberLorry,
    this.typeVehicleName,
    this.businessName,
    this.axleName,
    this.workLineName,
    this.mileage,
    this.tire,
  });

  factory MountingResult.fromJson(Map<String, dynamic> json) => MountingResult(
        licensePlate: json["vehicle__license_plate"],
        numberLorry: json["vehicle__number_lorry"],
        typeVehicleName: json["vehicle__type_vehicle__name"],
        businessName: json["vehicle__customer__business_name"],
        axleName: json["vehicle__type_vehicle__axle__axle_name"],
        workLineName: json["vehicle__work_line__name"],
        mileage: json["vehicle__mileage__km"]?.toDouble(),
        tire: json["vehicle__tire"] == null ? null : Tire.fromJson(json["vehicle__tire"]),
      );

  Map<String, dynamic> toJson() => {
        "vehicle__license_plate": licensePlate,
        "vehicle__number_lorry": numberLorry,
        "vehicle__type_vehicle__name": typeVehicleName,
        "vehicle__customer__business_name": businessName,
        "vehicle__type_vehicle__axle__axle_name": axleName,
        "vehicle__work_line__name": workLineName,
        "vehicle__mileage__km": mileage,
        "vehicle__tire": tire?.toJson(),
      };
}
