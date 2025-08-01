import 'package:app_lorry/config/configs.dart';
import 'package:flutter/material.dart';

class TireDataTextField extends StatefulWidget {
  final String label;
  final double lastValue;
  final TextEditingController? controller;
  final dynamic rawValue;
  final bool isEditable;
  final bool? isPressure;

  const TireDataTextField({
    super.key,
    required this.label,
    required this.lastValue,
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
        value, widget.isPressure ?? false, widget.lastValue, _hasFocus);

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
              borderSide: BorderSide(color: Apptheme.grayInput),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 16,
            ),
          ),
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w800,
            height: 1.2,
            letterSpacing: 0.5,
            color: Apptheme.textColorPrimary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Map<String, Color> _getColorsForValue(
      double value, bool isPressure, double lastValue, bool hasFocus) {
    if (value > lastValue) {
      return {
        'text': const Color(0xFFD32F2F),
        'background':
            isPressure || hasFocus ? Colors.white : const Color(0xFFFFCDD2),
        'border': const Color(0xFFD32F2F),
      };
    }

    // 3.2 El color va a depender de profMinimum para campos que no son presión

    // Colores por defecto (especialmente para campos de presión)
    // 1. Si isPressure es true el fondo SIEMPRE va a ser blanco
    // 2. Cuando el foco lo tenga el input el fondo va a ser blanco
    return {
      'text': const Color(0xFF494D4C),
      'background': Colors.white,
      'border': const Color(0xFFE0E0E0),
    };
  }
}
