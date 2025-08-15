import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/helpers/ToastHelper.dart';
import 'package:app_lorry/models/AuthResponse.dart';
import 'package:app_lorry/providers/auth/loginProvider.dart';
import 'package:app_lorry/services/services.dart';
import 'package:app_lorry/widgets/forms/customInput.dart';
import 'package:app_lorry/widgets/shared/ballBeatLoading.dart';
import 'package:app_lorry/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Forgotpassscreen extends ConsumerStatefulWidget {
  const Forgotpassscreen({super.key});

  @override
  ConsumerState<Forgotpassscreen> createState() => _ForgotpassscreenState();
}

class _ForgotpassscreenState extends ConsumerState<Forgotpassscreen> {
  final _changePassController = TextEditingController();

  Future<void> _sendResetEmail() async {
    final email = _changePassController.text;
    if (email.isNotEmpty) {
      try {
        ref.read(loadingProviderProvider.notifier).changeLoading(true);
        final AuthResponse response = await Authservice.forgotPassword(email);

        if (!mounted) return;

        if (response.success == true) {
          ToastHelper.show_success(
            context,
            response.messages?.first ??
                "Se ha enviado un correo de restablecimiento",
          );
          Navigator.pop(context);
        } else {
          ToastHelper.show_alert(
            context,
            response.messages?.first ?? "No se pudo enviar el correo",
          );
        }
      } catch (e) {
        // Check if widget is still mounted before using context
        if (!mounted) return;

        ToastHelper.show_alert(context, 'Error al enviar el correo');
      } finally {
        ref.read(loadingProviderProvider.notifier).changeLoading(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProviderProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Transform.rotate(
                          angle: 3.14159,
                          child: SvgPicture.asset(
                            'assets/icons/Icono_cerrar_sesion.svg',
                            width: 25,
                            height: 25,
                          ),
                        ),
                      ),
                      const Text(
                        'Atrás',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Apptheme.textColorPrimary),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 35,
                  ),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/lorry_logo_orange.svg',
                        width: 190,
                        height: 68,
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          "Escribe tu correo ingresado en el sistema para poder restablecer tu acceso",
                          style: Apptheme.h4Body(
                            context,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 32),
                      CustomInputField(
                        label: 'Correo',
                        controller: _changePassController,
                        hint: 'Escribe tu correo electrónico',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu correo electrónico';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 26),
                      CustomButton(
                        double.infinity,
                        46,
                        !isLoading
                            ? Text(
                                "Enviar correo de restablecimiento",
                                style: Apptheme.h4HighlightBody(
                                  context,
                                  color: Apptheme.backgroundColor,
                                ),
                              )
                            : BallBeatLoading(),
                        _sendResetEmail,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancelar",
                          style: Apptheme.h4HighlightBody(context,
                              color: Apptheme.primary),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _changePassController.dispose();
    super.dispose();
  }
}
