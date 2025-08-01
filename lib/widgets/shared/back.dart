import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app_lorry/config/app_theme.dart';

class Back extends StatelessWidget {
  const Back({
    super.key,
  });

  void _handleBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushNamed(
        context,
        '/home', // or your home route name
      );
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
                width: 25,
                height: 25,
              ),
            ),
          ),
          const Text(
            'Atrás',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Apptheme.textColorPrimary,
                fontSize: 16),
          ),
        ],
      ),
    );
  }
}
