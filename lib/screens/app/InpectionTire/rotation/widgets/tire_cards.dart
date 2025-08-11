import 'package:app_lorry/config/app_theme.dart';
import 'package:flutter/material.dart';
import '../spinAndRotationScreen.dart';
import 'tire_widgets.dart';

/// Widget para mostrar la etiqueta de posición
class PositionLabel extends StatelessWidget {
  final String positionId;

  const PositionLabel({
    super.key,
    required this.positionId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        positionId,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w900,
          color: Apptheme.textColorPrimary,
        ),
      ),
    );
  }
}

/// Widget para mostrar una tarjeta de llanta regular
class TireCard extends StatelessWidget {
  final TirePosition tire;
  final bool isEmpty;
  final Function(TirePosition)? onTireSelect;

  const TireCard({
    super.key,
    required this.tire,
    this.isEmpty = false,
    this.onTireSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isEmpty ? Container() : PositionLabel(positionId: tire.id),
        TireWidget(
          tire: tire,
          width: 60,
          height: 80,
          isEmpty: isEmpty,
          onTireSelect: onTireSelect,
        ),
      ],
    );
  }
}

/// Widget para mostrar una tarjeta de llanta de repuesto
class SpareCard extends StatelessWidget {
  final TirePosition tire;
  final bool isEmpty;
  final Function(TirePosition)? onTireSelect;

  const SpareCard({
    super.key,
    required this.tire,
    this.isEmpty = false,
    this.onTireSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isEmpty
            ? Container(
                margin: EdgeInsets.only(top: 20),
              )
            : PositionLabel(positionId: tire.id),
        SpareWidget(
          tire: tire,
          width: 80,
          height: 40,
          isEmpty: isEmpty,
          onTireSelect: onTireSelect,
        ),
      ],
    );
  }
}
