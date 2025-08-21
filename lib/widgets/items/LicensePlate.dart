import 'package:app_lorry/config/app_theme.dart';
import 'package:flutter/material.dart';

class LicensePlate extends StatelessWidget {
  const LicensePlate({
    super.key,
    required this.licensePlate,
    this.textSelectable = false,
    this.fontSize = 14,
  });

  final String licensePlate;
  final int fontSize;
  final bool textSelectable;

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
          border: Border.all(color: Colors.white),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.36, vertical: 3.3),
          child: LicensePlateText(
            licensePlate: licensePlate,
            textSelectable: textSelectable,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}

class LicensePlateText extends StatelessWidget {
  const LicensePlateText({
    super.key,
    required this.licensePlate,
    this.textSelectable = false,
    this.fontSize = 14,
  });

  final String licensePlate;
  final bool textSelectable;
  final int fontSize;

  @override
  Widget build(BuildContext context) {
    if (textSelectable) {
      return SelectableText(
        licensePlate,
        style: Apptheme.h5TitleDecorative(
          context,
          color: Apptheme.backgroundColor,
        ).copyWith(
          fontSize: fontSize.toDouble(),
        ),
      );
    } else {
      return Text(
        licensePlate,
        style: Apptheme.h5TitleDecorative(
          context,
          color: Apptheme.backgroundColor,
        ).copyWith(
          fontSize: fontSize.toDouble(),
        ),
      );
    }
  }
}
