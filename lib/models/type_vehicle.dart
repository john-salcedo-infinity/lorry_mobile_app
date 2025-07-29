import './models.dart';

class TypeVehicle {
  int? id;
  String? name;
  int? directional;
  int? traction;
  int? free;
  int? replacementTire;
  Axle? axle;
  bool? status;
  dynamic creationUser;
  dynamic userUpdate;
  String? creationDate;
  String? lastUpdate;

  TypeVehicle({
    this.id,
    this.name,
    this.directional,
    this.traction,
    this.free,
    this.replacementTire,
    this.axle,
    this.status,
    this.creationUser,
    this.userUpdate,
    this.creationDate,
    this.lastUpdate,
  });

  factory TypeVehicle.fromJson(Map<String, dynamic> json) => TypeVehicle(
        id: json["id"],
        name: json["name"],
        directional: json["directional"],
        traction: json["traction"],
        free: json["free"],
        replacementTire: json["replacement_tire"],
        axle: json["axle"] == null ? null : Axle.fromJson(json["axle"]),
        status: json["status"],
        creationUser: json["creation_user"],
        userUpdate: json["user_update"],
        creationDate: json["creation_date"],
        lastUpdate: json["last_update"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "directional": directional,
        "traction": traction,
        "free": free,
        "replacement_tire": replacementTire,
        "axle": axle?.toJson(),
        "status": status,
        "creation_user": creationUser,
        "user_update": userUpdate,
        "creation_date": creationDate,
        "last_update": lastUpdate,
      };
}