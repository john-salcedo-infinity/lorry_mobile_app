import 'dart:async';

import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/helpers/tlg1_decoder_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart' as fbc;

class BluetoothClassicAdapter implements BluetoothAdapter {
  final fbc.FlutterBlueClassic _bluetooth = fbc.FlutterBlueClassic();

  // Lista interna de dispositivos descubiertos
  final List<BluetoothDeviceModel> _devices = [];

  /// Controlador para la lista de dispositivos
  final StreamController<List<BluetoothDeviceModel>> _devicesController =
      StreamController.broadcast();

  /// Controlador para el estado de escaneo
  final StreamController<bool> _scanningController =
      StreamController.broadcast();

  /// Controlador para el dispositivo conectado
  final StreamController<BluetoothDeviceModel?> _connectedDeviceController =
      StreamController.broadcast();

  /// Controlador para los datos de profundidad del dispositivo
  final StreamController<DepthData> _depthDataController =
      StreamController.broadcast();

  /// Helper para decodificar datos del dispositivo
  final DepthDataProcessor _dataProcessor = TLG1DecoderHelper('TLG1-Device');

  // Suscripciones a streams
  StreamSubscription<fbc.BluetoothDevice>? _discoverySubscription;
  StreamSubscription<bool>? _scanningStateSubscription;
  bool _isScanning = false;
  BluetoothDeviceModel? _connectedDevice;
  fbc.BluetoothConnection? _connection;

  @override
  bool get isScanning => _isScanning;

  // Getters que devuelven copias inmutables o streams
  @override
  List<BluetoothDeviceModel> get discoveredDevices =>
      List.unmodifiable(_devices);

  @override
  Stream<List<BluetoothDeviceModel>> get devicesStream =>
      _devicesController.stream;

  @override
  Stream<bool> get scanningStream => _scanningController.stream;

  @override
  BluetoothDeviceModel? get connectedDevice => _connectedDevice;

  @override
  Stream<BluetoothDeviceModel?> get connectedDeviceStream =>
      _connectedDeviceController.stream;

  /// Stream de datos de profundidad del dispositivo
  @override
  Stream<DepthData> get depthDataStream => _depthDataController.stream;

  /// Inicia el escaneo de dispositivos Bluetooth
  @override
  Future<BluetoothScanResult> scanDevices(
      {Duration timeout = const Duration(seconds: 10)}) async {
    final bluetoothEnable = await validateBluetooth();

    if (!bluetoothEnable) {
      // Intentar activar Bluetooth si está deshabilitado
      _bluetooth.turnOn();
      return BluetoothScanResult.failure("Bluetooth is disabled");
    }

    try {
      // NO limpiar completamente la lista, solo remover dispositivos no emparejados y no conectados
      _devices.removeWhere((device) =>
          !device.isPaired &&
          (_connectedDevice == null ||
              device.address != _connectedDevice!.address));
      _devicesController.add(List.unmodifiable(_devices));

      // Iniciamos el escaneo
      _bluetooth.startScan();

      // Escuchar resultados del escaneo
      _discoverySubscription = _bluetooth.scanResults.listen((device) {
        final bluetoothDevice = BluetoothDeviceModel(
          name: device.name ?? "Desconocido",
          address: device.address,
          isPaired: device.bondState == fbc.BluetoothBondState.bonded,
          deviceType: device.type.name,
          rssi: device.rssi ?? -100, // Valor por defecto si no está disponible
        );

        // Evitar duplicados
        if (!_devices.any((d) => d.address == bluetoothDevice.address)) {
          _devices.add(bluetoothDevice);
          _devicesController.add(List.unmodifiable(_devices));
        }
      });

      // Escuchar estado del escaneo
      _scanningStateSubscription = _bluetooth.isScanning.listen((isScanning) {
        _isScanning = isScanning;
        _scanningController.add(_isScanning);
      });

      // Detener automáticamente después del timeout
      Timer(timeout, () => stopScanning());

      return BluetoothScanResult.success(_devices);
    } catch (e) {
      return BluetoothScanResult.failure(e.toString());
    }
  }

