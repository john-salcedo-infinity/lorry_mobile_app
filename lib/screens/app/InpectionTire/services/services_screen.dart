import 'package:app_lorry/config/configs.dart';
import 'package:app_lorry/widgets/shared/back.dart';
import 'package:app_lorry/config/tire_services.dart';
import 'package:app_lorry/models/Service_data.dart';
import 'package:app_lorry/screens/app/InpectionTire/services/widgets/service_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class ServicesScreen extends ConsumerStatefulWidget {
  const ServicesScreen({super.key});

  @override
  ConsumerState<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends ConsumerState<ServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Apptheme.backgroundColor,
      body: SafeArea(
          child: Column(
        children: [
          _buildHeader(),
          Expanded(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Servicios a realizar', style: Apptheme.titleStyle),
                  const SizedBox(height: 20),
                  _buildServicesGrid(),
                ],
              ),
            ),
          ))
        ],
      )),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.only(top: 30, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Back(),
          IconButton(
            onPressed: () => context.go('/home'),
            icon: SvgPicture.asset(
              'assets/icons/Icono_Casa_Lorry.svg',
              width: 40,
              height: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesGrid() {
    final services = servicesConfiguration.physicalServices;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 10 / 7,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final serviceConfig = services[index];
        return ServiceButton(
          serviceConfig: serviceConfig,
          onTap: () => _onServiceTap(serviceConfig.service),
        );
      },
    );
  }


  void _onServiceTap(ServiceData service) {
    // mostrar un SnackBar para feedback visual
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Servicio seleccionado: ${service.name} (${service.id})'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
