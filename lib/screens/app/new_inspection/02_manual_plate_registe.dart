import 'dart:io';
import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/widgets/buttons/CustomButton.dart';
import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/routers/app_routes.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ManualPlateRegister extends ConsumerStatefulWidget {
  const ManualPlateRegister({super.key});

  @override
  ConsumerState<ManualPlateRegister> createState() =>
      _ManualPlateRegisterState();
}

class _ManualPlateRegisterState extends ConsumerState<ManualPlateRegister> {
  final TextEditingController _plateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Esto ayuda
      backgroundColor: Apptheme.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () => ref.read(appRouterProvider).push('/home'),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Centrar horizontalmente
          children: [
            const Text(
              "Registro De Placa",
              style: TextStyle(
                fontSize: 23,
                color: Apptheme.textColorSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            //Mensaje de alerta dentro de un contenedor blanco
            Container(
              width: 342,
              height: 68,
              padding: const EdgeInsets.only(top: 26, bottom: 22),
              decoration: const BoxDecoration(
                color: Colors.white, // Fondo blanco
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), //  Borde superior izquierdo
                  topRight: Radius.circular(8), //  Borde superior derecho
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 20), // Mueve el contenido a la derecha
                  const Image(image: AssetImage('assets/icons/Alert_Icon.png')),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Digite manualmente la placa",
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 12,
                        color: Apptheme.textColorSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 2),

            // Sección de ingreso de placa dentro de un contenedor blanco con borde inferior redondeado
            Container(
              width: 342,
              height: 170,
              padding: const EdgeInsets.only(top: 22, bottom: 26),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft:
                      Radius.circular(8), // Mantener redondeado si lo deseas
                  bottomRight:
                      Radius.circular(8), // Mantener redondeado si lo deseas
                ),
              ),
              child: Column(
                children: [
                  // Campo de texto con icono
                  Container(
                    width: 292,
                    height: 46,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/Car_Icon.svg',
                          width: 24,
                          height: 24,
                          color: Apptheme.textColorPrimary,
                        ),
                        const SizedBox(width: 5), // Reducimos el espacio
                        IntrinsicWidth(
                          child: TextField(
                            controller: _plateController,
                            maxLength: 6,
                            textCapitalization: TextCapitalization.characters,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Apptheme.textColorPrimary,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              counterText: "",
                              hintText: "WMB 268",
                              hintStyle: TextStyle(
                                color: Apptheme.textColorPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Botón "Guardar"
                  Center(
                    child: CustomButton(
                      292, // Ancho
                      46, // Alto
                      const Text(
                        "Guardar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      () => _validateAndShowDialog(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// Validar si el campo de placa está vacío antes de mostrar el diálogo
  void _validateAndShowDialog(BuildContext context) {
    if (_plateController.text.isEmpty) {
      ToastHelper.show_alert(context, "La placa es requerida.");
      return; // Salir si el campo está vacío
    }
    _showSaveConfirmationDialog(context);
  }

  void _showSaveConfirmationDialog(BuildContext context) {
    final plate = _plateController.text;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Center(
            child: Text(
              "PLACA $plate",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Apptheme.textColorPrimary,
              ),
            ),
          ),
          content: const Text(
            "¿Deseas iniciar el proceso de inspección con este vehículo?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Apptheme.textColorSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                "Cancelar",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Apptheme.primary,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Apptheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: const BorderSide(width: 2, color: Apptheme.darkorange),
                ),
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await proceedWithPlateInspection(context, ref, plate);
              },
              child: const Text(
                "Aceptar",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> proceedWithPlateInspection(
      BuildContext context, WidgetRef ref, String plate) async {
    // Mostrar pantalla de carga
    showDialog(
      context: context,
      barrierDismissible: false, // Evita que se cierre tocando fuera
      builder: (BuildContext context) {
        return Container(
          color: Colors.white
              .withOpacity(0.9), // Fondo de color primario con opacidad
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Apptheme.primary), // Blanco sobre fondo primary
            ),
          ),
        );
      },
    );

    try {
      final response =
          await ManualPlateRegisterService.getMountingByPlate(plate, ref);

      // Cerrar el loading
      Navigator.of(context, rootNavigator: true).pop();

      print("Success: ${response.success}");
      print("Data: ${response.data}");

      if (response.success == false) {
        final mensaje = response.messages?.isNotEmpty == true
            ? response.messages!.first
            : "Vehículo no encontrado.";

        ToastHelper.show_alert(context, mensaje);
        return;
      }

      final firstResult = response.data?.results?.first;

      final isValidResult = firstResult != null &&
          (firstResult.licensePlate?.isNotEmpty ?? false);

      if (isValidResult) {
        final hasTires =
            firstResult.tires != null && firstResult.tires!.isNotEmpty;

        if (!hasTires) {
          ToastHelper.show_alert(context, "Vehículo sin llantas registradas.");
          return;
        } else {
          ToastHelper.show_success(context, "Vehículo encontrado con éxito.");
        }

        final extraData = {
          'licensePlate': firstResult.licensePlate,
          'typeVehicleName': firstResult.typeVehicleName,
          'workLineName': firstResult.workLineName,
          'businessName': firstResult.businessName,
          'mileage': firstResult.mileage,
        };

        if (hasTires) {
          extraData['tires'] =
              firstResult.tires!.map((tire) => tire.toJson()).toList();
        }

        ref.read(appRouterProvider).push('/InfoVehicles', extra: extraData);
      } else {
        ToastHelper.show_alert(context, "Vehículo no encontrado.");
      }
    } catch (e) {
      // Cerrar el loading en caso de error también
      Navigator.of(context, rootNavigator: true).pop();
      print("extra: $e");
      ToastHelper.show_alert(context, "Error al consultar la placa: $e");
    }
  }

  @override
  void dispose() {
    _plateController.dispose();
    super.dispose();
  }
}
