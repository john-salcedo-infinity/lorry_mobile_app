import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/routers/app_routes.dart';
import 'package:app_lorry/screens/app/InpectionTire/observations/observation_sceen.dart';
import 'package:app_lorry/services/bluetooth/bluetooth_service.dart';
import 'package:app_lorry/widgets/bluetooth/bluetooth_bottom_sheet.dart';
import 'package:app_lorry/widgets/bluetooth/bluetooth_tag.dart';
import 'package:app_lorry/widgets/dialogs/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'tire_data_text_field.dart';

class TireInspectionForm extends ConsumerStatefulWidget {
  final MountingResult currentMounting;
  final Function(Map<String, dynamic>) onDataChanged;
  final List<Map<String, dynamic>> existingNovelties;
  final Function(List<Map<String, dynamic>>) onNoveltiesChanged;
  final Map<String, dynamic>? initialInspectionData; // Datos ya guardados
  final bool shouldFillNext;
  final String? newDepthValue;
  final DepthValueType? newDepthTypeValue;
  final int? depthSequence;
  final bool isActive; // indica si la página está activa para forzar foco

  const TireInspectionForm({
    super.key,
    required this.currentMounting,
    required this.onDataChanged,
    required this.existingNovelties,
    required this.onNoveltiesChanged,
    this.initialInspectionData,
    this.shouldFillNext = false,
    this.newDepthValue,
    this.newDepthTypeValue,
    this.depthSequence,
    this.isActive = false,
  });

  @override
  ConsumerState<TireInspectionForm> createState() => _TireInspectionFormState();
}

class _TireInspectionFormState extends ConsumerState<TireInspectionForm> {
  late TextEditingController _pressureController;
  late TextEditingController _externalController;
  late TextEditingController _internalController;
  late TextEditingController _centerController;

  // FocusNodes para tracking de foco
  final FocusNode _pressureFocus = FocusNode();
  final FocusNode _externalFocus = FocusNode();
  final FocusNode _centerFocus = FocusNode();
  final FocusNode _internalFocus = FocusNode();

  int _currentFieldIndex =
      0; // 0: pressure, 1: external, 2: center, 3: internal

  // Guardar última secuencia procesada para no repetir
  int? _lastProcessedSequence;

