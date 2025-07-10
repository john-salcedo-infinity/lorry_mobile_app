
import 'dart:convert';

class User {
    int? id;
    String? name;
    String? username;
    String? email;
    dynamic image;
    List<Group>? groups;
    Persons? persons;
    DateTime? creationDate;
    DateTime? lastUpdate;

    User({
        this.id,
        this.name,
        this.username,
        this.email,
        this.image,
        this.groups,
        this.persons,
        this.creationDate,
        this.lastUpdate,
    });

    factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        username: json["username"],
        email: json["email"],
        image: json["image"],
        groups: json["groups"] == null ? [] : List<Group>.from(json["groups"]!.map((x) => Group.fromJson(x))),
        persons: json["persons"] == null ? null : Persons.fromJson(json["persons"]),
        creationDate: json["creation_date"] == null ? null : DateTime.parse(json["creation_date"]),
        lastUpdate: json["last_update"] == null ? null : DateTime.parse(json["last_update"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "username": username,
        "email": email,
        "image": image,
        "groups": groups == null ? [] : List<dynamic>.from(groups!.map((x) => x.toJson())),
        "persons": persons?.toJson(),
        "creation_date": creationDate?.toIso8601String(),
        "last_update": lastUpdate?.toIso8601String(),
    };
}

class Group {
    int? id;
    String? name;
    int? userUpdate;
    int? creationUser;
    bool? status;

    Group({
        this.id,
        this.name,
        this.userUpdate,
        this.creationUser,
        this.status,
    });

    factory Group.fromRawJson(String str) => Group.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Group.fromJson(Map<String, dynamic> json) => Group(
        id: json["id"],
        name: json["name"],
        userUpdate: json["user_update"],
        creationUser: json["creation_user"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "user_update": userUpdate,
        "creation_user": creationUser,
        "status": status,
    };
}

class Persons {
    int? id;
    TypeNumber? typeNumber;
    String? numberId;
    String? name;
    String? lastName;
    String? prefix;
    String? phone;
    String? email;
    String? address;
    bool? status;
    int? creationUser;
    int? userUpdate;
    DateTime? creationDate;
    DateTime? lastUpdate;

    Persons({
        this.id,
        this.typeNumber,
        this.numberId,
        this.name,
        this.lastName,
        this.prefix,
        this.phone,
        this.email,
        this.address,
        this.status,
        this.creationUser,
        this.userUpdate,
        this.creationDate,
        this.lastUpdate,
    });

    factory Persons.fromRawJson(String str) => Persons.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Persons.fromJson(Map<String, dynamic> json) => Persons(
        id: json["id"],
        typeNumber: json["type_number"] == null ? null : TypeNumber.fromJson(json["type_number"]),
        numberId: json["number_id"],
        name: json["name"],
        lastName: json["last_name"],
        prefix: json["prefix"],
        phone: json["phone"],
        email: json["email"],
        address: json["address"],
        status: json["status"],
        creationUser: json["creation_user"],
        userUpdate: json["user_update"],
        creationDate: json["creation_date"] == null ? null : DateTime.parse(json["creation_date"]),
        lastUpdate: json["last_update"] == null ? null : DateTime.parse(json["last_update"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "type_number": typeNumber?.toJson(),
        "number_id": numberId,
        "name": name,
        "last_name": lastName,
        "prefix": prefix,
        "phone": phone,
        "email": email,
        "address": address,
        "status": status,
        "creation_user": creationUser,
        "user_update": userUpdate,
        "creation_date": creationDate?.toIso8601String(),
        "last_update": lastUpdate?.toIso8601String(),
    };
}

class TypeNumber {
    int? id;
    String? name;
    int? parameter;
    String? parameterName;

    TypeNumber({
        this.id,
        this.name,
        this.parameter,
        this.parameterName,
    });

    factory TypeNumber.fromRawJson(String str) => TypeNumber.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TypeNumber.fromJson(Map<String, dynamic> json) => TypeNumber(
        id: json["id"],
        name: json["name"],
        parameter: json["parameter"],
        parameterName: json["parameter_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "parameter": parameter,
        "parameter_name": parameterName,
    };
}
