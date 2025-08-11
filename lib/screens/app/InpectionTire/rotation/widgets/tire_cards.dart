import 'package:app_lorry/config/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../spinAndRotationScreen.dart';
import 'tire_widgets.dart';

/// Widget para mostrar la etiqueta de posición
class PositionLabel extends StatelessWidget {
  final String positionId;
  final int sectionType;
  final TireMovement?
      movement; // Información del movimiento realizado si existe

  const PositionLabel({
    super.key,
    required this.positionId,
    required this.sectionType,
    this.movement,
  });

  @override
  Widget build(BuildContext context) {
    // Para sectionType 2 (Nueva configuración)
    if (sectionType == 2) {
      // Si no hay movimiento, no mostrar nada
      if (movement == null) {
        return const SizedBox(height: 22); // Mantener el espacio
      }

      // Si hay movimiento, mostrar ícono según el tipo de servicio
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle
        ),
        child: _buildMovementIcon(),
      );
    }

    // Para otros sectionTypes, comportamiento normal
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        'P$positionId',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w900,
          color: Apptheme.textColorPrimary,
        ),
      ),
    );
  }

  Widget _buildMovementIcon() {
    if (movement == null) return const SizedBox();

    // Determinar el ícono basado en el tipo de servicio
    String iconPath;
    Color iconColor = Apptheme.primary;
    IconData fallbackIcon;

    switch (movement!.service.id) {
      case 14: // SERVICE_ROTATE
        iconPath = 'assets/icons/services/lorr-rotate.svg';
        fallbackIcon = Icons.refresh;
        break;
      case 18: // SERVICE_TURN
        iconPath = 'assets/icons/services/lorr-turn.svg';
        fallbackIcon = Icons.rotate_90_degrees_ccw;
        break;
      case 19: // SERVICE_ROTATE_TURN
        iconPath = 'assets/icons/services/lorr-turn-rotate2.svg';
        fallbackIcon = Icons.autorenew;
        break;
      default:
        // Para otros servicios, usar un ícono genérico de movimiento
        return Icon(
          Icons.swap_horiz,
          size: 16,
          color: iconColor,
        );
    }

    // Intentar cargar el SVG, si hay error usar el fallback
    try {
      return SvgPicture.asset(
        iconPath,
        width: 16,
        height: 16,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      );
    } catch (e) {
      return Icon(
        fallbackIcon,
        size: 16,
        color: iconColor,
      );
    }
  }
}

/// Widget para mostrar una tarjeta de llanta regular
class TireCard extends StatelessWidget {
  final TirePosition tire;
  final bool isEmpty;
  final Function(TirePosition)? onTireSelect;
  final int sectionType;
  final TireMovement? movement; // Información del movimiento si existe

  const TireCard({
    super.key,
    required this.tire,
    this.isEmpty = false,
    this.onTireSelect,
    required this.sectionType,
    this.movement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PositionLabel(
          positionId: tire.position,
          sectionType: sectionType,
          movement: movement,
        ),
        TireWidget(
          tire: tire,
          width: 60,
          height: 80,
          isEmpty: isEmpty,
          onTireSelect: onTireSelect,
          sectionType: sectionType,
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
  final int sectionType;
  final TireMovement? movement; // Información del movimiento si existe

  const SpareCard({
    super.key,
    required this.tire,
    this.isEmpty = false,
    this.onTireSelect,
    required this.sectionType,
    this.movement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PositionLabel(
          positionId: tire.position,
          sectionType: sectionType,
          movement: movement,
        ),
        SpareWidget(
          tire: tire,
          width: 80,
          height: 40,
          isEmpty: isEmpty,
          onTireSelect: onTireSelect,
          sectionType: sectionType,
        ),
      ],
    );
  }
}
