import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/providers/auth/changePasswordProvider.dart';
import 'package:app_lorry/widgets/forms/customInput.dart';
import 'package:app_lorry/widgets/buttons/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_indicator/loading_indicator.dart';

class ChangePass extends ConsumerStatefulWidget {
  const ChangePass({super.key});

  @override
  ConsumerState<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends ConsumerState<ChangePass> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  // bool _isNewPasswordVisible = false;
  // bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      // Validar que las contraseñas coincidan
      if (_newPasswordController.text != _confirmPasswordController.text) {
        ToastHelper.show_alert(context, "Las contraseñas no coinciden");
        return;
      }

      try {
        ref
            .read(changePasswordLoadingProviderProvider.notifier)
            .changeLoading(true);

        final response = await ref.read(changePasswordServiceProvider(
          _newPasswordController.text,
          _confirmPasswordController.text,
        ).future);

        // Ocultar loading
        ref
            .read(changePasswordLoadingProviderProvider.notifier)
            .changeLoading(false);

        if (response.success == true) {
          ToastHelper.show_success(
            context,
            response.messages?.first ?? 'Contraseña actualizada correctamente',
          );

          _newPasswordController.clear();
          _confirmPasswordController.clear();

          if (response.data?.token != null) {
            Preferences preference = Preferences();
            await preference.init();
            preference.saveKey("token", response.data!.token!);
          }

          Navigator.pop(context);
        } else {
          // Mostrar mensaje de error
          ToastHelper.show_alert(
            context,
            response.messages?.first ?? 'Error al actualizar la contraseña',
          );
        }
      } catch (e) {
        // Ocultar loading en caso de error
        ref
            .read(changePasswordLoadingProviderProvider.notifier)
            .changeLoading(false);

        // Mostrar mensaje de error
        ToastHelper.show_alert(
          context,
          'Error de conexión. Inténtalo de nuevo.',
        );

        print('Error al cambiar contraseña: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(changePasswordLoadingProviderProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  32,
            ),
            child: IntrinsicHeight(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Header con botón de atrás
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
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

                    // Contenido centrado expandido
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Logo de Lorry
                            SvgPicture.asset(
                              'assets/icons/lorry_logo_orange.svg',
                              width: 190,
                              height: 68,
                            ),

                            const SizedBox(height: 20),

                            // Título
                            const Text(
                              'Actualiza tu contraseña de acceso',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontFamily: Apptheme.textFamily,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Campo Nueva Contraseña
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: CustomInputField(
                                label: 'Nueva contraseña',
                                hint: 'Escribe la nueva contraseña',
                                controller: _newPasswordController,
                                obscureText: true, // Always hidden
                                // suffixIcon: IconButton(
                                //   icon: Icon(
                                //     _isNewPasswordVisible
                                //         ? Icons.visibility
                                //         : Icons.visibility_off,
                                //     color: Apptheme.grayInput,
                                //   ),
                                //   onPressed: () {
                                //     setState(() {
                                //       _isNewPasswordVisible =
                                //           !_isNewPasswordVisible;
                                //     });
                                //   },
                                // ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingresa una nueva contraseña';
                                  }
                                  if (value.length < 6) {
                                    return 'La contraseña debe tener al menos 6 caracteres';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Campo Confirmar Contraseña
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: CustomInputField(
                                label: 'Confirmar contraseña',
                                hint: 'Escribe la nueva contraseña',
                                controller: _confirmPasswordController,
                                obscureText: true, // Always hidden
                                // suffixIcon: IconButton(
                                //   icon: Icon(
                                //     _isConfirmPasswordVisible
                                //         ? Icons.visibility
                                //         : Icons.visibility_off,
                                //     color: Apptheme.grayInput,
                                //   ),
                                //   onPressed: () {
                                //     setState(() {
                                //       _isConfirmPasswordVisible =
                                //           !_isConfirmPasswordVisible;
                                //     });
                                //   },
                                // ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor confirma tu contraseña';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            const SizedBox(height: 40),

                            // Botón Restablecer Contraseña
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: CustomButton(
                                double.infinity,
                                50,
                                isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: LoadingIndicator(
                                          indicatorType: Indicator.ballBeat,
                                          strokeWidth: 3.0,
                                          colors: [Colors.white],
                                        ),
                                      )
                                    : const Text(
                                        'Restablecer contraseña',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontFamily: Apptheme.textFamily,
                                        ),
                                      ),
                                isLoading ? null : _resetPassword,
                                type: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
