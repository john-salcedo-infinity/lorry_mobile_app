import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_lorry/config/app_theme.dart';

class BackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isEnabled;
  final String? text;
  final double? iconWidth;
  final double? iconHeight;

  const BackButton({
    super.key,
    this.onPressed,
    this.isEnabled = true,
    this.text = 'Atrás',
    this.iconWidth = 20,
    this.iconHeight = 20,
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
      onTap: !isEnabled ? null : () => _handleBack(context),
      child: Row(
        children: [
          IconButton(
            onPressed: !isEnabled
                ? null // Si isEnabled es false (loading), deshabilitar completamente
                : () => _handleBack(
                    context), // Si está habilitado, usar la lógica normal (custom o default)
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
            style: Apptheme.h5HighlightBody(context,
                color: !isEnabled
                    ? Apptheme.textColorPrimary.withValues(alpha: 0.5)
                    : Apptheme.textColorPrimary),
          ),
        ],
      ),
    );
  }
}
