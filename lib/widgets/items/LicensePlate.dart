import 'package:app_lorry/config/app_theme.dart';
import 'package:flutter/material.dart';

class LicensePlate extends StatelessWidget {
  const LicensePlate({
    super.key,
    required this.licensePlate,
    this.fontSize = 14,
  });

  final String licensePlate;
  final int fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Apptheme.secondaryv2,
      ),
      padding: const EdgeInsets.all(3.4),
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: Colors.white)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.36, vertical: 3.3),
          child: Text(
            licensePlate,
            style: Apptheme.h5TitleDecorative(
              context,
              color: Apptheme.backgroundColor,
            ).copyWith(
              fontSize: fontSize.toDouble(),
            ),
          ),
        ),
      ),
    );
  }
}
