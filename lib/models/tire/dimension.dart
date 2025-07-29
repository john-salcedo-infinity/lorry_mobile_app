class Dimension {
  int? id;
  String? dimension;
  double? pressure;
  String? creationDate;
  String? lastUpdate;

  Dimension({
    this.id,
    this.dimension,
    this.pressure,
    this.creationDate,
    this.lastUpdate,
  });

  factory Dimension.fromJson(Map<String, dynamic> json) => Dimension(
        id: json["id"],
        dimension: json["dimension"],
        pressure: json["pressure"]?.toDouble(),
        creationDate: json["creation_date"],
        lastUpdate: json["last_update"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "dimension": dimension,
        "pressure": pressure,
        "creation_date": creationDate,
        "last_update": lastUpdate,
      };
}
