class Stay {
  int? id;
  String? name;
  int? parameter;
  String? parameterName;

  Stay({
    this.id,
    this.name,
    this.parameter,
    this.parameterName,
  });

  factory Stay.fromJson(Map<String, dynamic> json) => Stay(
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
