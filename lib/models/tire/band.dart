import 'type_band.dart';

class Band {
  int? id;
  String? name;
  double? price;
  double? profundity;
  TypeBand? typeBand;
  String? creationDate;
  String? lastUpdate;

  Band({
    this.id,
    this.name,
    this.price,
    this.profundity,
    this.typeBand,
    this.creationDate,
    this.lastUpdate,
  });

  factory Band.fromJson(Map<String, dynamic> json) => Band(
        id: json["id"],
        name: json["name"],
        price: json["price"]?.toDouble(),
        profundity: json["profundity"]?.toDouble(),
        typeBand: json["type_band"] == null ? null : TypeBand.fromJson(json["type_band"]),
        creationDate: json["creation_date"],
        lastUpdate: json["last_update"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "profundity": profundity,
        "type_band": typeBand?.toJson(),
        "creation_date": creationDate,
        "last_update": lastUpdate,
      };
}
