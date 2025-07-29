class Axle {
  int id;
  int point;
  int amountAxle;
  bool isSingle;
  bool isDirectional;
  int amountPosition;
  String axleName;
  int numberDirectionalTires;
  int traction;
  bool status;
  String? creationUser;
  String? userUpdate;
  DateTime creationDate;
  DateTime lastUpdate;

  Axle({
    required this.id,
    required this.point,
    required this.amountAxle,
    required this.isSingle,
    required this.isDirectional,
    required this.amountPosition,
    required this.axleName,
    required this.numberDirectionalTires,
    required this.traction,
    required this.status,
    this.creationUser,
    this.userUpdate,
    required this.creationDate,
    required this.lastUpdate,
  });

  factory Axle.fromJson(Map<String, dynamic> json) => Axle(
        id: json["id"],
        point: json["point"],
        amountAxle: json["amount_axle"],
        isSingle: json["is_single"],
        isDirectional: json["is_directional"],
        amountPosition: json["amount_position"],
        axleName: json["axle_name"],
        numberDirectionalTires: json["number_directional_tires"],
        traction: json["traction"],
        status: json["status"],
        creationUser: json["creation_user"],
        userUpdate: json["user_update"],
        creationDate: DateTime.parse(json["creation_date"]),
        lastUpdate: DateTime.parse(json["last_update"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "point": point,
        "amount_axle": amountAxle,
        "is_single": isSingle,
        "is_directional": isDirectional,
        "amount_position": amountPosition,
        "axle_name": axleName,
        "number_directional_tires": numberDirectionalTires,
        "traction": traction,
        "status": status,
        "creation_user": creationUser,
        "user_update": userUpdate,
        "creation_date": creationDate.toIso8601String(),
        "last_update": lastUpdate.toIso8601String(),
      };
}
