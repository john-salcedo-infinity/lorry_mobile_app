import './models.dart';

class TypeVehicle {
  int id;
  String name;
  int directional;
  int traction;
  int free;
  int replacementTire;
  Axle axle;
  bool status;
  String? creationUser;
  String? userUpdate;
  DateTime creationDate;
  DateTime lastUpdate;

  TypeVehicle({
    required this.id,
    required this.name,
    required this.directional,
    required this.traction,
    required this.free,
    required this.replacementTire,
    required this.axle,
    required this.status,
    this.creationUser,
    this.userUpdate,
    required this.creationDate,
    required this.lastUpdate,
  });

  factory TypeVehicle.fromJson(Map<String, dynamic> json) => TypeVehicle(
        id: json["id"],
        name: json["name"],
        directional: json["directional"],
        traction: json["traction"],
        free: json["free"],
        replacementTire: json["replacement_tire"],
        axle: Axle.fromJson(json["axle"]),
        status: json["status"],
        creationUser: json["creation_user"],
        userUpdate: json["user_update"],
        creationDate: DateTime.parse(json["creation_date"]),
        lastUpdate: DateTime.parse(json["last_update"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "directional": directional,
        "traction": traction,
        "free": free,
        "replacement_tire": replacementTire,
        "axle": axle.toJson(),
        "status": status,
        "creation_user": creationUser,
        "user_update": userUpdate,
        "creation_date": creationDate.toIso8601String(),
        "last_update": lastUpdate.toIso8601String(),
      };
}