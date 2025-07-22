import 'package:app_lorry/helpers/ToastHelper.dart';
import 'package:app_lorry/models/ManualPlateRegisterResponse.dart';
import 'package:app_lorry/routers/app_routes.dart';
import 'package:app_lorry/widgets/buttons/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/config/app_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TireProfundity extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  const TireProfundity({super.key, required this.data});

  @override
  ConsumerState<TireProfundity> createState() => _TireProfundityState();
}

class _TireProfundityState extends ConsumerState<TireProfundity> {
  final TextEditingController _plateController = TextEditingController();

  late final String licensePlate;
  late final String typeVehicleName;
  late final String workLineName;
  late final String businessName;
  late final double mileage;
  late final List<Tire> tires;

  final TextEditingController pressureController = TextEditingController();
  final TextEditingController externalProfController = TextEditingController();
  final TextEditingController internalProfController = TextEditingController();
  final TextEditingController centerProfController = TextEditingController();

  int _currentTireIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentTireIndex = 0;

    final data = widget.data;

    licensePlate = data['licensePlate'] ?? '';
    typeVehicleName = data['typeVehicleName'] ?? '';
    workLineName = data['workLineName'] ?? '';
    businessName = data['businessName'] ?? '';
    mileage = (data['mileage'] as num?)?.toDouble() ?? 0.0;

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

    _loadTireData();
  }

  void _loadTireData() {
    if (_currentTireIndex < tires.length) {
      final tire = tires[_currentTireIndex];
      // Carga datos reales si los tienes, aquí ejemplos por defecto:
      pressureController.text = "12.0";
      externalProfController.text = "3.0";
      internalProfController.text = "19.0";
      centerProfController.text = "19.0";
    }
  }

  void _nextTire() {
    if (_currentTireIndex < tires.length - 1) {
      setState(() {
        _currentTireIndex++;
        _loadTireData();
      });
    } else {
      // Reset index (opcional si se destruye la vista al navegar)
      _currentTireIndex = 0;
      // Navega al home, lo que destruye esta vista y reinicia todo
      ref.read(appRouterProvider).go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTire = tires[_currentTireIndex];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Apptheme.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () {
            if (ref.watch(appRouterProvider) case var router) {
              router.go(
                '/DetailTire',
                extra: {
                  'licensePlate': licensePlate,
                  'typeVehicleName': typeVehicleName,
                  'workLineName': workLineName,
                  'businessName': businessName,
                  'mileage': mileage,
                  'tires': tires.map((tire) => tire.toJson()).toList(),
                },
              );
            }
          },
          child: const Row(
            children: [
              Icon(Icons.arrow_back_ios_new_rounded,
                  color: Apptheme.textColorPrimary, size: 20),
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
        // ... botón de casa
        actions: [
          IconButton(
            icon: SvgPicture.asset('assets/icons/Icono_Casa_Lorry.svg',
                width: 40, height: 40),
            onPressed: () {
              _currentTireIndex = 0; // Reset
              ref.read(appRouterProvider).push('/home');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título con posición dinámica
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    children: [
                      const TextSpan(text: "Inspección Llanta "),
                      TextSpan(
                        text: currentTire.positions ??
                            'P${_currentTireIndex + 1}',
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
            ),

            const SizedBox(height: 25),

            // Caja del formulario
            Container(
              width: double.infinity,
              height: 565,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFFDDEAE4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "Serie LL-${currentTire.integrationCode ?? 'Sin Serie'}",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Apptheme.textColorPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField("Presión Llanta", currentTire.pressure),
                  const SizedBox(height: 35),
                  _buildTextField(
                      "Profun. Externa", currentTire.profExternalCurrent),
                  const SizedBox(height: 10),
                  _buildTextField(
                      "Profun. Interna", currentTire.profInternalCurrent),
                  const SizedBox(height: 10),
                  _buildTextField(
                      "Profun. Central", currentTire.profCenterCurrent),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const Spacer(flex: 10),
            _buildBottomButtons(isLast: _currentTireIndex == tires.length - 1),
            const SizedBox(height: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, dynamic rawValue,
      {bool isEditable = true}) {
    ValueNotifier<Color> textColor = ValueNotifier<Color>(Colors.black);
    ValueNotifier<Color> backgroundColor = ValueNotifier<Color>(Colors.white);
    ValueNotifier<Color> borderColor = ValueNotifier<Color>(Colors.grey);

    final double value = double.tryParse(rawValue?.toString() ?? '') ?? 0;

    void updateColors(double val) {
      if (val <= 5) {
        textColor.value = const Color(0xFFD32F2F); // Rojo
        backgroundColor.value = const Color(0xFFFFCDD2); // Fondo rojo suave
        borderColor.value = const Color(0xFFD32F2F); // Borde rojo
      } else if (val > 5 && val <= 10) {
        textColor.value = const Color(0xFFFBC02D); // Amarillo
        backgroundColor.value = const Color(0xFFFFF9C4); // Fondo amarillo suave
        borderColor.value = const Color(0xFFFBC02D); // Borde amarillo
      } else {
        textColor.value = const Color(0xFF388E3C); // Verde
        backgroundColor.value = const Color(0xFFC8E6C9); // Fondo verde suave
        borderColor.value = const Color(0xFF388E3C); // Borde verde
      }
    }

    updateColors(value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF494D4C),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        ValueListenableBuilder<Color>(
          valueListenable: textColor,
          builder: (context, textColor, child) {
            return ValueListenableBuilder<Color>(
              valueListenable: backgroundColor,
              builder: (context, backgroundColor, child) {
                return ValueListenableBuilder<Color>(
                  valueListenable: borderColor,
                  builder: (context, borderColor, child) {
                    return TextField(
                      enabled: isEditable,
                      controller: TextEditingController(
                        text: value.toStringAsFixed(1),
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: true), // Teclado numérico
                      textInputAction: TextInputAction
                          .next, // Permite avanzar al siguiente campo
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: backgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: borderColor, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: borderColor, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: borderColor, width: 3),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 16,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Red Hat Mono',
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                        letterSpacing: 0.5,
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomButtons({required bool isLast}) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: CustomButton(
          340,
          46,
          Text(
            isLast ? "Finalizar Inspección" : "Siguiente Inspección",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          // Envolvemos la función proceedWithPlateInspection en una función anónima
          // para que no reciba parámetros
          isLast
              ? () => proceedWithPlateInspection(context, ref,
                  licensePlate) // Cambia el valor de '1234ABC' por la placa que necesites
              : _nextTire, // No necesitas cambios en _nextTire
        ),
      ),
    );
  }

  // _buildTextField() se mantiene igual (tu versión anterior funciona perfecto)
  void proceedWithPlateInspection(
      BuildContext context, WidgetRef ref, String plate) async {
    // Mostrar pantalla de carga

    try {
      // Si hay llantas, verificamos si es la última y mostramos el mensaje de éxito
      ToastHelper.show_success(context, "Inspecciona enviada con éxito.");
      ref.read(appRouterProvider).go('/home');
    } catch (e) {
      // Cerrar el loading en caso de error también
      Navigator.of(context, rootNavigator: true).pop();
      print("extra: $e");
      ToastHelper.show_alert(context, "Error al consultar la placa: $e");
    }
  }

  @override
  void dispose() {
    _currentTireIndex = 0; // Reset
    _plateController.dispose();
    pressureController.dispose();
    externalProfController.dispose();
    internalProfController.dispose();
    centerProfController.dispose();
    super.dispose();
  }
}
