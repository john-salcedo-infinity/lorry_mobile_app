class Route {
  int? id;
  String? name;
  bool? status;
  String? creationUser;
  String? userUpdate;
  String? creationDate;
  String? lastUpdate;

  Route({
    this.id,
    this.name,
    this.status,
    this.creationUser,
    this.userUpdate,
    this.creationDate,
    this.lastUpdate,
  });

  factory Route.fromJson(Map<String, dynamic> json) => Route(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        creationUser: json["creation_user"],
        userUpdate: json["user_update"],
        creationDate: json["creation_date"],
        lastUpdate: json["last_update"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "creation_user": creationUser,
        "user_update": userUpdate,
        "creation_date": creationDate,
        "last_update": lastUpdate,
      };
}
