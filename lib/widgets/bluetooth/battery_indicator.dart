import 'package:flutter/material.dart';
import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/services/bluetooth/bluetooth_service.dart';
import 'package:app_lorry/services/bluetooth/battery_level_manager.dart';
import 'package:app_lorry/models/models.dart';
import 'dart:async';

/// Widget reutilizable para mostrar el estado de la batería del dispositivo Bluetooth
class BatteryIndicator extends StatefulWidget {
  /// Tamaño del indicador (mini, small, medium, large)
  final BatteryIndicatorSize size;

  /// Si debe mostrar el porcentaje como texto
  final bool showPercentage;

  /// Si debe mostrar solo el ícono (sin fondo)
  final bool iconOnly;

  /// Color personalizado para el indicador
  final Color? customColor;

  const BatteryIndicator({
    super.key,
    this.size = BatteryIndicatorSize.medium,
    this.showPercentage = true,
    this.iconOnly = false,
    this.customColor,
  });

  @override
  State<BatteryIndicator> createState() => _BatteryIndicatorState();
}

class _BatteryIndicatorState extends State<BatteryIndicator> {
  final BluetoothService _bluetoothService = BluetoothService.instance;

  int? _batteryLevel;
  StreamSubscription<DepthGaugeData>? _batterySubscription;
  BluetoothDeviceModel? _connectedDevice;
  StreamSubscription<BluetoothDeviceModel?>? _deviceSubscription;

  @override
  void initState() {
    super.initState();
    _initializeBatteryListener();
  }

  @override
  void dispose() {
    _batterySubscription?.cancel();
    _deviceSubscription?.cancel();
    super.dispose();
  }

  void _initializeBatteryListener() {
    // Cargar el último nivel de batería conocido
    _loadLastKnownBatteryLevel();

    // Escuchar cambios en el dispositivo conectado
    _deviceSubscription = _bluetoothService.connectedDeviceStream.listen(
      (device) {
        if (mounted) {
          setState(() {
            _connectedDevice = device;
            if (device == null) {
              // No limpiar _batteryLevel cuando se desconecta, mantener último valor
            } else {
              // Al conectar, cargar último valor conocido
              _loadLastKnownBatteryLevel();
            }
          });
        }
      },
    );

    // Escuchar datos de batería del stream de profundidad
    _batterySubscription = _bluetoothService.depthDataStream.listen(
      (depthData) {
        if (depthData.valueType == DepthValueType.battery && mounted) {
          setState(() {
            _batteryLevel = depthData.value.toInt();
          });
          // El BatteryLevelManager ya se encarga de persistir automáticamente
        }
      },
      onError: (error) {
        debugPrint('BatteryIndicator - Error en stream de batería: $error');
      },
    );

    // Cargar estado inicial
    setState(() {
      _connectedDevice = _bluetoothService.connectedDevice;
    });
  }

  /// Carga el último nivel de batería conocido del almacenamiento
  void _loadLastKnownBatteryLevel() {
    final lastKnownLevel = BatteryLevelManager.instance.currentBatteryLevel;
    if (lastKnownLevel != null && mounted) {
      setState(() {
        _batteryLevel = lastKnownLevel;
      });
      debugPrint(
          'BatteryIndicator - Cargado último nivel conocido: $lastKnownLevel%');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si no hay dispositivo conectado, no mostrar nada
    if (_connectedDevice == null) {
      return const SizedBox.shrink();
    }

    if (widget.iconOnly) {
      return _buildIconOnly();
    }

    return _buildFullIndicator();
  }

  Widget _buildIconOnly() {
    return Icon(
      _getBatteryIcon(),
      size: _getIconSize(),
      color: widget.customColor ?? _getBatteryColor(),
    );
  }

  Widget _buildFullIndicator() {
    return Container(
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(_getBorderRadius()),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getBatteryIcon(),
            size: _getIconSize(),
            color: widget.customColor ?? _getBatteryColor(),
          ),
          if (widget.showPercentage && _batteryLevel != null) ...[
            SizedBox(width: _getSpacing()),
            Text(
              '$_batteryLevel%',
              style: _getTextStyle(),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getBatteryIcon() {
    if (_batteryLevel == null) {
      return Icons.battery_unknown;
    }

    if (_batteryLevel! <= 10) {
      return Icons.battery_0_bar;
    } else if (_batteryLevel! <= 25) {
      return Icons.battery_1_bar;
    } else if (_batteryLevel! <= 50) {
      return Icons.battery_3_bar;
    } else if (_batteryLevel! <= 75) {
      return Icons.battery_5_bar;
    } else {
      return Icons.battery_full;
    }
  }

  Color _getBatteryColor() {
    if (_batteryLevel == null) {
      return Apptheme.gray;
    }

    if (_batteryLevel! <= 20) {
      return Colors.red;
    } else if (_batteryLevel! <= 50) {
      return Apptheme.alertOrange;
    } else {
      return Apptheme.secondary;
    }
  }

  Color _getBackgroundColor() {
    if (_batteryLevel == null) {
      return Apptheme.lightGray.withAlpha(30);
    }

    if (_batteryLevel! <= 20) {
      return Colors.red.withAlpha(10);
    } else if (_batteryLevel! <= 50) {
      return Apptheme.lightOrange.withAlpha(50);
    } else {
      return Apptheme.lightGreen.withAlpha(50);
    }
  }

  Color _getBorderColor() {
    if (_batteryLevel == null) {
      return Apptheme.lightGray;
    }

    return _getBatteryColor().withAlpha(100);
  }

  double _getIconSize() {
    switch (widget.size) {
      case BatteryIndicatorSize.mini:
        return 12;
      case BatteryIndicatorSize.small:
        return 16;
      case BatteryIndicatorSize.medium:
        return 20;
      case BatteryIndicatorSize.large:
        return 24;
    }
  }

  EdgeInsets _getPadding() {
    switch (widget.size) {
      case BatteryIndicatorSize.mini:
        return const EdgeInsets.symmetric(horizontal: 4, vertical: 2);
      case BatteryIndicatorSize.small:
        return const EdgeInsets.symmetric(horizontal: 6, vertical: 3);
      case BatteryIndicatorSize.medium:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
      case BatteryIndicatorSize.large:
        return const EdgeInsets.symmetric(horizontal: 10, vertical: 6);
    }
  }

  double _getBorderRadius() {
    switch (widget.size) {
      case BatteryIndicatorSize.mini:
        return 4;
      case BatteryIndicatorSize.small:
        return 6;
      case BatteryIndicatorSize.medium:
        return 8;
      case BatteryIndicatorSize.large:
        return 10;
    }
  }

  double _getSpacing() {
    switch (widget.size) {
      case BatteryIndicatorSize.mini:
        return 2;
      case BatteryIndicatorSize.small:
        return 4;
      case BatteryIndicatorSize.medium:
        return 6;
      case BatteryIndicatorSize.large:
        return 8;
    }
  }

  TextStyle _getTextStyle() {
    Color textColor = widget.customColor ?? _getBatteryColor();

    switch (widget.size) {
      case BatteryIndicatorSize.mini:
        return TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textColor,
        );
      case BatteryIndicatorSize.small:
        return TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        );
      case BatteryIndicatorSize.medium:
        return Apptheme.h5HighlightBody(context, color: textColor);
      case BatteryIndicatorSize.large:
        return Apptheme.h4HighlightBody(context, color: textColor);
    }
  }
}

/// Tamaños disponibles para el indicador de batería
enum BatteryIndicatorSize {
  mini,
  small,
  medium,
  large,
}
