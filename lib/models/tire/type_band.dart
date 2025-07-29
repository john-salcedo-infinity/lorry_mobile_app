class TypeBand {
  int? id;
  String? name;
  int? parameter;
  String? parameterName;

  TypeBand({
    this.id,
    this.name,
    this.parameter,
    this.parameterName,
  });

  factory TypeBand.fromJson(Map<String, dynamic> json) => TypeBand(
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
