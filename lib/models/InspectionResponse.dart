import 'dart:convert';

class InspectionResponse {
  final bool success;
  final List<String> messages;
  final dynamic data;

  InspectionResponse({
    required this.success,
    required this.messages,
    this.data,
  });

  factory InspectionResponse.fromRawJson(String str) => InspectionResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InspectionResponse.fromJson(Map<String, dynamic> json) => InspectionResponse(
        success: json["success"] ?? false,
        messages: json["messages"] == null
            ? []
            : List<String>.from(json["messages"].map((x) => x)),
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "messages": messages,
        "data": data,
      };
}
