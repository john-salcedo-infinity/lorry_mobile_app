import 'package:app_lorry/routers/app_routes.dart';
import 'package:app_lorry/screens/app/InpectionTire/observations/observation_sceen.dart';
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

  const TireInspectionForm({
    super.key,
    required this.currentMounting,
    required this.onDataChanged,
    required this.existingNovelties,
    required this.onNoveltiesChanged,
    this.initialInspectionData,
  });

  @override
  ConsumerState<TireInspectionForm> createState() => _TireInspectionFormState();
}

class _TireInspectionFormState extends ConsumerState<TireInspectionForm> {
  late TextEditingController _pressureController;
  late TextEditingController _externalController;
  late TextEditingController _internalController;
  late TextEditingController _centerController;

  @override
  void initState() {
    super.initState();
    _initControllers();
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

  @override
  void dispose() {
    _pressureController.dispose();
    _externalController.dispose();
    _internalController.dispose();
    _centerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Apptheme.lightGreen,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Serie LL-${widget.currentMounting.tire?.integrationCode ?? 'Sin Serie'}",
              style:
                  Apptheme.h1Title(context, color: Apptheme.textColorPrimary),
            ),
          ),
          const SizedBox(height: 18),
          TireDataTextField(
            label: "Presión llanta",
            controller: _pressureController,
            isEditable: true,
            isPressure: true,
            lastValue: widget.currentMounting.tire?.pressure?.toInt() ?? 0,
          ),
          const SizedBox(height: 38),
          TireDataTextField(
            label: "Profun. Externa",
            controller: _externalController,
            isEditable: true,
            lastValue:
                widget.currentMounting.tire?.profExternalCurrent?.toDouble() ??
                    0.0,
          ),
          const SizedBox(height: 12),
          TireDataTextField(
            label: "Profun. Interna",
            controller: _internalController,
            isEditable: true,
            lastValue:
                widget.currentMounting.tire?.profInternalCurrent?.toDouble() ??
                    0.0,
          ),
          const SizedBox(height: 12),
          TireDataTextField(
            label: "Profun. Central",
            controller: _centerController,
            isEditable: true,
            lastValue:
                widget.currentMounting.tire?.profCenterCurrent?.toDouble() ??
                    0.0,
          ),
          const SizedBox(height: 32),
          _buildAddObservationButton(),
        ],
      ),
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
}
