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
