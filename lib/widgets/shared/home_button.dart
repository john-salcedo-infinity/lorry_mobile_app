import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HomeButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isEnabled;
  final double? width;
  final double? height;

  const HomeButton({
    super.key,
    this.onPressed,
    this.isEnabled = true,
    this.width = 40,
    this.height = 40,
  });

  void _handleHome(BuildContext context) {
    if (onPressed != null) {
      onPressed!();
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: !isEnabled 
          ? null  // Si isEnabled es false (loading), deshabilitar completamente
          : () => _handleHome(context), // Si está habilitado, usar la lógica normal (custom o default)
      icon: SvgPicture.asset(
        'assets/icons/Icono_Casa_Lorry.svg',
        width: width,
        height: height,
      ),
    );
  }
}
