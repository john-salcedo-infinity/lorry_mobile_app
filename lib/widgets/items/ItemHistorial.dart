import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/models/models.dart';

class ItemHistorial extends StatelessWidget {
  final HistoricalResult historical;
  const ItemHistorial({
    super.key,
    required this.historical,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      HelpersGeneral.formatCustomDate(historical.truncatedDate),
                      style: Apptheme.titleStylev2,
                    ),
                    Spacer(),
                    const Text(
                      "VCH ASOCIADO",
                      style: Apptheme.titleStylev2,
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "${historical.vehicleLastUpdate.hour}:${historical.vehicleLastUpdate.minute}:${historical.vehicleLastUpdate.second}",
                      style: Apptheme.titleStylev2,
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Apptheme.secondaryv3,
                      ),
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white)),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.all(3),
                          child: Text(
                            historical.vehicleLicensePlate,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ItemBadge(
                        title: "CLIENTE",
                        values: historical.vehicleCustomerBusinessName,
                        width: 100),
                    Spacer(),
                    _ItemBadge(
                        title: "KILOMETRAJE",
                        values: "${historical.mileage}",
                        width: 100),
                    Spacer(),
                    _ItemBadge(
                        title: "LLANTAS",
                        values: "${historical.totalTires}",
                        width: 50),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _ItemBadge extends StatelessWidget {
  String title = "Cliente";
  double width = 2.0;
  String values = "Sovatrans S.A";
  _ItemBadge({
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
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 7,
        ),
        Container(
          decoration: BoxDecoration(
              color: Apptheme.secondaryv4,
              borderRadius: BorderRadius.circular(5)),
          width: width,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Center(
              child: Text(
                values,
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
