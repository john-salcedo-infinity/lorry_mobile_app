import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/config/configs.dart';

class CustomInputField extends ConsumerWidget {
  final String? label;
  final String hint;
  final TextEditingController? controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;
  final bool showLabel;
  final bool showBorder;
  final double? height;

  const CustomInputField({
    super.key,
    this.label,
    required this.hint,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.suffixIcon,
    this.showLabel = true,
    this.showBorder = true,
    this.height,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel && label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
        ],
        SizedBox(
          height: height ?? 48, // Default height if not provided
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  Apptheme.h4Body(context, color: Apptheme.grayInput).copyWith(
                height: height != null ? 1.2 : null,
              ),
              fillColor: Colors.white,
              filled: true,
              suffixIcon: suffixIcon,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              border: showBorder
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Apptheme.grayInput),
                    )
                  : InputBorder.none,
              focusedBorder: showBorder
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide:
                          const BorderSide(color: Apptheme.primary, width: 2),
                    )
                  : InputBorder.none,
              enabledBorder: showBorder
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Apptheme.grayInput),
                    )
                  : InputBorder.none,
            ),
            validator: validator,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
