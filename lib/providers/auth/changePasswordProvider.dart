import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "changePasswordProvider.g.dart";

@Riverpod()
class ChangePasswordFormProvider extends _$ChangePasswordFormProvider {
  @override
  Map<String, String> build() => {"new_password": "", "confirm_password": ""};
  
  void changeKey(String key, String value) {
    state = {...state, key: value};
  }
  
  void clearForm() {
    state = {"new_password": "", "confirm_password": ""};
  }
}

@Riverpod()
class ChangePasswordLoadingProvider extends _$ChangePasswordLoadingProvider {
  @override
  bool build() => false;
  
  void changeLoading(bool value) {
    state = value;
  }
}

@riverpod
Future<AuthResponse> changePasswordService(
  Ref ref,
  String newPassword,
  String confirmPassword,
) async {
  final authResponse = await Authservice.changePassword(newPassword, confirmPassword);
  return authResponse;
}
