import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/services/NoveltyService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'noveltyProvider.g.dart';

@Riverpod()
class Noveltlies extends _$Noveltlies {
  @override
  List<NoveltyResponse> build() => [];

  void addResults(List<NoveltyResponse> newResults) {
    state = [...state, ...newResults];
  }
}

@Riverpod()
Future<NoveltyResponse> noveltyService(Ref ref) async {
  final novelty = await NoveltyService.getNovelty();
  return novelty;
}
