import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/widgets/shared/back.dart';
import 'package:app_lorry/services/bluetooth/bluetooth_service.dart';
import 'package:app_lorry/models/models.dart';

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
  DepthData? _currentDepth;
  String _statusMessage = 'Esperando datos del dispositivo...';

  // Subscripciones a streams
  StreamSubscription<DepthData>? _depthSubscription;

  @override
  void initState() {
    super.initState();
    _initializeStreams();
  }

  @override
  void dispose() {
    _depthSubscription?.cancel();
    super.dispose();
  }

  void _initializeStreams() {
    // Escuchar datos de profundidad
    _depthSubscription = _bluetoothService.depthDataStream.listen(
      (depthData) {
        debugPrint(
            'Calibration Screen - Datos de profundidad recibidos: ${depthData.depthWithUnit}');
        setState(() {
          _currentDepth = depthData;
          _statusMessage = 'Última profundidad: ${depthData.depthWithUnit}';
        });
      },
      onError: (error) {
        debugPrint(
            'Calibration Screen - Error en stream de profundidad: $error');
        setState(() {
          _statusMessage = 'Error en datos de profundidad: $error';
        });
      },
    );
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
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildDeviceInfo(),
                    const SizedBox(height: 20),
                    _buildDepthDisplay(),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDepthDisplay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Profundidad Actual',
            style: Apptheme.h2Title(context, color: Apptheme.textColorPrimary),
          ),
          const SizedBox(height: 16),
          Text(
            _currentDepth != null ? _currentDepth!.depthWithUnit : '--- mm',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: _getDepthColor(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _statusMessage,
            style: Apptheme.h5Body(context, color: Apptheme.textColorSecondary),
            textAlign: TextAlign.center,
          ),
          if (_currentDepth != null) ...[
            const SizedBox(height: 8),
            Text(
              'Última actualización: ${_formatTime(_currentDepth!.timestamp)}',
              style: Apptheme.h5Body(context, color: Apptheme.textColorSecondary),
            ),
          ],
        ],
      ),
    );
  }

  Color _getDepthColor() {
    if (_currentDepth != null && _currentDepth!.depth < 0) {
      return Colors.red;
    } else if (_currentDepth != null) {
      return Apptheme.primary;
    }
    return Apptheme.textColorSecondary;
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }
}
