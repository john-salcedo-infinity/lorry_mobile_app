import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HomeButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double? width;
  final double? height;

  const HomeButton({
    super.key,
    this.onPressed,
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
      onPressed: () => _handleHome(context),
      icon: SvgPicture.asset(
        'assets/icons/Icono_Casa_Lorry.svg',
        width: width,
        height: height,
      ),
    );
  }
}
