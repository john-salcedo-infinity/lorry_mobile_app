class TypeAxle {
  int id;
  String name;
  int parameter;
  String parameterName;

  TypeAxle({
    required this.id,
    required this.name,
    required this.parameter,
    required this.parameterName,
  });

  factory TypeAxle.fromJson(Map<String, dynamic> json) => TypeAxle(
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
