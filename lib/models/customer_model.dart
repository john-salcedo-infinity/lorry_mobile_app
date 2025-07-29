class Customer {
    int? id;
    String? businessName;
    bool? statusNumberLorry;
    int? coordinator;
    int? businessCustomersType;
    int? typeService;
    int? creationUser;
    int? userUpdate;

    Customer({
        this.id,
        this.businessName,
        this.statusNumberLorry,
        this.coordinator,
        this.businessCustomersType,
        this.typeService,
        this.creationUser,
        this.userUpdate,
    });

    factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        businessName: json["business_name"],
        statusNumberLorry: json["status_number_lorry"],
        coordinator: json["coordinator"],
        businessCustomersType: json["business_customers_type"],
        typeService: json["type_service"],
        creationUser: json["creation_user"],
        userUpdate: json["user_update"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "business_name": businessName,
        "status_number_lorry": statusNumberLorry,
        "coordinator": coordinator,
        "business_customers_type": businessCustomersType,
        "type_service": typeService,
        "creation_user": creationUser,
        "user_update": userUpdate,
    };
}