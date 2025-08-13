import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/providers/app/home/homeProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../widgets/widgets.dart';

class InspectionDetails extends StatefulWidget {
  final HistoricalResult? historical;
  const InspectionDetails({super.key, this.historical});

  @override
  State<InspectionDetails> createState() => _InspectionDetailsState();
}

class _InspectionDetailsState extends State<InspectionDetails> {
  late final Vehicle vehicle;
  late final String formattedDate;
  late final String formattedTime;
  late final String formattedMileage;
  late final String businessName;
  late final String licensePlate;
  late final String totalTires;
  late final String inspectorName;
  late final String lastMileage;

  @override
  void initState() {
    super.initState();
    final inspection = widget.historical!.inspection;
    vehicle = widget.historical!.vehicle;

    formattedDate = HelpersGeneral.formatDayDate(inspection.lastInspectionDate);
    final hour = inspection.lastInspectionDate.hour.toString();
    final minute =
        inspection.lastInspectionDate.minute.toString().padLeft(2, '0');
    final second =
        inspection.lastInspectionDate.second.toString().padLeft(2, '0');
    formattedTime = "$hour:$minute:$second";

    formattedMileage = HelpersGeneral.numberFormat(inspection.mileage);
    businessName = vehicle.customer?.businessName ?? '';
    licensePlate = vehicle.licensePlate ?? '';
    totalTires = "${inspection.totalTires}";
    inspectorName = widget.historical!.createdBy.fullName;
    lastMileage = HelpersGeneral.numberFormat(inspection.mileage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Apptheme.backgroundColor,
      body: widget.historical != null
          ? SafeArea(
              child: SingleChildScrollView(
                child: Column(children: [
                  _DetailsAppBar(),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(children: [
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
                            licensePlate: licensePlate,
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
                            _DetailsBadge(label: "Fecha", value: formattedDate),
                            _DetailsBadge(
                              label: "Hora",
                              value: formattedTime,
                            ),
                            _DetailsBadge(
                              label: "Tipo de vehículo",
                              value: vehicle.typeVehicle?.name ?? 'N/A',
                            ),
                            _DetailsBadge(
                              label: "Línea de trabajo",
                              value: vehicle.workLine?.name ?? 'N/A',
                            ),
                            _DetailsBadge(
                              label: "Cliente asociado al vehículo",
                              value: vehicle.customer?.businessName ?? 'N/A',
                            ),
                            _DetailsBadge(
                                label: "Número de llantas",
                                value: totalTires.toString()),
                            _DetailsBadge(
                                label: "Inspector", value: inspectorName),
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
                                        "$lastMileage KM",
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
    return Back(
      showHome: true,
      showNotifications: true,
    );
  }
}
