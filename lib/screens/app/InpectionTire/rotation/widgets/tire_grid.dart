import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/models/models.dart';
import 'package:flutter/material.dart';
import '../spinAndRotationScreen.dart';
import 'tire_layout.dart';

/// Widget principal para mostrar la grilla completa de llantas
class TireGrid extends StatelessWidget {
  final List<TirePosition> configuration;
  final bool isEmpty;
  final int sectionType;
  final Function(TirePosition)? onTireSelect;
  final List<TireMovement> movements;
  final ServiceData? activeService; // Información del servicio activo

  const TireGrid({
    super.key,
    required this.configuration,
    required this.isEmpty,
    required this.sectionType,
    this.onTireSelect,
    this.movements = const [],
    this.activeService,
  });

  @override
  Widget build(BuildContext context) {
    final regularTires = configuration.where((t) => !t.isSpare).toList();
    final spareTires = configuration.where((t) => t.isSpare).toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: (activeService != null && sectionType == 2)
            ? Apptheme.lightOrange
            : Apptheme.white,
      ),
      child: Column(
        children: [
          RegularTiresGrid(
            regularTires: regularTires,
            isEmpty: isEmpty,
            onTireSelect: onTireSelect,
            sectionType: sectionType,
            movements: movements,
          ),
          if (spareTires.isNotEmpty) ...[
            const SizedBox(height: 10),
            SpareTiresRow(
              spareTires: spareTires,
              isEmpty: isEmpty,
              onTireSelect: onTireSelect,
              sectionType: sectionType,
              movements: movements,
            ),
          ],
        ],
      ),
    );
  }
}
