import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/services/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "homeProvider.g.dart";



@Riverpod()
class inspections extends _$inspections {
  @override
  List<HistoricalResult> build() => [] ;
  
    void changeValue(List<HistoricalResult> value){
    state = value;
  }
}

@Riverpod()
class Loadinginspections extends _$Loadinginspections {
  @override
  bool build() => true ;
  
    void changeloading(bool value){
    state = value;
  }
}

//! Anteriormente llamados Family
@Riverpod(keepAlive: true)
Future<InspectionHistory> inspectionAllService(InspectionAllServiceRef ref) async{
  final inspection = await Homeservice.GetInspectionHistory(ref);
  return inspection;
}