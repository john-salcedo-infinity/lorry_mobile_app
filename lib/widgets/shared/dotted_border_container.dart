import 'package:flutter/material.dart';

/// Painter personalizado para crear bordes punteados con control completo de colores
class DottedBorderPainter extends CustomPainter {
  final Color dotColor;
  final Color backgroundColor;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final BorderRadius borderRadius;

  DottedBorderPainter({
    required this.dotColor,
    required this.backgroundColor,
    required this.strokeWidth,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Para mantener consistencia con Border.all() de Flutter,
    // usamos todo el espacio disponible
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, borderRadius.topLeft);

    // 1. Pintar el fondo completo primero
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, backgroundPaint);

    // 2. Crear path para el borde - ajustado para el strokeWidth
    final strokeOffset = strokeWidth / 2;
    final borderRect = Rect.fromLTWH(
      strokeOffset,
      strokeOffset,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final borderRRect = RRect.fromRectAndRadius(borderRect, borderRadius.topLeft);
    final path = Path()..addRRect(borderRRect);
    final pathMetric = path.computeMetrics().first;

    // 3. Pintar solo los puntos (dashes) del borde
    final dotPaint = Paint()
      ..color = dotColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    double distance = 0;
    while (distance < pathMetric.length) {
      final endDistance = (distance + dashWidth).clamp(0.0, pathMetric.length);
      if (endDistance > distance) {
        final extractPath = pathMetric.extractPath(distance, endDistance);
        canvas.drawPath(extractPath, dotPaint);
      }
      distance += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! DottedBorderPainter ||
        oldDelegate.dotColor != dotColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace;
  }
}

/// Widget reutilizable para crear contenedores con bordes punteados personalizados
/// 
/// Permite controlar:
/// - Color de los puntos del borde
/// - Color de fondo y espacios entre puntos
/// - Grosor del borde
/// - Tamaño de puntos y espacios
/// - Radius de las esquinas
class DottedBorderContainer extends StatelessWidget {
  /// El widget hijo que se mostrará dentro del contenedor
  final Widget child;
  
  /// Color de los puntos del borde
  final Color dotColor;
  
  /// Color de fondo del contenedor y espacios entre puntos
  final Color backgroundColor;
  
  /// Grosor del borde
  final double strokeWidth;
  
  /// Ancho de cada punto/dash
  final double dashWidth;
  
  /// Espacio entre puntos
  final double dashSpace;
  
  /// Ancho del contenedor (opcional)
  final double? width;
  
  /// Alto del contenedor (opcional)
  final double? height;
  
  /// Radio de las esquinas
  final BorderRadius borderRadius;
  
  /// Padding interno del contenedor
  final EdgeInsetsGeometry? padding;
  
  /// Margin externo del contenedor
  final EdgeInsetsGeometry? margin;

  const DottedBorderContainer({
    Key? key,
    required this.child,
    required this.dotColor,
    required this.backgroundColor,
    this.strokeWidth = 2.0,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.padding,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Si hay margin, usamos un Container externo para manejarlo
    Widget paintWidget = SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: DottedBorderPainter(
          dotColor: dotColor,
          backgroundColor: backgroundColor,
          strokeWidth: strokeWidth,
          dashWidth: dashWidth,
          dashSpace: dashSpace,
          borderRadius: borderRadius,
        ),
        child: padding != null 
          ? Padding(
              padding: padding!,
              child: child,
            )
          : child,
      ),
    );

    // Si hay margin, envolver en un Container con margin
    if (margin != null) {
      return Container(
        margin: margin,
        child: paintWidget,
      );
    }
    
    return paintWidget;
  }
}

/// Widget helper para casos comunes de uso
class DottedBorderCard extends StatelessWidget {
  final Widget child;
  final Color dotColor;
  final Color backgroundColor;
  final double strokeWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const DottedBorderCard({
    Key? key,
    required this.child,
    required this.dotColor,
    required this.backgroundColor,
    this.strokeWidth = 2.0,
    this.padding = const EdgeInsets.all(8.0),
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DottedBorderContainer(
      dotColor: dotColor,
      backgroundColor: backgroundColor,
      strokeWidth: strokeWidth,
      padding: padding,
      margin: margin,
      child: child,
    );
  }
}
