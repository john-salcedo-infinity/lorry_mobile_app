// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:app_lorry/widgets/bluetooth/bluetooth_widgets.dart';
import 'package:app_lorry/widgets/bluetooth/bluetooth_bottom_sheet.dart';
import 'package:app_lorry/services/services.dart';
import 'package:app_lorry/widgets/buttons/BottomButton.dart';
import 'package:app_lorry/widgets/forms/customInput.dart';
import 'package:app_lorry/widgets/shared/ScrollTopTop.dart';
import 'package:app_lorry/widgets/shared/custom_fab_location.dart';
import 'package:app_lorry/widgets/shared/notification_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/models/models.dart' hide Provider;
import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/providers/app/home/homeProvider.dart';
import 'package:app_lorry/routers/app_routes.dart';
import 'package:app_lorry/widgets/items/ItemHistorial.dart';
import 'package:flutter_svg/svg.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Timer? _debounce;
  Timer? _scrollThrottle; // Throttle para el scroll
  final ScrollController _scrollController = ScrollController();
  bool _shouldCancelRefresh =
      false; // Bandera para cancelar refresh si cambió dirección
  double _lastScrollPosition = 0.0; // Última posición del scroll
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  int? selectedIndex; // Índice de la tarjeta seleccionada

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
    ref.read(loadinginspectionsProvider.notifier).changeloading(true);

    try {
      // Invalidar el provider para forzar una nueva llamada al API
      ref.invalidate(inspectionAllServiceProvider(queryParams));

      final response =
          await ref.read(inspectionAllServiceProvider(queryParams).future);

      if (mounted) {
        ref
            .read(inspectionsProvider.notifier)
            .replaceResults(response.data.results);
        ref.read(inspectionPaginationProvider.notifier).state =
            response.data.next?.toString();
      }
    } catch (e) {
      if (context.mounted) {
        ToastHelper.show_alert(context, "Error al cargar las inspecciones");
      }
      if (mounted) {
        ref.read(inspectionsProvider.notifier).clearResults();
        ref.read(inspectionPaginationProvider.notifier).state = null;
      }
    } finally {
      if (mounted) {
        ref.read(loadinginspectionsProvider.notifier).changeloading(false);
      }
    }
  }

  /// Carga más datos de inspecciones de forma paginada.
  ///
  /// Este método verifica si hay una URL siguiente disponible y si no se está
  /// cargando actualmente más datos. Si las condiciones son válidas, procede a:
  ///
  /// 1. Activar el estado de carga
  /// 2. Extraer el número de página de la URL de paginación
  /// 3. Combinar los parámetros de consulta existentes con el nuevo número de página
  /// 4. Realizar la petición al servicio para obtener más inspecciones
  /// 5. Agregar los nuevos resultados al estado actual de inspecciones
  /// 6. Actualizar la URL de paginación para la siguiente carga
  ///
  /// En caso de error, imprime el mensaje en consola.
  /// Siempre desactiva el estado de carga al finalizar.
  ///
  /// Returns: [Future<void>] - Operación asíncrona sin valor de retorno

  Future<void> _loadMoreData() async {
    final nextUrl = ref.read(inspectionPaginationProvider);
    final isLoadingMore = ref.read(loadingMoreProvider);

    if (nextUrl == null || isLoadingMore) return;

    ref.read(loadingMoreProvider.notifier).state = true;

    try {
      // Extraer el número de página de la URL
      final uri = Uri.parse(nextUrl);
      final pageNumber = uri.queryParameters['page'];

      final queryParams = ref.read(queryParamsProvider);
      final newQueryParams = {
        ...queryParams,
        if (pageNumber != null) 'page': pageNumber,
      };

      final response = await Homeservice.GetInspectionHistory(
          ref, newQueryParams.cast<String, String>());

      ref.read(inspectionsProvider.notifier).addResults(response.data.results);
      ref.read(inspectionPaginationProvider.notifier).state =
          response.data.next?.toString();
    } catch (e) {
      print('Error loading more data: $e');
    } finally {
      ref.read(loadingMoreProvider.notifier).state = false;
    }
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchQueryProvider.notifier).state = value;

      // Mostrar loading durante el proceso de búsqueda
      ref.read(loadinginspectionsProvider.notifier).changeloading(true);

      _loadInitialData(); // Recargar con nuevo filtro
    });
  }

  /// Invalida todos los providers relacionados con las inspecciones
  /// para forzar una carga completamente fresca de datos
  void _invalidateAllProviders() {
    final queryParams = ref.read(queryParamsProvider);

    // Invalidar el provider principal de servicio
    ref.invalidate(inspectionAllServiceProvider(queryParams));

    // También invalidar con diferentes parámetros de consulta para limpiar caché
    ref.invalidate(inspectionAllServiceProvider);
  }

  /// Maneja la acción de actualización pull-to-refresh de la pantalla.

  /// Lee los parámetros de consulta actuales del provider, invalida el caché
  /// del servicio de inspecciones y espera a que se complete la nueva petición
  /// de datos. Este método se ejecuta cuando el usuario desliza hacia abajo
  /// para refrescar el contenido.
  ///
  /// Retorna un [Future<void>] que se completa cuando la operación de
  /// actualización ha terminado.

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
      ref.read(inspectionsProvider.notifier).clearResults();
      ref.read(inspectionPaginationProvider.notifier).state = null;

      // Cargar datos frescos y esconder inmediatamente al recibir respuesta
      final queryParams = ref.read(queryParamsProvider);
      ref.read(loadinginspectionsProvider.notifier).changeloading(true);

      // Invalidar para nueva llamada
      ref.invalidate(inspectionAllServiceProvider(queryParams));

      // Obtener datos frescos
      final response =
          await ref.read(inspectionAllServiceProvider(queryParams).future);

      // Actualizar estado con nuevos datos INMEDIATAMENTE
      if (mounted) {
        ref
            .read(inspectionsProvider.notifier)
            .replaceResults(response.data.results);
        ref.read(inspectionPaginationProvider.notifier).state =
            response.data.next?.toString();
      }
    } catch (e) {
      if (context.mounted) {
        ToastHelper.show_alert(context, "Error al actualizar las inspecciones");
      }
      if (mounted) {
        ref.read(inspectionsProvider.notifier).clearResults();
        ref.read(inspectionPaginationProvider.notifier).state = null;
      }
    } finally {
      // Asegurar que se deshabilite loading
      if (mounted) {
        ref.read(loadinginspectionsProvider.notifier).changeloading(false);
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
    final search = ref.watch(searchQueryProvider);
    return {
      if (search.isNotEmpty) 'search': search,
    };
  });

  @override
  Widget build(BuildContext context) {
    final inspectionsList = ref.watch(inspectionsProvider);
    final isLoading = ref.watch(loadinginspectionsProvider);
    final isLoadingMore = ref.watch(loadingMoreProvider);

    return Scaffold(
      backgroundColor: Apptheme.backgroundColor,
      floatingActionButton: ScrollToTopFab(
        scrollController: _scrollController,
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
      floatingActionButtonLocation: CustomFABLocation(
        offsetX: 60, // Valor fijo en píxeles para X
        offsetY: 200, // Valor fijo en píxeles para Y
      ),
      appBar: AppBar(
          backgroundColor: Apptheme.backgroundColor,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                child: SvgPicture.asset(
                  'assets/icons/logo_lorryv2.svg',
                  width: 100, // Ajusta el tamaño según sea necesario
                  height: 18,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BluetoothTag(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const BluetoothBottomSheet(),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  NotificationButton(
                    onPressed: () {
                      ref.read(appRouterProvider).push("/notifications");
                    },
                  )
                ],
              )
            ],
          )),
      body: SafeArea(
        child: Column(
          children: [
            // Elementos estáticos - Perfil, título y búsqueda
            Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Profile(),
                    const SizedBox(height: 30),
                    Text(
                      "ÚLTIMAS INSPECCIONES",
                      style: Apptheme.h4HighlightBody(
                        context,
                        color: Apptheme.textColorSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
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

            // Lista scrollable de inspecciones
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
                      : inspectionsList.isEmpty && !isLoading
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: const [
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child:
                                        Text('No se encontraron inspecciones'),
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),

                              // OPTIMIZACIONES DE RENDIMIENTO MEJORADAS
                              cacheExtent: 500.0, // Reducido para menos memoria
                              addAutomaticKeepAlives:
                                  false, // Evita mantener widgets fuera de pantalla
                              addRepaintBoundaries: true, // Mejora el repaint
                              addSemanticIndexes:
                                  false, // Reduce cálculos innecesarios

                              // OPTIMIZACIÓN CRÍTICA: Altura fija para mejor rendimiento
                              // itemExtent: 190.0,

                              itemCount: inspectionsList.length +
                                  (isLoadingMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index < inspectionsList.length) {
                                  final inspection = inspectionsList[index];

                                  // OPTIMIZACIÓN: Key más eficiente
                                  final itemKey = ValueKey(
                                      '${inspection.vehicle.licensePlate}_$index');

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: ItemHistorial(
                                      key: itemKey,
                                      historical: inspection,
                                      isSelected: selectedIndex == index,
                                      onTap: () {
                                        // OPTIMIZACIÓN: Solo llamar setState si realmente cambió
                                        final newSelectedIndex =
                                            selectedIndex == index
                                                ? null
                                                : index;
                                        if (newSelectedIndex != selectedIndex) {
                                          setState(() {
                                            selectedIndex = newSelectedIndex;
                                          });
                                        }
                                      },
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
            BottomButton(
              params: BottombuttonParams(
                  text: "Iniciar nueva inspección",
                  onPressed: () {
                    ref.read(appRouterProvider).push('/ManualPlateRegister');
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class _Profile extends StatefulWidget {
  const _Profile();

  @override
  State<_Profile> createState() => _ProfileState();
}

class _ProfileState extends State<_Profile> {
  User authUser = User();

  @override
  void initState() {
    super.initState();
    HelpersGeneral.getAuthUser().then((value) {
      setState(() {
        authUser = value;
      });
    });
  }

  String _getInitials() {
    String firstName = authUser.persons?.name ?? '';
    String lastName = authUser.persons?.lastName ?? '';

    String firstInitial =
        firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    String lastInitial = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';

    if (firstInitial.isEmpty && lastInitial.isEmpty) {
      return 'U'; // Default to 'U' for User if no name available
    }

    return firstInitial + lastInitial;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Apptheme.primary,
            child: CircleAvatar(
              radius: 22,
              backgroundColor:
                  authUser.image != null ? Colors.transparent : Colors.grey,
              backgroundImage:
                  authUser.image != null ? NetworkImage(authUser.image!) : null,
              child: authUser.image == null
                  ? Text(_getInitials(),
                      style: Apptheme.h4HighlightBody(context,
                          color: Apptheme.backgroundColor))
                  : null,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  '${authUser.persons?.name ?? ''} ${authUser.persons?.lastName ?? ''}'
                          .trim()
                          .isNotEmpty
                      ? '${authUser.persons?.name ?? ''} ${authUser.persons?.lastName ?? ''}'
                          .trim()
                      : 'Usuario',
                  style:
                      Apptheme.h4HighlightBody(context, color: Apptheme.gray)),
              Text(
                authUser.groups?.isNotEmpty == true
                    ? authUser.groups![0].name ?? ''
                    : '',
                style: Apptheme.h5Body(context, color: Apptheme.lightGray),
              ),
            ],
          ),
          const Spacer(),
          HomeMenu(),
        ],
      ),
    );
  }
}

class HomeMenu extends ConsumerWidget {
  const HomeMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void logOut() async {
      try {
        final response = await Authservice.logout();
        if (!context.mounted) return;

        if (response.success == true) {
          ToastHelper.show_alert(context, "Sesión cerrada correctamente");

          // Clear stored data
          Preferences pref = Preferences();
          await pref.init();
          pref.removeKey("token");
          pref.removeKey("refresh-token");
          pref.removeKey("menu");
          pref.removeKey("user");
          await Future.delayed(Duration(seconds: 1));
          if (context.mounted) {
            ref.read(appRouterProvider).go('/');
          }
        } else {
          if (context.mounted) {
            ToastHelper.show_alert(context, "Error al cerrar sesión");
          }
        }
      } catch (e) {
        if (context.mounted) {
          ToastHelper.show_alert(context, "Error al cerrar sesión");
        }
      }
    }

    return PopupMenuButton<String>(
      color: Colors.white,
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      offset: const Offset(-30, 20),
      onSelected: (value) async {
        if (!context.mounted) return;

        switch (value) {
          case 'change_password':
            ref.read(appRouterProvider).push('/ChangePassword');
            break;
          case 'logout':
            logOut();
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'change_password',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                child: Text(
                  "Cambiar contraseña",
                  textAlign: TextAlign.end,
                  style: Apptheme.h5Body(context,
                      color: Apptheme.textColorSecondary),
                ),
              ),
              SvgPicture.asset(
                'assets/icons/Icono_changePass.svg',
                width: 25,
                height: 25,
              ),
            ],
          ),
        ),
        const PopupMenuDivider(
          height: 1,
          thickness: .2,
        ),
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(right: 8),
                child: Text(
                  'Cerrar sesión',
                  textAlign: TextAlign.end,
                  style: Apptheme.h5Body(context,
                      color: Apptheme.textColorSecondary),
                ),
              ),
              SvgPicture.asset(
                'assets/icons/Icono_cerrar_sesion.svg',
                width: 25,
                height: 25,
              ),
            ],
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.grey),
    );
  }
}
