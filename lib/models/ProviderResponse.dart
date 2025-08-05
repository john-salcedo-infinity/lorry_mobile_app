import 'package:app_lorry/models/tire/provider.dart';

class ProviderResponse {
  final bool success;
  final List<String> messages;
  final ProviderData data;

  ProviderResponse({
    required this.success,
    required this.messages,
    required this.data,
  });

  factory ProviderResponse.fromJson(Map<String, dynamic> json) {
    return ProviderResponse(
      success: json['success'] ?? false,
      messages: List<String>.from(json['messages'] ?? []),
      data: ProviderData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'messages': messages,
      'data': data.toJson(),
    };
  }
}

class ProviderData {
  final int count;
  final String? next;
  final String? previous;
  final List<Provider>? results;

  ProviderData({
    required this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory ProviderData.fromJson(Map<String, dynamic> json) {
    return ProviderData(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: json['results'] != null
          ? List<Provider>.from(
              json['results'].map((x) => Provider.fromJson(x)),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'next': next,
      'previous': previous,
      'results': results?.map((x) => x.toJson()).toList(),
    };
  }
}
