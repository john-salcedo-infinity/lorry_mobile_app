import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "manualPlateRegisterProvider.g.dart";

@riverpod
class ManualPlateRegisterState extends _$ManualPlateRegisterState {
  @override
  ManualPlateRegisterResponse? build() => null;

  void setResponse(ManualPlateRegisterResponse? response) {
    state = response;
  }

  void clearResponse() {
    state = null;
  }
}

@riverpod
class ManualPlateRegisterLoading extends _$ManualPlateRegisterLoading {
  @override
  bool build() => false;

  void setLoading(bool value) {
    state = value;
  }
}

//! Provider para obtener información del vehículo por placa
@riverpod
Future<ManualPlateRegisterResponse> getMountingByPlate(
    Ref ref, String licensePlate) async {
  final response = await ManualPlateRegisterService.getMountingByPlate(licensePlate, ref);
  return response;
}
