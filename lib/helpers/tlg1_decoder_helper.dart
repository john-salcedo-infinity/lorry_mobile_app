import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:app_lorry/models/bluetooth/depth_device.dart';

/// Helper para decodificar datos del dispositivo TLG1
/// Implementa la interfaz genérica DepthDataProcessor
class TLG1DecoderHelper implements DepthDataProcessor {
  // Buffer para acumular datos incompletos
  String _dataBuffer = '';
  final String _deviceId;
  
  // Buffer para suavizar lecturas de batería
  final List<double> _batteryReadings = [];
  static const int _maxBatteryReadings = 3; // Promedio de las últimas 3 lecturas

  TLG1DecoderHelper(this._deviceId);

  @override
  String get deviceId => _deviceId;

  /// Implementación del método genérico usando la interfaz común
  @override
  DepthGaugeData? processRawData(List<int> data) {
    final uint8List = Uint8List.fromList(data);
    return processIncomingData(uint8List);
  }

  /// Procesa los bytes recibidos del dispositivo y retorna la información decodificada
  DepthGaugeData? processIncomingData(Uint8List data) {
    try {
      // Convertir bytes a string usando UTF-8
      String receivedData = utf8.decode(data, allowMalformed: true);

      debugPrint('TLG1 - Datos recibidos (bytes): ${data.toString()}');
      debugPrint('TLG1 - Datos convertidos: "$receivedData"');

      // Agregar al buffer para manejar datos fragmentados
      _dataBuffer += receivedData;

      // Procesar líneas completas (terminadas en \n o \r\n)
      while (_dataBuffer.contains('\n') || _dataBuffer.contains('\r')) {
        int endIndex = _dataBuffer.indexOf('\n');
        if (endIndex == -1) {
          endIndex = _dataBuffer.indexOf('\r');
        }

        String line = _dataBuffer.substring(0, endIndex).trim();
        _dataBuffer = _dataBuffer.substring(endIndex + 1);

        if (line.isNotEmpty) {
          final depthData = _parseDepthLine(line);
          if (depthData != null) {
            return depthData;
          }
        }
      }

      return null;
    } catch (e) {
      debugPrint('TLG1 - Error procesando datos: $e');
      return null;
    }
  }

