import 'package:flutter/material.dart';

class ResponsiveText {
  static double fontSize(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) return baseSize * 0.85; 
    if (width > 600) return baseSize * 1.2;
    return baseSize;
  }
}
