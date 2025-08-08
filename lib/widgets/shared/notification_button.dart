import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isEnabled;
  final double? width;
  final double? height;

  const NotificationButton({
    super.key,
    this.onPressed,
    this.isEnabled = true,
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
      onPressed: !isEnabled 
          ? null  // Si isEnabled es false (loading), deshabilitar completamente
          : () => _handleNotifications(context), // Si está habilitado, usar la lógica normal (custom o default)
      icon: SvgPicture.asset(
        'assets/icons/Lorry_Icono_Notificación_Vacía.svg',
        width: width,
        height: height,
      ),
    );
  }
}
