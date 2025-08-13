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
  });

  @override
  Widget build(BuildContext context) {
    // Detectar automáticamente si se puede navegar hacia atrás
    final canGoBack = Navigator.canPop(context);

    return Container(
      margin: const EdgeInsets.only(top: 10, left: 14, right: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Botón de atrás (solo si se puede navegar hacia atrás)
          if (canGoBack)
            custom.BackButton(
              onPressed: onBackPressed,
              isEnabled: !isLoading,
            )
          else
            const SizedBox(width: 48), // Espacio vacío para mantener el layout
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
  }
}
