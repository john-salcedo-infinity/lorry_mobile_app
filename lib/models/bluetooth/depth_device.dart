/// Modelo genérico para datos de profundidad de cualquier dispositivo
/// Este modelo es independiente del tipo de dispositivo específico

enum DepthValueType {
  depth,
  pressure,
  action,
  battery
}

class DepthGaugeData {
  final num value;
  final DepthValueType valueType;
  final String unit;
  final DateTime timestamp;
  final String rawData;
  final String? deviceId;

  DepthGaugeData({
    required this.value,
    required this.valueType,
    required this.unit,
    required this.timestamp,
    required this.rawData,
    this.deviceId,
  });

  @override
  String toString() {
    return 'DepthData(depth: $value $unit, timestamp: $timestamp, device: $deviceId, raw: "$rawData")';
  }

  /// Retorna la profundidad formateada con decimales
  String get formattedDepth => value.toStringAsFixed(2);

  /// Retorna la profundidad con unidad
  String get depthWithUnit => '$formattedDepth $unit';

  /// Convierte a JSON para persistencia o transmisión
  Map<String, dynamic> toJson() {
    return {
      'depth': value,
      'unit': unit,
      'timestamp': timestamp.toIso8601String(),
      'rawData': rawData,
      'deviceId': deviceId,
    };
  }

  /// Crea una instancia desde JSON
  factory DepthGaugeData.fromJson(Map<String, dynamic> json) {
    return DepthGaugeData(
      value: json['depth']?.toDouble() ?? 0.0,
      valueType: json['valueType'] ?? 'unknown',
      unit: json['unit'] ?? 'mm',
      timestamp: DateTime.parse(json['timestamp']),
      rawData: json['rawData'] ?? '',
      deviceId: json['deviceId'],
    );
  }

  /// Crea una copia con valores modificados
  DepthGaugeData copyWith({
    double? depth,
    String? unit,
    DateTime? timestamp,
    String? rawData,
    String? deviceId,
  }) {
    return DepthGaugeData(
      value: depth ?? value,
      valueType: valueType,
      unit: unit ?? this.unit,
      timestamp: timestamp ?? this.timestamp,
      rawData: rawData ?? this.rawData,
      deviceId: deviceId ?? this.deviceId,
    );
  }
}

/// Estados genéricos para cualquier dispositivo de medición de profundidad

/// Modelo genérico para el estado de dispositivos de profundidad
class DepthDeviceState {
  final String message;
  final DepthGaugeData? lastReading;
  final DateTime timestamp;
  final String? deviceId;

  DepthDeviceState({
    required this.message,
    this.lastReading,
    DateTime? timestamp,
    this.deviceId,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() {
    return 'DepthDeviceState(message: "$message", device: $deviceId, lastReading: ${lastReading?.depthWithUnit})';
  }

  /// Crea una copia con valores modificados
  DepthDeviceState copyWith({
    String? message,
    DepthGaugeData? lastReading,
    DateTime? timestamp,
    String? deviceId,
  }) {
    return DepthDeviceState(
      message: message ?? this.message,
      lastReading: lastReading ?? this.lastReading,
      timestamp: timestamp ?? this.timestamp,
      deviceId: deviceId ?? this.deviceId,
    );
  }

  /// Convierte a JSON para persistencia o transmisión
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'lastReading': lastReading?.toJson(),
      'timestamp': timestamp.toIso8601String(),
      'deviceId': deviceId,
    };
  }

  /// Crea una instancia desde JSON
  factory DepthDeviceState.fromJson(Map<String, dynamic> json) {
    return DepthDeviceState(
      message: json['message'] ?? '',
      lastReading: json['lastReading'] != null
          ? DepthGaugeData.fromJson(json['lastReading'])
          : null,
      timestamp: DateTime.parse(json['timestamp']),
      deviceId: json['deviceId'],
    );
  }
}

/// Interfaz genérica para procesadores de datos de profundidad
/// Cualquier dispositivo debe implementar esta interfaz para ser compatible
abstract class DepthDataProcessor {
  /// Procesa los datos raw del dispositivo y retorna datos de profundidad
  DepthGaugeData? processRawData(List<int> data);

  /// Limpia el buffer interno del procesador
  void clearBuffer();

  /// Valida si los datos son válidos para este tipo de dispositivo
  bool isValidData(String data);

  /// Obtiene el ID único del dispositivo
  String get deviceId;
}
