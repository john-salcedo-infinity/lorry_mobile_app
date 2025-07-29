class Customer {
    String businessName;
    bool statusNumberLorry;

    Customer({
        required this.businessName,
        required this.statusNumberLorry,
    });

    factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        businessName: json["business_name"],
        statusNumberLorry: json["status_number_lorry"],
    );

    Map<String, dynamic> toJson() => {
        "business_name": businessName,
        "status_number_lorry": statusNumberLorry,
    };
}