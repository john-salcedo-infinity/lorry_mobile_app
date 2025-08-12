// ignore_for_file: use_build_context_synchronously

import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/providers/auth/loginProvider.dart';
import 'package:app_lorry/screens/app/InpectionTire/TireProfundity.dart';
import 'package:app_lorry/screens/app/InpectionTire/rotation/spinAndRotationScreen.dart';
import 'package:app_lorry/services/InspectionService.dart';
import 'package:app_lorry/widgets/buttons/BottomButton.dart';
import 'package:app_lorry/widgets/buttons/CustomButton.dart';
import 'package:app_lorry/widgets/shared/back.dart';
import 'package:app_lorry/widgets/dialogs/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/routers/app_routes.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class DetailTireParams {
  final List<MountingResult> results;
  final Vehicle vehicle;
  final double mileage;
  final Map<String, Object>? inspectionData;

  DetailTireParams({
    required this.results,
    required this.vehicle,
    required this.mileage,
    this.inspectionData = const {},
  });
}

class DetailTire extends ConsumerStatefulWidget {
  final DetailTireParams data;

  const DetailTire({super.key, required this.data});

  @override
  ConsumerState<DetailTire> createState() => _DetailTireState();
}

class _DetailTireState extends ConsumerState<DetailTire> {
  final TextEditingController _plateController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tires = widget.data.results
        .where((result) => result.tire != null)
        .toList()
        .reversed;
    return Scaffold(
      backgroundColor: Apptheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            // Elementos estáticos - Título y kilometraje
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Llantas de VHC",
                    style: TextStyle(
                      fontSize: 23,
                      color: Apptheme.textColorSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Kilometraje de la inspección
                  _buildMileageInpection(),

                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Lista scrollable de llantas
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: tires.length,
                itemBuilder: (context, index) {
                  final tire = tires.elementAt(index);
                  return _buildTireCard(tire, widget.data.inspectionData);
                },
              ),
            ),

            // Botón fijo en la parte inferior
            _buildBottomButton(tires, widget.data.inspectionData),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    // Observar el estado de loading del provider
    final isLoading = ref.watch(loadingProviderProvider);

