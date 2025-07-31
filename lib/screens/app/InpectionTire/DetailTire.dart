import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/screens/app/InpectionTire/TireProfundity.dart';
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

  DetailTireParams({
    required this.results,
    required this.vehicle,
    required this.mileage,
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
                      for (var result in tires) _buildTireCard(result),
                    ],
                  ),
                ),
              ),
            ),

            // Botón fijo en la parte inferior
            _buildBottomButton(tires),
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
  Widget _buildTireCard(MountingResult tire) {
    // Extraer número de posición como entero desde "P1", "P2", etc.

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
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
                  color: Apptheme.tireBackground,
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
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTireRow("Serie", tire.tire?.integrationCode as String,
                      "Diseño", tire.tire!.design?.name as String),
                  const SizedBox(height: 8),
                  _buildTireRow(
                    "Marca",
                    tire.tire?.design?.brand?.name ?? '-',
                    "Banda",
                    tire.tire?.band?.name ?? '-',
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 290,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {
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
                          side: const BorderSide(
                            color: Apptheme.textColorPrimary,
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          elevation: 0),
                      child: const Text(
                        "Inspeccionar",
                        style: TextStyle(
                          color: Apptheme.textColorPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
      String label1, String value1, String label2, String value2) {
    return Row(
      children: [
        _buildTireColumn(label1, value1),
        const SizedBox(width: 12),
        _buildTireColumn(label2, value2),
      ],
    );
  }

  /// Widget de una celda de llanta
  Widget _buildTireColumn(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: Apptheme.grayInput)),
          const SizedBox(height: 8),
          buildTireInfo(value),
        ],
      ),
    );
  }

  /// Botón de la parte inferior
  Widget _buildBottomButton(Iterable<MountingResult> mountingResults) {
    final mountingWithTires =
        mountingResults.where((result) => result.tire != null).toList();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      color: Colors.white,
      child: CustomButton(
        342,
        46,
        const Text(
          "Iniciar Inspección",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        () {
          // Pasamos toda la lista de llantas a la ruta (sin startIndex = empezar desde 0)
          ref.read(appRouterProvider).push(
                '/TireProfundity',
                extra: TireProfundityParams(
                    data: mountingWithTires,
                    vehicle: widget.data.vehicle.id ?? 0,
                    mileage: widget.data.mileage),
              );
        },
      ),
    );
  }

  Widget buildTireInfo(String value) {
    return Container(
      width: 110, // Aumentamos el ancho
      height: 38, // Un poco más alto para mejorar la visibilidad
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
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Apptheme.textColorPrimary),
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
