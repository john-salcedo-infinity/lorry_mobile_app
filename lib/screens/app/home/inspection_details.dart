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
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Datos de VHC",
                              style: Apptheme.h1Title(
                                context,
                                color: Apptheme.textColorSecondary,
                              ),
                            ),
                            LicensePlate(
                              licensePlate: licensePlate,
                              fontSize: 22,
                            )
                          ],
                        ),
                        SizedBox(height: 18),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(26),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                        child: SingleChildScrollView(
                          child: InspectionDetailsContent(
                            formattedDate: formattedDate,
                            formattedTime: formattedTime,
                            vehicle: vehicle,
                            totalTires: totalTires,
                            inspectorName: inspectorName,
                            lastMileage: lastMileage,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24), // Espacio inferior opcional
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
        SizedBox(height: 22),
        _DetailsBadge(label: "Hora", value: formattedTime),
        SizedBox(height: 22),
        _DetailsBadge(
            label: "Tipo de vehículo",
            value: vehicle.typeVehicle?.name ?? 'N/A'),
        SizedBox(height: 22),
        _DetailsBadge(
            label: "Línea de trabajo", value: vehicle.workLine?.name ?? 'N/A'),
        SizedBox(height: 22),
        _DetailsBadge(
            label: "Cliente asociado al vehiculo",
            value: vehicle.customer?.businessName ?? 'N/A'),
        SizedBox(height: 22),
        _DetailsBadge(label: "Número de llantas", value: totalTires),
        SizedBox(height: 22),
        _DetailsBadge(label: "Nombre del inspector", value: inspectorName),
        SizedBox(height: 22),
        Column(
          children: [
            Text(
              "Última medición kilometraje",
              style:
                  Apptheme.h5Body(context, color: Apptheme.textColorSecondary),
            ),
            Container(
              margin: EdgeInsets.only(top: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/Icono_Velocimetro_Lorry.svg',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "$lastMileage KM",
                    style: Apptheme.h1TitleDecorative(
                      context,
                      color: Apptheme.secondary,
                    ),
                  )
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
        Text(
          label,
          style: Apptheme.h5Body(context, color: Apptheme.textColorSecondary),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 4),
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Apptheme.secondaryv3,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            textAlign: TextAlign.center,
            value,
            style: Apptheme.h5HighlightBody(context, color: Apptheme.secondary),
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
