import 'package:flutter/material.dart';

class CustomFABLocation extends FloatingActionButtonLocation {
  final double offsetX;
  final double offsetY;

  CustomFABLocation({required this.offsetX, required this.offsetY});

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX = scaffoldGeometry.scaffoldSize.width - offsetX;
    final double fabY = scaffoldGeometry.scaffoldSize.height - offsetY;
    return Offset(fabX, fabY);
  }
}
