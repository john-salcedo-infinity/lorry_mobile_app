import 'package:flutter/material.dart';
import 'package:app_lorry/widgets/shared/back_button.dart' as custom;
import 'package:app_lorry/widgets/shared/home_button.dart';
import 'package:app_lorry/widgets/shared/notification_button.dart';
import 'package:app_lorry/widgets/shared/delete_button.dart';

class Back extends StatelessWidget {
  final bool showHome;
  final bool showNotifications;
  final bool showDelete;
  final bool isLoading;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onBackPressed;
  final VoidCallback? onHomePressed;
  final VoidCallback? onNotificationPressed;
  final bool? showHomeDialogConfirm;
  final bool interceptSystemBack; // Nueva propiedad

  const Back({
    super.key,
    this.showHome = false,
    this.showNotifications = false,
    this.showDelete = false,
    this.isLoading = false,
    this.onDeletePressed,
    this.onBackPressed,
    this.onHomePressed,
    this.onNotificationPressed,
    this.showHomeDialogConfirm,
    this.interceptSystemBack = false,
  });

  // Maneja tanto el tap del botón como el gesto del sistema
  void _handleBackAction(BuildContext context) {
    if (onBackPressed != null) {
      onBackPressed!();
    } else {
      // Comportamiento por defecto
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final canGoBack = Navigator.canPop(context);

    Widget backWidget = Container(
      margin: const EdgeInsets.only(top: 10, left: 14, right: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Botón de atrás (solo si se puede navegar hacia atrás)
          if (canGoBack)
            custom.BackButton(
              onPressed: () => _handleBackAction(context),
              isEnabled: !isLoading,
            )
          else
            const SizedBox(width: 48),
          // Iconos adicionales
          Row(
            children: [
              if (showDelete)
                DeleteButton(
                  onPressed: onDeletePressed,
                  isEnabled: !isLoading,
                ),
              if (showNotifications)
                NotificationButton(
                  onPressed: onNotificationPressed,
                  isEnabled: !isLoading,
                ),
              if (showHome)
                HomeButton(
                  onPressed: onHomePressed,
                  isEnabled: !isLoading,
                  showDialogConfirm: showHomeDialogConfirm ?? false,
                ),
            ],
          )
        ],
      ),
    );

    // Si necesitamos interceptar el gesto del sistema, envolvemos con PopScope
    if (interceptSystemBack && onBackPressed != null) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop && !isLoading) {
            _handleBackAction(context);
          }
        },
        child: backWidget,
      );
    }

    return backWidget;
  }
}
