import 'dart:convert';

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
  String? licensePlate;
  dynamic numberLorry;
  String? typeVehicleName;
  String? businessName;
  String? axleName;
  String? workLineName;
  double? mileage;
  List<Tire>? tires;

  MountingResult({
    this.licensePlate,
    this.numberLorry,
    this.typeVehicleName,
    this.businessName,
    this.axleName,
    this.workLineName,
    this.mileage,
    this.tires,
  });

  factory MountingResult.fromJson(Map<String, dynamic> json) => MountingResult(
        licensePlate: json["vehicle__license_plate"],
        numberLorry: json["vehicle__number_lorry"],
        typeVehicleName: json["vehicle__type_vehicle__name"],
        businessName: json["vehicle__customer__business_name"],
        axleName: json["vehicle__type_vehicle__axle__axle_name"],
        workLineName: json["vehicle__work_line__name"],
        mileage: json["vehicle__mileage__km"]?.toDouble(),
        tires: (json['tires'] as List?)
            ?.cast<Map<String, dynamic>>()
            .map((e) => Tire.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "vehicle__license_plate": licensePlate,
        "vehicle__number_lorry": numberLorry,
        "vehicle__type_vehicle__name": typeVehicleName,
        "vehicle__customer__business_name": businessName,
        "vehicle__type_vehicle__axle__axle_name": axleName,
        "vehicle__work_line__name": workLineName,
        "vehicle__mileage__km": mileage,
        "tires": tires == null
            ? []
            : List<dynamic>.from(tires!.map((x) => x.toJson())),
      };
}

class Tire {
  int? tirId;
  String? integrationCode;
  String? design;
  String? brand;
  String? band;
  String? positions;
  double? pressure;
  double? profExternalCurrent;
  double? profCenterCurrent;
  double? profInternalCurrent;

  Tire({
    this.tirId,
    this.integrationCode,
    this.design,
    this.brand,
    this.band,
    this.positions,
    this.pressure = 100,
    this.profExternalCurrent,
    this.profCenterCurrent,
    this.profInternalCurrent,
  });

  factory Tire.fromJson(Map<String, dynamic> json) => Tire(
        tirId: json["tire__id"],
        integrationCode: json["tire__integration_code"],
        design: json["tire__design__name"],
        brand: json["tire__design__brand__name"],
        band: json["tire__band__name"],
        positions: json["position"],
        pressure: json["pressure"],
        profExternalCurrent: json["tire__prof_external_current"],
        profCenterCurrent: json["tire__prof_center_current"],
        profInternalCurrent: json["tire__prof_internal_current"],
      );

  Map<String, dynamic> toJson() => {
        "tire__id": tirId,
        "tire__integration_code": integrationCode,
        "tire__design__name": design,
        "tire__design__brand__name": brand,
        "tire__band__name": band,
        "position": positions,
        "pressure": pressure,
        "tire__prof_external_current": profExternalCurrent,
        "tire__prof_center_current": profCenterCurrent,
        "tire__prof_internal_current": profInternalCurrent,
      };

  // Sobrescribir el método toString para una representación más completa
  @override
  String toString() {
    return 'Tire(id: $tirId, design: $design, brand: $brand, band: $band, position: $positions, pressure: $pressure, externalProf: $profExternalCurrent, centerProf: $profCenterCurrent, internalProf: $profInternalCurrent)';
  }
}

