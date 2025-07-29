class ConsecutiveType {
  int? id;
  String? name;
  int? parameter;
  String? parameterName;

  ConsecutiveType({
    this.id,
    this.name,
    this.parameter,
    this.parameterName,
  });

  factory ConsecutiveType.fromJson(Map<String, dynamic> json) => ConsecutiveType(
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
