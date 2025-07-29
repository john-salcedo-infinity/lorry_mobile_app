import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/widgets.dart';

class InspectionDetails extends StatelessWidget {
  final HistoricalResult? historical;
  const InspectionDetails({super.key, this.historical});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: historical != null
          ? SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: Column(children: [
                  _DetailsAppBar(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 10),
                        child: Text(
                          "Datos de VHC",
                          style: Apptheme.titleStyle,
                        ),
                      ),
                      LicensePlate(
                        licensePlate: historical!.vehicle?.licensePlate ?? 'N/A',
                        fontSize: 22,
                      )
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _DetailsBadge(
                          label: "Fecha",
                          value: HelpersGeneral.formatDayDate(
                              historical!.inspection.lastInspectionDate),
                        ),
                        _DetailsBadge(
                          label: "Hora",
                          value:
                              "${historical!.inspection.lastInspectionDate.hour}:${historical!.inspection.lastInspectionDate.minute}:${historical!.inspection.lastInspectionDate.second}",
                        ),
                        _DetailsBadge(
                          label: "Tipo de vehículo",
                          value: historical!.vehicle.typeVehicle?.name ?? 'N/A',
                        ),
                        _DetailsBadge(
                          label: "Línea de trabajo",
                          value: historical!.vehicle.workLine?.name ?? 'N/A',
                        ),
                        _DetailsBadge(
                          label: "Cliente asociado al vehículo",
                          value: historical!.vehicle.customer?.businessName ?? 'N/A',
                        ),
                        _DetailsBadge(
                            label: "Número de llantas",
                            value:
                                historical!.inspection.totalTires.toString()),
                        _DetailsBadge(
                            label: "Inspector",
                            value: historical!.createdBy.fullName),
                        SizedBox(height: 20),
                        Column(
                          children: [
                            Text(
                              "Última medición kilometraje",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Apptheme.textColorSecondary),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/Icono_Velocimetro_Lorry.svg',
                                    width: 30,
                                    height: 30,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "${HelpersGeneral.numberFormat(historical!.inspection.mileage)} KM",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Apptheme.textColorPrimary),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ]),
              ),
            )
          : const Center(child: Text('No hay datos históricos disponibles')),
    );
  }
}

class _DetailsBadge extends StatelessWidget {
  const _DetailsBadge({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Apptheme.textColorSecondary),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 20),
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Apptheme.secondaryv4,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            textAlign: TextAlign.center,
            value,
            style: TextStyle(
                color: Apptheme.textColorPrimary, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}

class _DetailsAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(
        children: [
          Back(),
        ],
      ),
      Row(
        children: [
          IconButton(
            onPressed: () => context.go('/home'),
            icon: SvgPicture.asset(
              'assets/icons/Icono_Casa_Lorry.svg',
              width: 40,
              height: 40,
            ),
          ),
        ],
      )
    ]);
  }
}
