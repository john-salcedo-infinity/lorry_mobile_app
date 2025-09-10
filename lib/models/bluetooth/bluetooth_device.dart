class BluetoothDeviceModel {
  final String name;
  final String address;
  final int rssi;
  final bool isConnected;
  final bool isPaired;
  final String deviceType;

  const BluetoothDeviceModel({
    required this.name,
    required this.address,
    this.rssi = 0,
    this.isConnected = false,
    this.isPaired = false,
    this.deviceType = 'Unknown',
  });

  BluetoothDeviceModel copyWith({
    String? name,
    String? address,
    int? rssi,
    bool? isConnected,
    bool? isPaired,
    String? deviceType,
  }) {
    return BluetoothDeviceModel(
      name: name ?? this.name,
      address: address ?? this.address,
      rssi: rssi ?? this.rssi,
      isConnected: isConnected ?? this.isConnected,
      isPaired: isPaired ?? this.isPaired,
      deviceType: deviceType ?? this.deviceType,
    );
  }

  @override
  String toString() {
    return 'BluetoothDeviceModel{name: $name, address: $address, isConnected: $isConnected}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BluetoothDeviceModel &&
          runtimeType == other.runtimeType &&
          address == other.address;

  @override
  int get hashCode => address.hashCode;
}


enum BluetoothSharedPreference {
  lastConnectedDevice('last_connected_device');

  final String key;
  const BluetoothSharedPreference(this.key);
}