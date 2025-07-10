import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/config/app_theme.dart';

class CustomButtonSecondary extends ConsumerWidget {
  final double width;
  final double height;
  final Widget child;
  final VoidCallback? onPressed;

  const CustomButtonSecondary(
    this.width,
    this.height,
    this.child,
    this.onPressed, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4), //  border-radius: 4px
            boxShadow: const [
              BoxShadow(
                color: Colors.transparent, // ❌ Elimina el borde gris
                offset: Offset(0, 0), // Sin desplazamiento
                blurRadius: 0, // Sin difuminado
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, // Fondo blanco
              elevation: 0, // Sin sombra adicional
              padding: const EdgeInsets.all(4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              side: const BorderSide(
                color: Colors.transparent, // Elimina el borde de color
                width: 0,
              ),
              overlayColor: Colors.transparent, // Elimina el efecto hover
            ),
            child: DefaultTextStyle(
              style: TextStyle(
                color: Apptheme.primary, // Texto anaranjado
                fontWeight: FontWeight.w600,
              ),
              child: child,
            ),
          ),
        ),
        const SizedBox(height: 10), //  Simula gap: 10px
      ],
    );
  }
}