  /// Parsea una línea de datos de profundidad
  DepthGaugeData? _parseDepthLine(String line) {
    try {
      // Limpiar espacios y caracteres especiales
      String cleanLine = line.trim();

      debugPrint('TLG1 - Procesando línea: "$cleanLine"');

      DepthValueType valueType = DepthValueType.action;
      
      // Si la línea empieza con 'T', remover el prefijo (formato: T15.99)
      if (cleanLine.startsWith('T') && cleanLine.length > 1) {
        cleanLine = cleanLine.substring(1); // Remover la 'T'
        valueType = DepthValueType.depth;
        debugPrint('TLG1 - Después de remover T: "$cleanLine"');
      }
      // También manejar otros posibles prefijos de comandos
      else if (cleanLine.startsWith('P') && cleanLine.length > 1) {
        cleanLine = cleanLine.substring(1); // Remover la 'P' (presión)
        valueType = DepthValueType.pressure;
        debugPrint('TLG1 - Después de remover P: "$cleanLine"');
      } else if (cleanLine.startsWith('B') && cleanLine.length > 1) {
        cleanLine = cleanLine.substring(1); // Remover la 'B' (batería)
        valueType = DepthValueType.battery;
        debugPrint('TLG1 - Después de remover B: "$cleanLine" (DATOS DE BATERÍA RAW)');
      } else if (cleanLine.startsWith('N') && cleanLine.length > 1) {
        cleanLine = cleanLine.substring(1); // Remover la 'N' (no válido)
        debugPrint('TLG1 - Después de remover N: "$cleanLine"');
      }
      // Manejar formato con otros caracteres especiales
      else if (cleanLine.contains(':')) {
        // En caso de formato como "T:15.99"
        final parts = cleanLine.split(':');
        if (parts.length == 2) {
          cleanLine = parts[1].trim();
          debugPrint('TLG1 - Después de dividir por ":": "$cleanLine"');
        }
      }

      // Intentar convertir a número decimal
      double? parsedValue = double.tryParse(cleanLine);
      String? formattedValue = parsedValue?.toStringAsFixed(1);
      double? value =
          formattedValue != null ? double.parse(formattedValue) : null;

      if (value != null) {
        debugPrint('TLG1 - Valor parseado: $value para tipo $valueType');

        if (valueType == DepthValueType.action) {
          return DepthGaugeData(
            value: value,
            valueType: valueType,
            unit: 'N/A',
            timestamp: DateTime.now(),
            rawData: line,
            deviceId: _deviceId
          );
        }

        // Procesar datos de batería con fórmula de la documentación TLG1
        if (valueType == DepthValueType.battery) {
          debugPrint('TLG1 - Procesando batería: valor raw = $value');
          
          // Usar únicamente la fórmula de 10-bit (estándar según documentación)
          // Vb = (3.3 x Vr / 1024) ÷ 0.6803
          // Esta fórmula es consistente y evita fluctuaciones entre diferentes métodos
          double batteryVoltage = (3.3 * value / 1024) / 0.6803;
          
          debugPrint('TLG1 - Voltaje calculado: ${batteryVoltage.toStringAsFixed(3)}V');
          
          // Convertir voltaje a porcentaje
          // Según documentación: 3.5V mínimo operacional, 4.1-4.3V batería llena
          const double minOperationalVoltage = 3.5;
          const double maxBatteryVoltage = 4.3;
          
          double batteryPercentage;
          if (batteryVoltage < minOperationalVoltage) {
            batteryPercentage = 0.0; // Batería crítica
          } else if (batteryVoltage >= maxBatteryVoltage) {
            batteryPercentage = 100.0; // Batería llena
          } else {
            // Calcular porcentaje lineal entre 3.5V y 4.3V
            batteryPercentage = ((batteryVoltage - minOperationalVoltage) / 
                               (maxBatteryVoltage - minOperationalVoltage)) * 100;
          }
          
          // Asegurar que esté en el rango 0-100
          batteryPercentage = batteryPercentage.clamp(0.0, 100.0);
          
          // Suavizar la lectura usando promedio de las últimas lecturas
          _batteryReadings.add(batteryPercentage);
          if (_batteryReadings.length > _maxBatteryReadings) {
            _batteryReadings.removeAt(0); // Remover la lectura más antigua
          }
          
          // Calcular promedio
          double smoothedBatteryPercentage = _batteryReadings.reduce((a, b) => a + b) / _batteryReadings.length;
          
          debugPrint('TLG1 - Batería raw: ${batteryPercentage.toStringAsFixed(1)}%, suavizada: ${smoothedBatteryPercentage.toStringAsFixed(1)}% (${batteryVoltage.toStringAsFixed(3)}V)');
          
          return DepthGaugeData(
            value: smoothedBatteryPercentage,
            valueType: valueType,
            unit: '%',
            timestamp: DateTime.now(),
            rawData: line,
            deviceId: _deviceId,
          );
        }

        return DepthGaugeData(
          value: valueType == DepthValueType.depth
              ? value
              : int.parse(value.toStringAsFixed(0)),
          valueType: valueType,
          unit: valueType == DepthValueType.depth ? 'mm' : 'psi',
          timestamp: DateTime.now(),
          rawData: line,
          deviceId: _deviceId,
        );
      } else {
        debugPrint(
            'TLG1 - Línea no válida para profundidad después del parsing: "$cleanLine"');
        return null;
      }
    } catch (e) {
      debugPrint('TLG1 - Error parseando línea de profundidad: $e');
      return null;
    }
  }

  /// Limpia el buffer interno
  @override
  void clearBuffer() {
    _dataBuffer = '';
    _batteryReadings.clear(); // También limpiar el buffer de batería
  }

  /// Implementación de la validación específica para TLG1
  @override
  bool isValidData(String data) {
    final cleanData = data.trim();

    // Si empieza con 'T', 'P', o 'B', remover el prefijo
    String numberPart = cleanData;
    if (numberPart.startsWith('T') && numberPart.length > 1) {
      numberPart = numberPart.substring(1);
    } else if (numberPart.startsWith('P') && numberPart.length > 1) {
      numberPart = numberPart.substring(1);
    } else if (numberPart.startsWith('B') && numberPart.length > 1) {
      numberPart = numberPart.substring(1);
    }

    return double.tryParse(numberPart) != null;
  }

  /// Valida si los datos recibidos son válidos
  static bool isValidDepthData(String data) {
    final cleanData = data.trim();

    // Si empieza con 'T', 'P', o 'B', remover el prefijo
    String numberPart = cleanData;
    if (numberPart.startsWith('T') && numberPart.length > 1) {
      numberPart = numberPart.substring(1);
    } else if (numberPart.startsWith('P') && numberPart.length > 1) {
      numberPart = numberPart.substring(1);
    } else if (numberPart.startsWith('B') && numberPart.length > 1) {
      numberPart = numberPart.substring(1);
    }

    return double.tryParse(numberPart) != null;
  }

  /// Convierte bytes individuales a su representación de carácter
  static String bytesToString(List<int> bytes) {
    try {
      return utf8.decode(bytes, allowMalformed: true);
    } catch (e) {
      return bytes.toString();
    }
  }
}
