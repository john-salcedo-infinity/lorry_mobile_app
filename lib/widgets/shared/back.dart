import 'package:flutter/material.dart';
import 'package:app_lorry/widgets/shared/back_button.dart' as custom;
import 'package:app_lorry/widgets/shared/home_button.dart';
import 'package:app_lorry/widgets/shared/notification_button.dart';
import 'package:app_lorry/widgets/shared/delete_button.dart';

class Back extends StatelessWidget {
  final bool showHome;
  final bool showNotifications;
  final bool showDelete;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onBackPressed;
  final VoidCallback? onHomePressed;
  final VoidCallback? onNotificationPressed;

  const Back({
    super.key,
    this.showHome = false,
    this.showNotifications = false,
    this.showDelete = false,
    this.onDeletePressed,
    this.onBackPressed,
    this.onHomePressed,
    this.onNotificationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 14, right: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Botón de atrás
          custom.BackButton(
            onPressed: onBackPressed,
          ),
          // Iconos adicionales
          Row(
            children: [
              if (showDelete)
                DeleteButton(
                  onPressed: onDeletePressed,
                ),
              if (showNotifications)
                NotificationButton(
                  onPressed: onNotificationPressed,
                ),
              if (showHome)
                HomeButton(
                  onPressed: onHomePressed,
                ),
            ],
          )
        ],
      ),
    );
  }
}
