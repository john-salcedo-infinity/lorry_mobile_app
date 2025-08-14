import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/models/models.dart';
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
              child: Column(
                children: [
                  _DetailsAppBar(),
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Datos de VHC", style: Apptheme.titleStyle),
                            LicensePlate(
                              licensePlate: licensePlate,
                              fontSize: 22,
                            )
                          ],
                        ),
                        SizedBox(height: 18),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.75,
                          padding: EdgeInsets.all(26),
                          decoration: BoxDecoration(color: Colors.white),
                          child: SingleChildScrollView(
                            child: InspectionDetailsContent(
                                formattedDate: formattedDate,
                                formattedTime: formattedTime,
                                vehicle: vehicle,
                                totalTires: totalTires,
                                inspectorName: inspectorName,
                                lastMileage: lastMileage),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          : const Center(child: Text('No hay datos históricos disponibles')),
    );
  }
}

class InspectionDetailsContent extends StatelessWidget {
  const InspectionDetailsContent({
    super.key,
    required this.formattedDate,
    required this.formattedTime,
    required this.vehicle,
    required this.totalTires,
    required this.inspectorName,
    required this.lastMileage,
  });

  final String formattedDate;
  final String formattedTime;
  final Vehicle vehicle;
  final String totalTires;
  final String inspectorName;
  final String lastMileage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _DetailsBadge(label: "Fecha", value: formattedDate),
        _DetailsBadge(label: "Hora", value: formattedTime),
        _DetailsBadge(
            label: "Tipo de vehículo",
            value: vehicle.typeVehicle?.name ?? 'N/A'),
        _DetailsBadge(
            label: "Línea de trabajo", value: vehicle.workLine?.name ?? 'N/A'),
        _DetailsBadge(
            label: "Cliente asociado al vehiculo",
            value: vehicle.customer?.businessName ?? 'N/A'),
        _DetailsBadge(label: "Número de llantas", value: totalTires),
        _DetailsBadge(label: "Nombre del inspector", value: inspectorName),
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
            ),
          ],
        ),
      ],
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
        Container(
          margin: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            label,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Apptheme.textColorSecondary),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Apptheme.secondaryv3,
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
