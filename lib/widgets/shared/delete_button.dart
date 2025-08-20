import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DeleteButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isEnabled;
  final double? width;
  final double? height;

  const DeleteButton({
    super.key,
    this.onPressed,
    this.isEnabled = true,
    this.width = 40,
    this.height = 40,
  });

  void _handleDelete() {
    if (onPressed != null) {
      onPressed!();
    } else {
      // TODO: ACCIÓN DE ELIMINAR
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: !isEnabled 
          ? null  // Si isEnabled es false (loading), deshabilitar completamente
          : _handleDelete, // Si está habilitado, usar la lógica normal (custom o default)
      icon: SvgPicture.asset(
        'assets/icons/Lorry_Icono_Eliminar.svg',
        width: width,
        height: height,
      ),
    );
  }
}
