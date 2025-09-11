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

  TLG1DecoderHelper(this._deviceId);

  @override
  String get deviceId => _deviceId;

  /// Implementación del método genérico usando la interfaz común
  @override
  DepthGaugeData? processRawData(List<int> data) {
    final uint8List = Uint8List.fromList(data);
    return processIncomingData(uint8List);
  }

  /// Procesa los bytes recibidos del dispositivo y retorna la profundidad decodificada
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

      // Si la línea empieza con 'T', remover el prefijo (formato: T15.99)
      if (cleanLine.startsWith('T') && cleanLine.length > 1) {
        cleanLine = cleanLine.substring(1); // Remover la 'T'
        debugPrint('TLG1 - Después de remover T: "$cleanLine"');
      }
      // También manejar otros posibles prefijos de comandos
      else if (cleanLine.startsWith('P') && cleanLine.length > 1) {
        cleanLine = cleanLine.substring(1); // Remover la 'P' (presión)
        debugPrint('TLG1 - Después de remover P: "$cleanLine"');
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
      double? value = formattedValue != null ? double.parse(formattedValue) : null;
      DepthValueType valueType =
          line.startsWith('T') ? DepthValueType.depth : DepthValueType.pressure;

      if (value != null) {
        debugPrint('TLG1 - Profundidad procesada: $value $valueType');

        return DepthGaugeData(
          value: value,
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
  }

  /// Implementación de la validación específica para TLG1
  @override
  bool isValidData(String data) {
    final cleanData = data.trim();

    // Si empieza con 'T', remover el prefijo
    String numberPart = cleanData;
    if (numberPart.startsWith('T') && numberPart.length > 1) {
      numberPart = numberPart.substring(1);
    }

    return double.tryParse(numberPart) != null;
  }

  /// Valida si los datos recibidos son válidos
  static bool isValidDepthData(String data) {
    final cleanData = data.trim();

    // Si empieza con 'T', remover el prefijo
    String numberPart = cleanData;
    if (numberPart.startsWith('T') && numberPart.length > 1) {
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
