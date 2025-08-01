// ignore_for_file: use_build_context_synchronously

import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/providers/auth/loginProvider.dart';
import 'package:app_lorry/screens/app/InpectionTire/TireProfundity.dart';
import 'package:app_lorry/services/InspectionService.dart';
import 'package:app_lorry/widgets/shared/back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/widgets/buttons/CustomButton.dart';
import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/routers/app_routes.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
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
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Llantas De VHC",
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

                      // Tarjetas de llantas generadas dinámicamente
                      for (var result in tires)
                        _buildTireCard(result, widget.data.inspectionData),
                    ],
                  ),
                ),
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

  /// Widget del kilometraje de la inspección
  Widget _buildMileageInpection() {
    return Container(
      width: double.infinity,
      height: 140,
      padding: const EdgeInsets.symmetric(vertical: 26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Text(
              "KILOMETRAJE DE LA INSPECCIÓN",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF494D4C),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
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
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Apptheme.textColorPrimary,
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
                  _buildTireRow("Serie", tire.tire?.integrationCode as String,
                      "Diseño", tire.tire!.design?.name as String,
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
                  SizedBox(
                    width: 290,
                    height: 46,
                    child: Opacity(
                      opacity: isInspected ? 0.5 : 1.0,
                      child: ElevatedButton(
                        onPressed: isInspected
                            ? () {}
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
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            side: BorderSide(
                              color: isInspected
                                  ? Apptheme.primary
                                  : Apptheme.textColorPrimary,
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            elevation: 0),
                        child: Text(
                          isInspected ? "Inspeccionado" : "Inspeccionar",
                          style: TextStyle(
                            color: isInspected
                                ? Apptheme.primary
                                : Apptheme.textColorPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
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
          Text(label,
              style: const TextStyle(fontSize: 12, color: Apptheme.grayInput)),
          const SizedBox(height: 8),
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
    if (inspectionData != null && inspectionData.containsKey('inspections')) {
      final inspections = inspectionData['inspections'] as List<dynamic>;
      allTiresInspected = mountingWithTires.every((tire) =>
          inspections.any((inspection) => inspection['mounting'] == tire.id));
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      color: Colors.white,
      child: CustomButton(
        342,
        46,
        Text(
          allTiresInspected ? "Finalizar Inspección" : "Iniciar Inspección",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        () {
          if (allTiresInspected) {
            // Finalizar inspección
            _finishInspection(inspectionData);
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
        ref.read(appRouterProvider).replace("/home");
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
      width: 110, // Aumentamos el ancho
      height: 38,
      padding:
          const EdgeInsets.symmetric(horizontal: 8), // Reducimos el padding
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
              color: isInspected ? Apptheme.primary : Apptheme.textColorPrimary,
              fontWeight: FontWeight.bold),
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
