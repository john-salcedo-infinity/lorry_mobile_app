// ignore_for_file: deprecated_member_use

import 'package:app_lorry/config/configs.dart';
import 'package:app_lorry/models/Service_data.dart';
import 'package:app_lorry/widgets/buttons/CustomButton.dart';
import 'package:app_lorry/widgets/shared/select_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

class ServiceDialog extends StatefulWidget {
  final ServiceData service;
  final String? tireCode;

  const ServiceDialog({
    super.key,
    required this.service,
    this.tireCode,
  });

  @override
  State<ServiceDialog> createState() => _ServiceDialogState();
}

class _ServiceDialogState extends State<ServiceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _costController = TextEditingController();
  ProviderSelection? _selectedProvider;
  String? _costError;
  String? _providerError;
  bool _isProcessing = false;

  // Cache del formateador para evitar recrearlo
  late final _CurrencyInputFormatter _currencyFormatter;

  @override
  void initState() {
    super.initState();
    _costController.text = '';
    _currencyFormatter = _CurrencyInputFormatter();
  }

  @override
  void dispose() {
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Reemplazar BackdropFilter por Dialog simple
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          // Sombra estática en lugar de BackdropFilter
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: _buildForm(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: _buildActions(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Column(
        children: [
          Text(
            widget.service.name,
            style: Apptheme.h1Title(context, color: Apptheme.textColorPrimary),
            textAlign: TextAlign.center,
          ),
          if (widget.tireCode != null) ...[
            const SizedBox(height: 4),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: Apptheme.h5Body(context,
                    color: Apptheme.textColorSecondary),
                children: [
                  const TextSpan(text: 'se realizará en la llanta '),
                  TextSpan(
                    text: "LL-${widget.tireCode!}",
                    style: Apptheme.h5Body(
                      context,
                      color: Apptheme.textColorPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCostField(),
          const SizedBox(height: 18),
          _buildProviderField(),
        ],
      ),
    );
  }

  Widget _buildCostField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'COSTO',
          style: Apptheme.h5HighlightBody(context,
              color: Apptheme.textColorSecondary),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 42,
          child: TextField(
            controller: _costController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
              _currencyFormatter, // Usar el formateador cacheado
            ],
            decoration: InputDecoration(
              filled: true,
              fillColor: Apptheme.backgroundColor,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide:
                    BorderSide(color: Apptheme.backgroundColor, width: 1),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(color: Apptheme.lightGray, width: 1),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide:
                    BorderSide(color: Apptheme.selectActiveBorder, width: 1),
              ),
              errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(color: Colors.red, width: 1),
              ),
              hintText: '000.00',
              hintStyle: Apptheme.h4Medium(
                context,
                color: Apptheme.textColorSecondary,
              ).copyWith(
                height: 1.2,
              ),
              // Mostrar error en la decoración en lugar de widget separado
              errorText: _costError,
            ),
            style: Apptheme.h4Medium(
              context,
              color: Apptheme.textColorSecondary,
            ),
            onChanged: (value) {
              if (_costError != null) {
                setState(() {
                  _costError = null;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProviderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PROVEEDOR',
          style: Apptheme.h5HighlightBody(
            context,
            color: Apptheme.textColorSecondary,
          ),
        ),
        const SizedBox(height: 6),
        SelectProvider(
          hintText: 'Selecciona un proveedor',
          onChanged: (ProviderSelection? selection) {
            if (mounted) {
              // Verificar si el widget está montado
              setState(() {
                _selectedProvider = selection;
                if (_providerError != null) {
                  _providerError = null;
                }
              });
            }
          },
        ),
        if (_providerError != null) ...[
          const SizedBox(height: 4),
          Text(
            _providerError!,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActions() {
    return CustomButton(
      double.infinity,
      42,
      _isProcessing
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text(
              'Realizar Servicio',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
      _isProcessing ? null : () => _onRealizeService(),
      type: 1,
    );
  }

  void _onRealizeService() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      _costError = null;
      _providerError = null;
    });

    // Mover validaciones a un Future para no bloquear UI
    final validation = await _validateForm();

    if (!mounted) return;

    if (validation['hasErrors']) {
      setState(() {
        _costError = validation['costError'];
        _providerError = validation['providerError'];
        _isProcessing = false;
      });
      return;
    }

    // Si no hay errores, procesar el formulario
    final result = {
      'type_service': widget.service.id,
      'provider': _selectedProvider?.id ?? 0,
      'cost_service': validation['cost'],
    };

    if (mounted) {
      Navigator.of(context).pop(result);
    }
  }

  Future<Map<String, dynamic>> _validateForm() async {
    // Ejecutar validaciones en un compute o Future para no bloquear UI
    return await Future.microtask(() {
      String? costError;
      String? providerError;
      double cost = 0.0;

      // Validar costo
      if (_costController.text.isEmpty) {
        costError = 'Por favor ingresa el costo';
      } else {
        final cleanValue =
            _costController.text.replaceAll(',', '').replaceAll('.', '').trim();
        final parsedCost = double.tryParse(cleanValue);
        if (parsedCost == null || parsedCost < 0) {
          costError = 'Por favor ingresa un costo válido';
        } else {
          cost = parsedCost;
        }
      }

      // Validar proveedor
      if (_selectedProvider == null) {
        providerError = 'Por favor selecciona un proveedor';
      }

      return {
        'hasErrors': costError != null || providerError != null,
        'costError': costError,
        'providerError': providerError,
        'cost': cost,
      };
    });
  }
}

// Formateador optimizado
class _CurrencyInputFormatter extends TextInputFormatter {
  // Cache del formatter para evitar recrearlo
  static final _formatter = NumberFormat('#,###', 'es_CO');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    // Optimización: si el texto no cambió, no reformatear
    if (newValue.text == oldValue.text) {
      return newValue;
    }

    // Remover todos los caracteres no numéricos
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Si está vacío, retornar vacío
    if (newText.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Limitar la longitud para evitar números demasiado grandes
    if (newText.length > 10) {
      newText = newText.substring(0, 10);
    }

    // Formatear con puntos como separadores de miles (formato colombiano)
    final int value = int.tryParse(newText) ?? 0;
    final formattedText = _formatter.format(value).replaceAll(',', '.');

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
