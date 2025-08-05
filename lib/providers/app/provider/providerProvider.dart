import 'package:app_lorry/models/ProviderResponse.dart';
import 'package:app_lorry/services/ProviderService.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providerProvider.g.dart';

@Riverpod(keepAlive: true)
Future<ProviderResponse> providerService(ProviderServiceRef ref) async {
  final providers = await ProviderService.getProviders();
  return providers;
}
