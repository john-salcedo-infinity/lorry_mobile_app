import 'package:flutter/material.dart';
import 'package:app_lorry/config/app_theme.dart';

class InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const InfoRow({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: Apptheme.h5Body(context, color: Apptheme.textColorSecondary),
        ),
        const SizedBox(height: 12), // gap: 12px
        Container(
          width: 292, // Ancho
          height: 38, // Alto
          padding: const EdgeInsets.all(12), // Padding de 12px
          decoration: BoxDecoration(
            color: const Color(0xFFDCE6E3),
            borderRadius: BorderRadius.circular(4), // Bordes redondeados
          ),
          alignment: Alignment.center, // Centrar contenido
          child: Text(
            value,
            style: Apptheme.h5HighlightBody(context, color: Apptheme.secondary),
            textAlign: TextAlign.center, // Centrar el texto
          ),
        ),
      ],
    );
  }
}
