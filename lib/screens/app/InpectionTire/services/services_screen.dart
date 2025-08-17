import 'package:app_lorry/config/configs.dart';
import 'package:app_lorry/constants/services.dart';
import 'package:app_lorry/models/ManualPlateRegisterResponse.dart';
import 'package:app_lorry/routers/app_routes.dart';
import 'package:app_lorry/widgets/dialogs/confirmation_dialog.dart';
import 'package:app_lorry/widgets/shared/back.dart';
import 'package:app_lorry/config/tire_services.dart';
import 'package:app_lorry/models/Service_data.dart';
import 'package:app_lorry/screens/app/InpectionTire/services/widgets/service_button.dart';
import 'package:app_lorry/widgets/buttons/BottomButton.dart';
import 'package:app_lorry/widgets/dialogs/service_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServiceItem {
  final TextEditingController costController;
  int provider;
  int service;

  void dispose() {
    costController.dispose();
  }

  ServiceItem({
    required this.costController,
    required this.provider,
    required this.service,
  });

  Map<String, dynamic> toMap() {
    return {
      'type_service': service,
      'provider': provider,
      'cost_service': double.tryParse(costController.text) ?? 0.0,
    };
  }
}

class ServiceScreenParams {
  final MountingResult currentMountingResult;
  final List<Map<String, dynamic>>? existingServices;

  ServiceScreenParams({
    required this.currentMountingResult,
    required this.existingServices,
  });
}

class ServicesScreen extends ConsumerStatefulWidget {
  final ServiceScreenParams data;
  const ServicesScreen({super.key, required this.data});

  @override
  ConsumerState<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends ConsumerState<ServicesScreen> {
  late final MountingResult currentMounting;

  final List<ServiceItem> _serviceItems = [];

  @override
  void initState() {
    super.initState();
    currentMounting = widget.data.currentMountingResult;

    // Initialize any other state variables here
    if (widget.data.existingServices != null &&
        widget.data.existingServices!.isNotEmpty) {
      _loadExistingServices(widget.data.existingServices!);
    }
  }

  void _loadExistingServices(List<Map<String, dynamic>> existingServices) {
    for (var serviceData in existingServices) {
      final controller = TextEditingController(
          text: serviceData["cost_service"]?.toString() ?? '');
      _serviceItems.add(ServiceItem(
        costController: controller,
        provider: serviceData["provider"],
        service: serviceData["type_service"],
      ));
    }
  }

  @override
  void dispose() {
    // Dispose de todos los controladores
    for (var item in _serviceItems) {
      item.dispose();
    }
    super.dispose();
  }

  List<Map<String, dynamic>> _getServicesArray() {
    return _serviceItems.map((item) => item.toMap()).toList();
  }

  List<Map<String, dynamic>> get servicesArray => _getServicesArray();

  // Método para contar cuántos servicios de un tipo específico hay
  int _getServiceCountForType(int serviceType) {
    return _serviceItems.where((item) => item.service == serviceType).length;
  }

  // Método para verificar si el servicio de rotación + giro está deshabilitado
  bool _isRotationTurnDisabled() {
    return _serviceItems.any((item) => item.service == SERVICE_ROTATE_TURN.id);
  }

  // Método para reiniciar todos los servicios
  void _resetAllServices() {
    // Dispose de todos los controladores existentes
    for (var item in _serviceItems) {
      item.dispose();
    }

    setState(() {
      _serviceItems.clear();
    });
  }

  // Método para enviar servicios (retornar al screen anterior con los servicios)
  void _sendServices() {
    final services = _getServicesArray();
    Navigator.of(context).pop(services);
  }

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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Servicios a realizar',
                        style: Apptheme.h1Title(
                          context,
                          color: Apptheme.textColorSecondary,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildServicesGrid(),
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Back(
        showHome: true,
        showDelete: true,
        showNotifications: true,
        onDeletePressed: () {
          ConfirmationDialog.show(
            context: context,
            title: "Eliminar Inspección",
            message:
                "¿Estás seguro que deseas eliminar la inspección? No podrás deshacer esta acción",
            cancelText: "Cancelar",
            acceptText: "Aceptar",
            onAccept: () {
              ref
                  .read(appRouterProvider)
                  .pushReplacement('/ManualPlateRegister');
            },
          );
        },
        onBackPressed: () {
          if (_serviceItems.isNotEmpty) {
            ConfirmationDialog.show(
              context: context,
              title: "Salir de Servicios",
              message:
                  "¿Estás seguro que deseas salir de los Servicios? No podrás deshacer esta acción",
              cancelText: "Cancelar",
              acceptText: "Aceptar",
              onAccept: () {
                Navigator.pop(context);
              },
            );
          } else {
            Navigator.pop(context);
          }
        });
  }

  Widget _buildServicesGrid() {
    final services = servicesConfiguration.physicalServices;

    return Column(children: [
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 10 / 8.5,
          crossAxisSpacing: 20,
        ),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final serviceConfig = services[index];
          final serviceCount =
              _getServiceCountForType(serviceConfig.service.id);
          final isDisabled =
              serviceConfig.service.id == SERVICE_ROTATE_TURN.id &&
                  _isRotationTurnDisabled();

          return ServiceButton(
            serviceConfig: serviceConfig,
            serviceCount: serviceCount,
            isDisabled: isDisabled,
            onTap:
                isDisabled ? null : () => _onServiceTap(serviceConfig.service),
          );
        },
      ),
    ]);
  }

  Widget _buildBottomButtons() {
    return BottomButton(
      gap: 20,
      buttons: [
        BottomButtonItem(
          text: 'Reiniciar',
          buttonType: 2,
          onPressed: _resetAllServices,
          textColor: Apptheme.darkorange,
        ),
        BottomButtonItem(
          text: 'Enviar Servicios',
          buttonType: 1,
          onPressed: _sendServices,
        ),
      ],
    );
  }

  void _onServiceTap(ServiceData service) async {
    // Abrir el dialog de servicio
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierColor: Apptheme.secondary.withValues(alpha: 0.5),
      builder: (dialogContext) => ServiceDialog(
        service: service,
        tireCode: currentMounting.tire?.integrationCode ?? 'N/A',
      ),
    );

    // Procesar el resultado si se confirma el servicio
    if (result != null) {
      // Crear un nuevo item de servicio
      final costController = TextEditingController(
        text: result['cost_service']?.toString() ?? '0',
      );

      final serviceItem = ServiceItem(
        costController: costController,
        provider: result['provider'] ?? 0,
        service: result['type_service'] ?? service.id,
      );

      setState(() {
        _serviceItems.add(serviceItem);
      });
    }
  }
}
