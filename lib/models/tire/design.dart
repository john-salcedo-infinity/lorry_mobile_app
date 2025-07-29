import 'route.dart';
import 'dimension.dart';
import 'brand.dart';

class Design {
  int? id;
  String? name;
  String? observation;
  Route? route;
  double? profundity;
  String? image;
  Dimension? dimension;
  Brand? brand;
  String? creationDate;
  String? lastUpdate;

  Design({
    this.id,
    this.name,
    this.observation,
    this.route,
    this.profundity,
    this.image,
    this.dimension,
    this.brand,
    this.creationDate,
    this.lastUpdate,
  });

  factory Design.fromJson(Map<String, dynamic> json) => Design(
        id: json["id"],
        name: json["name"],
        observation: json["observation"],
        route: json["route"] == null ? null : Route.fromJson(json["route"]),
        profundity: json["profundity"]?.toDouble(),
        image: json["image"],
        dimension: json["dimension"] == null ? null : Dimension.fromJson(json["dimension"]),
        brand: json["brand"] == null ? null : Brand.fromJson(json["brand"]),
        creationDate: json["creation_date"],
        lastUpdate: json["last_update"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "observation": observation,
        "route": route?.toJson(),
        "profundity": profundity,
        "image": image,
        "dimension": dimension?.toJson(),
        "brand": brand?.toJson(),
        "creation_date": creationDate,
        "last_update": lastUpdate,
      };
}
