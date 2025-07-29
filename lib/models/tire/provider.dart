import '../User.dart' show TypeNumber;
import 'cities.dart';
import 'type_provider.dart';

class Provider {
  int? id;
  String? numberId;
  String? nameProvider;
  String? contac;
  String? prefix;
  String? phone;
  String? email;
  String? address;
  TypeNumber? typeNumber;
  Cities? cities;
  TypeProvider? typeProvider;
  String? creationDate;
  String? lastUpdate;

  Provider({
    this.id,
    this.numberId,
    this.nameProvider,
    this.contac,
    this.prefix,
    this.phone,
    this.email,
    this.address,
    this.typeNumber,
    this.cities,
    this.typeProvider,
    this.creationDate,
    this.lastUpdate,
  });

  factory Provider.fromJson(Map<String, dynamic> json) => Provider(
        id: json["id"],
        numberId: json["number_id"],
        nameProvider: json["name_provider"],
        contac: json["contac"],
        prefix: json["prefix"],
        phone: json["phone"],
        email: json["email"],
        address: json["address"],
        typeNumber: json["type_number"] == null ? null : TypeNumber.fromJson(json["type_number"]),
        cities: json["cities"] == null ? null : Cities.fromJson(json["cities"]),
        typeProvider: json["type_provider"] == null ? null : TypeProvider.fromJson(json["type_provider"]),
        creationDate: json["creation_date"],
        lastUpdate: json["last_update"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "number_id": numberId,
        "name_provider": nameProvider,
        "contac": contac,
        "prefix": prefix,
        "phone": phone,
        "email": email,
        "address": address,
        "type_number": typeNumber?.toJson(),
        "cities": cities?.toJson(),
        "type_provider": typeProvider?.toJson(),
        "creation_date": creationDate,
        "last_update": lastUpdate,
      };
}
