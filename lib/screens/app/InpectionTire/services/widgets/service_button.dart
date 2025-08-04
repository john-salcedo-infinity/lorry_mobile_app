import 'package:app_lorry/models/Service_data.dart';
import 'package:app_lorry/widgets/buttons/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ServiceButton extends StatelessWidget {
  final ServiceConfig serviceConfig;
  final VoidCallback onTap;

  const ServiceButton({
    super.key,
    required this.serviceConfig,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      159,
      110,
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildServiceIcon(context, serviceConfig.icon),
          const SizedBox(height: 8),
          Text(
            serviceConfig.text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      onTap,
      type: 4,
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
