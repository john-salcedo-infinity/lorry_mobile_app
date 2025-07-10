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
    int vehicleId;
    String vehicleTypeVehicleName;
    String vehicleCustomerBusinessName;
    bool vehicleCustomerStatusNumberLorry;
    String vehicleWorkLineName;
    dynamic vehicleNumberLorry;
    String vehicleLicensePlate;
    DateTime vehicleLastUpdate;
    DateTime truncatedDate;
    double mileage;
    int totalTires;

    HistoricalResult({
        required this.vehicleId,
        required this.vehicleTypeVehicleName,
        required this.vehicleCustomerBusinessName,
        required this.vehicleCustomerStatusNumberLorry,
        required this.vehicleWorkLineName,
        required this.vehicleNumberLorry,
        required this.vehicleLicensePlate,
        required this.vehicleLastUpdate,
        required this.truncatedDate,
        required this.mileage,
        required this.totalTires,
    });

    factory HistoricalResult.fromJson(Map<String, dynamic> json) => HistoricalResult(
        vehicleId: json["vehicle__id"],
        vehicleTypeVehicleName: json["vehicle__type_vehicle__name"],
        vehicleCustomerBusinessName: json["vehicle__customer__business_name"],
        vehicleCustomerStatusNumberLorry: json["vehicle__customer__status_number_lorry"],
        vehicleWorkLineName: json["vehicle__work_line__name"],
        vehicleNumberLorry: json["vehicle__number_lorry"],
        vehicleLicensePlate: json["vehicle__license_plate"],
        vehicleLastUpdate: DateTime.parse(json["vehicle__last_update"]),
        truncatedDate: DateTime.parse(json["truncated_date"]),
        mileage: json["mileage"],
        totalTires: json["total_tires"],
    );

    Map<String, dynamic> toJson() => {
        "vehicle__id": vehicleId,
        "vehicle__type_vehicle__name": vehicleTypeVehicleName,
        "vehicle__customer__business_name": vehicleCustomerBusinessName,
        "vehicle__customer__status_number_lorry": vehicleCustomerStatusNumberLorry,
        "vehicle__work_line__name": vehicleWorkLineName,
        "vehicle__number_lorry": vehicleNumberLorry,
        "vehicle__license_plate": vehicleLicensePlate,
        "vehicle__last_update": vehicleLastUpdate.toIso8601String(),
        "truncated_date": "${truncatedDate.year.toString().padLeft(4, '0')}-${truncatedDate.month.toString().padLeft(2, '0')}-${truncatedDate.day.toString().padLeft(2, '0')}",
        "mileage": mileage,
        "total_tires": totalTires,
    };
}
