class WorkLine {
    int? id;
    String? name;
    bool? status;
    dynamic creationUser;
    dynamic userUpdate;
    String? creationDate;
    String? lastUpdate;

    WorkLine({
        this.id,
        this.name,
        this.status,
        this.creationUser,
        this.userUpdate,
        this.creationDate,
        this.lastUpdate,
    });

    factory WorkLine.fromJson(Map<String, dynamic> json) => WorkLine(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        creationUser: json["creation_user"],
        userUpdate: json["user_update"],
        creationDate: json["creation_date"],
        lastUpdate: json["last_update"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "creation_user": creationUser,
        "user_update": userUpdate,
        "creation_date": creationDate,
        "last_update": lastUpdate,
    };
}