import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/widgets/shared/back.dart';
import 'package:app_lorry/services/bluetooth/bluetooth_service.dart';
import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/widgets/bluetooth/battery_indicator.dart';
// import 'package:app_lorry/widgets/bluetooth/depth_input_fields.dart';

class BluetoothCalibrationScreen extends StatefulWidget {
  final String? deviceName;
  final String? deviceAddress;

  const BluetoothCalibrationScreen({
    super.key,
    this.deviceName,
    this.deviceAddress,
  });

  @override
  State<BluetoothCalibrationScreen> createState() =>
      _BluetoothCalibrationScreenState();
}

class _BluetoothCalibrationScreenState
    extends State<BluetoothCalibrationScreen> {
  final BluetoothService _bluetoothService = BluetoothService.instance;

  // Estado para mostrar datos de profundidad del dispositivo
  DepthGaugeData? _currentDepth;
  DepthGaugeData? _currentPressure;

  DepthGaugeData? _previousDepth;
  DepthGaugeData? _previousPressure;

  StreamSubscription<DepthGaugeData>? _depthSubscription;

  // Estado simple para acción detectada
  bool _actionDetected = false;
  Timer? _actionTimer;

  @override
  void initState() {
    super.initState();
    _initializeStreams();
  }

  @override
  void dispose() {
    _depthSubscription?.cancel();
    _actionTimer?.cancel();
    super.dispose();
  }

  void _initializeStreams() {
    _depthSubscription = _bluetoothService.depthDataStream.listen(
      (depthData) {
        debugPrint(
            'Calibration Screen - Datos de profundidad recibidos: ${depthData.depthWithUnit}');

        setState(() {
          if (depthData.valueType == DepthValueType.depth) {
            _currentDepth = depthData;
            if (_previousDepth == null ||
                _previousDepth!.value != depthData.value) {
              _previousDepth = depthData;
            }
          } else if (depthData.valueType == DepthValueType.pressure) {
            _currentPressure = depthData;
            if (_previousPressure == null ||
                _previousPressure!.value != depthData.value) {
              _previousPressure = depthData;
            }
          } else if (depthData.valueType == DepthValueType.action) {
            _handleActionData(depthData.rawData);
          }
        });
      },
      onError: (error) {
        debugPrint(
            'Calibration Screen - Error en stream de profundidad: $error');
      },
    );
  }

  void _handleActionData(String actionData) {
    setState(() {
      _actionDetected = true;
    });

    // Mostrar la indicación por 2 segundos
    _actionTimer?.cancel();
    _actionTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _actionDetected = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Apptheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildDeviceInfo(),
                    const SizedBox(height: 20),
                    _buildDepthDisplay(),
                    const SizedBox(height: 20),
                    _buildPressureDisplay(),
                    const SizedBox(height: 20),
                    _buildTestButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Back(
      showHome: false,
      showDelete: false,
      showNotifications: false,
    );
  }

  Widget _buildDeviceInfo() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _actionDetected ? Apptheme.lightOrange : Apptheme.white,
        borderRadius: BorderRadius.circular(8),
        border: _actionDetected 
            ? Border.all(color: Apptheme.primary, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: _actionDetected 
                ? Apptheme.primary.withAlpha(20)
                : Apptheme.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dispositivo Conectado',
            style: Apptheme.h2Title(context, color: Apptheme.textColorPrimary),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.bluetooth_connected,
                color: Apptheme.secondary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.deviceName ?? 'Dispositivo desconocido',
                      style: Apptheme.h4HighlightBody(context,
                          color: Apptheme.textColorPrimary),
                    ),
                    if (widget.deviceAddress != null)
                      Text(
                        widget.deviceAddress!,
                        style: Apptheme.h5Body(context,
                            color: Apptheme.textColorSecondary),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Apptheme.secondary.withAlpha(10),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Conectado',
                  style: Apptheme.h5Body(context, color: Apptheme.secondary),
                ),
              ),
              const SizedBox(width: 8),
              BatteryIndicator(
                size: BatteryIndicatorSize.small,
                showPercentage: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Reusable card builder for measurement displays
  Widget _buildMeasurementCard({
    required String title,
    required String value,
    required Color valueColor,
    DateTime? timestamp,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Apptheme.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Apptheme.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: Apptheme.h2Title(context, color: Apptheme.textColorPrimary),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 8),
          if (timestamp != null) ...[
            const SizedBox(height: 8),
            Text(
              'Última actualización: ${_formatTime(timestamp)}',
              style:
                  Apptheme.h5Body(context, color: Apptheme.textColorSecondary),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDepthDisplay() {
    final value = _currentDepth != null ? _currentDepth!.depthWithUnit : '--- mm';
    return _buildMeasurementCard(
      title: 'Profundidad Actual',
      value: value,
      valueColor: _getDepthColor(),
      timestamp: _currentDepth?.timestamp,
    );
  }

  Widget _buildPressureDisplay() {
    final value = _currentPressure != null
        ? _currentPressure!.depthWithUnit
        : '--- psi';
    return _buildMeasurementCard(
      title: 'Presión Actual',
      value: value,
      valueColor: _getPressureColor(),
      timestamp: _currentPressure?.timestamp,
    );
  }

  Color _getDepthColor() {
    if (_currentDepth != null && _currentDepth!.value < 0) {
      return Colors.red;
    } else if (_currentDepth != null) {
      return Apptheme.primary;
    }
    return Apptheme.textColorSecondary;
  }

  Color _getPressureColor() {
    if (_currentPressure != null && _currentPressure!.value < 0) {
      return Colors.red;
    } else if (_currentPressure != null) {
      return Apptheme.secondary; // Differentiate with a different theme color
    }
    return Apptheme.textColorSecondary;
  }

  Widget _buildTestButtons() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Apptheme.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Apptheme.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Comandos de Prueba',
            style: Apptheme.h2Title(context, color: Apptheme.textColorPrimary),
          ),
          const SizedBox(height: 24),
          // Primera fila - 2 botones lado a lado
          Row(
            children: [
              Expanded(
                child: _buildTestButton(
                  label: 'Solicitar Profundidad',
                  onPressed: () async {
                    final result = await _bluetoothService.requestDepthReading();
                    debugPrint('Solicitud de profundidad: $result');
                  },
                  borderColor: Apptheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTestButton(
                  label: 'Solicitar Presión',
                  onPressed: () async {
                    final result = await _bluetoothService.requestPressureReading();
                    debugPrint('Solicitud de presión: $result');
                  },
                  borderColor: Apptheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Segunda fila - 1 botón centrado
          _buildTestButton(
            label: 'Solicitar Batería',
            onPressed: () async {
              final result = await _bluetoothService.requestBatteryLevel();
              debugPrint('Solicitud de batería: $result');
            },
            borderColor: Apptheme.alertOrange,
          ),
        ],
      ),
    );
  }

  Widget _buildTestButton({
    required String label,
    required VoidCallback onPressed,
    required Color borderColor,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: borderColor,
          side: BorderSide(color: borderColor, width: 1.5),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: borderColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }
}
