import 'package:flutter/material.dart';
import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/widgets/shared/back.dart';

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
  bool _isCalibrating = false;
  double _calibrationProgress = 0.0;
  String _statusMessage = '';

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
                    const SizedBox(height: 40),
                    _buildDeviceInfo(),
                    const SizedBox(height: 60),
                    _buildCalibrationStatus(),
                    const Spacer(),
                    _buildCalibrationButton(),
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
            color: Colors.black.withOpacity(0.05),
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
                  color: Apptheme.secondary.withOpacity(0.1),
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

  Widget _buildCalibrationStatus() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Estado de Calibración',
            style: Apptheme.h2Title(context, color: Apptheme.textColorPrimary),
          ),
          const SizedBox(height: 24),
          if (_isCalibrating) ...[
            SizedBox(
              width: 80,
              height: 80,
              child: Stack(
                children: [
                  Apptheme.loadingIndicator(),
                  Center(
                    child: Text(
                      '${(_calibrationProgress * 100).toInt()}%',
                      style: Apptheme.h4HighlightBody(context,
                          color: Apptheme.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: _calibrationProgress,
              backgroundColor: Apptheme.lightGray,
              valueColor: AlwaysStoppedAnimation<Color>(Apptheme.primary),
            ),
            const SizedBox(height: 16),
            Text(
              _statusMessage,
              style: Apptheme.h4Medium(context, color: Apptheme.textColorPrimary),
              textAlign: TextAlign.center,
            ),
          ] else ...[
            Icon(
              Icons.settings_bluetooth,
              size: 80,
              color: Apptheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Listo para calibrar',
              style: Apptheme.h4Medium(context, color: Apptheme.textColorPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'La calibración optimizará la conexión\ncon el dispositivo seleccionado',
              style: Apptheme.h5Body(context, color: Apptheme.textColorSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCalibrationButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isCalibrating ? null : _startCalibration,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isCalibrating ? Apptheme.lightGray : Apptheme.primary,
          disabledBackgroundColor: Apptheme.lightGray,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _isCalibrating
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Apptheme.loadingIndicatorButton(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Calibrando...',
                    style: Apptheme.h4HighlightBody(context, color: Colors.white),
                  ),
                ],
              )
            : Text(
                'Iniciar Calibración',
                style: Apptheme.h4HighlightBody(context, color: Colors.white),
              ),
      ),
    );
  }

  void _startCalibration() async {
    setState(() {
      _isCalibrating = true;
      _calibrationProgress = 0.0;
      _statusMessage = 'Iniciando calibración...';
    });

    // Simular proceso de calibración
    await _simulateCalibrationProcess();
  }

  Future<void> _simulateCalibrationProcess() async {
    final List<String> steps = [
      'Iniciando calibración...',
      'Verificando conexión...',
      'Configurando parámetros...',
      'Probando señal...',
      'Optimizando conexión...',
      'Finalizando proceso...',
      'Calibración completada!',
    ];

    for (int i = 0; i < steps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        setState(() {
          _statusMessage = steps[i];
          _calibrationProgress = (i + 1) / steps.length;
        });
      }
    }

    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _isCalibrating = false;
      });

      // Mostrar mensaje de éxito y regresar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Calibración completada exitosamente'),
          backgroundColor: Apptheme.secondary,
          duration: const Duration(seconds: 2),
        ),
      );

      // Regresar después de 2 segundos
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }
}
