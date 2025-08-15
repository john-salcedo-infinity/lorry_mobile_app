// ignore_for_file: use_build_context_synchronously
import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/providers/auth/loginProvider.dart';
import 'package:app_lorry/routers/app_routes.dart';
import 'package:app_lorry/screens/app/InpectionTire/DetailTire.dart';
import 'package:app_lorry/screens/app/InpectionTire/services/services_screen.dart';
import 'package:app_lorry/widgets/buttons/BottomButton.dart';
import 'package:app_lorry/widgets/dialogs/confirmation_dialog.dart';
import 'package:app_lorry/widgets/shared/back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/config/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'widgets/tire_inspection_form.dart';

class TireProfundityParams {
  final List<MountingResult> data;
  final int vehicle;
  final double mileage;
  final int? startIndex; // Índice desde donde empezar la inspección

  TireProfundityParams({
    required this.data,
    required this.vehicle,
    required this.mileage,
    this.startIndex,
  });
}

class TireProfundity extends ConsumerStatefulWidget {
  final TireProfundityParams data;

  const TireProfundity({super.key, required this.data});

  @override
  ConsumerState<TireProfundity> createState() => _TireProfundityState();
}

class _TireProfundityState extends ConsumerState<TireProfundity> {
  late final int licensePlate; // id del vehículo
  late final List<MountingResult> mountings; // Lista de montajes

  // Mapa para almacenar los datos de inspección de cada mounting
  Map<int, Map<String, dynamic>> inspectionData = {};

  // Mapa para almacenar las novedades de cada mounting
  Map<int, List<Map<String, dynamic>>> noveltiesData = {};

  // Mapa para almacenar los servicios de cada mounting
  Map<int, List<Map<String, dynamic>>> servicesData = {};

  // Lista para trackear qué llantas han sido inspeccionadas
  Set<int> inspectedTires = {};

  int _currentTireIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    final data = widget.data;
    licensePlate = data.vehicle;
    mountings = data.data;

    // Establecer el índice inicial (puede venir desde un botón específico)
    _currentTireIndex = data.startIndex ?? 0;

    // Inicializar el PageController
    _pageController = PageController(initialPage: _currentTireIndex);

    // Inicializar los datos de inspección con los valores originales
    _initializeInspectionData();

