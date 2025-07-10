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
        Container(
          width: width, //  Ajusta el ancho
          height: height, // Ajusta la altura
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4), //  border-radius: 4px
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.0), //  Simula el borde inferior
                offset: const Offset(0, 2), // Grosor del borde inferior
                blurRadius: 0,
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              foregroundColor: type == 0 ? Apptheme.primary : Colors.white,
              backgroundColor: type == 0 ? Colors.white : Apptheme.primary,
              padding: EdgeInsets.zero, //  Elimina el padding interno
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4), //  border-radius: 4px
                side: BorderSide(
                  width: 2,
                  color: Apptheme.darkorange,
                ),
              ),
            ),
            child: Center(
              child: child,
            ),
          ),
        ),
        const SizedBox(height: 12), //  gap: 12px
      ],
    );
  }
}
