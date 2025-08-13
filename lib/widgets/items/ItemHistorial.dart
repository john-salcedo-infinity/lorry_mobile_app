import 'package:app_lorry/routers/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets.dart';

class ItemHistorial extends ConsumerStatefulWidget {
  final HistoricalResult historical;
  final bool isSelected;
  final VoidCallback onTap;

  const ItemHistorial({
    super.key,
    required this.historical,
    required this.isSelected,
    required this.onTap,
  });

  @override
  ConsumerState<ItemHistorial> createState() => _ItemHistorialState();
}

class _ItemHistorialState extends ConsumerState<ItemHistorial> {
  // OPTIMIZACIÓN: Cachear valores calculados
  late final String formattedDate;
  late final String formattedTime;
  late final String formattedMileage;
  late final String businessName;
  late final String licensePlate;
  late final String totalTires;

  @override
  void initState() {
    super.initState();
    // Pre-calcular todos los valores para evitar recálculos en cada build
    final inspection = widget.historical.inspection;
    final vehicle = widget.historical.vehicle;

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
  }

  void _navigateToDetails() {
    ref.read(appRouterProvider).push('/inspectionDetails', extra: {
      'historical': widget.historical,
    });
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              _navigateToDetails();
              widget.onTap();
            },
            borderRadius: BorderRadius.circular(8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: widget.isSelected
                    ? Border.all(color: Apptheme.secondary, width: 1)
                    : null,
                // OPTIMIZACIÓN: Agregar shadow solo si es necesario
                boxShadow: widget.isSelected
                    ? [
                        BoxShadow(
                          color: Apptheme.secondary.withValues(alpha: .2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.all(26),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(formattedDate, style: Apptheme.titleStyle),
                            const SizedBox(height: 4),
                            Text(formattedTime,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: Apptheme.textColorSecondary,
                                )),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "VHC ASOCIADO",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Apptheme.textColorSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            LicensePlate(licensePlate: licensePlate),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 26),
                    // Badges row
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 3,
                            child: _ItemBadge(
                              title: "CLIENTE",
                              values: businessName,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 3,
                            child: _ItemBadge(
                              title: "KILOMETRAJE",
                              values: formattedMileage,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: _ItemBadge(
                              title: "LLANTAS",
                              values: totalTires,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ItemBadge extends StatelessWidget {
  final String title;
  final String values;

  const _ItemBadge({
    required this.title,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 10,
            color: Apptheme.textColorSecondary,
          ),
        ),
        const SizedBox(height: 7),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Apptheme.secondaryv4,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              values,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow:
                  TextOverflow.ellipsis, // OPTIMIZACIÓN: Manejo de overflow
              style: const TextStyle(
                color: Apptheme.secondary,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
