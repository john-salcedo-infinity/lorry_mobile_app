class WorkLine {
    String name;

    WorkLine({
        required this.name,
    });

    factory WorkLine.fromJson(Map<String, dynamic> json) => WorkLine(
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
    };
}