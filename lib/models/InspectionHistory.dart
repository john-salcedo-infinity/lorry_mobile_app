// To parse this JSON data, do
//
//     final inspectionHistory = inspectionHistoryFromJson(jsonString);

import 'dart:convert';

InspectionHistory inspectionHistoryFromJson(String str) => InspectionHistory.fromJson(json.decode(str));

String inspectionHistoryToJson(InspectionHistory data) => json.encode(data.toJson());

class InspectionHistory {
    bool success;
    List<String> messages;
    DataInspectionHistory data;

    InspectionHistory({
        required this.success,
        required this.messages,
        required this.data,
    });

    factory InspectionHistory.fromJson(Map<String, dynamic> json) => InspectionHistory(
        success: json["success"],
        messages: List<String>.from(json["messages"].map((x) => x)),
        data: DataInspectionHistory.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "messages": List<dynamic>.from(messages.map((x) => x)),
        "data": data.toJson(),
    };
}

class DataInspectionHistory {
    int count;
    dynamic next;
    dynamic previous;
    List<HistoricalResult> results;

    DataInspectionHistory({
        required this.count,
        required this.next,
        required this.previous,
        required this.results,
    });

    factory DataInspectionHistory.fromJson(Map<String, dynamic> json) => DataInspectionHistory(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<HistoricalResult>.from(json["results"].map((x) => HistoricalResult.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
    };
}

class HistoricalResult {
    Vehicle vehicle;
    Inspection inspection;
    CreatedBy createdBy;

    HistoricalResult({
        required this.vehicle,
        required this.inspection,
        required this.createdBy,
    });

    factory HistoricalResult.fromJson(Map<String, dynamic> json) => HistoricalResult(
        vehicle: Vehicle.fromJson(json["vehicle"]),
        inspection: Inspection.fromJson(json["inspection"]),
        createdBy: CreatedBy.fromJson(json["created_by"]),
    );

    Map<String, dynamic> toJson() => {
        "vehicle": vehicle.toJson(),
        "inspection": inspection.toJson(),
        "created_by": createdBy.toJson(),
    };
}

class Vehicle {
    int id;
    String typeVehicleName;
    String? numberLorry;
    String licensePlate;
    DateTime lastUpdate;
    int mileageId;
    Customer customer;
    WorkLine workLine;

    Vehicle({
        required this.id,
        required this.typeVehicleName,
        this.numberLorry,
        required this.licensePlate,
        required this.lastUpdate,
        required this.mileageId,
        required this.customer,
        required this.workLine,
    });

    factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json["id"],
        typeVehicleName: json["type_vehicle_name"],
        numberLorry: json["number_lorry"],
        licensePlate: json["license_plate"],
        lastUpdate: DateTime.parse(json["last_update"]),
        mileageId: json["mileage_id"],
        customer: Customer.fromJson(json["customer"]),
        workLine: WorkLine.fromJson(json["work_line"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "type_vehicle_name": typeVehicleName,
        "number_lorry": numberLorry,
        "license_plate": licensePlate,
        "last_update": lastUpdate.toIso8601String(),
        "mileage_id": mileageId,
        "customer": customer.toJson(),
        "work_line": workLine.toJson(),
    };
}

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

class Inspection {
    String date;
    DateTime lastInspectionDate;
    double mileage;
    int totalTires;

    Inspection({
        required this.date,
        required this.lastInspectionDate,
        required this.mileage,
        required this.totalTires,
    });

    factory Inspection.fromJson(Map<String, dynamic> json) => Inspection(
        date: json["date"],
        lastInspectionDate: DateTime.parse(json["last_inspection_date"]),
        mileage: json["mileage"],
        totalTires: json["total_tires"],
    );

    Map<String, dynamic> toJson() => {
        "date": date,
        "last_inspection_date": lastInspectionDate.toIso8601String(),
        "mileage": mileage,
        "total_tires": totalTires,
    };
}

class CreatedBy {
    int id;
    String fullName;
    String role;

    CreatedBy({
        required this.id,
        required this.fullName,
        required this.role,
    });

    factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        id: json["id"],
        fullName: json["full_name"],
        role: json["role"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "role": role,
    };
}
