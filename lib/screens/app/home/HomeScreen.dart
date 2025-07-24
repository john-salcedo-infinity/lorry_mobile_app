import 'dart:async';

import 'package:app_lorry/services/services.dart';
import 'package:app_lorry/widgets/forms/customInput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/providers/app/home/homeProvider.dart';
import 'package:app_lorry/routers/app_routes.dart';
import 'package:app_lorry/widgets/buttons/CustomButton.dart';
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
  final ScrollController _scrollController = ScrollController();

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
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreData();
    }
  }

  Future<void> _loadInitialData() async {
    final queryParams = ref.read(queryParamsProvider);
    ref.read(loadinginspectionsProvider.notifier).changeloading(true);

    try {
      final response =
          await ref.read(inspectionAllServiceProvider(queryParams).future);

      ref
          .read(inspectionsProvider.notifier)
          .replaceResults(response.data.results);
      ref.read(inspectionPaginationProvider.notifier).state =
          response.data.next?.toString();
    } catch (e) {
      if (context.mounted) {
        ToastHelper.show_alert(context, "Error al cargar las inspecciones");
      }
      ref.read(inspectionsProvider.notifier).clearResults();
      ref.read(inspectionPaginationProvider.notifier).state = null;
      print('Error loading initial data: $e');
    } finally {
      ref.read(loadinginspectionsProvider.notifier).changeloading(false);
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

      final response =
          await Homeservice.GetInspectionHistory(ref, newQueryParams);

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
      _loadInitialData(); // Recargar con nuevo filtro
    });
  }

  /// Maneja la acción de actualización pull-to-refresh de la pantalla.

  /// Lee los parámetros de consulta actuales del provider, invalida el caché
  /// del servicio de inspecciones y espera a que se complete la nueva petición
  /// de datos. Este método se ejecuta cuando el usuario desliza hacia abajo
  /// para refrescar el contenido.
  ///
  /// Retorna un [Future<void>] que se completa cuando la operación de
  /// actualización ha terminado.
  ///
  ///
  Future<void> _onRefresh() async {
    ref.read(inspectionsProvider.notifier).clearResults();
    ref.read(inspectionPaginationProvider.notifier).state = null;
    await _loadInitialData();
  }

  @override
  void dispose() {
    _debounce?.cancel();
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
      appBar: AppBar(
        backgroundColor: Apptheme.backgroundColor,
        title: const Image(image: AssetImage('assets/icons/logo_lorryv2.png')),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              color: Apptheme.primary,
              backgroundColor: Apptheme.backgroundColor,
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _Profile(),
                        const SizedBox(height: 10),
                        const Text(
                          "HISTORIAL INSPECCIONES",
                          style: Apptheme.subtitleStyle,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          child: CustomInputField(
                            showBorder: false,
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
                        if (isLoading && inspectionsList.isEmpty)
                          Center(child: Apptheme.loadingIndicator())
                        else ...[
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: inspectionsList.length +
                                (isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index < inspectionsList.length) {
                                return ItemHistorial(
                                  historical: inspectionsList[index],
                                );
                              } else {
                                // Mostrar indicador de carga al final
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Center(
                                      child: Apptheme.loadingIndicator()),
                                );
                              }
                            },
                          ),
                          if (inspectionsList.isEmpty && !isLoading)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text('No se encontraron inspecciones'),
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: CustomButton(
              342,
              46,
              const Text(
                "Iniciar Nueva Inspección",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              () {
                ref.read(appRouterProvider).push('/ManualPlateRegister');
              },
            ),
          ),
        ],
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
          const CircleAvatar(
            radius: 24,
            backgroundColor: Apptheme.primary,
            child: CircleAvatar(
              radius: 21,
              backgroundImage: AssetImage('assets/icons/Vector.png'),
            ),
            // backgroundImage: AssetImage('assets/icons/Vector.png'),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                authUser.name ?? 'Usuario',
                style: Apptheme.titleStylev2,
              ),
              Text(
                authUser.groups?.isNotEmpty == true
                    ? authUser.groups![0].name ?? ''
                    : '',
                style: Apptheme.textMuted,
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
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.1),
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
                  child: const Text("Cambiar Contraseña")),
              SvgPicture.asset(
                'assets/icons/Icono_changePass.svg',
                width: 25, // Ajusta el tamaño según sea necesario
                height: 25,
              ),
            ],
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                child: const Text('Cerrar Sesión'),
              ),
              SvgPicture.asset(
                'assets/icons/Icono_cerrar_sesion.svg',
                width: 25, // Ajusta el tamaño según sea necesario
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
