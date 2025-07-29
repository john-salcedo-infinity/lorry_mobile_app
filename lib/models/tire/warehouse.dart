class Warehouse {
  int? id;
  String? address;
  String? name;
  double? latitude;
  double? longitude;
  bool? status;
  int? creationUser;
  int? userUpdate;
  String? creationDate;
  String? lastUpdate;
  int? warehouseAssistant;
  int? cities;

  Warehouse({
    this.id,
    this.address,
    this.name,
    this.latitude,
    this.longitude,
    this.status,
    this.creationUser,
    this.userUpdate,
    this.creationDate,
    this.lastUpdate,
    this.warehouseAssistant,
    this.cities,
  });

  factory Warehouse.fromJson(Map<String, dynamic> json) => Warehouse(
        id: json["id"],
        address: json["addres"], // Note: API has typo "addres"
        name: json["name"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        status: json["status"],
        creationUser: json["creation_user"],
        userUpdate: json["user_update"],
        creationDate: json["creation_date"],
        lastUpdate: json["last_update"],
        warehouseAssistant: json["warehouse_assistant"],
        cities: json["cities"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "addres": address, // Maintaining API consistency
        "name": name,
        "latitude": latitude,
        "longitude": longitude,
        "status": status,
        "creation_user": creationUser,
        "user_update": userUpdate,
        "creation_date": creationDate,
        "last_update": lastUpdate,
        "warehouse_assistant": warehouseAssistant,
        "cities": cities,
      };
}