  @override
  void initState() {
    super.initState();

    // Agregar listeners para detectar cambios de foco manuales
    _pressureFocus.addListener(_onPressureFocusChanged);
    _externalFocus.addListener(_onExternalFocusChanged);
    _centerFocus.addListener(_onCenterFocusChanged);
    _internalFocus.addListener(_onInternalFocusChanged);

    _initControllers();

    // Inicialmente el foco está en el primer campo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pressureFocus.requestFocus();
    });
  }

  void _initControllers() {
    // Usar datos guardados si existen y tienen valores válidos, sino usar los originales del mounting
    final savedData = widget.initialInspectionData;

    final pressureValue = savedData != null &&
            savedData['pressure'] != null &&
            savedData['pressure'] != 0.0
        ? savedData['pressure'].toString()
        : (widget.currentMounting.tire?.pressure?.toString() ??
            widget.currentMounting.tire?.design?.dimension?.pressure
                ?.toString() ??
            "0");

    final externalProfValue = savedData != null &&
            savedData['prof_external'] != null &&
            savedData['prof_external'] != 0.0
        ? savedData['prof_external'].toString()
        : (widget.currentMounting.tire?.profExternalCurrent?.toString() ?? "0");

    final internalProfValue = savedData != null &&
            savedData['prof_internal'] != null &&
            savedData['prof_internal'] != 0.0
        ? savedData['prof_internal'].toString()
        : (widget.currentMounting.tire?.profInternalCurrent?.toString() ?? "0");

    final centerProfValue = savedData != null &&
            savedData['prof_center'] != null &&
            savedData['prof_center'] != 0.0
        ? savedData['prof_center'].toString()
        : (widget.currentMounting.tire?.profCenterCurrent?.toString() ?? "0");

    _pressureController = TextEditingController(text: pressureValue);
    _externalController = TextEditingController(text: externalProfValue);
    _internalController = TextEditingController(text: internalProfValue);
    _centerController = TextEditingController(text: centerProfValue);

    _pressureController.addListener(_notifyDataChanged);
    _externalController.addListener(_notifyDataChanged);
    _internalController.addListener(_notifyDataChanged);
    _centerController.addListener(_notifyDataChanged);
  }

  @override
  void didUpdateWidget(covariant TireInspectionForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Si la tarjeta pasa a estar activa, forzar foco al primer campo (sin teclado)
    if (widget.isActive && !oldWidget.isActive) {
      if (mounted) {
        _pressureFocus.requestFocus();
      }
    }

    final incomingSeq = widget.depthSequence;
    if (widget.shouldFillNext &&
        widget.newDepthValue != null &&
        widget.newDepthValue!.isNotEmpty &&
        incomingSeq != null &&
        incomingSeq != _lastProcessedSequence &&
        widget.newDepthTypeValue != null) {
      _handleIncomingMeasurement(
          widget.newDepthValue!, widget.newDepthTypeValue!);
      _lastProcessedSequence = incomingSeq;
      return;
    }

    // Solo actualizar si el mounting realmente cambió (diferente ID)
    final mountingChanged =
        oldWidget.currentMounting.id != widget.currentMounting.id;

    // Solo actualizar si hay datos iniciales y son diferentes a los valores actuales
    final hasInitialData = widget.initialInspectionData != null;
    final dataChanged =
        oldWidget.initialInspectionData != widget.initialInspectionData;

    if (mountingChanged || (hasInitialData && dataChanged)) {
      // Temporalmente remover listeners
      _pressureController.removeListener(_notifyDataChanged);
      _externalController.removeListener(_notifyDataChanged);
      _internalController.removeListener(_notifyDataChanged);
      _centerController.removeListener(_notifyDataChanged);

      // Solo actualizar si el mounting cambió o si es la primera vez que recibimos datos
      if (mountingChanged ||
          (hasInitialData && oldWidget.initialInspectionData == null)) {
        final savedData = widget.initialInspectionData;

        _pressureController.text = savedData != null &&
                savedData['pressure'] != null &&
                savedData['pressure'] != 0
            ? savedData['pressure'].toString()
            : (widget.currentMounting.tire?.pressure?.toString() ??
                widget.currentMounting.tire?.design?.dimension?.pressure
                    ?.toString() ??
                "0");

        _externalController.text = savedData != null &&
                savedData['prof_external'] != null &&
                savedData['prof_external'] != 0.0
            ? savedData['prof_external'].toString()
            : (widget.currentMounting.tire?.profExternalCurrent?.toString() ??
                "0");

        _internalController.text = savedData != null &&
                savedData['prof_internal'] != null &&
                savedData['prof_internal'] != 0.0
            ? savedData['prof_internal'].toString()
            : (widget.currentMounting.tire?.profInternalCurrent?.toString() ??
                "0");

        _centerController.text = savedData != null &&
                savedData['prof_center'] != null &&
                savedData['prof_center'] != 0.0
            ? savedData['prof_center'].toString()
            : (widget.currentMounting.tire?.profCenterCurrent?.toString() ??
                "0");
      }

      // Volver a agregar listeners
      _pressureController.addListener(_notifyDataChanged);
      _externalController.addListener(_notifyDataChanged);
      _internalController.addListener(_notifyDataChanged);
      _centerController.addListener(_notifyDataChanged);
    }
  }

  void _notifyDataChanged() {
    final data = {
      'mounting': widget.currentMounting.id,
      'pressure': int.tryParse(_pressureController.text) ?? 0,
      'prof_external': double.tryParse(_externalController.text) ?? 0.0,
      'prof_center': double.tryParse(_centerController.text) ?? 0.0,
      'prof_internal': double.tryParse(_internalController.text) ?? 0.0,
    };
    widget.onDataChanged(data);
  }

  // manejar medición según tipo y foco actual
  void _handleIncomingMeasurement(String value, DepthValueType type) {
    // Normalizar valor
    final v = value.trim();

    if (type == DepthValueType.depth) {
      // Si el foco está en presión (0) saltar al primer campo de profundidad
      if (_currentFieldIndex == 0) {
        _currentFieldIndex = 2; // external
        _externalController.text = v;
        _centerFocus.requestFocus();
      } else {
        // Foco ya en algún campo de profundidad => llenar ese mismo
        switch (_currentFieldIndex) {
          case 1:
            _externalController.text = v;
            _currentFieldIndex = 2;
            _centerFocus.requestFocus();
            break;
          case 2:
            _centerController.text = v;
            _currentFieldIndex = 3;
            _internalFocus.requestFocus();
            break;
          case 3:
            _internalController.text = v;
            _currentFieldIndex = 0;
            _pressureFocus.requestFocus();
            break;
          default:
            // Si por alguna razón índice es otro, forzar a external
            _currentFieldIndex = 1;
            _externalController.text = v;
            _externalFocus.requestFocus();
        }
      }
    } else if (type == DepthValueType.pressure) {
      // Si llega presión y estamos en profundidad, llenar presión
      _pressureController.text = v;
      _currentFieldIndex = 0;
      _externalFocus.requestFocus();
    }

    _notifyDataChanged();
  }

  // Métodos para manejar cambios de foco manuales
  void _onPressureFocusChanged() {
    if (_pressureFocus.hasFocus) {
      if (_currentFieldIndex != 0 && mounted) {
        setState(() {
          _currentFieldIndex = 0;
        });
      }
    }
  }

  void _onExternalFocusChanged() {
    if (_externalFocus.hasFocus) {
      if (_currentFieldIndex != 1 && mounted) {
        setState(() {
          _currentFieldIndex = 1;
        });
      }
    }
  }

  void _onCenterFocusChanged() {
    if (_centerFocus.hasFocus) {
      if (_currentFieldIndex != 2 && mounted) {
        setState(() {
          _currentFieldIndex = 2;
        });
      }
    }
  }

  void _onInternalFocusChanged() {
    if (_internalFocus.hasFocus) {
      if (_currentFieldIndex != 3 && mounted) {
        setState(() {
          _currentFieldIndex = 3;
        });
      }
    }
  }

  @override
  void dispose() {
    // Remover listeners antes de disponer los FocusNodes
    _pressureFocus.removeListener(_onPressureFocusChanged);
    _externalFocus.removeListener(_onExternalFocusChanged);
    _centerFocus.removeListener(_onCenterFocusChanged);
    _internalFocus.removeListener(_onInternalFocusChanged);

    _pressureController.dispose();
    _externalController.dispose();
    _internalController.dispose();
    _centerController.dispose();

    _pressureFocus.dispose();
    _externalFocus.dispose();
    _centerFocus.dispose();
    _internalFocus.dispose();

    super.dispose();
  }

  void _handleTireAlert(
      String fieldName, double currentValue, double lastValue) {
    // --- Validación presión ---

    if (fieldName == "Presión llanta" && currentValue < 30) {
      ValidationToastHelper.showValidationToast(
        context: context,
        title: "Alerta Presión",
        message:
            "La presión de la llanta es menor a 30 PSI. Se recomienda realizar servicio o corregir datos.",
      );
    }

    // --- Validación profundidad ---
    if (fieldName.startsWith("Profun.")) {
      final desgaste = lastValue - currentValue;
      if (desgaste > 2) {
        ValidationToastHelper.showValidationToast(
          context: context,
          title: "Alerta Profundidad",
          message:
              "La $fieldName disminuyó más de 2mm. Se recomienda realizar servicio o corregir datos.",
        );
      }
    }
  }

  Future<void> _activateBluetoothAndConnect(List<dynamic>? deviceData) async {
    try {
      final bluetoothService = BluetoothService.instance;

      // Encender Bluetooth
      await bluetoothService.turnBluetoothOn();

      // Esperar un momento para que el Bluetooth se active completamente
      await Future.delayed(const Duration(seconds: 2));

      // Verificar que el Bluetooth esté realmente encendido
      final isEnabled = await bluetoothService.validateBluetooth();

      if (isEnabled && deviceData != null && deviceData[0] != null) {
        // Intentar conectar al dispositivo guardado
        await _connectToSavedDevice(deviceData);
      } else if (!isEnabled) {
        if (context.mounted) {
          ValidationToastHelper.showValidationToast(
            context: context,
            title: "Error de Bluetooth",
            message: "No se pudo activar el Bluetooth. Inténtelo manualmente.",
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ValidationToastHelper.showValidationToast(
          context: context,
          title: "Error de Conexión",
          message: "Error al activar Bluetooth: $e",
        );
      }
    }
  }

  Future<void> _connectToSavedDevice(List<dynamic> deviceData) async {
    try {
      final bluetoothService = BluetoothService.instance;

      final connectionResult = await bluetoothService.connectToDevice(
        BluetoothDeviceModel(
          name: deviceData[1] ?? "Dispositivo",
          address: deviceData[0],
        ),
      );

      if (!mounted) return;

      if (connectionResult.state == BluetoothConnectionState.connected) {
        ToastHelper.show_success(
          context,
          "Conectado con éxito",
        );
      } else {
        ToastHelper.show_alert(
          context,
          "No se pudo conectar al dispositivo",
        );
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const BluetoothBottomSheet(),
        );
      }
    } catch (e) {
      if (!mounted) return;
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const BluetoothBottomSheet(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Apptheme.lightGreen,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 12),
          _buildHeaderCard(),
          const SizedBox(height: 16),
          TireDataTextField(
            key: ValueKey('pressure-${widget.currentMounting.id}'),
            label: "Presión llanta",
            controller: _pressureController,
            isEditable: true,
            isPressure: true,
            lastValue: widget.currentMounting.tire?.pressure?.toInt() ?? 0,
            onValueChanged: _handleTireAlert,
            focusNode: _pressureFocus,
            suppressKeyboardUntilTap: true,
            nextFocusNode: _externalFocus,
          ),
          const SizedBox(height: 24),
          TireDataTextField(
            key: ValueKey('prof_ext-${widget.currentMounting.id}'),
            label: "Profun. Externa",
            controller: _externalController,
            isEditable: true,
            lastValue:
                widget.currentMounting.tire?.profExternalCurrent?.toDouble() ??
                    0.0,
            onValueChanged: _handleTireAlert,
            focusNode: _externalFocus,
            suppressKeyboardUntilTap: true,
            nextFocusNode: _centerFocus,
          ),
          const SizedBox(height: 12),
          TireDataTextField(
            key: ValueKey('prof_center-${widget.currentMounting.id}'),
            label: "Profun. Central",
            controller: _centerController,
            isEditable: true,
            lastValue:
                widget.currentMounting.tire?.profCenterCurrent?.toDouble() ??
                    0.0,
            onValueChanged: _handleTireAlert,
            focusNode: _centerFocus,
            suppressKeyboardUntilTap: true,
            nextFocusNode: _internalFocus,
          ),
          const SizedBox(height: 12),
          TireDataTextField(
            key: ValueKey('prof_internal-${widget.currentMounting.id}'),
            label: "Profun. Interna",
            controller: _internalController,
            isEditable: true,
            lastValue:
                widget.currentMounting.tire?.profInternalCurrent?.toDouble() ??
                    0.0,
            onValueChanged: _handleTireAlert,
            focusNode: _internalFocus,
            suppressKeyboardUntilTap: true,
            nextFocusNode: _pressureFocus,
          ),
          const SizedBox(height: 24),
          _buildBluetoothConnectionButton(),
          _buildAddObservationButton(),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Serie LL-${widget.currentMounting.tire?.integrationCode ?? 'Sin Serie'}",
          style: Apptheme.h1Title(context, color: Apptheme.textColorPrimary),
        ),
        const SizedBox(height: 8),
        Row(
          spacing: 8,
          children: [
            Expanded(
              // Añadir Expanded
              child: Container(
                height: 32,
                decoration: BoxDecoration(
                  color: Apptheme.lightGreenv2,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Apptheme.secondary, width: 2),
                ),
                child: Center(
                  // Centrar el texto
                  child: Text(
                    widget.currentMounting.tire?.design?.name ?? 'N/A',
                    style: Apptheme.h5HighlightBody(
                      context,
                      color: Apptheme.secondary,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            Expanded(
              // Añadir Expanded
              child: Container(
                height: 32,
                decoration: BoxDecoration(
                  color: Apptheme.lightGreenv2,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Apptheme.secondary, width: 2),
                ),
                child: Center(
                  // Centrar el texto
                  child: Text(
                    widget.currentMounting.tire?.band?.name ?? 'N/A',
                    style: Apptheme.h5HighlightBody(
                      context,
                      color: Apptheme.secondary,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildAddObservationButton() {
    return TextButton(
      onPressed: () async {
        final result =
            await ref.read(appRouterProvider).push<List<Map<String, dynamic>>>(
                  "/observations",
                  extra: ObservationSceenParams(
                    currentMountingResult: widget.currentMounting,
                    existingNovelties: widget.existingNovelties,
                  ),
                );

        // Si se devolvieron novedades, actualizar el estado
        if (result != null) {
          widget.onNoveltiesChanged(result);
        }
      },
      style: TextButton.styleFrom(
        foregroundColor: Apptheme.textColorPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.existingNovelties.isNotEmpty
                ? "Editar Novedades"
                : "Reportar Novedad",
            style: Apptheme.h4HighlightBody(
              context,
              color: Apptheme.textColorPrimary,
            ),
          ),
          if (widget.existingNovelties.isNotEmpty) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Apptheme.alertOrange,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${widget.existingNovelties.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBluetoothConnectionButton() {
    final BluetoothService bluetoothService = BluetoothService.instance;
    return FutureBuilder<dynamic>(
      future: () async {
        Preferences prefs = Preferences();
        await prefs.init();
        return prefs.getList(
          BluetoothSharedPreference.lastConnectedDevice.key,
        );
      }(),
      builder: (context, snapshot) {
        void handleTap() async {
          // Validar que el Bluetooth esté encendido antes de cualquier operación
          final isBluetoothEnabled = await bluetoothService.validateBluetooth();

          if (!context.mounted) return;

          if (!isBluetoothEnabled) {
            ConfirmationDialog.show(
              context: context,
              title: 'Bluetooth Desactivado',
              message:
                  'El Bluetooth está desactivado. ¿Desea activarlo y conectar el dispositivo automáticamente?',
              cancelText: 'Cancelar',
              acceptText: 'Activar y Conectar',
              onAccept: () async {
                await _activateBluetoothAndConnect(snapshot.data);
              },
            );
            return;
          }

          if (snapshot.data != null) {
            if (bluetoothService.connectedDevice != null) {
              ConfirmationDialog.show(
                context: context,
                title: 'Desconectar Dispositivo',
                message:
                    '¿Desea desconectar el dispositivo ${bluetoothService.connectedDevice!.name}?',
                cancelText: 'Cancelar',
                acceptText: 'Aceptar',
                onAccept: () => bluetoothService.disconnectDevice(),
              );
              return;
            }

            // Conectar automáticamente si hay dispositivo guardado
            await _connectToSavedDevice(snapshot.data);
          } else {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const BluetoothBottomSheet(),
            );
          }
        }

        return BluetoothTag(
          showAsButton: true,
          onTap: handleTap,
        );
      },
    );
  }
}
