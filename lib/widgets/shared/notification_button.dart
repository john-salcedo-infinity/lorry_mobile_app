import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double? width;
  final double? height;

  const NotificationButton({
    super.key,
    this.onPressed,
    this.width = 40,
    this.height = 40,
  });

  void _handleNotifications(BuildContext context) {
    if (onPressed != null) {
      onPressed!();
    } else {
      // TODO: Implementar navegación por defecto a notificaciones
      // context.go('/notifications');
      print('Navegando a notificaciones...');
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _handleNotifications(context),
      icon: SvgPicture.asset(
        'assets/icons/Lorry_Icono_Notificación_Vacía.svg',
        width: width,
        height: height,
      ),
    );
  }
}
