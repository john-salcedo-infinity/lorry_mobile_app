import 'package:flutter/material.dart';
import 'package:app_lorry/config/app_theme.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final dynamic message; // Can be String or Widget
  final String cancelText;
  final String acceptText;
  final VoidCallback? onCancel;
  final VoidCallback? onAccept;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.cancelText = 'Cancelar',
    this.acceptText = 'Aceptar',
    this.onCancel,
    this.onAccept,
  }) : assert(message is String || message is Widget,
            'message must be either String or Widget');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.white,
      title: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Apptheme.textColorPrimary,
          ),
        ),
      ),
      content: message is Widget
          ? message as Widget
          : Text(
              message as String,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Apptheme.textColorSecondary,
                fontWeight: FontWeight.normal,
              ),
            ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: _buildCancelButton(context)),
            const SizedBox(width: 16),
            Expanded(child: _buildAcceptButton(context)),
          ],
        ),
      ],
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
        if (onCancel != null) {
          onCancel!();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        elevation: 0,
      ),
      child: Text(
        cancelText,
        style: const TextStyle(
          color: Apptheme.primary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAcceptButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
        if (onAccept != null) {
          onAccept!();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Apptheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(color: Apptheme.darkorange, width: 2),
        ),
        elevation: 0,
      ),
      child: Text(
        acceptText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Método estático para mostrar el diálogo de manera fácil
  static Future<void> show({
    required BuildContext context,
    required String title,
    required dynamic message, // Can be String or Widget
    String cancelText = 'Cancelar',
    String acceptText = 'Aceptar',
    VoidCallback? onCancel,
    VoidCallback? onAccept,
  }) {
    assert(message is String || message is Widget,
        'message must be either String or Widget');
    return showDialog(
      context: context,
      barrierColor: Apptheme.secondary.withValues(alpha: 0.5),
      builder: (dialogContext) => ConfirmationDialog(
        title: title,
        message: message,
        cancelText: cancelText,
        acceptText: acceptText,
        onCancel: onCancel,
        onAccept: onAccept,
      ),
    );
  }
}
