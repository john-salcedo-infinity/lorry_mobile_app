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

  @override
  void initState() {
    super.initState();
    // Inicializar con un campo vacío para que sea editable
    _costController.text = '';
  }

  @override
  void dispose() {
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 32, vertical: 32), // Agregar más padding interno
        title: _buildHeader(),
        content: SizedBox(
          child: SingleChildScrollView(
            child: _buildForm(),
          ),
        ),
        actions: [
          Expanded(child: _buildActions()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          widget.service.name,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w900,
            color: Apptheme.textColorPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        if (widget.tireCode != null) ...[
          const SizedBox(height: 8),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14,
                color: Apptheme.textColorSecondary,
                fontWeight: FontWeight.normal,
              ),
              children: [
                const TextSpan(text: 'se realizará en la llanta '),
                TextSpan(
                  text: "LL-${widget.tireCode!}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Apptheme.textColorPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCostField(),
          const SizedBox(height: 10),
          _buildProviderField(),
        ],
      ),
    );
  }

  Widget _buildCostField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'COSTO',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: Apptheme.textColorSecondary,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 40,
          child: TextField(
            controller: _costController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
              _CurrencyInputFormatter(),
            ],
            decoration: const InputDecoration(
              filled: true,
              fillColor: Apptheme.backgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide:
                    BorderSide(color: Apptheme.backgroundColor, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(color: Apptheme.grayInput, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(color: Apptheme.primary, width: 1),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(color: Colors.red, width: 1),
              ),
              hintText: '000.00',
              hintStyle: TextStyle(
                height: 1.2,
                color: Apptheme.grayInput,
              ),
            ),
            style: const TextStyle(
              fontSize: 14,
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
        if (_costError != null) ...[
          const SizedBox(height: 4),
          Text(
            _costError!,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildProviderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PROVEEDOR',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Apptheme.textColorSecondary,
          ),
        ),
        const SizedBox(height: 8),
        SelectProvider(
          hintText: 'Selecciona un proveedor',
          showBorder: false,
          onChanged: (ProviderSelection? selection) {
            setState(() {
              _selectedProvider = selection;
              if (_providerError != null) {
                _providerError = null;
              }
            });
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
      // double.infinity,
      900000,
      50,
      const Text(
        'Realizar Servicio',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      () => _onRealizeService(),
      type: 1,
    );
  }

  void _onRealizeService() {
    // Limpiar errores previos
    setState(() {
      _costError = null;
      _providerError = null;
    });

    bool hasErrors = false;

    // Validar costo
    if (_costController.text.isEmpty) {
      setState(() {
        _costError = 'Por favor ingresa el costo';
      });
      hasErrors = true;
    } else {
      final cleanValue =
          _costController.text.replaceAll(',', '').replaceAll('.', '').trim();
      final cost = double.tryParse(cleanValue);
      if (cost == null || cost < 0) {
        setState(() {
          _costError = 'Por favor ingresa un costo válido';
        });
        hasErrors = true;
      }
    }

    // Validar proveedor
    if (_selectedProvider == null) {
      setState(() {
        _providerError = 'Por favor selecciona un proveedor';
      });
      hasErrors = true;
    }

    // Si no hay errores, procesar el formulario
    if (!hasErrors) {
      final cleanValue =
          _costController.text.replaceAll(',', '').replaceAll('.', '').trim();
      final cost = double.tryParse(cleanValue) ?? 0.0;

      // Cerrar el dialog y retornar los datos del servicio
      Navigator.of(context).pop({
        'type_service': widget.service.id,
        'provider': _selectedProvider?.id ?? 0,
        'cost_service': cost,
      });
    }
  }
}

// Formateador personalizado para currency
class _CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.baseOffset == 0) {
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

    // Formatear con puntos como separadores de miles (formato colombiano)
    final int value = int.tryParse(newText) ?? 0;
    final formatter = NumberFormat('#,###', 'es_CO');
    final formattedText = formatter.format(value).replaceAll(',', '.');

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
