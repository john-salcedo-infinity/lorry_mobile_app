import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/constants/services.dart';
import 'package:app_lorry/models/Service_data.dart';
import 'package:app_lorry/widgets/buttons/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';

class ServiceSelectionDialog extends StatelessWidget {
  final String tireSerial;
  final Function(ServiceData) onServiceSelected;

  const ServiceSelectionDialog({
    super.key,
    required this.tireSerial,
    required this.onServiceSelected,
  });

  static Future<void> show({
    required BuildContext context,
    required String tireSerial,
    required Function(ServiceData) onServiceSelected,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ServiceSelectionDialog(
        tireSerial: tireSerial,
        onServiceSelected: onServiceSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            backgroundColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 32,
            ), // Agregar más padding interno
            title: _buildHeader(),
            content: SizedBox(
              child: SingleChildScrollView(
                child: _buildServicesList(context),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Apptheme.textColorPrimary,
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.close,
              color: Apptheme.textColorPrimary,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          "Selecciona el servicio",
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w900,
            color: Apptheme.textColorPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              fontSize: 14,
              color: Apptheme.textColorSecondary,
              fontWeight: FontWeight.normal,
            ),
            children: [
              const TextSpan(text: 'se realizará en la llanta '),
              TextSpan(
                text: "LL-$tireSerial",
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Apptheme.textColorPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServicesList(BuildContext context) {
    return Column(
      children: [
        _buildServiceOption(
          context,
          SERVICE_ROTATE,
          'assets/icons/services/lorr-rotate.svg',
        ),
        _buildServiceOption(
          context,
          SERVICE_TURN,
          'assets/icons/services/lorr-turn.svg',
        ),
        _buildServiceOption(
          context,
          SERVICE_ROTATE_TURN,
          'assets/icons/services/lorr-turn-rotate2.svg',
        ),
      ],
    );
  }

  Widget _buildServiceOption(
      BuildContext context, ServiceData service, String iconPath) {
    return CustomButton(
      300,
      42,
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 12),
          Text(
            service.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Apptheme.textColorPrimary,
            ),
          ),
        ],
      ),
      () {
        Navigator.of(context).pop();
        onServiceSelected(service);
      },
      type: 4,
    );
  }
}
