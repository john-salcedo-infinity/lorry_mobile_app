import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/config/configs.dart';
import 'package:app_lorry/widgets/forms/customInput.dart';

class DepthInputFields extends ConsumerStatefulWidget {
  final Function(String extrema, String centro, String interna)? onAllFieldsFilled;
  final bool shouldFillNext;
  final String? newDepthValue;

  const DepthInputFields({
    super.key,
    this.onAllFieldsFilled,
    this.shouldFillNext = false,
    this.newDepthValue,
  });

  @override
  ConsumerState<DepthInputFields> createState() => _DepthInputFieldsState();
}

class _DepthInputFieldsState extends ConsumerState<DepthInputFields> {
  final TextEditingController _profExtrController = TextEditingController();
  final TextEditingController _profCentController = TextEditingController();
  final TextEditingController _profIntController = TextEditingController();

  final FocusNode _profExtrFocus = FocusNode();
  final FocusNode _profCentFocus = FocusNode();
  final FocusNode _profIntFocus = FocusNode();

  int _currentFieldIndex = 0; // 0: extrema, 1: centro, 2: interna

  @override
  void initState() {
    super.initState();
    // Inicialmente el foco está en el primer campo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _profExtrFocus.requestFocus();
    });
  }

  @override
  void didUpdateWidget(DepthInputFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Si se debe llenar el siguiente campo con un nuevo valor
    if (widget.shouldFillNext && 
        widget.newDepthValue != null && 
        widget.newDepthValue!.isNotEmpty &&
        widget.newDepthValue != oldWidget.newDepthValue) {
      _fillCurrentField(widget.newDepthValue!);
    }
  }

  @override
  void dispose() {
    _profExtrController.dispose();
    _profCentController.dispose();
    _profIntController.dispose();
    _profExtrFocus.dispose();
    _profCentFocus.dispose();
    _profIntFocus.dispose();
    super.dispose();
  }

  void _fillCurrentField(String value) {
    switch (_currentFieldIndex) {
      case 0:
        _profExtrController.text = value;
        _currentFieldIndex = 1;
        _profCentFocus.requestFocus();
        break;
      case 1:
        _profCentController.text = value;
        _currentFieldIndex = 2;
        _profIntFocus.requestFocus();
        break;
      case 2:
        _profIntController.text = value;
        _currentFieldIndex = 0;
        _profExtrFocus.requestFocus();
        
        // Llamar callback cuando todos los campos estén llenos
        if (widget.onAllFieldsFilled != null) {
          widget.onAllFieldsFilled!(
            _profExtrController.text,
            _profCentController.text,
            _profIntController.text,
          );
        }
        break;
    }
  }

  void _resetFields() {
    _profExtrController.clear();
    _profCentController.clear();
    _profIntController.clear();
    _currentFieldIndex = 0;
    _profExtrFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Medición de Profundidades',
                style: Apptheme.h2Title(context, color: Apptheme.textColorPrimary),
              ),
              IconButton(
                onPressed: _resetFields,
                icon: Icon(
                  Icons.refresh,
                  color: Apptheme.primary,
                ),
                tooltip: 'Limpiar campos',
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Campo Profundidad Extrema
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _currentFieldIndex == 0 ? Apptheme.primary : Apptheme.grayInput,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '1',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomInputField(
                  label: 'Prof. Extrema',
                  hint: 'Ingrese profundidad extrema',
                  controller: _profExtrController,
                  keyboardType: TextInputType.number,
                  height: 48,
                  focusNode: _profExtrFocus,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Campo Profundidad Centro
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _currentFieldIndex == 1 ? Apptheme.primary : Apptheme.grayInput,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomInputField(
                  label: 'Prof. Centro',
                  hint: 'Ingrese profundidad centro',
                  controller: _profCentController,
                  keyboardType: TextInputType.number,
                  height: 48,
                  focusNode: _profCentFocus,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Campo Profundidad Interna
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _currentFieldIndex == 2 ? Apptheme.primary : Apptheme.grayInput,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomInputField(
                  label: 'Prof. Interna',
                  hint: 'Ingrese profundidad interna',
                  controller: _profIntController,
                  keyboardType: TextInputType.number,
                  height: 48,
                  focusNode: _profIntFocus,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Indicador de progreso
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Apptheme.primary.withAlpha(10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Apptheme.primary,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getStatusMessage(),
                    style: Apptheme.h5Body(context, color: Apptheme.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusMessage() {
    switch (_currentFieldIndex) {
      case 0:
        return 'Esperando medición de profundidad extrema...';
      case 1:
        return 'Esperando medición de profundidad centro...';
      case 2:
        return 'Esperando medición de profundidad interna...';
      default:
        return 'Listo para nueva medición';
    }
  }
}
