import 'package:app_lorry/models/ManualPlateRegisterResponse.dart';
import 'package:flutter/material.dart';

class TireDataTextField extends StatefulWidget {
  final String label;
  final MountingResult currentMounting;
  final TextEditingController? controller;
  final dynamic rawValue;
  final bool isEditable;
  final bool? isPressure;

  const TireDataTextField({
    super.key,
    required this.label,
    required this.currentMounting,
    this.controller,
    this.rawValue,
    this.isEditable = true,
    this.isPressure = false,
  });

  @override
  State<TireDataTextField> createState() => _TireDataTextFieldState();
}

class _TireDataTextFieldState extends State<TireDataTextField> {
  final FocusNode _focusNode = FocusNode();
  late TextEditingController _controller;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    
    // Usar el controller pasado o crear uno nuevo
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      final value = double.tryParse(widget.rawValue?.toString() ?? '') ?? 0;
      _controller = TextEditingController(text: value.toStringAsFixed(1));
    }
    
    _focusNode.addListener(() {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    // Solo dispose del controller si lo creamos nosotros
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double value = double.tryParse(_controller.text) ?? 0;

    final colors = _getColorsForValue(
        value, widget.isPressure ?? false, widget.currentMounting, _hasFocus);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF494D4C),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          focusNode: _focusNode,
          enabled: widget.isEditable,
          controller: _controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            filled: true,
            fillColor: colors['background'],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors['border']!, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors['border']!, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors['border']!, width: 3),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 16,
            ),
          ),
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Red Hat Mono',
            fontWeight: FontWeight.w600,
            height: 1.2,
            letterSpacing: 0.5,
            color: colors['text'],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Map<String, Color> _getColorsForValue(
      double value, bool isPressure, MountingResult currentMounting, bool hasFocus) {
    
    // Si el valor agregado en el campo es mayor que original (currentMounting) 
    // entonces el campo se coloque rojo y no deje pasar a la siguiente inspección
    final double? originalValue = _getOriginalValue(currentMounting, isPressure);
    if (originalValue != null && value > originalValue) {
      return {
        'text': const Color(0xFFD32F2F),
        'background': isPressure || hasFocus ? Colors.white : const Color(0xFFFFCDD2),
        'border': const Color(0xFFD32F2F),
      };
    }
    
    // 3.2 El color va a depender de profMinimum para campos que no son presión
    if (!isPressure) {
      final double? profMinimum = currentMounting.tire?.profMinimum;
      if (profMinimum != null) {
        // Si es menor o igual sale rojo
        if (value <= profMinimum) {
          return {
            'text': const Color(0xFFD32F2F),
            'background': hasFocus ? Colors.white : const Color(0xFFFFCDD2),
            'border': const Color(0xFFD32F2F),
          };
        }
        // Si está casi llegando a la mínima que sea amarilla (dentro del 20% por encima)
        else if (value <= profMinimum * 1.2) {
          return {
            'text': const Color(0xFFFBC02D),
            'background': hasFocus ? Colors.white : const Color(0xFFFFF9C4),
            'border': const Color(0xFFFBC02D),
          };
        }
        // Si está muy por encima va a ser verde
        else {
          return {
            'text': const Color(0xFF388E3C),
            'background': hasFocus ? Colors.white : const Color(0xFFC8E6C9),
            'border': const Color(0xFF388E3C),
          };
        }
      }
    }
    
    // Colores por defecto (especialmente para campos de presión)
    // 1. Si isPressure es true el fondo SIEMPRE va a ser blanco
    // 2. Cuando el foco lo tenga el input el fondo va a ser blanco
    return {
      'text': const Color(0xFF494D4C),
      'background': Colors.white,
      'border': const Color(0xFFE0E0E0),
    };
  }
  
  double? _getOriginalValue(MountingResult currentMounting, bool isPressure) {
    if (isPressure) {
      return currentMounting.tire?.pressure;
    } else {
      // Para profundidad, podemos usar profExternalCurrent, profCenterCurrent o profInternalCurrent
      // dependiendo del contexto. Por ahora, usaremos profExternalCurrent como referencia
      return currentMounting.tire?.profExternalCurrent;
    }
  }
}
