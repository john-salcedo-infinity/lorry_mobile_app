class TypeProvider {
  int? id;
  String? name;

  TypeProvider({
    this.id,
    this.name,
  });

  factory TypeProvider.fromJson(Map<String, dynamic> json) => TypeProvider(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
