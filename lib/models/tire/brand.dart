import 'provider.dart';

class Brand {
  int? id;
  String? name;
  bool? status;
  Provider? provider;
  String? creationDate;
  String? lastUpdate;

  Brand({
    this.id,
    this.name,
    this.status,
    this.provider,
    this.creationDate,
    this.lastUpdate,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        provider: json["provider"] == null ? null : Provider.fromJson(json["provider"]),
        creationDate: json["creation_date"],
        lastUpdate: json["last_update"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "provider": provider?.toJson(),
        "creation_date": creationDate,
        "last_update": lastUpdate,
      };
}
