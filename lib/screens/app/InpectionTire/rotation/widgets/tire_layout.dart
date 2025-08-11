import 'package:flutter/material.dart';
import '../spinAndRotationScreen.dart';
import 'tire_cards.dart';

/// Widget para mostrar la grilla de llantas regulares
class RegularTiresGrid extends StatelessWidget {
  final List<TirePosition> regularTires;
  final bool isEmpty;
  final Function(TirePosition)? onTireSelect;
  final int sectionType;
  final List<TireMovement> movements; // Lista de movimientos

  const RegularTiresGrid({
    super.key,
    required this.regularTires,
    required this.isEmpty,
    required this.sectionType,
    this.onTireSelect,
    this.movements = const [],
  });

  @override
  Widget build(BuildContext context) {
    const columnsCount = 3;
    const tiresPerCell = 2; // 2 llantas por celda
    final tiresPerRow = columnsCount * tiresPerCell; // 6 llantas por fila
    final numberOfRows = (regularTires.length / tiresPerRow).ceil();

    return Column(
      children: [
        for (int row = 0; row < numberOfRows; row++) ...[
          Row(
            children: [
              for (int col = 0; col < columnsCount; col++) ...[
                Expanded(
                  child: _buildGridCell(row, col, tiresPerCell),
                ),
                if (col < columnsCount - 1) const SizedBox(width: 20),
              ],
            ],
          ),
          if (row < numberOfRows - 1) const SizedBox(height: 20),
        ],
      ],
    );
  }

  /// Encuentra el movimiento asociado a una posición específica
  TireMovement? _findMovementForPosition(String position) {
    try {
      return movements.firstWhere(
        (movement) => movement.destinationPosition == position,
      );
    } catch (e) {
      return null;
    }
  }

  Widget _buildGridCell(int row, int col, int tiresPerCell) {
    const columnsCount = 3;
    final tiresPerRow = columnsCount * tiresPerCell;
    final startIndex = row * tiresPerRow + col * tiresPerCell;

    // Obtener las 2 llantas para esta celda
    final cellTires = <TirePosition>[];
    for (int i = 0; i < tiresPerCell; i++) {
      final tireIndex = startIndex + i;
      if (tireIndex < regularTires.length) {
        cellTires.add(regularTires[tireIndex]);
      }
    }

    if (cellTires.isEmpty) {
      return Container();
    }

    return Row(
      children: [
        for (int i = 0; i < cellTires.length; i++) ...[
          Expanded(
            child: TireCard(
              tire: cellTires[i],
              isEmpty: isEmpty,
              onTireSelect: onTireSelect,
              sectionType: sectionType,
              movement: _findMovementForPosition(cellTires[i].position),
            ),
          ),
        ],
        // Agregar espacios vacíos si no hay suficientes llantas para llenar la celda
        for (int i = cellTires.length; i < tiresPerCell; i++) ...[
          if (i > 0) const SizedBox(width: 4),
          Expanded(child: Container()),
        ],
      ],
    );
  }
}

/// Widget para mostrar la fila de llantas de repuesto
class SpareTiresRow extends StatelessWidget {
  final List<TirePosition> spareTires;
  final bool isEmpty;
  final int sectionType;
  final Function(TirePosition)? onTireSelect;
  final List<TireMovement> movements; // Lista de movimientos

  const SpareTiresRow({
    super.key,
    required this.spareTires,
    required this.isEmpty,
    required this.sectionType,
    this.onTireSelect,
    this.movements = const [],
  });

  /// Encuentra el movimiento asociado a una posición específica
  TireMovement? _findMovementForPosition(String position) {
    try {
      return movements.firstWhere(
        (movement) => movement.destinationPosition == position,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: spareTires
          .asMap()
          .entries
          .map((entry) => [
                SpareCard(
                  tire: entry.value,
                  isEmpty: isEmpty,
                  onTireSelect: onTireSelect,
                  sectionType: sectionType,
                  movement: _findMovementForPosition(entry.value.position),
                ),
                if (entry.key < spareTires.length - 1) const SizedBox(width: 8),
              ])
          .expand((element) => element)
          .toList(),
    );
  }
}
