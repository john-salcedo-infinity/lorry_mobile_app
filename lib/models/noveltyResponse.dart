import 'dart:convert';

class NoveltyResponse {
  bool success;
  List<String> messages;
  NoveltyData data;  // Cambiado de List<Novelty>? a NoveltyData?

  NoveltyResponse({
    required this.success,
    required this.messages,
    required this.data,
  });

  factory NoveltyResponse.fromRawJson(String str) =>
      NoveltyResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NoveltyResponse.fromJson(Map<String, dynamic> json) =>
      NoveltyResponse(
        success: json["success"],
        messages: List<String>.from(json["messages"].map((x) => x)),
        data: NoveltyData.fromJson(json["data"]),  // Cambiado a NoveltyData.fromJson
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "messages": List<dynamic>.from(messages.map((x) => x)),
        "data": data.toJson(),
      };
}

// Nueva clase para manejar la paginación
class NoveltyData {
  int? count;
  String? next;
  String? previous;
  List<Novelty>? results;

  NoveltyData({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory NoveltyData.fromJson(Map<String, dynamic> json) => NoveltyData(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null
            ? null
            : List<Novelty>.from(json["results"].map((x) => Novelty.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}

class Novelty {
  int? id;
  String? name;
  String? abbreviation;
  String? description;
  bool? status;
  int? creationUser;
  int? userUpdate;
  String? creationDate;
  String? lastUpdate;

  Novelty({
    this.id,
    this.name,
    this.abbreviation,
    this.description,
    this.status,
    this.creationUser,
    this.userUpdate,
    this.creationDate,
    this.lastUpdate,
  });

  factory Novelty.fromJson(Map<String, dynamic> json) => Novelty(
        id: json["id"],
        name: json["name"],
        abbreviation: json["abbreviation"],
        description: json["description"],
        status: json["status"],
        creationUser: json["creation_user"],
        userUpdate: json["user_update"],
        creationDate: json["creation_date"],
        lastUpdate: json["last_update"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "abbreviation": abbreviation,
        "description": description,
        "status": status,
        "creation_user": creationUser,
        "user_update": userUpdate,
        "creation_date": creationDate,
        "last_update": lastUpdate,
      };
}