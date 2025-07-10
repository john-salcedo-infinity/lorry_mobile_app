import 'package:flutter/services.dart';

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Eliminar cualquier carácter que no sea número
    final rawText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Limitar el valor a 50.000.000
    if (int.tryParse(rawText) != null && int.parse(rawText) > 50000000) {
      return oldValue;
    }

    if (rawText.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    final formattedText = _formatWithThousandsSeparator(rawText);

    // Calcular nueva posición del cursor al final
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _formatWithThousandsSeparator(String value) {
    final number = int.tryParse(value);
    if (number == null) return '';
    final reversed = value.split('').reversed.toList();
    final buffer = StringBuffer();

    for (int i = 0; i < reversed.length; i++) {
      buffer.write(reversed[i]);
      if ((i + 1) % 3 == 0 && i + 1 != reversed.length) {
        buffer.write('.');
      }
    }

    return buffer.toString().split('').reversed.join('');
  }
}
