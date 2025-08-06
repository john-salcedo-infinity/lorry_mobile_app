import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_lorry/config/app_theme.dart';

class BackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;
  final double? iconWidth;
  final double? iconHeight;

  const BackButton({
    super.key,
    this.onPressed,
    this.text = 'Atrás',
    this.iconWidth = 25,
    this.iconHeight = 25,
  });

  void _handleBack(BuildContext context) {
    if (onPressed != null) {
      onPressed!();
    } else {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacementNamed(
          context,
          '/', // Use the root route instead
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleBack(context),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _handleBack(context),
            icon: Transform.rotate(
              angle: 3.14159,
              child: SvgPicture.asset(
                'assets/icons/Icono_cerrar_sesion.svg',
                width: iconWidth,
                height: iconHeight,
              ),
            ),
          ),
          Text(
            text!,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Apptheme.textColorPrimary,
                fontSize: 16),
          ),
        ],
      ),
    );
  }
}
