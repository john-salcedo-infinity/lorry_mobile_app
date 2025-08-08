import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/models/Service_data.dart';
import 'package:app_lorry/widgets/buttons/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ServiceButton extends StatelessWidget {
  final ServiceConfig serviceConfig;
  final VoidCallback? onTap;
  final int serviceCount;
  final bool isDisabled;

  const ServiceButton({
    super.key,
    required this.serviceConfig,
    required this.onTap,
    this.serviceCount = 0,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CustomButton(
          double.infinity,
          110,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildServiceIcon(context, serviceConfig.icon),
              const SizedBox(height: 8),
              Text(
                serviceConfig.text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: isDisabled ? Colors.grey : null,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          isDisabled ? null : onTap,
          type: 4,
        ),
        if (serviceCount > 0)
          Positioned(
            top: -8,
            right: -8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration:  BoxDecoration(
                color: Apptheme.lightOrange2,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                serviceCount.toString(),
                style: const TextStyle(
                  color: Apptheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildServiceIcon(BuildContext context, String iconName) {
    return FutureBuilder<bool>(
      future: _checkAssetExists(context, 'assets/icons/services/$iconName.svg'),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          // El icono existe, mostrar SVG
          return SvgPicture.asset(
            'assets/icons/services/$iconName.svg',
            width: 40,
            height: 40,
          );
        } else {
          // Fallback: mostrar un contenedor con las iniciales del servicio
          return _buildFallbackIcon(iconName);
        }
      },
    );
  }

  Widget _buildFallbackIcon(String iconName) {
    // Extraer las primeras letras del nombre del icono para crear un "alt"
    String initials = _getInitialsFromIconName(iconName);

    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.green.withAlpha(512), // Color de fondo con transparencia
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.green, width: 1),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.green,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _getInitialsFromIconName(String iconName) {
    // Convertir nombres como "lorr-turn-rotate" a "TR"
    List<String> parts = iconName.split('-');
    String initials = '';

    for (String part in parts) {
      if (part.isNotEmpty && part != 'lorr') {
        initials += part[0].toUpperCase();
        if (initials.length >= 2) break;
      }
    }

    return initials.isNotEmpty ? initials : '?';
  }

  Future<bool> _checkAssetExists(BuildContext context, String assetPath) async {
    try {
      await DefaultAssetBundle.of(context).load(assetPath);
      return true;
    } catch (e) {
      return false;
    }
  }
}
