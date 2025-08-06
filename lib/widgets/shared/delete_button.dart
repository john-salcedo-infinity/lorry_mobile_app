import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DeleteButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double? width;
  final double? height;

  const DeleteButton({
    super.key,
    this.onPressed,
    this.width = 40,
    this.height = 40,
  });

  void _handleDelete() {
    if (onPressed != null) {
      onPressed!();
    } else {
      print('Acción de eliminar no definida');
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _handleDelete,
      icon: SvgPicture.asset(
        'assets/icons/Lorry_Icono_Eliminar.svg',
        width: width,
        height: height,
      ),
    );
  }
}
