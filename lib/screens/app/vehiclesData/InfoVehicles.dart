import 'dart:io';
import 'package:app_lorry/helpers/InfoRow.dart';
import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/models/ManualPlateRegisterResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/widgets/buttons/CustomButton.dart';
import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/routers/app_routes.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class InfoVehicles extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  const InfoVehicles({super.key, required this.data});

  @override
  ConsumerState<InfoVehicles> createState() => _InfoVehiclesState();
}

class _InfoVehiclesState extends ConsumerState<InfoVehicles> {
  final TextEditingController _plateController = TextEditingController();

  late final String licensePlate;
  late final String typeVehicleName;
  late final String workLineName;
  late final String businessName;
  late final double mileage;
  double _mileage = 0;
  late final List<Tire> tires;
  final ValueNotifier<bool> isButtonEnabled = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    final data = widget.data;

    licensePlate = data['licensePlate'] ?? '';
    typeVehicleName = data['typeVehicleName'] ?? '';
    workLineName = data['workLineName'] ?? '';
    businessName = data['businessName'] ?? '';
    mileage = data['mileage'] ?? 0.0;

    tires = (data['tires'] as List<dynamic>?)
            ?.map((e) => Tire.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    _mileage = data['_mileage'] ?? mileage;
    _plateController.text = NumberFormat('#,###').format(_mileage.toInt());
    _plateController.addListener(_onMileageChanged);

    _onMileageChanged(); // evalúa el botón desde el inicio
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Esto ayuda
      backgroundColor: Apptheme.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white, //  Fondo blanco
        title: GestureDetector(
          onTap: () {
            ref.read(appRouterProvider).pushReplacement('/ManualPlateRegister');
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
              width: 40,
              height: 40,
            ),
            onPressed: () {
              ref.read(appRouterProvider).push('/home');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
            left: 30,
            right: 30,
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom * 0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título + Placa
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Datos De VHC",
                  style: TextStyle(
                    fontSize: 23,
                    color: Apptheme.textColorSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: 128,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFF32966C),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    width: 118,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF32966C),
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      licensePlate,
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Info Container
            Container(
              width: 342,
              height: 350,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InfoRow(title: 'Tipo de vehículo', value: typeVehicleName),
                  const SizedBox(height: 12),
                  InfoRow(title: 'Línea de trabajo', value: workLineName),
                  const SizedBox(height: 12),
                  InfoRow(
                    title: 'Cliente asociado al vehículo',
                    value: businessName,
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Última medición Kilometraje',
                        style: TextStyle(
                          fontSize: 14,
                          color: Apptheme.textColorSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/Icono_Velocimetro_Lorry.svg',
                            width: 24,
                            height: 24,
                            color: Apptheme.textColorPrimary,
                          ),
                          const SizedBox(width: 8),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      '${NumberFormat('#,###').format(mileage.toInt())} ',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Apptheme.textColorPrimary,
                                  ),
                                ),
                                const TextSpan(
                                  text: 'KM',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Apptheme.textColorPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Alerta
            Container(
              width: 342,
              height: 84,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/Alert_Icon.png',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Para realizar una nueva inspección, primero debes actualizar el kilometraje",
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
            const SizedBox(height: 1),

            // Campo para actualizar kilometraje
            Container(
              width: 342,
              height: 170,
              padding: const EdgeInsets.only(top: 22, bottom: 26),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 292,
                    height: 46,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/Icono_Velocimetro_Lorry.svg',
                          width: 24,
                          height: 24,
                          color: Apptheme.textColorPrimary,
                        ),
                        const SizedBox(width: 3),
                        IntrinsicWidth(
                          child: TextField(
                            controller: _plateController
                              ..text =
                                  NumberFormat('#,###').format(_mileage.toInt())
                              ..selection = TextSelection.collapsed(
                                offset: NumberFormat('#,###')
                                    .format(_mileage.toInt())
                                    .length,
                              ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              ThousandsSeparatorInputFormatter(),
                            ],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              height: 0.2,
                              fontWeight: FontWeight.bold,
                              color: Apptheme.textColorPrimary,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: Apptheme.textColorPrimary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 3),
                        const Text(
                          "KM",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Apptheme.textColorPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ValueListenableBuilder<bool>(
                    valueListenable: isButtonEnabled,
                    builder: (context, enabled, _) {
                      return Opacity(
                        opacity: enabled ? 1.0 : 0.5,
                        child: IgnorePointer(
                          ignoring: !enabled,
                          child: CustomButton(
                            292,
                            46,
                            const Text("Actualizar Kilometraje"),
                            () => _validateAndShowDialog(context),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _validateAndShowDialog(BuildContext context) {
    if (_plateController.text.isEmpty) {
      ToastHelper.show_alert(context, "El kilometraje es requerido.");
      return;
    }
    ref.read(appRouterProvider).push(
      '/DetailTire',
      extra: {
        'licensePlate': licensePlate,
        'typeVehicleName': typeVehicleName,
        'workLineName': workLineName,
        'businessName': businessName,
        '_mileage': _mileage,
        'mileage': mileage,
        'tires': tires.map((t) => t.toJson()).toList(),
      },
    );
  }

  void _onMileageChanged() {
    final cleanedInput = _plateController.text.replaceAll(RegExp(r'[.,]'), '');
    final inputMileage = int.tryParse(cleanedInput) ?? 0;

    setState(() {
      isButtonEnabled.value = inputMileage >= mileage.toInt();
      _mileage = inputMileage.toDouble();
    });
  }

  @override
  void dispose() {
    _plateController.dispose();
    isButtonEnabled.dispose();
    super.dispose();
  }
}
