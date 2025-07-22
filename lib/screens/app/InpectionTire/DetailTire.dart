import 'package:app_lorry/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/widgets/buttons/CustomButton.dart';
import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/routers/app_routes.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class DetailTire extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  const DetailTire({super.key, required this.data});

  @override
  ConsumerState<DetailTire> createState() => _DetailTireState();
}

class _DetailTireState extends ConsumerState<DetailTire> {
  final TextEditingController _plateController = TextEditingController();

  late final String licensePlate;
  late final String typeVehicleName;
  late final String workLineName;
  late final String businessName;
  late final double mileage;
  late final double _mileage;
  late final List<Tire> tires;

  @override
  void initState() {
    super.initState();
    final data = widget.data;

    licensePlate = data['licensePlate'] ?? '';
    typeVehicleName = data['typeVehicleName'] ?? '';
    workLineName = data['workLineName'] ?? '';
    businessName = data['businessName'] ?? '';
    mileage = (data['mileage'] as num?)?.toDouble() ?? 0.0;
    _mileage = (data['_mileage'] as num?)?.toDouble() ?? 0.0;

    tires = (data['tires'] as List<dynamic>?)
            ?.map((e) => Tire.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    tires.sort((a, b) {
      final aPos =
          int.tryParse(a.positions?.replaceAll(RegExp(r'[^0-9]'), '') ?? '') ??
              0;
      final bPos =
          int.tryParse(b.positions?.replaceAll(RegExp(r'[^0-9]'), '') ?? '') ??
              0;
      return aPos.compareTo(bPos);
    });
    _plateController.text = NumberFormat('#,###').format(_mileage.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Apptheme.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white, //  Fondo blanco
        title: GestureDetector(
          onTap: () {
            if (ref.watch(appRouterProvider) case var router) {
              router.go(
                '/InfoVehicles',
                extra: {
                  'licensePlate': licensePlate,
                  'typeVehicleName': typeVehicleName,
                  'workLineName': workLineName,
                  'businessName': businessName,
                  'mileage': mileage,
                  '_mileage': widget.data['_mileage'],
                  'tires': tires
                      .map((tire) => tire.toJson())
                      .toList(), // asegúrate de que Tire tenga toJson()
                },
              );
            }
          },
          child: const Row(
            children: [
              Icon(Icons.arrow_back_ios_new_rounded,
                  color: Apptheme.textColorPrimary),
              SizedBox(width: 4),
              Text(
                'Atrás',
                style: TextStyle(
                  fontSize: 20,
                  color: Apptheme.textColorPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.all(10),
            icon: SvgPicture.asset(
              'assets/icons/Icono_Casa_Lorry.svg',
              width: 40, // Ajusta el tamaño según sea necesario
              height: 40,
            ),
            onPressed: () {
              ref.read(appRouterProvider).push('/home');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 30,
                right: 30,
                top: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom * 0.2,
              ),
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
                  for (var i = 0; i < tires.length; i++)
                    _buildTireCard(tires[i]),
                ],
              ),
            ),
          ),

          // Botón fijo en la parte inferior
          _buildBottomButton(tires),
        ],
      ),
    );
  }

  /// Widget del kilometraje de la inspección
  Widget _buildMileageInpection() {
    // Recalcula cada vez que se construye el widget
    final double updatedMileage =
        (widget.data['_mileage'] as num?)?.toDouble() ?? 0.0;

    return Container(
      width: 342,
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
            width: 292,
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
                  color: Color(0xFFB0BEC5),
                ),
                const SizedBox(width: 8),
                Text(
                  NumberFormat('#,###').format(updatedMileage.toInt()),
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
  Widget _buildTireCard(Tire tire) {
    // Extraer número de posición como entero desde "P1", "P2", etc.
    int positionNumber =
        int.tryParse(tire.positions?.replaceAll(RegExp(r'[^0-9]'), '') ?? '') ??
            0;

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
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: SvgPicture.asset(
                    'assets/icons/Llanta_completa.svg',
                    width: 100,
                    height: 214,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                left: 10,
                bottom: 10,
                child: Text(
                  tire.positions ?? 'P?',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
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
                  _buildTireRow(
                    "Id Llanta",
                    tire.integrationCode ?? '-',
                    "Diseño",
                    tire.design ?? '-',
                  ),
                  const SizedBox(height: 8),
                  _buildTireRow(
                    "Marca",
                    tire.brand ?? '-',
                    "Banda",
                    tire.band ?? '-',
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 290,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {
                        ref
                            .read(appRouterProvider)
                            .go('/TireProfundity/$positionNumber');
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
                        elevation: 0,
                      ),
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
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 8),
          buildTireInfo(value),
        ],
      ),
    );
  }

  /// Botón de la parte inferior
  /// Botón de la parte inferior
  Widget _buildBottomButton(List<Tire> tires) {
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
          // Pasamos toda la lista de llantas a la ruta
          ref.read(appRouterProvider).push(
            '/TireProfundity',
            extra: {
              'licensePlate': licensePlate,
              'typeVehicleName': typeVehicleName,
              'workLineName': workLineName,
              'businessName': businessName,
              'mileage': mileage,
              'tires': tires.map((t) => t.toJson()).toList(),
            },
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
        border: Border.all(width: 2, color: Colors.grey),
      ),
      child: Center(
        child: Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
