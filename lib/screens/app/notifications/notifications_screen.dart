import 'dart:async';

import 'package:app_lorry/services/services.dart';
import 'package:app_lorry/widgets/shared/ScrollTopTop.dart';
import 'package:app_lorry/widgets/shared/custom_fab_location.dart';
import 'package:app_lorry/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/models/models.dart' as models;
import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/providers/app/notifications/notificationsProvider.dart';
import 'package:app_lorry/routers/app_routes.dart';

final searchNotificationProvider = StateProvider<String>((ref) => '');

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

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
    final queryParams = ref.read(queryParamsProvider);
    ref.read(loadingNotificationsProvider.notifier).changeLoading(true);

    try {
      // Invalidar el provider para forzar una nueva llamada al API
      ref.invalidate(NotificationServiceProvider(queryParams));

      final response =
          await ref.read(notificationServiceProvider(queryParams).future);

      if (mounted) {
        ref
            .read(notificationsProvider.notifier)
            .replaceResults(response.data.results ?? []);
        ref.read(notificationsPaginationProvider.notifier).state =
            response.data.next?.toString();
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.show_alert(context, "Error al cargar las notificaciones");
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

      final queryParams = ref.read(queryParamsProvider);
      final newQueryParams = {
        ...queryParams,
        if (pageNumber != null) 'page': pageNumber,
      };

      final response = await NotificationService.getNotifications(
          ref, newQueryParams.cast<String, String>());

      ref
          .read(notificationsProvider.notifier)
          .addResults(response.data.results ?? []);
      ref.read(notificationsPaginationProvider.notifier).state =
          response.data.next?.toString();
    } catch (e) {
      debugPrint('Error loading more data: $e');
    } finally {
      ref.read(loadingMoreNotificationsProvider.notifier).state = false;
    }
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchNotificationProvider.notifier).state = value;

      // Mostrar loading durante el proceso de búsqueda
      ref.read(loadingNotificationsProvider.notifier).changeLoading(true);

      _loadInitialData(); // Recargar con nuevo filtro
    });
  }

  /// Invalida todos los providers para forzar refresh completo
  void _invalidateAllProviders() {
    final queryParams = ref.read(queryParamsProvider);

    // Invalidar TODOS los providers relacionados
    ref.invalidate(notificationServiceProvider(queryParams));
    ref.invalidate(notificationServiceProvider);
  }

  Future<void> _onRefresh() async {
    // Si se marcó para cancelar refresh, no hacer nada
    if (!mounted || _shouldCancelRefresh) {
      // Reset la bandera
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

      // Cargar datos frescos y esconder inmediatamente al recibir respuesta
      final queryParams = ref.read(queryParamsProvider);
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
    _scrollController.dispose();
    super.dispose();
  }

  final queryParamsProvider = Provider<Map<String, String>>((ref) {
    final search = ref.watch(searchNotificationProvider);
    return {
      if (search.isNotEmpty) 'search': search,
    };
  });

  void _onBackAction() {
    ref.read(notificationsProvider.notifier).clearResults();
    ref.read(loadingNotificationsProvider.notifier).changeLoading(false);
    ref.read(notificationsPaginationProvider.notifier).state = null;
    ref.read(searchNotificationProvider.notifier).state = '';
    ref.read(appRouterProvider).go("/home");
  }

  @override
  Widget build(BuildContext context) {
    final notificationsList = ref.watch(notificationsProvider);
    final isLoading = ref.watch(loadingNotificationsProvider);
    final isLoadingMore = ref.watch(loadingMoreNotificationsProvider);

    return Scaffold(
      backgroundColor: Apptheme.backgroundColor,
      floatingActionButton: ScrollToTopFab(
        scrollController: _scrollController,
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
      floatingActionButtonLocation: CustomFABLocation(
        offsetX: 65, // Valor fijo en píxeles para X
        offsetY: 120, // Valor fijo en píxeles para Y
      ),
      body: SafeArea(
        child: Column(
          children: [
            Back(
              interceptSystemBack: true,
              onBackPressed: _onBackAction,
            ),
            Padding(
              padding: EdgeInsets.all(4),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
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
                    SizedBox(height: 12),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: CustomInputField(
                        showBorder: false,
                        height: 42,
                        hint: "Buscar por VHC asociada",
                        onChanged: _onSearchChanged,
                        showLabel: false,
                        suffixIcon: Icon(
                          Icons.search,
                          color: Apptheme.textColorPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Lista Scrollable de Notificaciones
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notification) {
                  // Verificar que el ScrollController esté adjunto antes de procesar notificaciones
                  if (!_scrollController.hasClients) return false;

                  // OPTIMIZACIÓN: Solo procesar UserScrollNotification para mejor rendimiento
                  if (notification is UserScrollNotification ||
                      notification is ScrollUpdateNotification) {
                    final position = _scrollController.position;
                    final currentPosition = position.pixels;

                    // Si está en zona de pull-to-refresh (posición negativa)
                    if (currentPosition < 0) {
                      // Detectar si cambió de dirección hacia abajo después de haber ido hacia arriba
                      if (_lastScrollPosition < currentPosition &&
                          currentPosition > -30) {
                        // OPTIMIZACIÓN: Solo actualizar estado si realmente cambió
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
                  key: _refreshIndicatorKey,
                  color: Apptheme.primary,
                  backgroundColor: Colors.white,
                  strokeWidth: 2.0,
                  displacement: 50.0,
                  onRefresh: _onRefresh,
                  child: isLoading
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              child: Center(child: Apptheme.loadingIndicator()),
                            ),
                          ],
                        )
                      : notificationsList.isEmpty && !isLoading
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: const [
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Text(
                                        'No se encontraron notificaciones.'),
                                  ),
                                ),
                              ],
                            )
                          : ListView.separated(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 12,
                              ),

                              // OPTIMIZACIONES DE RENDIMIENTO MEJORADAS
                              cacheExtent: 500.0, // Reducido para menos memoria
                              addAutomaticKeepAlives:
                                  false, // Evita mantener widgets fuera de pantalla
                              addRepaintBoundaries: true, // Mejora el repaint
                              addSemanticIndexes:
                                  false, // Reduce cálculos innecesarios

                              // OPTIMIZACIÓN CRÍTICA: Altura fija para mejor rendimiento
                              // itemExtent: 190.0,

                              itemCount: notificationsList.length +
                                  (isLoadingMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index < notificationsList.length) {
                                  final notification = notificationsList[index];

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: _NotificationItem(
                                      notification: notification,
                                      index: index,
                                    ),
                                  );
                                } else if (isLoadingMore) {
                                  // Mostrar indicador de carga al final
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Center(
                                        child: Apptheme.loadingIndicator()),
                                  );
                                }
                                return const SizedBox
                                    .shrink(); // Más eficiente que null
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
