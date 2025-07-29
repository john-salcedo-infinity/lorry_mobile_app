class Axle {
  int? id;
  int? point;
  int? amountAxle;
  bool? isSingle;
  bool? isDirectional;
  int? amountPosition;
  String? axleName;
  int? numberDirectionalTires;
  int? traction;
  bool? status;
  dynamic creationUser;
  dynamic userUpdate;
  String? creationDate;
  String? lastUpdate;

  Axle({
    this.id,
    this.point,
    this.amountAxle,
    this.isSingle,
    this.isDirectional,
    this.amountPosition,
    this.axleName,
    this.numberDirectionalTires,
    this.traction,
    this.status,
    this.creationUser,
    this.userUpdate,
    this.creationDate,
    this.lastUpdate,
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
        creationDate: json["creation_date"],
        lastUpdate: json["last_update"],
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
        "creation_date": creationDate,
        "last_update": lastUpdate,
      };
}
