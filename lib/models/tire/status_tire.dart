class StatusTire {
  int? id;
  String? name;

  StatusTire({
    this.id,
    this.name,
  });

  factory StatusTire.fromJson(Map<String, dynamic> json) => StatusTire(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
