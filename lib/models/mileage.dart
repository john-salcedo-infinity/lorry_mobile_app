class Mileage {
  int id;
  double km;
  DateTime creationDate;
  DateTime lastUpdate;

  Mileage({
    required this.id,
    required this.km,
    required this.creationDate,
    required this.lastUpdate,
  });

  factory Mileage.fromJson(Map<String, dynamic> json) => Mileage(
        id: json["id"],
        km: json["km"]?.toDouble() ?? 0.0,
        creationDate: DateTime.parse(json["creation_date"]),
        lastUpdate: DateTime.parse(json["last_update"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "km": km,
        "creation_date": creationDate.toIso8601String(),
        "last_update": lastUpdate.toIso8601String(),
      };
}
