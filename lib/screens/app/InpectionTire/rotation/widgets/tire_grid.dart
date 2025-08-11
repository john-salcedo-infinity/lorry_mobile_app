import 'package:flutter/material.dart';
import '../spinAndRotationScreen.dart';
import 'tire_layout.dart';

/// Widget principal para mostrar la grilla completa de llantas
class TireGrid extends StatelessWidget {
  final List<TirePosition> configuration;
  final bool isEmpty;
  final Function(TirePosition)? onTireSelect;

  const TireGrid({
    super.key,
    required this.configuration,
    required this.isEmpty,
    this.onTireSelect,
  });

  @override
  Widget build(BuildContext context) {
    final regularTires = configuration.where((t) => !t.isSpare).toList();
    final spareTires = configuration.where((t) => t.isSpare).toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        children: [
          RegularTiresGrid(
            regularTires: regularTires,
            isEmpty: isEmpty,
            onTireSelect: onTireSelect,
          ),
          if (spareTires.isNotEmpty) ...[
            const SizedBox(height: 10),
            SpareTiresRow(
              spareTires: spareTires,
              isEmpty: isEmpty,
              onTireSelect: onTireSelect,
            ),
          ],
        ],
      ),
    );
  }
}
