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
  final FocusNode? focusNode; // Agregar focusNode opcional
  // Evitar que el teclado aparezca automáticamente; sólo al tocar manualmente
  final bool suppressKeyboardUntilTap;
  // Foco del siguiente campo cuando se presiona Enter/Next
  final FocusNode? nextFocusNode;

  const TireDataTextField({
    super.key,
    required this.label,
    required this.lastValue,
    this.controller,
    this.rawValue,
    this.isEditable = true,
    this.isPressure = false,
    this.onValueChanged,
    this.focusNode, // Agregar al constructor
    this.suppressKeyboardUntilTap = true,
  this.nextFocusNode,
  });

  @override
  State<TireDataTextField> createState() => _TireDataTextFieldState();
}

class _TireDataTextFieldState extends State<TireDataTextField> {
  // Desbloquea el teclado en el próximo foco si se avanzó con Enter
  static bool _unlockForNextFocus = false;
  final FocusNode _internalFocusNode = FocusNode();
  late FocusNode _focusNode;
  late TextEditingController _controller;
  bool _hasFocus = false;
  double _currentValue = 0;
  bool _suppressKeyboard = true;

  @override
  void initState() {
    super.initState();

    // Usar el focusNode externo si está disponible, sino usar el interno
    _focusNode = widget.focusNode ?? _internalFocusNode;

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

    // Inicializar supresión de teclado según prop
    _suppressKeyboard = widget.suppressKeyboardUntilTap;
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
      _currentValue = newValue;
      if (mounted) setState(() {});
      
      // Disparar alertas inmediatamente al cambiar el valor
      if (widget.controller != null) {
        _checkAndTriggerAlerts();
      }
    }
  }

  void _onFocusChanged() {
    final hasFocus = _focusNode.hasFocus;
    if (_hasFocus != hasFocus) {
      setState(() {
        _hasFocus = hasFocus;
      });
    }
    Future.microtask(() {
      if (_hasFocus) {
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        );
      }
    });

    // Si ganamos foco por avance con Enter, no suprimir teclado
    if (hasFocus && widget.suppressKeyboardUntilTap && _suppressKeyboard) {
      if (_unlockForNextFocus) {
        setState(() {
          _suppressKeyboard = false;
          _unlockForNextFocus = false;
        });
      }
    }

    // Si perdemos foco, volver a suprimir teclado para próximos montajes
    if (!hasFocus && widget.suppressKeyboardUntilTap) {
      _suppressKeyboard = true;
    }
  }

  void _checkAndTriggerAlerts() {
    // Usar el valor actual ya parseado en lugar de volver a parsear
    final newValue = _currentValue;

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

    // Solo dispose del focusNode si lo creamos nosotros
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }

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
        TextField(
          focusNode: _focusNode,
          onSubmitted: (value) {
            // Avanzar al siguiente sin cerrar el teclado
            if (widget.nextFocusNode != null) {
              _unlockForNextFocus = true;
              FocusScope.of(context).requestFocus(widget.nextFocusNode);
            } else {
              // Mantener el foco actual para no cerrar el teclado
              _focusNode.requestFocus();
            }
          },
          onTap: () {
            if (widget.suppressKeyboardUntilTap && _suppressKeyboard) {
              setState(() => _suppressKeyboard = false);
            }
          },
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
            _checkAndTriggerAlerts();
          },
          enabled: widget.isEditable,
          controller: _controller,
          showCursor: !_suppressKeyboard,
          readOnly: widget.suppressKeyboardUntilTap && _suppressKeyboard,
          keyboardType: widget.isPressure == true
              ? TextInputType.number
              : const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: widget.isPressure == true
              ? [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3), // Máximo 3 dígitos (200)
                ]
              : [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,1}$')),
                ],
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            filled: true,
            isDense: true,
            fillColor: colors['background'],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colors['border']!,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colors['border']!,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colors['border']!,
                width: 2,
              ),
            ),
          ),
          style: Apptheme.h4TitleDecorative(
            context,
            color: colors['text']!,
          ),
          textAlign: TextAlign.center,
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
