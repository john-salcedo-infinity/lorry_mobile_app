import 'package:flutter/material.dart';
import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/models/models.dart';
import 'tire_data_text_field.dart';

class TireInspectionForm extends StatefulWidget {
  final MountingResult currentMounting;
  final Function(Map<String, dynamic>) onDataChanged;

  const TireInspectionForm({
    super.key,
    required this.currentMounting,
    required this.onDataChanged,
  });

  @override
  State<TireInspectionForm> createState() => _TireInspectionFormState();
}

class _TireInspectionFormState extends State<TireInspectionForm> {
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
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
