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
        contentPadding: const EdgeInsets.all(24), // Agregar más padding interno
        title: _buildHeader(),
        content: SizedBox(
          child: SingleChildScrollView(
            child: _buildForm(),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 24, vertical: 16), // Padding para las acciones
            child: _buildActions(),
          ),
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
            fontSize: 22,
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
                fontSize: 16,
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
          const SizedBox(height: 20),
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
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Apptheme.grayInput),
            color: Apptheme.backgroundColor, // Agregar color de fondo
          ),
          child: TextFormField(
            controller: _costController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
              _CurrencyInputFormatter(),
            ],
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              hintText: '0.00',
              hintStyle: TextStyle(
                color: Apptheme.grayInput,
              ),
            ),
            style: const TextStyle(
              fontSize: 16,
              color: Apptheme.textColorSecondary,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa el costo';
              }
              final cleanValue =
                  value.replaceAll(',', '').replaceAll('.', '').trim();
              final cost = double.tryParse(cleanValue);
              if (cost == null || cost < 0) {
                return 'Por favor ingresa un costo válido';
              }
              return null;
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
          onChanged: (ProviderSelection? selection) {
            setState(() {
              _selectedProvider = selection;
            });
          },
        ),
      ],
    );
  }

  Widget _buildActions() {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        double.infinity,
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
      ),
    );
  }

  void _onRealizeService() {
    if (_formKey.currentState!.validate()) {
      // Aquí puedes procesar los datos del formulario
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
