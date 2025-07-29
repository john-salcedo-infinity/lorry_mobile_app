import 'stay.dart';
import 'status_tire.dart';
import 'design.dart';
import 'band.dart';
import 'warehouse.dart';
import 'consecutive_type.dart';

class Tire {
  int? id;
  bool? status;
  bool? typeOfTire;
  int? km;
  double? costUnit;
  String? purchaseOrder;
  String? integrationCode;
  String? description;
  bool? reRecorded;
  double? profMinimum;
  double? profExternal;
  String? costPerKm;
  double? profCenter;
  double? profInternal;
  double? profExternalCurrent;
  double? profCenterCurrent;
  double? profInternalCurrent;
  double? kmCurrent;
  String? inspectionsDate;
  String? dotPlate;
  double? costPerKmProyect;
  double? millimetersSpent;
  double? kmPerMillimeters;
  String? mountingDate;
  double? availableMillimeters;
  double? averageMonth;
  String? costPerMonth;
  double? millimetersCost;
  double? wearPercentage;
  double? remainingPercentage;
  int? wearCost;
  double? remainingCost;
  double? kmProyect;
  String? dismantlingDate;
  Stay? stay;
  StatusTire? statusTire;
  Design? design;
  Band? band;
  Warehouse? warehouse;
  ConsecutiveType? consecutiveType;
  String? creationDate;
  String? lastUpdate;

  Tire({
    this.id,
    this.status,
    this.typeOfTire,
    this.km,
    this.costUnit,
    this.purchaseOrder,
    this.integrationCode,
    this.description,
    this.reRecorded,
    this.profMinimum,
    this.profExternal,
    this.costPerKm,
    this.profCenter,
    this.profInternal,
    this.profExternalCurrent,
    this.profCenterCurrent,
    this.profInternalCurrent,
    this.kmCurrent,
    this.inspectionsDate,
    this.dotPlate,
    this.costPerKmProyect,
    this.millimetersSpent,
    this.kmPerMillimeters,
    this.mountingDate,
    this.availableMillimeters,
    this.averageMonth,
    this.costPerMonth,
    this.millimetersCost,
    this.wearPercentage,
    this.remainingPercentage,
    this.wearCost,
    this.remainingCost,
    this.kmProyect,
    this.dismantlingDate,
    this.stay,
    this.statusTire,
    this.design,
    this.band,
    this.warehouse,
    this.consecutiveType,
    this.creationDate,
    this.lastUpdate,
  });

  factory Tire.fromJson(Map<String, dynamic> json) => Tire(
        id: json["id"],
        status: json["status"],
        typeOfTire: json["type_of_tire"],
        km: json["km"],
        costUnit: json["cost_unit"]?.toDouble(),
        purchaseOrder: json["purchase_order"],
        integrationCode: json["integration_code"],
        description: json["description"],
        reRecorded: json["re_recorded"],
        profMinimum: json["prof_minimum"]?.toDouble(),
        profExternal: json["prof_external"]?.toDouble(),
        costPerKm: json["cost_per_km"],
        profCenter: json["prof_center"]?.toDouble(),
        profInternal: json["prof_internal"]?.toDouble(),
        profExternalCurrent: json["prof_external_current"]?.toDouble(),
        profCenterCurrent: json["prof_center_current"]?.toDouble(),
        profInternalCurrent: json["prof_internal_current"]?.toDouble(),
        kmCurrent: json["km_current"]?.toDouble(),
        inspectionsDate: json["inspections_date"],
        dotPlate: json["dot_plate"],
        costPerKmProyect: json["cost_per_km_proyect"]?.toDouble(),
        millimetersSpent: json["millimeters_spent"]?.toDouble(),
        kmPerMillimeters: json["km_per_millimeters"]?.toDouble(),
        mountingDate: json["mounting_date"],
        availableMillimeters: json["available_millimeters"]?.toDouble(),
        averageMonth: json["average_month"]?.toDouble(),
        costPerMonth: json["cost_per_month"],
        millimetersCost: json["millimeters_cost"]?.toDouble(),
        wearPercentage: json["wear_percentage"]?.toDouble(),
        remainingPercentage: json["remaining_percentage"]?.toDouble(),
        wearCost: json["wear_cost"],
        remainingCost: json["remaining_cost"]?.toDouble(),
        kmProyect: json["km_proyect"]?.toDouble(),
        dismantlingDate: json["dismantling_date"],
        stay: json["stay"] == null ? null : Stay.fromJson(json["stay"]),
        statusTire: json["status_tire"] == null ? null : StatusTire.fromJson(json["status_tire"]),
        design: json["design"] == null ? null : Design.fromJson(json["design"]),
        band: json["band"] == null ? null : Band.fromJson(json["band"]),
        warehouse: json["warehouse"] == null ? null : Warehouse.fromJson(json["warehouse"]),
        consecutiveType: json["consecutive_type"] == null ? null : ConsecutiveType.fromJson(json["consecutive_type"]),
        creationDate: json["creation_date"],
        lastUpdate: json["last_update"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "type_of_tire": typeOfTire,
        "km": km,
        "cost_unit": costUnit,
        "purchase_order": purchaseOrder,
        "integration_code": integrationCode,
        "description": description,
        "re_recorded": reRecorded,
        "prof_minimum": profMinimum,
        "prof_external": profExternal,
        "cost_per_km": costPerKm,
        "prof_center": profCenter,
        "prof_internal": profInternal,
        "prof_external_current": profExternalCurrent,
        "prof_center_current": profCenterCurrent,
        "prof_internal_current": profInternalCurrent,
        "km_current": kmCurrent,
        "inspections_date": inspectionsDate,
        "dot_plate": dotPlate,
        "cost_per_km_proyect": costPerKmProyect,
        "millimeters_spent": millimetersSpent,
        "km_per_millimeters": kmPerMillimeters,
        "mounting_date": mountingDate,
        "available_millimeters": availableMillimeters,
        "average_month": averageMonth,
        "cost_per_month": costPerMonth,
        "millimeters_cost": millimetersCost,
        "wear_percentage": wearPercentage,
        "remaining_percentage": remainingPercentage,
        "wear_cost": wearCost,
        "remaining_cost": remainingCost,
        "km_proyect": kmProyect,
        "dismantling_date": dismantlingDate,
        "stay": stay?.toJson(),
        "status_tire": statusTire?.toJson(),
        "design": design?.toJson(),
        "band": band?.toJson(),
        "warehouse": warehouse?.toJson(),
        "consecutive_type": consecutiveType?.toJson(),
        "creation_date": creationDate,
        "last_update": lastUpdate,
      };

  @override
  String toString() {
    return 'Tire(id: $id, integrationCode: $integrationCode, design: ${design?.name}, status: $status, km: $km)';
  }
}
