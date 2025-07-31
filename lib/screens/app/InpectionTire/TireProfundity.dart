// ignore_for_file: use_build_context_synchronously
import 'package:app_lorry/helpers/ToastHelper.dart';
import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/providers/auth/loginProvider.dart';
import 'package:app_lorry/routers/app_routes.dart';
import 'package:app_lorry/services/InspectionService.dart';
import 'package:app_lorry/widgets/buttons/CustomButton.dart';
import 'package:app_lorry/widgets/shared/back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/config/app_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  // Lista para trackear qué llantas han sido inspeccionadas
  Set<int> inspectedTires = {};

  int _currentTireIndex = 0;

  @override
  void initState() {
    super.initState();

    final data = widget.data;
    licensePlate = data.vehicle;
    mountings = data.data;

    // Establecer el índice inicial (puede venir desde un botón específico)
    _currentTireIndex = data.startIndex ?? 0;

    // Inicializar los datos de inspección con los valores originales
    _initializeInspectionData();
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

    return comparisons.any((isInvalid) => isInvalid);
  }

  void _onTireDataChanged(Map<String, dynamic> data) {
    final currentData = inspectionData[_currentTireIndex] ?? {};

    inspectionData[_currentTireIndex] = {
      'mounting': data['mounting'] ?? currentData['mounting'],
      'pressure': data['pressure'] ?? currentData['pressure'],
      'prof_external': data['prof_external'] ?? currentData['prof_external'],
      'prof_center': data['prof_center'] ?? currentData['prof_center'],
      'prof_internal': data['prof_internal'] ?? currentData['prof_internal'],
    };

    // Solo triggerea un rebuild - btnDisabled se recalcula automáticamente
    setState(() {});
  }

  Future<InspectionResponse> _onFinish() async {
    List<Map<String, dynamic>> inspections = [];
    ref.read(loadingProviderProvider.notifier).changeLoading(true);

    for (int i = 0; i < mountings.length; i++) {
      final data = inspectionData[i];

      inspections.add({
        "unmount": false,
        "tire_mounting": 0,
        "mounting": data?['mounting'] ?? 0,
        "pressure": data?['pressure'] ?? 0,
        "prof_external": data?['prof_external'] ?? 0,
        "prof_center": data?['prof_center'] ?? 0,
        "prof_internal": data?['prof_internal'] ?? 0,
        "novelty": [],
        "service": [],
        "service_action": []
      });
    }

    final jsonInspectionData = {
      "mileage": {"vehicle": licensePlate, "km": widget.data.mileage.toInt()},
      "inspections": inspections
    };

    return await InspectionService.createInspection(jsonInspectionData);
  }

  @override
  Widget build(BuildContext context) {
    final currentMounting = mountings[_currentTireIndex];
    final isLoading = ref.watch(loadingProviderProvider);
    return Scaffold(
      backgroundColor: Apptheme.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitleWidget(currentMounting.position.toString()),
                    const SizedBox(height: 25),
                    TireInspectionForm(
                      currentMounting: currentMounting,
                      onDataChanged: _onTireDataChanged,
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomButtons(
              isLast: inspectedTires.length >= mountings.length - 1,
              isFirst: inspectedTires.isEmpty,
              isLoading: isLoading,
              onNext: _nextTire,
              onFinish: () =>
                  proceedWithPlateInspection(context, ref, "DEFAULT_PLATE"),
              btnDisabled: btnDisabled,
            ),
            const SizedBox(height: 0),
          ],
        ),
      ),
    );
  }

  void proceedWithPlateInspection(
      BuildContext context, WidgetRef ref, String plate) async {
    try {
      final response = await _onFinish();

      if (response.success == true) {
        // Navegar al home
        ref.read(loadingProviderProvider.notifier).changeLoading(false);
        ref.read(appRouterProvider).replace("/home");
        ToastHelper.show_success(context, "Inspección enviada con éxito.");
      } else {
        ref.read(loadingProviderProvider.notifier).changeLoading(false);
        ToastHelper.show_alert(context, "Error al enviar la inspección.");
      }
    } catch (e) {
      ref.read(loadingProviderProvider.notifier).changeLoading(false);
      Navigator.of(context, rootNavigator: true).pop();
      ToastHelper.show_alert(context, "Error al consultar la placa: $e");
    }
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.only(top: 30, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Back(),
          IconButton(
            onPressed: () => context.go('/home'),
            icon: SvgPicture.asset(
              'assets/icons/Icono_Casa_Lorry.svg',
              width: 40,
              height: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleWidget(String position) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 22,
              color: Apptheme.textColorSecondary,
              fontWeight: FontWeight.bold,
            ),
            children: [
              const TextSpan(text: "Inspección Llanta "),
              TextSpan(
                text: 'P$position',
                style: const TextStyle(
                  color: Apptheme.textColorPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        const Image(
          image: AssetImage('assets/icons/Alert_Icon.png'),
          width: 20,
          height: 20,
        ),
      ],
    );
  }

  Widget _buildBottomButtons({
    required bool isLast,
    required bool isFirst,
    required VoidCallback onNext,
    required VoidCallback onFinish,
    required bool btnDisabled,
    required bool isLoading,
  }) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          children: [
            // Botón siguiente/finalizar
            Expanded(
              child: CustomButton(
                340,
                46,
                isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        isLast
                            ? "Finalizar Inspección"
                            : "Siguiente Inspección",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                btnDisabled || isLoading
                    ? null
                    : isLast
                        ? onFinish
                        : onNext,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _currentTireIndex = 0; // Reset
    super.dispose();
  }
}
