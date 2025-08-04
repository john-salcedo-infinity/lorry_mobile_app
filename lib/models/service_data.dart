// ignore_for_file: constant_identifier_names

class ServiceData {
  final int id;
  final String name;
  final String? sendTo;
  final bool unmountingRequired;

  const ServiceData({
    required this.id,
    required this.name,
    this.sendTo,
    required this.unmountingRequired,
  });

  factory ServiceData.fromJson(Map<String, dynamic> json) {
    return ServiceData(
      id: json['id'] as int,
      name: json['name'] as String,
      sendTo: json['send_to'] as String?,
      unmountingRequired: json['unmounting_required'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'send_to': sendTo,
      'unmounting_required': unmountingRequired,
    };
  }
}

class ServiceConfig {
  final int xs;
  final int sm;
  final String icon;
  final ServiceData service;
  final String text;

  const ServiceConfig({
    required this.xs,
    required this.sm,
    required this.icon,
    required this.service,
    required this.text,
  });
}

class ServicesConfiguration {
  final List<ServiceConfig> physicalServices;
  final List<ServiceConfig> unmountingServices;

  const ServicesConfiguration({
    required this.physicalServices,
    required this.unmountingServices,
  });
}
