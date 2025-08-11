import 'package:app_lorry/config/app_theme.dart';
import 'package:flutter/material.dart';
import '../spinAndRotationScreen.dart';

/// Widget para mostrar una llanta individual
class TireWidget extends StatelessWidget {
  final TirePosition tire;
  final double width;
  final double height;
  final bool isEmpty;
  final Function(TirePosition)? onTireSelect;

  const TireWidget({
    super.key,
    required this.tire,
    required this.width,
    required this.height,
    this.isEmpty = false,
    this.onTireSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTireSelect?.call(tire),
      child: Tooltip(
        verticalOffset: 50,
        message: tire.hasTire && tire.serialNumber != null
            ? 'LL-${tire.serialNumber!}'
            : '',
        decoration: BoxDecoration(
          color: Apptheme.lightOrange,
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: const TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
        child: Container(
          width: width,
          height: height,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: tire.isSelected
                  ? Apptheme.primary
                  : (isEmpty ? Apptheme.primary : Apptheme.textColorPrimary),
              width: tire.isSelected ? 3 : 2,
            ),
            color: tire.isSelected
                ? Apptheme.lightOrange
                : isEmpty
                    ? Apptheme.lightOrange
                    : Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isEmpty && tire.hasTire) ...[
                Image.asset(
                  'assets/icons/tire.png',
                  width: width,
                  height: height * 0.875,
                ),
              ] else if (!isEmpty && !tire.hasTire) ...[
                Image.asset(
                  'assets/icons/tire.png',
                  width: width * 0.5,
                  height: height * 0.375,
                  color: Colors.grey[400],
                ),
              ] else ...[
                Text(
                  tire.id,
                  style: TextStyle(
                    color: Apptheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget para mostrar una llanta de repuesto
class SpareWidget extends StatelessWidget {
  final TirePosition tire;
  final double width;
  final double height;
  final bool isEmpty;
  final Function(TirePosition)? onTireSelect;

  const SpareWidget({
    super.key,
    required this.tire,
    required this.width,
    required this.height,
    this.isEmpty = false,
    this.onTireSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTireSelect?.call(tire),
      child: Tooltip(
        verticalOffset: 10,
        message: tire.hasTire && tire.serialNumber != null
            ? 'LL-${tire.serialNumber!}'
            : '',
        decoration: BoxDecoration(
          color: Apptheme.lightOrange,
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: const TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: tire.isSelected
                  ? Apptheme.primary
                  : (isEmpty ? Apptheme.primary : Apptheme.textColorPrimary),
              width: tire.isSelected ? 2 : 2,
            ),
            color: tire.isSelected
                ? Apptheme.lightOrange
                : (isEmpty ? Apptheme.lightOrange : null),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Center(
                  child: Transform.rotate(
                    angle: isEmpty ? 0 : 1.5708,
                    child: _buildSpareImage(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpareImage() {
    if (isEmpty) {
      return Text(
        tire.id,
        style: TextStyle(
          color: Apptheme.primary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (tire.hasTire) {
      return Image.asset(
        'assets/icons/tire.png',
        width: width * 1.125,
        height: height * 1.25,
      );
    } else {
      return Image.asset(
        'assets/icons/tire.png',
        width: height * 0.5,
        height: height * 0.75,
        color: Colors.grey[400],
        fit: BoxFit.contain,
      );
    }
  }
}
