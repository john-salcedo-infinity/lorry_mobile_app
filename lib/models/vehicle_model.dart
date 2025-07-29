import './models.dart';

class Vehicle {
  int id;
  String typeVehicleName;
  String? numberLorry;
  String licensePlate;
  int mileageId;
  Customer customer;
  TypeVehicle? typeVehicle;
  WorkLine workLine;
  Mileage? mileage;
  DateTime? creationDate;
  DateTime lastUpdate;

  Vehicle({
    required this.id,
    required this.typeVehicleName,
    this.numberLorry,
    required this.licensePlate,
    required this.lastUpdate,
    required this.mileageId,
    required this.customer,
    required this.workLine,
    this.mileage,
    this.typeVehicle,
    this.creationDate,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json["id"],
        typeVehicleName: json["type_vehicle_name"],
        numberLorry: json["number_lorry"],
        licensePlate: json["license_plate"],
        lastUpdate: DateTime.parse(json["last_update"]),
        mileageId: json["mileage_id"],
        customer: Customer.fromJson(json["customer"]),
        workLine: WorkLine.fromJson(json["work_line"]),
        mileage: json["mileage"] == null ? null : Mileage.fromJson(json["mileage"]),
        typeVehicle: json["type_vehicle"] == null
            ? null
            : TypeVehicle.fromJson(json["type_vehicle"]),
        creationDate: json["creation_date"] == null
            ? null
            : DateTime.parse(json["creation_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type_vehicle_name": typeVehicleName,
        "number_lorry": numberLorry,
        "license_plate": licensePlate,
        "mileage_id": mileageId,
        "customer": customer.toJson(),
        "work_line": workLine.toJson(),
        "type_vehicle": typeVehicle?.toJson(),
        "mileage": mileage?.toJson(),
        "creation_date": creationDate?.toIso8601String(),
        "last_update": lastUpdate.toIso8601String(),
      };
}
