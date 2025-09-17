import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/config/app_theme.dart';

class CustomButtonWhite extends ConsumerWidget {
  final double width;
  final double height;
  final Widget child;
  final VoidCallback? onPressed;

  const CustomButtonWhite(
    this.width,
    this.height,
    this.child,
    this.onPressed, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Apptheme.white,
          elevation: 0, // Sin sombra
          padding: const EdgeInsets.all(4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: Apptheme.primary, // Borde anaranjado
              width: 3  , // Grosor del borde
            ),
          ),
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            color: Apptheme.primary, // Texto anaranjado
            fontWeight: FontWeight.w600,
          ),
          child: child,
        ),
      ),
    );
  }
}