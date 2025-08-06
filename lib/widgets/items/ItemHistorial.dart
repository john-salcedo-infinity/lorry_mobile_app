import 'package:app_lorry/routers/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets.dart';

class ItemHistorial extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    void printHistoricalData() {
      // print(historical);
      ref.read(appRouterProvider).push('/inspectionDetails', extra: {
        'historical': historical,
      });
    }

    return RepaintBoundary(
      // Optimización: Evita repaints innecesarios
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              printHistoricalData();
              onTap();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: isSelected
                    ? Border.all(color: Apptheme.secondary, width: 1)
                    : null,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          HelpersGeneral.formatDayDate(
                              historical.inspection.lastInspectionDate),
                          style: Apptheme.titleStyle,
                        ),
                        const Spacer(),
                        const Text(
                          "VCH ASOCIADO",
                          style: Apptheme.titleStylev2,
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          "${historical.inspection.lastInspectionDate.hour.toString()}:${historical.inspection.lastInspectionDate.minute.toString().padLeft(2, '0')}:${historical.inspection.lastInspectionDate.second.toString().padLeft(2, '0')}",
                          style: Apptheme.titleStyle,
                        ),
                        const Spacer(),
                        LicensePlate(
                            licensePlate: historical.vehicle.licensePlate ?? '')
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _ItemBadge(
                            title: "CLIENTE",
                            values:
                                historical.vehicle.customer?.businessName ?? '',
                            width: 120),
                        const Spacer(),
                        _ItemBadge(
                            title: "KILOMETRAJE",
                            values: HelpersGeneral.numberFormat(
                                historical.inspection.mileage),
                            width: 120),
                        const Spacer(),
                        _ItemBadge(
                            title: "LLANTAS",
                            values: "${historical.inspection.totalTires}",
                            width: 50),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _ItemBadge extends StatelessWidget {
  final String title;
  final double width;
  final String values;

  const _ItemBadge({
    required this.title,
    required this.values,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 10,
              color: Apptheme.textColorSecondary),
        ),
        const SizedBox(
          height: 7,
        ),
        Container(
          decoration: BoxDecoration(
              color: Apptheme.secondaryv4,
              borderRadius: BorderRadius.circular(8)),
          width: width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Center(
              child: Text(
                values,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Apptheme.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),
          ),
        )
      ],
    );
  }
}
