class Mileage {
  int? id;
  double? km;
  String? creationDate;
  String? lastUpdate;

  Mileage({
    this.id,
    this.km,
    this.creationDate,
    this.lastUpdate,
  });

  factory Mileage.fromJson(Map<String, dynamic> json) => Mileage(
        id: json["id"],
        km: json["km"]?.toDouble(),
        creationDate: json["creation_date"],
        lastUpdate: json["last_update"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "km": km,
        "creation_date": creationDate,
        "last_update": lastUpdate,
      };
}
