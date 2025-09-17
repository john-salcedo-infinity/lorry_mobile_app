import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/config/app_theme.dart';

class CustomButtonBorderOrange extends ConsumerWidget {
  final double width;
  final double height;
  final Widget child;
  final VoidCallback? onPressed;

  const CustomButtonBorderOrange(
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
          foregroundColor: Apptheme.primary,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: const BorderSide(color: Apptheme.primary, width: 2),
          ),
          elevation: 0,
          shadowColor: Colors.transparent, 
        ),
        child: Center(child: child),
      ),
    );
  }
}
