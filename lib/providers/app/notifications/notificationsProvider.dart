import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/services/NotificationService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notificationsProvider.g.dart';

@Riverpod()
class Notifications extends _$Notifications {
  @override
  List<Notification> build() => [];

  void addResults(List<Notification> newResults) {
    state = [...state, ...newResults];
  }

  void replaceResults(List<Notification> results) {
    state = results;
  }

  void clearResults() {
    state = [];
  }

  void changeValue(List<Notification> value) {
    state = value;
  }
}

@Riverpod()
class LoadingNotifications extends _$LoadingNotifications {
  @override
  bool build() => false;

  void changeLoading(bool value) {
    state = value;
  }
}

//! Provider para Paginación
final notificationsPaginationProvider = StateProvider<String?>((ref) => null);
final loadingMoreNotificationsProvider = StateProvider<bool>((ref) => false);

@Riverpod()
Future<NotificationResponse> notificationService(
    Ref ref, Map<String, String>? queryParams) async {
  final notifications =
      await NotificationService.getNotifications(ref, queryParams);
  return notifications;
}
