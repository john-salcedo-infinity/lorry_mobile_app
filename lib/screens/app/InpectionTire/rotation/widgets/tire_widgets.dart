import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/widgets/widgets.dart';
import 'package:flutter/material.dart';
import '../spinAndRotationScreen.dart';

/// Clase para definir las propiedades de estilo de una llanta
class _TireStyleProperties {
  final Color borderColor;
  final double borderWidth;
  final Color backgroundColor;
  final BorderStyle borderStyle;
  final bool isDotted;
  final Color? spaceColor; // Color de los espacios en bordes punteados

  _TireStyleProperties({
    required this.borderColor,
    required this.borderWidth,
    required this.backgroundColor,
    required this.borderStyle,
    this.isDotted = false,
    this.spaceColor,
  });
}

/// Widget para mostrar una llanta individual
class TireWidget extends StatelessWidget {
  final TirePosition tire;
  final double width;
  final double height;
  final bool isEmpty;
  final Function(TirePosition)? onTireSelect;
  final int sectionType;

  const TireWidget({
    super.key,
    required this.tire,
    required this.width,
    required this.height,
    this.isEmpty = false,
    this.onTireSelect,
    required this.sectionType,
  });

  /// Define las propiedades de estilo basado en sectionType y estado
  _TireStyleProperties _getTireStyleProperties() {
    if (sectionType == 1) {
      // Configuración Actual
      if (tire.isSelected) {
        // Seleccionada: borde naranja ancho, fondo naranja claro
        return _TireStyleProperties(
          borderColor: Apptheme.primary,
          borderWidth: 3.0,
          backgroundColor: Apptheme.lightOrange,
          borderStyle: BorderStyle.solid,
          isDotted: false,
        );
      } else if (!tire.hasTire) {
        // Vacía: borde punteado verde, fondo verde claro
        return _TireStyleProperties(
          borderColor: Apptheme.textColorPrimary,
          borderWidth: 2.0,
          backgroundColor: Apptheme.lightGreen,
          borderStyle: BorderStyle.solid,
          isDotted: true,
          spaceColor: Apptheme.lightGreen, // Color de los espacios
        );
      } else {
        // Por defecto con llanta: borde verde, fondo transparente
        return _TireStyleProperties(
          borderColor: Apptheme.textColorPrimary,
          borderWidth: 2.0,
          backgroundColor: Colors.transparent,
          borderStyle: BorderStyle.solid,
          isDotted: false,
        );
      }
    } else {
      // Nueva Configuración (sectionType == 2)
      if (!tire.hasTire) {
        // Vacía: borde naranja punteado, fondo naranja claro
        return _TireStyleProperties(
          borderColor: Apptheme.primary,
          borderWidth: 2.0,
          backgroundColor: Apptheme.lightOrange,
          borderStyle: BorderStyle.solid,
          isDotted: true,
          spaceColor: Apptheme.lightOrange, // Color de los espacios
        );
      } else {
        // Con llanta: borde naranja, fondo transparente
        return _TireStyleProperties(
          borderColor: Apptheme.primary,
          borderWidth: 2.0,
          backgroundColor: Colors.transparent,
          borderStyle: BorderStyle.solid,
          isDotted: false,
        );
      }
    }
  }

