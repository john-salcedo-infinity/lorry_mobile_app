import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/config/configs.dart';

class CustomInputField extends ConsumerWidget {
  final bool? obscureText = false;
  final String? hint;
  final () onchange;
  

  const CustomInputField(this.hint, this.onchange, {super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return TextFormField(
              obscureText: true,
              style: const TextStyle(fontSize: 15),
              decoration: Apptheme.inputDecorationPrimary("Contraseña"),
              textCapitalization: TextCapitalization.words,
              onChanged: (value) {
              },
            );
  }
}