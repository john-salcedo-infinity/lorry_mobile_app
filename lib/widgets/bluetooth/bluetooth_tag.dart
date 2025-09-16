import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/services/bluetooth/bluetooth_service.dart';
import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:async';

/// Tag de Bluetooth que muestra el estado de conexión en tiempo real
class BluetoothTag extends StatefulWidget {
  final VoidCallback? onTap;
  final bool? showAsButton;

  const BluetoothTag({
    super.key,
    this.onTap,
    this.showAsButton = false,
  });

  @override
  State<BluetoothTag> createState() => _BluetoothTagState();
}

class _BluetoothTagState extends State<BluetoothTag> {
  final BluetoothService _bluetoothService = BluetoothService.instance;
  BluetoothDeviceModel? _connectedDevice;
  bool _isBluetoothEnabled = false;
  bool _isScanning = false;
  Timer? _statusCheckTimer;

  // StreamSubscriptions
  StreamSubscription<BluetoothDeviceModel?>? _connectedDeviceSubscription;
  StreamSubscription<bool>? _scanningSubscription;

  @override
  void initState() {
    super.initState();
    _initializeService();
    _setupListeners();
    _startPeriodicStatusCheck();
  }

  @override
  void dispose() {
    _statusCheckTimer?.cancel();
    _connectedDeviceSubscription?.cancel();
    _scanningSubscription?.cancel();
    super.dispose();
  }

  void _initializeService() async {
    try {
      _bluetoothService.initialize();
      await _updateBluetoothStatus();

      // Cargar estado inicial
      setState(() {
        _connectedDevice = _bluetoothService.connectedDevice;
        _isScanning = _bluetoothService.isScanning;
      });
    } catch (e) {
      print('Error inicializando BluetoothTag: $e');
    }
  }

  void _setupListeners() {
    // Escuchar cambios en el dispositivo conectado
    _connectedDeviceSubscription =
        _bluetoothService.connectedDeviceStream.listen(
      (device) {
        if (mounted) {
          setState(() {
            _connectedDevice = device;
          });
        }
      },
    );

    // Escuchar cambios en el estado de escaneo
    _scanningSubscription = _bluetoothService.scanningStream.listen(
      (isScanning) {
        if (mounted) {
          setState(() {
            _isScanning = isScanning;
          });
        }
      },
    );
  }

  void _startPeriodicStatusCheck() {
    _statusCheckTimer =
        Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }
      await _updateBluetoothStatus();
      await _bluetoothService.verifyConnectionState();
    });
  }

  Future<void> _updateBluetoothStatus() async {
    try {
      // Aquí podrías agregar lógica para verificar si el Bluetooth está habilitado
      // Por ahora asumimos que está habilitado si el servicio funciona
      setState(() {
        _isBluetoothEnabled = true;
      });
    } catch (e) {
      setState(() {
        _isBluetoothEnabled = false;
      });
    }
  }

  void _handleTap() {
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.showAsButton == true ? _buildAsButton() : _buildAsTag();
  }

  Widget _buildAsButton() {
    return CustomButton(
      double.infinity,
      36,
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _connectedDevice != null ? _buildIcon() : SizedBox(),
          const SizedBox(width: 8),
          Text(
            _getDisplayText(),
            style: Apptheme.h5HighlightBody(
              context,
              color: Apptheme.backgroundColor,
            ),
          ),
        ],
      ),
      _handleTap,
      type: 3,
    );
  }

  Widget _buildAsTag() {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _getBorderColor(),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(),
            const SizedBox(width: 6),
            Text(
              _getDisplayText(),
              style: Apptheme.h5HighlightBody(
                context,
                color: _getTextColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (_isScanning) {
      return SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: _getIconColor(),
        ),
      );
    }

    return Icon(
      _getIconData(),
      size: 16,
      color: _getIconColor(),
    );
  }

  IconData _getIconData() {
    if (!_isBluetoothEnabled) {
      return Icons.bluetooth_disabled;
    }

    if (_connectedDevice != null) {
      return Icons.bluetooth_connected;
    }

    return Icons.bluetooth;
  }

  Color _getBackgroundColor() {
    if (!_isBluetoothEnabled) {
      return Apptheme.lightGray.withAlpha(30);
    }

    if (_connectedDevice != null) {
      return Apptheme.lightGreen;
    }

    if (_isScanning) {
      return Apptheme.lightOrange;
    }

    return Apptheme.backgroundColor;
  }

  Color _getBorderColor() {
    if (!_isBluetoothEnabled) {
      return Apptheme.gray;
    }

    if (_connectedDevice != null) {
      return Apptheme.secondary;
    }

    if (_isScanning) {
      return Apptheme.primary;
    }

    return Apptheme.lightGray;
  }

  Color _getIconColor() {
    if (!_isBluetoothEnabled) {
      return Apptheme.gray;
    }

    if (_connectedDevice != null) {
      return widget.showAsButton == true ? Apptheme.backgroundColor : Apptheme.secondary;
    }

    if (_isScanning) {
      return Apptheme.primary;
    }

    return Apptheme.textColorSecondary;
  }

  Color _getTextColor() {
    if (!_isBluetoothEnabled) {
      return Apptheme.gray;
    }

    if (_connectedDevice != null) {
      return Apptheme.secondary;
    }

    if (_isScanning) {
      return Apptheme.primary;
    }

    return Apptheme.textColorSecondary;
  }

  String _getDisplayText() {
    if (_isScanning) {
      // Si hay un dispositivo conectado y está scanning, probablemente es una reconexión
      if (_connectedDevice != null) {
        return 'Reconectando...';
      }
      return 'Conectando...';
    }

    if (!_isBluetoothEnabled) {
      return 'BT Deshabilitado';
    }

    if (_connectedDevice != null) {
      // Mostrar solo las primeras 2 palabras del nombre del dispositivo
      final deviceName = _connectedDevice!.name;
      if (deviceName.isEmpty) {
        return 'Conectado';
      }

      final words = deviceName.split(' ');
      if (words.length <= 1) {
        return deviceName;
      } else {
        return words[1];
      }
    }

    return widget.showAsButton == true ? "Usar profundimetro" : 'No Conectado';
  }
}
