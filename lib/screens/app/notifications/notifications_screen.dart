import 'dart:async';

import 'package:app_lorry/config/configs.dart';
import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/providers/app/home/homeProvider.dart';
import 'package:app_lorry/routers/routers.dart';
import 'package:app_lorry/services/NotificationService.dart';
import 'package:app_lorry/widgets/shared/ScrollTopTop.dart';
import 'package:app_lorry/widgets/shared/back.dart';
import 'package:app_lorry/widgets/shared/custom_fab_location.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/models/models.dart' as models;
import 'package:app_lorry/providers/providers.dart';
import 'package:app_lorry/widgets/forms/customInput.dart';
import 'package:go_router/go_router.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

final searchNotificationProvider = StateProvider<String>((ref) => '');

// Provider para query params de notifications - definido globalmente
final notificationQueryParamsProvider = Provider<Map<String, String>>((ref) {
  final search = ref.watch(searchNotificationProvider);

  // Debug para ver cuando cambian los parámetros
  debugPrint('Query params changed - search: "$search"');

  return {
    if (search.isNotEmpty) 'search': search,
    // Agregar timestamp para forzar cambios
    '_timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
  };
});

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  Timer? _debounce;
  Timer? _scrollThrottle; // Throttle para el scroll
  final ScrollController _scrollController = ScrollController();
  bool _shouldCancelRefresh =
      false; // Bandera para cancelar refresh si cambió dirección
  double _lastScrollPosition = 0.0; // Última posición del scroll
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Cargar datos iniciales
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _onScroll() {
    // Throttle para evitar llamadas excesivas durante scroll rápido
    if (_scrollThrottle?.isActive ?? false) return;

    _scrollThrottle = Timer(const Duration(milliseconds: 100), () {
      // Verificar que el ScrollController esté adjunto a una vista de scroll
      if (_scrollController.hasClients &&
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200) {
        _loadMoreData();
      }
    });
  }

  Future<void> _loadInitialData() async {
    // Asegurar que loading esté activo desde el principio
    if (!ref.read(loadingNotificationsProvider)) {
      ref.read(loadingNotificationsProvider.notifier).changeLoading(true);
    }

    try {
      final queryParams = ref.read(notificationQueryParamsProvider);

      // Debug para verificar los parámetros
      debugPrint('Loading notifications with params: $queryParams');

      // FORZAR invalidación completa del provider
      ref.invalidate(notificationServiceProvider(queryParams));
      ref.invalidate(notificationServiceProvider);

      // Esperar un poco para asegurar invalidación
      await Future.delayed(const Duration(milliseconds: 50));

      final response =
          await ref.read(notificationServiceProvider(queryParams).future);

      if (mounted) {
        debugPrint(
            'Received ${response.data.results?.length ?? 0} notifications');
        ref
            .read(notificationsProvider.notifier)
            .replaceResults(response.data.results ?? []);
        ref.read(notificationsPaginationProvider.notifier).state =
            response.data.next?.toString();
      }
    } catch (e) {
      debugPrint('Error loading notifications: $e');
      if (context.mounted) {
        ToastHelper.show_alert(context, "Error al cargar las Notificaciones");
      }
      if (mounted) {
        ref.read(notificationsProvider.notifier).clearResults();
        ref.read(notificationsPaginationProvider.notifier).state = null;
      }
    } finally {
      if (mounted) {
        ref.read(loadingNotificationsProvider.notifier).changeLoading(false);
      }
    }
  }

  Future<void> _loadMoreData() async {
    final nextUrl = ref.read(notificationsPaginationProvider);
    final isLoadingMore = ref.read(loadingMoreNotificationsProvider);

    if (nextUrl == null || isLoadingMore) return;

    ref.read(loadingMoreNotificationsProvider.notifier).state = true;

    try {
      // Extraer el número de página de la URL
      final uri = Uri.parse(nextUrl);
      final pageNumber = uri.queryParameters['page'];

      final queryParams = ref.read(notificationQueryParamsProvider);
      final newQueryParams = {
        ...queryParams,
        if (pageNumber != null) 'page': pageNumber,
      };

      final response = await NotificationService.getNotifications(
          ref, newQueryParams.cast<String, String>());

      if (mounted) {
        ref
            .read(notificationsProvider.notifier)
            .addResults(response.data.results ?? []);
        ref.read(notificationsPaginationProvider.notifier).state =
            response.data.next?.toString();
      }
    } catch (e) {
      debugPrint('Error loading more data: $e');
    } finally {
      if (mounted) {
        ref.read(loadingMoreNotificationsProvider.notifier).state = false;
      }
    }
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(
      const Duration(milliseconds: 500),
      () async {
        // Actualizar el valor de búsqueda
        ref.read(searchNotificationProvider.notifier).state = value;

        // Limpiar estado actual ANTES de cargar
        ref.read(notificationsProvider.notifier).clearResults();
        ref.read(notificationsPaginationProvider.notifier).state = null;

        // Mostrar loading durante el proceso de búsqueda
        ref.read(loadingNotificationsProvider.notifier).changeLoading(true);

        // FORZAR invalidación completa antes de la nueva búsqueda
        final queryParams = ref.read(notificationQueryParamsProvider);
        ref.invalidate(notificationServiceProvider(queryParams));
        ref.invalidate(notificationServiceProvider);

        // Esperar un frame para asegurar que la invalidación se procese
        await Future.delayed(const Duration(milliseconds: 10));

        // Ahora cargar con los nuevos parámetros
        _loadInitialData();
      },
    );
  }

  /// Invalida todos los providers para forzar refresh completo
  void _invalidateAllProviders() {
    final queryParams = ref.read(notificationQueryParamsProvider);

    // Invalidar TODOS los providers relacionados
    ref.invalidate(notificationServiceProvider(queryParams));
    ref.invalidate(notificationServiceProvider);
    ref.invalidate(notificationQueryParamsProvider);

    // También invalidar providers de estado si es necesario
    ref.read(notificationsPaginationProvider.notifier).state = null;
  }

  Future<void> _onRefresh() async {
    // Si se marcó para cancelar refresh, no hacer nada
    if (!mounted || _shouldCancelRefresh) {
      setState(() {
        _shouldCancelRefresh = false;
      });
      return;
    }

    try {
      // Invalidar todos los providers para forzar refresh completo
      _invalidateAllProviders();

      // Limpiar estado actual
      ref.read(notificationsProvider.notifier).clearResults();
      ref.read(notificationsPaginationProvider.notifier).state = null;

      // Cargar datos frescos
      final queryParams = ref.read(notificationQueryParamsProvider);
      ref.read(loadingNotificationsProvider.notifier).changeLoading(true);

      // Invalidar para nueva llamada
      ref.invalidate(notificationServiceProvider(queryParams));

      // Obtener datos frescos
      final response =
          await ref.read(notificationServiceProvider(queryParams).future);

      // Actualizar estado con nuevos datos INMEDIATAMENTE
      if (mounted) {
        ref
            .read(notificationsProvider.notifier)
            .replaceResults(response.data.results ?? []);
        ref.read(notificationsPaginationProvider.notifier).state =
            response.data.next?.toString();
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.show_alert(
            context, "Error al actualizar las notificaciones");
      }
      if (mounted) {
        ref.read(notificationsProvider.notifier).clearResults();
        ref.read(notificationsPaginationProvider.notifier).state = null;
      }
    } finally {
      // Asegurar que se deshabilite loading
      if (mounted) {
        ref.read(loadingNotificationsProvider.notifier).changeLoading(false);
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollThrottle?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationsProvider);
    final isLoading = ref.watch(loadingNotificationsProvider);
    final isLoadingMore = ref.watch(loadingMoreNotificationsProvider);

    return Scaffold(
      backgroundColor: Apptheme.backgroundColor,
      floatingActionButton: ScrollToTopFab(
        scrollController: _scrollController,
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
      floatingActionButtonLocation: CustomFABLocation(
        offsetX: 70, // Valor fijo en píxeles para X
        offsetY: 120, // Valor fijo en píxeles para Y
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Elementos estáticos - Back button, título y búsqueda (similar a Home)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                Back(
                  interceptSystemBack: true,
                  onBackPressed: () {
                    ref.read(searchNotificationProvider.notifier).state = "";
                    ref.read(appRouterProvider).go("/home");
                  },
                ),
                const SizedBox(height: 12),

                Container(
                  margin:
                      EdgeInsets.only(left: 24, right: 25, top: 12, bottom: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notificaciones',
                        style: Apptheme.h1Title(
                          context,
                          color: Apptheme.textColorSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Campo de búsqueda
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: CustomInputField(
                          showBorder: false,
                          height: 42,
                          hint: "Buscar...",
                          onChanged: _onSearchChanged,
                          showLabel: false,
                          controller: TextEditingController(
                            text: ref.watch(searchNotificationProvider),
                          ),
                          suffixIcon: Icon(
                            Icons.search,
                            color: Apptheme.textColorPrimary,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // Título
              ],
            ),

            // Lista scrollable de notificaciones (igual que en Home)
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notification) {
                  // Verificar que el ScrollController esté adjunto antes de procesar
                  if (!_scrollController.hasClients) return false;

                  // Solo procesar UserScrollNotification para mejor rendimiento
                  if (notification is UserScrollNotification ||
                      notification is ScrollUpdateNotification) {
                    final position = _scrollController.position;
                    final currentPosition = position.pixels;

                    // Si está en zona de pull-to-refresh (posición negativa)
                    if (currentPosition < 0) {
                      // Detectar si cambió de dirección hacia abajo después de haber ido hacia arriba
                      if (_lastScrollPosition < currentPosition &&
                          currentPosition > -30) {
                        // Solo actualizar estado si realmente cambió
                        if (!_shouldCancelRefresh) {
                          setState(() {
                            _shouldCancelRefresh = true;
                          });
                        }
                      }
                      // Si está yendo más hacia arriba, permitir refresh
                      else if (_lastScrollPosition > currentPosition) {
                        if (_shouldCancelRefresh) {
                          setState(() {
                            _shouldCancelRefresh = false;
                          });
                        }
                      }
                    }
                    // Reset cuando vuelve a posición normal
                    else if (currentPosition >= 0) {
                      if (_shouldCancelRefresh) {
                        setState(() {
                          _shouldCancelRefresh = false;
                        });
                      }
                    }

                    _lastScrollPosition = currentPosition;
                  }
                  return false;
                },
                child: RefreshIndicator(
                  color: Apptheme.primary,
                  strokeWidth: 1.5,
                  backgroundColor: Colors.white,
                  key: _refreshIndicatorKey,
                  onRefresh: _onRefresh,
                  child: isLoading && notifications.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Apptheme.primary,
                                  strokeWidth: 1.5,
                                ),
                              ),
                            ),
                          ],
                        )
                      : notifications.isEmpty && !isLoading
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: const [
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Text('No hay notificaciones'),
                                  ),
                                ),
                              ],
                            )
                          : ListView.separated(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),

                              // Optimizaciones de rendimiento
                              cacheExtent: 500.0,
                              addAutomaticKeepAlives: false,
                              addRepaintBoundaries: true,
                              addSemanticIndexes: false,

                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: notifications.length +
                                  (isLoadingMore ? 1 : 0),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                if (index == notifications.length &&
                                    isLoadingMore) {
                                  return const _LoadingMoreIndicator();
                                }

                                return _NotificationItem(
                                  notification: notifications[index],
                                  index: index,
                                );
                              },
                            ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationItem extends StatefulWidget {
  final models.Notification notification;
  final int index;

  const _NotificationItem({
    required this.notification,
    required this.index,
  });

  @override
  State<_NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<_NotificationItem> {
  late String status;
  late String date;
  late String title;
  late String message;
  late Color backgroundColor;
  late Color borderColor;

  @override
  void initState() {
    super.initState();
    status = widget.notification.viewed! ? "LEÍDO" : "NUEVO";
    date = HelpersGeneral.formatDayDateTime(
        widget.notification.creationDate!.toLocal());
    title = widget.notification.title!;
    message = widget.notification.message!;
    backgroundColor = widget.notification.viewed!
        ? Colors.white
        : Apptheme.unReadNotificationBackground;
    borderColor = widget.notification.viewed!
        ? Apptheme.backgroundColor
        : Apptheme.unReadNotificationBorder;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    status,
                    style: Apptheme.h5Body(context, color: Apptheme.gray),
                  ),
                ),
                Text(
                  date,
                  style: Apptheme.h5Body(context, color: Apptheme.gray),
                ),
              ],
            ),
          ),
          // Linea horizontal
          Divider(
            height: 1,
            color: borderColor,
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(24, 10, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Apptheme.h4HighlightBody(
                      context,
                      color: Apptheme.gray,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    message,
                    style: Apptheme.h5Body(
                      context,
                      color: Apptheme.textColorSecondary,
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class _LoadingMoreIndicator extends StatelessWidget {
  const _LoadingMoreIndicator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: Apptheme.primary,
          ),
        ),
      ),
    );
  }
}
