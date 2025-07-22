

import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/services/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part "loginProvider.g.dart";

@Riverpod()
class LoginFormProvider extends _$LoginFormProvider {
  @override
  Map<String, String> build() =>{"email": "", "password": ""};
  void changeKey(key,value){
    state[key] = value;
  }
}

@Riverpod()
class LoadingProvider extends _$LoadingProvider {
  @override
  bool build() => false;
  void changeLoading(bool value){
    state = value;
  }
}

@Riverpod(keepAlive: true)
Future<AuthResponse> LoginServiceProvider(LoginServiceProviderRef ref,String email,String password) async {
  final authService = await Authservice.login(email, password);
  return authService;
}