  @override
  Future<BluetoothConnectionResult> connectToDevice(
      BluetoothDeviceModel device) async {
    try {
      // Si ya hay una conexión activa con el mismo dispositivo, no reconectar
      if (_connectedDevice != null &&
          _connectedDevice!.address == device.address &&
          _connection != null &&
          _connection!.isConnected) {
        return BluetoothConnectionResult.success(
          BluetoothConnectionState.connected,
        );
      }

      // Cerrar conexión anterior si existe y es diferente
      if (_connection != null && _connectedDevice?.address != device.address) {
        _connection!.dispose();
        _connection = null;
        _connectedDevice = null;
        _connectedDeviceController.add(null);
      }

      // Intentar conectar al dispositivo
      _connection = await _bluetooth.connect(device.address);

      if (_connection != null && _connection!.isConnected) {
        _connectedDevice = device;
        _connectedDeviceController.add(_connectedDevice);

        return BluetoothConnectionResult.success(
          BluetoothConnectionState.connected,
        );
      } else {
        _connectedDevice = null;
        _connectedDeviceController.add(null);
        return BluetoothConnectionResult.failure(
            "No se pudo conectar al dispositivo");
      }
    } catch (e) {
      _connectedDevice = null;
      _connectedDeviceController.add(null);
      return BluetoothConnectionResult.failure(e.toString());
    }
  }

  Future<bool> validateBluetooth() async {
    final state = await _bluetooth.adapterStateNow;
    return state == fbc.BluetoothAdapterState.on;
  }

  @override
  Future<void> stopScanning() async {
    if (_isScanning) {
      _bluetooth.stopScan();
      await _discoverySubscription?.cancel();
      await _scanningStateSubscription?.cancel();
      _discoverySubscription = null;
      _scanningStateSubscription = null;

      _isScanning = false;
      _scanningController.add(false);
    }
  }

  @override
  Future<List<BluetoothDeviceModel>> getBondedDevices() async {
    try {
      final bonded = await _bluetooth.bondedDevices;
      return bonded
              ?.map((d) => BluetoothDeviceModel(
                    name: d.name ?? "Unknown",
                    address: d.address,
                    isPaired: true,
                    deviceType: d.type.name,
                    rssi:
                        -50, // Valor por defecto para dispositivos emparejados
                  ))
              .toList() ??
          [];
    } catch (e) {
      return [];
    }
  }

  /// Método para desconectar explícitamente del dispositivo actual
  @override
  Future<void> disconnectDevice() async {
    if (_connection != null) {
      _connection!.dispose();
      _connection = null;
      _connectedDevice = null;
      _connectedDeviceController.add(null);
    }
  }

  @override
  Future<void> getDeviceInput() async {
    if (_connection != null) {
      _connection!.input?.listen(
        (data) {
          processIncomingData(data);
        },
        onDone: () {
          _connectedDevice = null;
          _connectedDeviceController.add(null);
          _connection = null;
        },
        onError: (error) {
          _connectedDevice = null;
          _connectedDeviceController.add(null);
          _connection = null;
        },
      );
    }
  }

  /// Implementación del método de la interfaz para procesar datos entrantes del dispositivo
  @override
  void processIncomingData(List<int> data) {
    try {
      debugPrint('Device - Datos raw recibidos: ${data.toString()}');

      final depthData = _dataProcessor.processRawData(data);

      if (depthData != null) {
        debugPrint(
            'Device - Datos procesados exitosamente: ${depthData.depthWithUnit}');
        _depthDataController.add(depthData);
      } else {
        debugPrint('Device - No se pudieron procesar los datos');
      }
    } catch (e) {
      debugPrint('Device - Error procesando datos: $e');
    }
  }

  /// Implementación del método de la interfaz para actualizar el estado del dispositivo

  /// Método para verificar y restaurar el estado de conexión
  @override
  Future<void> verifyConnectionState() async {
    if (_connectedDevice != null && _connection != null) {
      if (!_connection!.isConnected) {
        _connectedDevice = null;
        _connection = null;
        _connectedDeviceController.add(null);
      }
    }
  }

  @override
  Future<void> dispose() async {
    await stopScanning();
    // Solo cerrar la conexión si realmente se está cerrando el servicio
    // no solo el UI
    await _devicesController.close();
    await _scanningController.close();
    await _connectedDeviceController.close();
    await _depthDataController.close();
  }
}
