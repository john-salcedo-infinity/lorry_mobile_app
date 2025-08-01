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

  const TireInspectionForm({
    super.key,
    required this.currentMounting,
    required this.onDataChanged,
    required this.existingNovelties,
    required this.onNoveltiesChanged,
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
    final pressureValue = widget.currentMounting.tire?.pressure?.toString() ??
        widget.currentMounting.tire?.design?.dimension?.pressure?.toString() ??
        "0";
    final externalProfValue =
        widget.currentMounting.tire?.profExternalCurrent?.toString() ?? "0";
    final internalProfValue =
        widget.currentMounting.tire?.profInternalCurrent?.toString() ?? "0";
    final centerProfValue =
        widget.currentMounting.tire?.profCenterCurrent?.toString() ?? "0";

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
    if (oldWidget.currentMounting != widget.currentMounting) {
      // El montaje cambió, actualiza los controladores
      _pressureController.removeListener(_notifyDataChanged);
      _externalController.removeListener(_notifyDataChanged);
      _internalController.removeListener(_notifyDataChanged);
      _centerController.removeListener(_notifyDataChanged);

      _pressureController.text =
          widget.currentMounting.tire?.pressure?.toString() ??
              widget.currentMounting.tire?.design?.dimension?.pressure
                  ?.toString() ??
              "0";
      _externalController.text =
          widget.currentMounting.tire?.profExternalCurrent?.toString() ?? "0";
      _internalController.text =
          widget.currentMounting.tire?.profInternalCurrent?.toString() ?? "0";
      _centerController.text =
          widget.currentMounting.tire?.profCenterCurrent?.toString() ?? "0";

      _pressureController.addListener(_notifyDataChanged);
      _externalController.addListener(_notifyDataChanged);
      _internalController.addListener(_notifyDataChanged);
      _centerController.addListener(_notifyDataChanged);
    }
  }

  void _notifyDataChanged() {
    final data = {
      'mounting': widget.currentMounting.id,
      'pressure': double.tryParse(_pressureController.text) ?? 0.0,
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
      height: 565,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFDDEAE4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Serie LL-${widget.currentMounting.tire?.integrationCode ?? 'Sin Serie'}",
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Apptheme.textColorPrimary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TireDataTextField(
            label: "Presión Llanta",
            controller: _pressureController,
            isEditable: true,
            isPressure: true,
            lastValue: widget.currentMounting.tire?.pressure?.toDouble() ?? 0.0,
          ),
          const SizedBox(height: 35),
          TireDataTextField(
            label: "Profun. Externa",
            controller: _externalController,
            isEditable: true,
            lastValue:
                widget.currentMounting.tire?.profExternalCurrent?.toDouble() ??
                    0.0,
          ),
          const SizedBox(height: 10),
          TireDataTextField(
            label: "Profun. Interna",
            controller: _internalController,
            isEditable: true,
            lastValue:
                widget.currentMounting.tire?.profInternalCurrent?.toDouble() ??
                    0.0,
          ),
          const SizedBox(height: 10),
          TireDataTextField(
            label: "Profun. Central",
            controller: _centerController,
            isEditable: true,
            lastValue:
                widget.currentMounting.tire?.profCenterCurrent?.toDouble() ??
                    0.0,
          ),
          const SizedBox(height: 30),
          _buildAddObservationButton(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildAddObservationButton() {
    return TextButton(
      onPressed: () async {
        final result = await ref.read(appRouterProvider).push<List<Map<String, dynamic>>>(
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
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          if (widget.existingNovelties.isNotEmpty) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Apptheme.AlertOrange,
                borderRadius: BorderRadius.circular(12),
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
