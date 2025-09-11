import '../bluetooth/bluetooth_response.dart';
import '../bluetooth/bluetooth_device.dart';
import 'depth_device.dart';

/// Interface abstracta para manejar escaneo de dispositivos Bluetooth
abstract class BluetoothAdapter {
  /// Escanea dispositivos Bluetooth cercanos
  Future<BluetoothScanResult> scanDevices(
      {Duration timeout = const Duration(seconds: 30)});

  /// Detiene el escaneo actual
  Future<void> stopScanning();

  /// Obtiene dispositivos ya emparejados
  Future<List<BluetoothDeviceModel>> getBondedDevices();

  // Conexión a un dispositivo Bluetooth
  Future<BluetoothConnectionResult> connectToDevice(
      BluetoothDeviceModel device);


  /// Desconecta del dispositivo actual
  Future<void> disconnectDevice();

  /// Verifica el estado real de la conexión
  Future<void> verifyConnectionState();

  Future<void> getDeviceInput();

  /// Getters para obtener información del estado actual
  bool get isScanning;
  List<BluetoothDeviceModel> get discoveredDevices;
  BluetoothDeviceModel? get connectedDevice;

  /// Streams para notificar cambios
  Stream<List<BluetoothDeviceModel>> get devicesStream;
  Stream<bool> get scanningStream;
  Stream<BluetoothDeviceModel?> get connectedDeviceStream;

  /// Streams genéricos para datos de profundidad (compatibles con cualquier dispositivo)
  Stream<DepthData> get depthDataStream;

  /// Método para procesar datos entrantes del dispositivo
  /// Cada adaptador implementará este método según el protocolo de su dispositivo
  void processIncomingData(List<int> data);

  /// Libera recursos
  Future<void> dispose();
}
