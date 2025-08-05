import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/config/app_theme.dart';

class CustomButton extends ConsumerWidget {
  final double width;
  final double height;
  final Widget child;
  final VoidCallback? onPressed;
  final int? type;

  const CustomButton(
    this.width,
    this.height,
    this.child,
    this.onPressed, {
    super.key,
    this.type = 1,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: width, // Ajusta el ancho
              height: height, // Ajusta la altura
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4), // border-radius: 4px
                boxShadow: [
                  BoxShadow(
                    color: onPressed == null 
                        ? _getBorderColor(type).withAlpha(50) // Sombra difuminada cuando está desactivado
                        : _getBorderColor(type), // Sombra normal cuando está activo
                    offset: const Offset(0, 3), // Grosor del borde inferior
                    blurRadius: 0,
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  foregroundColor: _getForegroundColor(type),
                  backgroundColor: _getBackgroundColor(type),
                  disabledBackgroundColor: _getBackgroundColor(type).withAlpha(50),
                  disabledForegroundColor: _getForegroundColor(type).withAlpha(50),
                  padding: EdgeInsets.zero, // Elimina el padding interno
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4), // border-radius: 4px
                    side: BorderSide(
                      width: 2,
                      color: onPressed == null
                          ? _getBorderColor(type).withAlpha(50)
                          : _getBorderColor(type),
                    ),
                  ),
                ),
                child: Center(
                  child: child,
                ),
              ),
            ),
            // Overlay difuminado cuando está desactivado
            if (onPressed == null)
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white.withAlpha(150), 
                ),
              ),
          ],
        ),
        const SizedBox(height: 12), //  gap: 12px
      ],
    );
  }

  Color _getForegroundColor(int? type) {
    switch (type) {
      case 0:
        return Apptheme.primary; // Texto naranja en fondo blanco
      case 2:
        return Apptheme.primary; // Texto naranja en fondo blanco
      case 3:
        return Colors.white; // Texto blanco en fondo verde
      case 4:
        return Apptheme.secondary; // Texto verde en fondo blanco
      default:
        return Colors.white; // Texto blanco en fondo naranja (type 1)
    }
  }

  Color _getBackgroundColor(int? type) {
    switch (type) {
      case 0:
        return Colors.white; // Fondo blanco
      case 2:
        return Colors.white; // Fondo blanco
      case 3:
        return Apptheme.secondary; // Fondo verde
      case 4:
        return Colors.white; // Fondo blanco
      default:
        return Apptheme.primary; // Fondo naranja (type 1)
    }
  }

  Color _getBorderColor(int? type) {
    switch (type) {
      case 0:
        return Apptheme.darkorange; // Borde naranja oscuro
      case 2:
        return Apptheme.darkorange; // Borde naranja oscuro
      case 3:
        return Apptheme.textColorPrimary; // Borde verde oscuro
      case 4:
        return Apptheme.secondary; // Borde verde
      default:
        return Apptheme.darkorange; // Borde naranja oscuro (type 1)
    }
  }
}
