import 'package:app_lorry/models/Service_data.dart';
import 'package:app_lorry/constants/services.dart';

final ServicesConfiguration servicesConfiguration = ServicesConfiguration(
  physicalServices: [
    ServiceConfig(
      xs: 12,
      sm: 12,
      icon: 'lorr-turn-rotate',
      service: SERVICE_ROTATE_TURN,
      text: 'Rotar y Girar',
    ),
    ServiceConfig(
      xs: 12,
      sm: 12,
      icon: 'lorr-unflattened',
      service: SERVICE_UNFLATEN,
      text: 'Despinchar',
    ),
    ServiceConfig(
      xs: 12,
      sm: 12,
      icon: 'lorr-alignment',
      service: SERVICE_ALIGNMENT,
      text: 'Alineación',
    ),
    ServiceConfig(
      xs: 12,
      sm: 12,
      icon: 'lorr-re-record',
      service: SERVICE_RERECORD,
      text: 'Regrabación',
    ),
    ServiceConfig(
      xs: 12,
      sm: 12,
      icon: 'lorr-psi',
      service: SERVICE_CALIBRATE,
      text: 'Calibración',
    ),
    ServiceConfig(
      xs: 12,
      sm: 12,
      icon: 'lorr-bulcanization',
      service: SERVICE_BULCANIZATION,
      text: 'Vulcanización',
    ),
  ],
  unmountingServices: [],
);
