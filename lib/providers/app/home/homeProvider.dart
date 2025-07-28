import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "homeProvider.g.dart";

@Riverpod()
class inspections extends _$inspections {
  @override
  List<HistoricalResult> build() => [];

  void addResults(List<HistoricalResult> newResults) {
    state = [...state, ...newResults];
  }

  void replaceResults(List<HistoricalResult> results) {
    state = results;
  }

  void clearResults() {
    state = [];
  }

  void changeValue(List<HistoricalResult> value) {
    state = value;
  }
}

@Riverpod()
class Loadinginspections extends _$Loadinginspections {
  @override
  bool build() => false;

  void changeloading(bool value) {
    state = value;
  }
}

//! Providers simples para paginación
final inspectionPaginationProvider = StateProvider<String?>((ref) => null);
final loadingMoreProvider = StateProvider<bool>((ref) => false);

//! Anteriormente llamados Family
@Riverpod()  // Removemos keepAlive para permitir invalidación automática
Future<InspectionHistory> inspectionAllService(
    Ref ref, Map<String, String>? queryParams) async {
  final inspection = await Homeservice.GetInspectionHistory(ref, queryParams);
  return inspection;
}
