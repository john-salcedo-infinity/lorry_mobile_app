// ignore_for_file: constant_identifier_names

import 'package:app_lorry/models/Service_data.dart';

const ServiceData SERVICE_ROTATE = ServiceData(
  id: 14,
  name: 'Rotación',
  sendTo: null,
  unmountingRequired: false,
);

const ServiceData SERVICE_TURN = ServiceData(
  id: 18,
  name: 'Giro',
  sendTo: null,
  unmountingRequired: false,
);

const ServiceData SERVICE_ROTATE_TURN = ServiceData(
  id: 19,
  name: 'Rotacion + Giro',
  sendTo: null,
  unmountingRequired: false,
);

const ServiceData SERVICE_FVU = ServiceData(
  id: 30,
  name: 'Enviar a Analisis Tecnico',
  sendTo: 'FVU',
  unmountingRequired: true,
);

const ServiceData SERVICE_RETREAD = ServiceData(
  id: 42,
  name: 'Enviar a Reencauche',
  sendTo: 'Reencauche',
  unmountingRequired: true,
);

const ServiceData SERVICE_PATCH = ServiceData(
  id: 20,
  name: 'Parche',
  sendTo: null,
  unmountingRequired: false,
);

const ServiceData SERVICE_ALIGNMENT = ServiceData(
  id: 21,
  name: 'Alineacion',
  sendTo: null,
  unmountingRequired: false,
);

const ServiceData SERVICE_BALANCE = ServiceData(
  id: 22,
  name: 'Balanceo',
  sendTo: null,
  unmountingRequired: false,
);

const ServiceData SERVICE_CALIBRATE = ServiceData(
  id: 23,
  name: 'Calibracion',
  sendTo: null,
  unmountingRequired: false,
);

const ServiceData SERVICE_RERECORD = ServiceData(
  id: 44,
  name: 'Regrabación',
  sendTo: null,
  unmountingRequired: false,
);

const ServiceData SERVICE_UNFLATEN = ServiceData(
  id: 9,
  name: 'Despinchar',
  sendTo: null,
  unmountingRequired: false,
);

const ServiceData SERVICE_BULCANIZATION = ServiceData(
  id: 11,
  name: 'Vulcanización',
  sendTo: null,
  unmountingRequired: false,
);
