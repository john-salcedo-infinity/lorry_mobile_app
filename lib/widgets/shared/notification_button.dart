import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/providers/providers.dart';
import 'package:app_lorry/services/NotificationService.dart';
import 'package:app_lorry/widgets/dialogs/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class NotificationButton extends ConsumerWidget {
  final VoidCallback? onPressed;
  final bool showDialogConfirm;
  final bool isEnabled;
  final double? width;
  final double? height;

  const NotificationButton({
    super.key,
    this.onPressed,
    this.isEnabled = true,
    this.width = 40,
    this.height = 40,
    this.showDialogConfirm = false,
  });

  void _handleNotifications(BuildContext context, WidgetRef ref) {
    if (onPressed != null) {
      onPressed!();
    } else {
      if (showDialogConfirm) {
        ConfirmationDialog.show(
          context: context,
          title: "¿Está seguro que desea ver las notificaciones?",
          message: "Todas las acciones realizadas no podran ser restauradas",
          onAccept: () {
            context.push("/notifications");
            // Refrescar el conteo después de navegar
            Future.delayed(const Duration(milliseconds: 200), () {
              ref.invalidate(autoRefreshNotificationsProvider);
            });
          },
        );
      } else {
        context.push('/notifications');
        Future.delayed(const Duration(milliseconds: 200), () {
          ref.invalidate(autoRefreshNotificationsProvider);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsCountAsyncValue =
        ref.watch(autoRefreshNotificationsProvider);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed:
              !isEnabled ? null : () => _handleNotifications(context, ref),
          icon: SvgPicture.asset(
            'assets/icons/Lorry_Icono_Notificación_Vacía.svg',
            width: width,
            height: height,
          ),
        ),
        // Punto rojo para notificaciones nuevas
        notificationsCountAsyncValue.when(
          data: (count) {
            if (count >= 1) {
              return Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Apptheme.secondary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
          loading: () =>
              const SizedBox.shrink(), // No mostrar nada mientras carga
          error: (error, stack) =>
              const SizedBox.shrink(), // No mostrar nada si hay error
        ),
      ],
    );
  }
}
