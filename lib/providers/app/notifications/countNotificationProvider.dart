import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/services/NotificationService.dart';

// Provider para el conteo de notificaciones nuevas
final newNotificationsCountProvider = FutureProvider<int>((ref) async {
  try {
    final response =
        await NotificationService.getNewNotificationsCount(ref, {});
    if (response.success == true) {
      return response.data.totalNotificationsToSee;
    }
    return 0;
  } catch (e) {
    // En caso de error, no mostrar badge
    return 0;
  }
});

// Provider para refrescar automáticamente cada cierto tiempo (opcional)
final autoRefreshNotificationsProvider = StreamProvider<int>((ref) async* {
  while (true) {
    try {
      final response =
          await NotificationService.getNewNotificationsCount(ref, {});
      if (response.success == true) {
        yield response.data.totalNotificationsToSee;
      } else {
        yield 0;
      }
    } catch (e) {
      yield 0;
    }

    // Esperar 30 segundos antes de la próxima consulta
    await Future.delayed(const Duration(seconds: 30));
  }
});
