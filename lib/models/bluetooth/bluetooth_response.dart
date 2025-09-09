import 'bluetooth_device.dart';

enum BluetoothConnectionState {
  disconnected,
  connecting,
  connected,
  disconnecting,
}

class BluetoothConnectionResult {
  final bool isSuccess;
  final String? errorMessage;
  final BluetoothConnectionState state;

  const BluetoothConnectionResult({
    required this.isSuccess,
    this.errorMessage,
    this.state = BluetoothConnectionState.disconnected,
  });

  factory BluetoothConnectionResult.success(BluetoothConnectionState state) {
    return BluetoothConnectionResult(
      isSuccess: true,
      state: state,
    );
  }

  factory BluetoothConnectionResult.failure(String error) {
    return BluetoothConnectionResult(
      isSuccess: false,
      errorMessage: error,
      state: BluetoothConnectionState.disconnected,
    );
  }
}

class BluetoothScanResult {
  final List<BluetoothDeviceModel> devices;
  final bool isSuccess;
  final String? errorMessage;

  const BluetoothScanResult({
    required this.devices,
    required this.isSuccess,
    this.errorMessage,
  });

  factory BluetoothScanResult.success(List<BluetoothDeviceModel> devices) {
    return BluetoothScanResult(
      devices: devices,
      isSuccess: true,
    );
  }

  factory BluetoothScanResult.failure(String error) {
    return BluetoothScanResult(
      devices: [],
      isSuccess: false,
      errorMessage: error,
    );
  }
}