    // Marcar la llanta inicial como inspeccionada
    inspectedTires.add(_currentTireIndex);
  }

  void _initializeInspectionData() {
    for (int i = 0; i < mountings.length; i++) {
      final mounting = mountings[i];
      inspectionData[i] = {
        'mounting': mounting.id,
        'pressure': mounting.tire?.pressure ??
            mounting.tire?.design?.dimension?.pressure ??
            0.0,
        'prof_external': mounting.tire?.profExternalCurrent ?? 0.0,
        'prof_center': mounting.tire?.profCenterCurrent ?? 0.0,
        'prof_internal': mounting.tire?.profInternalCurrent ?? 0.0,
      };

      // Inicializar el array de novedades vacío para cada mounting
      noveltiesData[i] = [];
      servicesData[i] = [];
    }
  }

  void _nextTire() {
    // Marcar la llanta actual como inspeccionada
    inspectedTires.add(_currentTireIndex);

    // Si ya inspeccionamos todas las llantas, finalizar
    if (inspectedTires.length >= mountings.length) {
      _currentTireIndex = 0;
      return;
    }

    // Buscar la siguiente llanta no inspeccionada
    int nextIndex = _findNextUninspectedTire();

    setState(() {
      _currentTireIndex = nextIndex;
    });
  }

  int _findNextUninspectedTire() {
    for (int i = 0; i < mountings.length; i++) {
      if (i != _currentTireIndex && !inspectedTires.contains(i)) {
        return i;
      }
    }
    // Si no encontramos ninguna, retornar la actual (esto no debería pasar)
    return _currentTireIndex;
  }

  bool get btnDisabled {
    final currentData = inspectionData[_currentTireIndex];
    if (currentData == null) return false;

    final tire = mountings[_currentTireIndex].tire;

    // Comparar todos los valores de profundidad de una vez
    final comparisons = [
      (currentData["prof_external"] as double? ?? 0.0) >
          (tire?.profExternalCurrent ?? 0.0),
      (currentData["prof_center"] as double? ?? 0.0) >
          (tire?.profCenterCurrent ?? 0.0),
      (currentData["prof_internal"] as double? ?? 0.0) >
          (tire?.profInternalCurrent ?? 0.0),
    ];

    // Verificar si todas las llantas han sido inspeccionadas
    bool allTiresInspected = inspectedTires.length >= mountings.length;

    return comparisons.any((isInvalid) => isInvalid) || !allTiresInspected;
  }

  // Método para obtener los servicios del mounting actual
  List<Map<String, dynamic>> _getCurrentMountingServices() {
    return servicesData[_currentTireIndex] ?? [];
  }

  void _onService() async {
    final currentMounting = mountings[_currentTireIndex];
    final currentServices = _getCurrentMountingServices();

    final result = await context.push(
      '/services',
      extra: ServiceScreenParams(
        currentMountingResult: currentMounting,
        existingServices: currentServices,
      ),
    );

    if (result != null && result is List<Map<String, dynamic>>) {
      servicesData[_currentTireIndex] = result;
      setState(() {});
    }
  }

  void _onFinish() async {
    List<Map<String, dynamic>> inspections = [];

    for (int i = 0; i < mountings.length; i++) {
      final data = inspectionData[i];
      final novelties = noveltiesData[i] ?? [];
      final services = servicesData[i] ?? [];

      inspections.add({
        "unmount": false,
        "tire_mounting": 0,
        "mounting": data?['mounting'] ?? 0,
        "pressure": data?['pressure'] ?? 0,
        "prof_external": data?['prof_external'] ?? 0,
        "prof_center": data?['prof_center'] ?? 0,
        "prof_internal": data?['prof_internal'] ?? 0,
        "novelty": novelties,
        "service": services,
        "service_action": []
      });
    }

    final jsonInspectionData = {
      "mileage": {"vehicle": licensePlate, "km": widget.data.mileage.toInt()},
      "inspections": inspections
    };

    ref.read(appRouterProvider).push(
          "/DetailTire",
          extra: DetailTireParams(
              results: mountings.reversed.toList(),
              vehicle: mountings.first.vehicle!,
              mileage: widget.data.mileage,
              inspectionData: jsonInspectionData),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProviderProvider);
    return Scaffold(
      backgroundColor: Apptheme.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                onPageChanged: (index) {
                  setState(() {
                    _currentTireIndex = index;
                    // Marcar la llanta como inspeccionada cuando el usuario navega a ella
                    // Solo agregar si no está ya en el Set (evita duplicados automáticamente)
                    inspectedTires.add(index);
                  });
                },
                itemCount: mountings.length,
                itemBuilder: (context, index) {
                  final currentMounting = mountings[index];
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitleWidget(currentMounting.position.toString()),
                        const SizedBox(height: 18),
                        TireInspectionForm(
                          currentMounting: currentMounting,
                          onDataChanged: (data) {
                            // Usar el índice específico de esta página
                            final currentData = inspectionData[index] ?? {};
                            inspectionData[index] = {
                              'mounting':
                                  data['mounting'] ?? currentData['mounting'],
                              'pressure':
                                  data['pressure'] ?? currentData['pressure'],
                              'prof_external': data['prof_external'] ??
                                  currentData['prof_external'],
                              'prof_center': data['prof_center'] ??
                                  currentData['prof_center'],
                              'prof_internal': data['prof_internal'] ??
                                  currentData['prof_internal'],
                            };
                            setState(() {});
                          },
                          existingNovelties: noveltiesData[index] ?? [],
                          onNoveltiesChanged: (novelties) {
                            noveltiesData[index] = novelties;
                            setState(() {});
                          },
                          // Pasar los datos ya guardados para esta página específica
                          initialInspectionData: inspectionData[index],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            _buildBottomButtons(
              isLast: _currentTireIndex >= mountings.length - 1,
              isFirst: _currentTireIndex <= 0,
              isLoading: isLoading,
              onNext: _nextTire,
              onFinish: () => _onFinish(),
              onService: () => _onService(),
            ),
            const SizedBox(height: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Back(
      showHome: true,
      showDelete: true,
      showNotifications: true,
      showHomeDialogConfirm: true,
      onBackPressed: () {
        ConfirmationDialog.show(
          context: context,
          title: "¿Estás seguro que deseas regresar?",
          message:
              "Todas las inspecciones registradas no podran ser resturadas",
          onAccept: () => {context.pop()},
        );
      },
      onDeletePressed: () {
        ConfirmationDialog.show(
          context: context,
          title: "Eliminar Inspección",
          message:
              "¿Estás seguro que deseas eliminar la inspección? No podrás deshacer esta acción",
          cancelText: "Cancelar",
          acceptText: "Aceptar",
          onAccept: () {
            ref.read(appRouterProvider).pushReplacement('/ManualPlateRegister');
          },
        );
      },
    );
  }

  Widget _buildTitleWidget(String position) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            style:
                Apptheme.h1Title(context, color: Apptheme.textColorSecondary),
            children: [
              const TextSpan(text: "Inspección llanta "),
              TextSpan(
                text: 'P$position',
                style: Apptheme.h1TitleDecorative(
                  context,
                  color: Apptheme.secondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        const Icon(Icons.error, color: Apptheme.primary),
      ],
    );
  }

  Widget _buildBottomButtons({
    required bool isLast,
    required bool isFirst,
    required VoidCallback onNext,
    required VoidCallback onService,
    required VoidCallback onFinish,
    required bool isLoading,
  }) {
    return BottomButton(
      gap: 20,
      buttons: [
        BottomButtonItem(
          text: "Servicios",
          buttonType: 2,
          onPressed: onService,
          customChild: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Servicios",
                style: Apptheme.h4HighlightBody(
                  context,
                  color: Apptheme.alertOrange,
                ),
              ),
              if (_getCurrentMountingServices().isNotEmpty) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: const BoxDecoration(
                    color: Apptheme.primary,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  child: Text(
                    '${_getCurrentMountingServices().length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        BottomButtonItem(
          text: 'Finalizar Inspección',
          onPressed: onFinish,
          disabled: !isLast || btnDisabled || isLoading,
          isLoading: isLoading,
          customChild: Text(
            'Finalizar Inspección',
            style: Apptheme.h4HighlightBody(
              context,
              color: Apptheme.backgroundColor,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentTireIndex = 0; // Reset
    super.dispose();
  }
}
