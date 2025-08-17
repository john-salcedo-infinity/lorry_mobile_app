import 'package:app_lorry/config/configs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TireDataTextField extends StatefulWidget {
  final String label;
  final num lastValue;
  final TextEditingController? controller;
  final dynamic rawValue;
  final bool isEditable;
  final bool? isPressure;
  final Function(String fieldName, double currentValue, double lastValue)?
      onValueChanged;

  const TireDataTextField({
    super.key,
    required this.label,
    required this.lastValue,
    this.controller,
    this.rawValue,
    this.isEditable = true,
    this.isPressure = false,
    this.onValueChanged,
  });

  @override
  State<TireDataTextField> createState() => _TireDataTextFieldState();
}

class _TireDataTextFieldState extends State<TireDataTextField> {
  final FocusNode _focusNode = FocusNode();
  late TextEditingController _controller;
  bool _hasFocus = false;
  double _currentValue = 0;

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      final value = double.tryParse(widget.rawValue?.toString() ?? '') ?? 0;
      // Si es presión, no mostrar decimales
      if (widget.isPressure == true) {
        _controller = TextEditingController(text: value.toInt().toString());
      } else {
        _controller = TextEditingController(text: value.toStringAsFixed(1));
      }
    }

    // Inicializar el valor actual
    _currentValue = double.tryParse(_controller.text) ?? 0;

    // Listener para cambios en el texto (tiempo real)
    _controller.addListener(_onTextChanged);

    // Listener para cambios de foco
    _focusNode.addListener(_onFocusChanged);
  }

  void _onTextChanged() {
    final newValue = double.tryParse(_controller.text) ?? 0;

    // Si es presión, validar que no exceda 200
    if (widget.isPressure == true && newValue > 200) {
      // Restaurar el valor anterior
      _controller.value = _controller.value.copyWith(
        text: _currentValue.toInt().toString(),
        selection: TextSelection.collapsed(
            offset: _currentValue.toInt().toString().length),
      );
      return;
    }

    if (_currentValue != newValue) {
      setState(() {
        _currentValue = newValue;
      });

      _focusNode.addListener(() {
        if (!_focusNode.hasFocus) {
          _checkAndTriggerAlerts();
        }
      });
    }
  }

  void _onFocusChanged() {
    final hasFocus = _focusNode.hasFocus;
    if (_hasFocus != hasFocus) {
      setState(() {
        _hasFocus = hasFocus;
      });
    }
  }

  void _checkAndTriggerAlerts() {
    final newValue = double.tryParse(widget.controller!.text) ?? 0;

    if (widget.onValueChanged != null) {
      widget.onValueChanged!(
        widget.label,
        newValue,
        widget.lastValue.toDouble(),
      );
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();

    // Solo dispose del controller si lo creamos nosotros
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getColorsForValue(
      _currentValue,
      widget.isPressure ?? false,
      widget.lastValue.toDouble(),
      _hasFocus,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.label,
          style: Apptheme.h5Body(context, color: Apptheme.textColorSecondary),
        ),
        const SizedBox(height: 2),
        TweenAnimationBuilder<Color?>(
          duration: const Duration(milliseconds: 200),
          tween: ColorTween(
            begin: colors['background'],
            end: colors['background'],
          ),
          builder: (context, animatedBackgroundColor, child) {
            return TweenAnimationBuilder<Color?>(
              duration: const Duration(milliseconds: 200),
              tween: ColorTween(
                begin: colors['border'],
                end: colors['border'],
              ),
              builder: (context, animatedBorderColor, child) {
                return TextField(
                  focusNode: _focusNode,
                  enabled: widget.isEditable,
                  controller: _controller,
                  keyboardType: widget.isPressure == true
                      ? TextInputType.number
                      : const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: widget.isPressure == true
                      ? [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(
                              3), // Máximo 3 dígitos (200)
                        ]
                      : [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,1}$')),
                        ],
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: animatedBackgroundColor ?? colors['background'],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: animatedBorderColor ?? colors['border']!,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: animatedBorderColor ?? colors['border']!,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: animatedBorderColor ?? colors['border']!,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 16,
                    ),
                  ),
                  style: Apptheme.h4TitleDecorative(
                    context,
                    color: colors['text']!,
                  ),
                  textAlign: TextAlign.center,
                );
              },
            );
          },
        ),
      ],
    );
  }

  Map<String, Color> _getColorsForValue(
      double value, bool isPressure, double lastValue, bool hasFocus) {
    // Si el valor es mayor que el último valor registrado

    if (isPressure && value < 30) {
      return {
        'text': Apptheme.alertOrange,
        'background': Apptheme.highAlertBackground,
        'border': Apptheme.alertOrange,
      };
    }
    if (!isPressure && value > lastValue) {
      return {
        'text': Apptheme.alertOrange,
        'background': isPressure ? Colors.white : Apptheme.highAlertBackground,
        'border': Apptheme.alertOrange,
      };
    }

    // Si el valor se redujo 2 unidades o mas cons respecto al último valor y el valor NO es menor o igual a 3
    if (!isPressure && value < lastValue - 2 && value > 3) {
      return {
        'text': Apptheme.alarmYellow,
        'background':
            isPressure ? Colors.white : Apptheme.mediumAlertBackground,
        'border': Apptheme.alarmYellow,
      };
    }

    // Si el valor es menor o igual a 3
    if (!isPressure && value <= 3) {
      return {
        'text': Apptheme.alertOrange,
        'background': isPressure ? Colors.white : Apptheme.highAlertBackground,
        'border': Apptheme.alertOrange,
      };
    }

    Color borderColor =
        hasFocus ? Apptheme.textColorPrimary : const Color(0xFFE0E0E0);

    return {
      'text': Apptheme.textColorPrimary,
      'background': Colors.white,
      'border': borderColor,
    };
  }
}