  /// Define el contenido del widget basado en sectionType y estado
  Widget _getTireContent(BuildContext context) {
    if (sectionType == 1) {
      // Configuración Actual
      if (isEmpty) {
        return Text(
          'P${tire.destinationPosition ?? tire.position}',
          style: Apptheme.h5TitleDecorative(context,
              color: Apptheme.textColorPrimary),
        );
      } else if (tire.hasTire) {
        // Tiene llanta: mostrar imagen de llanta
        return Image.asset(
          'assets/icons/tire.png',
          width: width,
          height: height * 0.875,
        );
      } else if (tire.destinationPosition != null) {
        // Posición vacía con destinationPosition: mostrar la posición de destino
        return Text(
          'P${tire.destinationPosition}',
          style: Apptheme.h5TitleDecorative(
            context,
            color: Apptheme.textColorPrimary,
          ),
        );
      } else {
        // Posición vacía: mostrar solo la posición actual
        return Text(
          'P${tire.position}',
          style: Apptheme.h5TitleDecorative(
            context,
            color: Apptheme.textColorPrimary,
          ),
        );
      }
    } else {
      // Nueva Configuración (sectionType == 2)
      if (isEmpty) {
        return Text(
          'P${tire.position}',
          style: Apptheme.h5TitleDecorative(
            context,
            color: Apptheme.primary,
          ),
        );
      } else if (!tire.hasTire) {
        // Posición vacía: mostrar posición
        return Text(
          'P${tire.position}',
          style: Apptheme.h5TitleDecorative(
            context,
            color: Apptheme.primary,
          ),
        );
      } else if (!tire.hasTire) {
        // Posición vacía: mostrar posición
        return Text(
          'P${tire.position}',
          style: Apptheme.h5TitleDecorative(
            context,
            color: Apptheme.primary,
          ),
        );
      } else {
        // Tiene llanta: mostrar imagen de llanta
        return Image.asset(
          'assets/icons/tire.png',
          width: width,
          height: height * 0.875,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final styleProperties = _getTireStyleProperties();

    Widget tireContainer;

    if (styleProperties.isDotted) {
      // Para bordes punteados, usar el componente reutilizable
      tireContainer = DottedBorderContainer(
        dotColor: styleProperties.borderColor,
        backgroundColor:
            styleProperties.spaceColor ?? styleProperties.backgroundColor,
        strokeWidth: styleProperties.borderWidth,
        width: width, // Usar las mismas dimensiones que el sólido
        height: height,
        margin: const EdgeInsets.all(4), // Mismo margin que el sólido
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _getTireContent(context),
          ],
        ),
      );
    } else {
      // Para bordes sólidos, usar el contenedor normal
      tireContainer = Container(
        width: width,
        height: height,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: styleProperties.borderColor,
            width: styleProperties.borderWidth,
            style: styleProperties.borderStyle,
          ),
          color: styleProperties.backgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _getTireContent(context),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () => onTireSelect?.call(tire),
      child: Tooltip(
        verticalOffset: 50,
        message: tire.hasTire && tire.serialNumber != null
            ? 'LL-${tire.serialNumber!}'
            : '',
        decoration: BoxDecoration(
          color: Apptheme.lightOrange,
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: const TextStyle(
          color: Apptheme.textColorSecondary,
          fontSize: 14,
        ),
        child: tireContainer,
      ),
    );
  }
}

/// Widget para mostrar una llanta de repuesto
class SpareWidget extends StatelessWidget {
  final TirePosition tire;
  final double width;
  final double height;
  final bool isEmpty;
  final Function(TirePosition)? onTireSelect;
  final int sectionType;

  const SpareWidget({
    super.key,
    required this.tire,
    required this.width,
    required this.height,
    this.isEmpty = false,
    this.onTireSelect,
    required this.sectionType,
  });

  /// Define las propiedades de estilo basado en sectionType y estado para SpareWidget
  _TireStyleProperties _getSpareStyleProperties() {
    if (sectionType == 1) {
      // Configuración Actual
      if (tire.isSelected) {
        // Seleccionada: borde naranja ancho, fondo naranja claro
        return _TireStyleProperties(
          borderColor: Apptheme.primary,
          borderWidth: 3.0,
          backgroundColor: Apptheme.lightOrange,
          borderStyle: BorderStyle.solid,
          isDotted: false,
        );
      } else if (!tire.hasTire) {
        // Vacía: borde punteado verde, fondo verde claro
        return _TireStyleProperties(
          borderColor: Apptheme.textColorPrimary,
          borderWidth: 2.0,
          backgroundColor: Apptheme.lightGreen,
          borderStyle: BorderStyle.solid,
          isDotted: true,
          spaceColor: Apptheme.lightGreen,
        );
      } else {
        // Por defecto con llanta: borde verde, fondo transparente
        return _TireStyleProperties(
          borderColor: Apptheme.textColorPrimary,
          borderWidth: 2.0,
          backgroundColor: Colors.transparent,
          borderStyle: BorderStyle.solid,
          isDotted: false,
        );
      }
    } else {
      // Nueva Configuración (sectionType == 2)
      if (!tire.hasTire) {
        // Vacía: borde naranja punteado, fondo naranja claro
        return _TireStyleProperties(
          borderColor: Apptheme.primary,
          borderWidth: 2.0,
          backgroundColor: Apptheme.lightOrange,
          borderStyle: BorderStyle.solid,
          isDotted: true,
          spaceColor: Apptheme.lightOrange,
        );
      } else {
        // Con llanta: borde naranja, fondo transparente
        return _TireStyleProperties(
          borderColor: Apptheme.primary,
          borderWidth: 2.0,
          backgroundColor: Colors.transparent,
          borderStyle: BorderStyle.solid,
          isDotted: false,
        );
      }
    }
  }

  /// Define el contenido del widget basado en sectionType y estado para SpareWidget
  Widget _getSpareContent(BuildContext context) {
    if (sectionType == 1) {
      // Configuración Actual
      if (isEmpty) {
        return Text(
          'P${tire.destinationPosition ?? tire.position}',
          style: TextStyle(
            color: Apptheme.secondary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        );
      } else if (tire.hasTire) {
        // Tiene llanta: mostrar imagen de llanta
        return Transform.rotate(
          angle: 1.5708,
          child: Image.asset(
            'assets/icons/tire.png',
            width: width * 1.125,
            height: height * 1.25,
          ),
        );
      } else if (tire.destinationPosition != null) {
        // Posición vacía con destinationPosition: mostrar la posición de destino
        return Text(
          'P${tire.destinationPosition}',
          style: Apptheme.h5TitleDecorative(
            context,
            color: Apptheme.textColorPrimary,
          ),
        );
      } else {
        // Posición vacía sin destino
        return Transform.rotate(
          angle: 1.5708,
          child: Image.asset(
            'assets/icons/tire.png',
            width: height * 0.5,
            height: height * 0.75,
            color: Colors.grey[400],
            fit: BoxFit.contain,
          ),
        );
      }
    } else {
      // Nueva Configuración (sectionType == 2)
      if (isEmpty) {
        return Text(
          'P${tire.position}',
          style: TextStyle(
            color: Apptheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        );
      } else if (!tire.hasTire) {
        // Posición vacía: mostrar posición
        return Text(
          'P${tire.position}',
          style: TextStyle(
            color: Apptheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        );
      } else {
        // Tiene llanta: mostrar imagen de llanta
        return Transform.rotate(
          angle: 1.5708,
          child: Image.asset(
            'assets/icons/tire.png',
            width: width * 1.125,
            height: height * 1.25,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final styleProperties = _getSpareStyleProperties();

    Widget spareContainer;

    if (styleProperties.isDotted) {
      // Para bordes punteados, usar el componente reutilizable
      spareContainer = DottedBorderContainer(
        dotColor: styleProperties.borderColor,
        backgroundColor:
            styleProperties.spaceColor ?? styleProperties.backgroundColor,
        strokeWidth: styleProperties.borderWidth,
        width: width,
        height: height,
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: _getSpareContent(context),
              ),
            ),
          ],
        ),
      );
    } else {
      // Para bordes sólidos, usar el contenedor normal
      spareContainer = Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: styleProperties.borderColor,
            width: styleProperties.borderWidth,
            style: styleProperties.borderStyle,
          ),
          color: styleProperties.backgroundColor,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: _getSpareContent(context),
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () => onTireSelect?.call(tire),
      child: Tooltip(
        verticalOffset: 30,
        message: tire.hasTire && tire.serialNumber != null
            ? 'LL-${tire.serialNumber!}'
            : '',
        decoration: BoxDecoration(
          color: Apptheme.lightOrange,
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: const TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
        child: spareContainer,
      ),
    );
  }
}
