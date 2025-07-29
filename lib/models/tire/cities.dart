class Cities {
  int? id;
  String? name;

  Cities({
    this.id,
    this.name,
  });

  factory Cities.fromJson(Map<String, dynamic> json) => Cities(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
