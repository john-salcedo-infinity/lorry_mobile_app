import 'dart:convert';

class GeneralResponse<T> {
    bool success;
    List<String> messages;
    T data;

    GeneralResponse({
        required this.success,
        required this.messages,
        required this.data,
    });

    factory GeneralResponse.fromRawJson(String str) => GeneralResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GeneralResponse.fromJson(Map<String, dynamic> json) => GeneralResponse(
        success: json["success"],
        messages: List<String>.from(json["messages"].map((x) => x)),
        data: json["data"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "messages": List<dynamic>.from(messages.map((x) => x)),
        "data": data,
    };
}