    return Back(
      showDelete: true,
      showHome: true,
      showNotifications: true,
      isLoading: isLoading,
      onDeletePressed: () {
        _showDeleteDialog();
      },
    );
  }

  void _showDeleteDialog() {
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
  }

  /// Widget del kilometraje de la inspección
  Widget _buildMileageInpection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            // padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Text(
              "KILOMETRAJE DE LA INSPECCIÓN",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF494D4C),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            height: 46,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFD1D5DB), width: 2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/Icono_Velocimetro_Lorry.svg',
                  width: 24,
                  height: 24,
                  colorFilter:
                      ColorFilter.mode(Color(0xFFB0BEC5), BlendMode.srcIn),
                ),
                const SizedBox(width: 8),
                Text(
                  NumberFormat('#,###').format(widget.data.mileage.toInt()),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB0BEC5),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  "KM",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB0BEC5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Widget de la tarjeta de llanta
  Widget _buildTireCard(
      MountingResult tire, Map<String, Object>? inspectionData) {
    // Verificar si la llanta está inspeccionada
    bool isInspected = false;
    if (inspectionData != null && inspectionData.containsKey('inspections')) {
      final inspections = inspectionData['inspections'] as List<dynamic>;
      isInspected =
          inspections.any((inspection) => inspection['mounting'] == tire.id);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: isInspected ? Apptheme.primary : Colors.transparent,
          width: 1,
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12)],
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Container(
                width: 100,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  color: isInspected
                      ? Apptheme.lightOrange
                      : Apptheme.tireBackground,
                ),
              ),
              Positioned(
                top: -10,
                left: -20,
                child: Image.asset(
                  'assets/icons/Llanta.png',
                  width: 180,
                  height: 259,
                  // fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 10,
                bottom: 10,
                child: Text(
                  'P${tire.position?.toString() ?? '?'}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: isInspected
                        ? Apptheme.primary
                        : Apptheme.textColorPrimary,
                  ),
                ),
              ),
              isInspected
                  ? Positioned(
                      left: 10,
                      top: 10,
                      child: Icon(
                        Icons.check_circle,
                        color: Apptheme.primary,
                        size: 24,
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTireRow(
                      "Serie",
                      "LL-${tire.tire?.integrationCode}",
                      "Diseño",
                      tire.tire!.design?.name as String,
                      isInspected: isInspected),
                  const SizedBox(height: 8),
                  _buildTireRow(
                    "Marca",
                    tire.tire?.design?.brand?.name ?? '-',
                    "Banda",
                    tire.tire?.band?.name ?? '-',
                    isInspected: isInspected,
                  ),
                  const SizedBox(height: 15),
                  CustomButton(
                    double.infinity,
                    46,
                    isInspected
                        ? Text("Inspeccionado")
                        : Text(
                            "Inspeccionar",
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 16),
                          ),
                    isInspected
                        ? null
                        : () {
                            // Encontrar el índice de esta llanta en la lista completa
                            final allTiresIterable = widget.data.results
                                .where((result) => result.tire != null)
                                .toList()
                                .reversed;
                            final allTires = allTiresIterable.toList();

                            final tireIndex = allTires.indexOf(tire);

                            // Navegar a la inspección empezando desde esta llanta específica
                            ref.read(appRouterProvider).push(
                                  '/TireProfundity',
                                  extra: TireProfundityParams(
                                    data: allTires,
                                    vehicle: widget.data.vehicle.id ?? 0,
                                    mileage: widget.data.mileage,
                                    startIndex:
                                        tireIndex, // Empezar desde esta llanta
                                  ),
                                );
                          },
                    type: isInspected ? 2 : 4,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Widget de la fila de información de llanta
  Widget _buildTireRow(
      String label1, String value1, String label2, String value2,
      {bool isInspected = false}) {
    return Row(
      children: [
        _buildTireColumn(label1, value1, isInspected: isInspected),
        const SizedBox(width: 12),
        _buildTireColumn(label2, value2, isInspected: isInspected),
      ],
    );
  }

  /// Widget de una celda de llanta
  Widget _buildTireColumn(String label, String value,
      {bool isInspected = false}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 14,
                color: Apptheme.textColorSecondary,
                fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 4),
          buildTireInfo(value, isInspected: isInspected),
        ],
      ),
    );
  }

  /// Botón de la parte inferior
  Widget _buildBottomButton(Iterable<MountingResult> mountingResults,
      Map<String, Object>? inspectionData) {
    final mountingWithTires =
        mountingResults.where((result) => result.tire != null).toList();

    // Verificar si todas las llantas han sido inspeccionadas
    bool allTiresInspected = false;
    bool thereIsTurnRotation = false;
    List<String> TurnRotationMountigs = <String>[];

    if (inspectionData != null && inspectionData.containsKey('inspections')) {
      final inspections = inspectionData['inspections'] as List<dynamic>;
      allTiresInspected = mountingWithTires.every((tire) =>
          inspections.any((inspection) => inspection['mounting'] == tire.id));
    }

    // Verificar si hay servicios de rotación y guarda sus id de montajes
    if (inspectionData != null && inspectionData.containsKey('inspections')) {
      final inspections = inspectionData['inspections'] as List<dynamic>;
      for (var inspection in inspections) {
        if (inspection['service'] != null) {
          final services = inspection['service'] as List<dynamic>;
          final hasRotationService =
              services.any((service) => service['type_service'] == 19);
          if (hasRotationService) {
            thereIsTurnRotation = true;
            TurnRotationMountigs.add(inspection['mounting'].toString());
          }
        }
      }
    }

    // Observar el estado de loading del provider
    final isLoading = ref.watch(loadingProviderProvider);

    return BottomButton(
      params: BottombuttonParams(
        text: (allTiresInspected && thereIsTurnRotation)
            ? "Realizar Acciones"
            : allTiresInspected
                ? "Finalizar Inspección"
                : "Iniciar Inspección",
        onPressed: () {
          if (allTiresInspected) {
            // Finalizar inspección
            if (thereIsTurnRotation) {
              ref.read(appRouterProvider).push(
                    '/rotation',
                    extra: SpinandrotationParams(
                        results: mountingWithTires,
                        turnRotationMountigs: TurnRotationMountigs,
                        inspectionData: inspectionData),
                  );
            } else {
              _finishInspection(inspectionData);
            }
          } else {
            // Iniciar inspección normal
            ref.read(appRouterProvider).push(
                  '/TireProfundity',
                  extra: TireProfundityParams(
                      data: mountingWithTires,
                      vehicle: widget.data.vehicle.id ?? 0,
                      mileage: widget.data.mileage),
                );
          }
        },
        isLoading: isLoading,
      ),
    );
  }

  // Método para finalizar la inspección
  void _finishInspection(Map<String, Object>? inspectionData) async {
    try {
      ref.read(loadingProviderProvider.notifier).changeLoading(true);
      final response = await InspectionService.createInspection(
          inspectionData as Map<String, Object>);

      ref.read(loadingProviderProvider.notifier).changeLoading(false);
      if (response.success == true) {
        ref.read(appRouterProvider).go("/home");
        ToastHelper.show_success(context, "Inspección enviada con éxito.");
      } else {
        ToastHelper.show_alert(context, "Error al enviar la inspección.");
      }
    } catch (e) {
      ref.read(loadingProviderProvider.notifier).changeLoading(false);
      ToastHelper.show_alert(context, "Error al finalizar la inspección: $e");
    }
  }

  Widget buildTireInfo(String value, {bool isInspected = false}) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 2, color: Apptheme.lightGreen),
      ),
      child: Center(
        child: Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: isInspected ? Apptheme.primary : Apptheme.secondary,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow
              .ellipsis, // Si el texto es muy largo, lo trunca con "..."
        ),
      ),
    );
  }

  @override
  void dispose() {
    _plateController.dispose();
    super.dispose();
  }
}
