import 'dart:async';
import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/services/bluetooth/adapter/bluetooth_fbc_adapter.dart';
import 'package:app_lorry/services/bluetooth/battery_level_manager.dart';

/// Enum para definir los tipos de adaptadores disponibles
enum BluetoothAdapterType {
  classic,
  // Se pueden agregar más tipos aquí en el futuro
}

/// Servicio de Bluetooth que consume diferentes adaptadores
class BluetoothService {
  static BluetoothService? _instance;
  BluetoothAdapter? _adapter;
  StreamSubscription<DepthGaugeData>? _batteryLevelSubscription;

  BluetoothService._internal();

  static BluetoothService get instance {
    _instance ??= BluetoothService._internal();
    return _instance!;
  }

  /// Inicializa el servicio con el adaptador especificado
  void initialize(
      {BluetoothAdapterType adapterType = BluetoothAdapterType.classic}) {
    // Si ya hay un adaptador del mismo tipo, no crear uno nuevo
    if (_adapter != null) {
      return;
    }

    switch (adapterType) {
      case BluetoothAdapterType.classic:
        _adapter = BluetoothClassicAdapter();
        break;
    }

    // Inicializar el manager de batería
    _initializeBatteryManager();
  }

  /// Inicializa el manager de batería y configura el listener
  void _initializeBatteryManager() async {
    try {
      // Inicializar el singleton de batería
      await BatteryLevelManager.instance.initialize();

      // Configurar listener para actualizar cuando lleguen datos de batería
      _batteryLevelSubscription?.cancel(); // Cancelar listener previo si existe
      _batteryLevelSubscription = depthDataStream.listen((depthData) {
        if (depthData.valueType == DepthValueType.battery) {
          final batteryLevel = depthData.value.toInt();
          BatteryLevelManager.instance.updateBatteryLevel(batteryLevel);
        }
      });
    } catch (e) {
      print('Error inicializando BatteryLevelManager: $e');
    }
  }

  /// Ejecuta escaneo de dispositivos
  Future<BluetoothScanResult> scanDevices(
      {Duration timeout = const Duration(seconds: 10)}) async {
    if (_adapter == null) initialize();
    return await _adapter!.scanDevices(timeout: timeout);
  }

  /// Detiene el escaneo
  Future<void> stopScanning() async {
    await _adapter?.stopScanning();
  }

  /// Getters que delegan al adaptador
  bool get isScanning => _adapter?.isScanning ?? false;
  List<BluetoothDeviceModel> get discoveredDevices =>
      _adapter?.discoveredDevices ?? [];
  BluetoothDeviceModel? get connectedDevice => _adapter?.connectedDevice;
  Stream<List<BluetoothDeviceModel>> get devicesStream =>
      _adapter?.devicesStream ?? const Stream.empty();
  Stream<bool> get scanningStream =>
      _adapter?.scanningStream ?? const Stream.empty();
  Stream<BluetoothDeviceModel?> get connectedDeviceStream =>
      _adapter?.connectedDeviceStream ?? const Stream.empty();

  /// Getters genéricos para datos de profundidad (ahora independientes del dispositivo)
  Stream<DepthGaugeData> get depthDataStream {
    return _adapter?.depthDataStream ?? const Stream.empty();
  }

  /// Método para procesar datos de dispositivos (usa la interfaz común)
  void processDeviceData(List<int> data) {
    _adapter?.processIncomingData(data);
  }

  /// Obtiene dispositivos ya emparejados
  Future<List<BluetoothDeviceModel>> getBondedDevices() async {
    if (_adapter == null) initialize();
    return await _adapter!.getBondedDevices();
  }

  /// Conecta a un dispositivo Bluetooth
  Future<BluetoothConnectionResult> connectToDevice(
      BluetoothDeviceModel device) async {
    if (_adapter == null) initialize();

    final result = await _adapter!.connectToDevice(device);

    // Almacenar el dispositivo conectado si la conexión fue exitosa
    if (result.state == BluetoothConnectionState.connected) {
      Preferences prefs = Preferences();
      await prefs.init();
      prefs.saveList(
        BluetoothSharedPreference.lastConnectedDevice.key,
        [device.address, device.name],
      );
    }

    // Si la conexión fue exitosa, configurar el listener de datos
    if (result.state == BluetoothConnectionState.connected) {
      await getDeviceInput();
    }

    return result;
  }

  Future<bool> validateBluetooth() async {
    if (_adapter == null) initialize();
    return await _adapter!.validateBluetooth();
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

  Future<void> getDeviceInput() async {
    if (_adapter == null) return;
    await _adapter!.getDeviceInput();
  }

  Future<void> turnBluetoothOn() async {
    if (_adapter == null) initialize();
    await _adapter!.turnBluetoothOn();
  }

  /// Envía un comando al dispositivo TLG1 conectado
  Future<bool> sendCommand(String command) async {
    if (_adapter == null) return false;
    return await _adapter!.sendCommand(command);
  }

  /// Solicita el nivel de batería al dispositivo TLG1
  Future<bool> requestBatteryLevel() async {
    if (_adapter == null) return false;
    return await _adapter!.requestBatteryLevel();
  }

  /// Solicita una lectura de profundidad al dispositivo TLG1
  Future<bool> requestDepthReading() async {
    if (_adapter == null) return false;
    return await _adapter!.requestDepthReading();
  }

  /// Solicita una lectura de presión al dispositivo TLG1
  Future<bool> requestPressureReading() async {
    if (_adapter == null) return false;
    return await _adapter!.requestPressureReading();
  }

  /// Solicita una actualización completa de todos los valores (profundidad, presión, batería)
  Future<void> requestAllReadings() async {
    if (_adapter == null) return;
    
    // Solicitar cada tipo de lectura con un pequeño delay entre ellas
    await requestDepthReading();
    await Future.delayed(const Duration(milliseconds: 500));
    await requestPressureReading();
    await Future.delayed(const Duration(milliseconds: 500));
    await requestBatteryLevel();
  }

  /// Obtiene el último nivel de batería conocido del almacenamiento persistente
  int? getLastKnownBatteryLevel() {
    return BatteryLevelManager.instance.currentBatteryLevel;
  }

  /// Verifica si hay datos de batería disponibles
  bool hasBatteryData() {
    return BatteryLevelManager.instance.hasBatteryLevel;
  }

  /// Limpia los datos de batería almacenados (útil para testing o reset)
  Future<void> clearBatteryData() async {
    await BatteryLevelManager.instance.clearBatteryData();
  }

  /// Libera recursos
  Future<void> dispose() async {
    _batteryLevelSubscription?.cancel();
    await _adapter?.dispose();
    _adapter = null;
  }
}
