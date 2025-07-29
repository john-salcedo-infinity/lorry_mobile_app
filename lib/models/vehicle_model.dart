import './models.dart';

class Vehicle {
  int? id;
  String? licensePlate;
  dynamic numberLorry;
  bool? status;
  Customer? customer;
  TypeVehicle? typeVehicle;
  WorkLine? workLine;
  List<Mileage>? mileage;
  String? creationDate;
  String? lastUpdate;

  Vehicle({
    this.id,
    this.licensePlate,
    this.numberLorry,
    this.status,
    this.customer,
    this.typeVehicle,
    this.workLine,
    this.mileage,
    this.creationDate,
    this.lastUpdate,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json["id"],
        licensePlate: json["license_plate"],
        numberLorry: json["number_lorry"],
        status: json["status"],
        customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
        typeVehicle: json["type_vehicle"] == null ? null : TypeVehicle.fromJson(json["type_vehicle"]),
        workLine: json["work_line"] == null ? null : WorkLine.fromJson(json["work_line"]),
        mileage: json["mileage"] == null 
            ? [] 
            : List<Mileage>.from(json["mileage"].map((x) => Mileage.fromJson(x))),
        creationDate: json["creation_date"],
        lastUpdate: json["last_update"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "license_plate": licensePlate,
        "number_lorry": numberLorry,
        "status": status,
        "customer": customer?.toJson(),
        "type_vehicle": typeVehicle?.toJson(),
        "work_line": workLine?.toJson(),
        "mileage": mileage == null 
            ? [] 
            : List<dynamic>.from(mileage!.map((x) => x.toJson())),
        "creation_date": creationDate,
        "last_update": lastUpdate,
      };
}
