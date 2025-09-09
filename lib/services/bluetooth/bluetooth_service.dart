import 'dart:async';
import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/services/bluetooth/adapter/bluetooth_fbc_adapter.dart';

/// Enum para definir los tipos de adaptadores disponibles
enum BluetoothAdapterType {
  classic,
  // Se pueden agregar más tipos aquí en el futuro
}

/// Servicio de Bluetooth que consume diferentes adaptadores
class BluetoothService {
  static BluetoothService? _instance;
  BluetoothAdapter? _adapter;

  BluetoothService._internal();

  static BluetoothService get instance {
    _instance ??= BluetoothService._internal();
    return _instance!;
  }

  /// Inicializa el servicio con el adaptador especificado
  void initialize({BluetoothAdapterType adapterType = BluetoothAdapterType.classic}) {
    // Si ya hay un adaptador del mismo tipo, no crear uno nuevo
    if (_adapter != null) {
      print('Adaptador ya inicializado, reutilizando instancia existente');
      return;
    }
    
    switch (adapterType) {
      case BluetoothAdapterType.classic:
        print('Creando nuevo adaptador Bluetooth Classic');
        _adapter = BluetoothClassicAdapter();
        break;
    }
  }

  /// Ejecuta escaneo de dispositivos
  Future<BluetoothScanResult> scanDevices({Duration timeout = const Duration(seconds: 10)}) async {
    if (_adapter == null) initialize();
    return await _adapter!.scanDevices(timeout: timeout);
  }

  /// Detiene el escaneo
  Future<void> stopScanning() async {
    await _adapter?.stopScanning();
  }

  /// Getters que delegan al adaptador
  bool get isScanning => _adapter?.isScanning ?? false;
  List<BluetoothDeviceModel> get discoveredDevices => _adapter?.discoveredDevices ?? [];
  BluetoothDeviceModel? get connectedDevice => _adapter?.connectedDevice;
  Stream<List<BluetoothDeviceModel>> get devicesStream => _adapter?.devicesStream ?? const Stream.empty();
  Stream<bool> get scanningStream => _adapter?.scanningStream ?? const Stream.empty();
  Stream<BluetoothDeviceModel?> get connectedDeviceStream => _adapter?.connectedDeviceStream ?? const Stream.empty();

  /// Obtiene dispositivos ya emparejados
  Future<List<BluetoothDeviceModel>> getBondedDevices() async {
    if (_adapter == null) initialize();
    return await _adapter!.getBondedDevices();
  }

  /// Conecta a un dispositivo Bluetooth
  Future<BluetoothConnectionResult> connectToDevice(BluetoothDeviceModel device) async {
    if (_adapter == null) initialize();
    return await _adapter!.connectToDevice(device);
  }

  /// Desconecta del dispositivo actual
  Future<void> disconnectDevice() async {
    if (_adapter == null) return;
    await _adapter!.disconnectDevice();
  }
  
  /// Verifica el estado de la conexión actual
  Future<void> verifyConnectionState() async {
    if (_adapter == null) return;
    await _adapter!.verifyConnectionState();
  }
  
  /// Libera recursos
  Future<void> dispose() async {
    await _adapter?.dispose();
    _adapter = null;
  }
}