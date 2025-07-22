import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/widgets/forms/customInput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class ChangePass extends ConsumerStatefulWidget {
  const ChangePass({super.key});

  @override
  ConsumerState<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends ConsumerState<ChangePass> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      // Validar que las contraseñas coincidan
      if (_newPasswordController.text != _confirmPasswordController.text) {
        ToastHelper.show_alert(context, "Las contraseñas no coinciden");

        return;
      }

      // Print de ambos campos
      print('Nueva contraseña: ${_newPasswordController.text}');
      print('Confirmar contraseña: ${_confirmPasswordController.text}');

      // Mostrar mensaje de éxito
      ToastHelper.show_success(
        context,
        'Contraseña restablecida exitosamente',
      );

      // Limpiar los campos
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      padding: const EdgeInsets.all(16.0),
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
                                label: 'Nueva Contraseña',
                                hint: 'Escribe la nueva contraseña',
                                controller: _newPasswordController,
                                obscureText: !_isNewPasswordVisible,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isNewPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Apptheme.grayInput,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isNewPasswordVisible =
                                          !_isNewPasswordVisible;
                                    });
                                  },
                                ),
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
                                label: 'Confirmar Contraseña',
                                hint: 'Escribe la nueva contraseña',
                                controller: _confirmPasswordController,
                                obscureText: !_isConfirmPasswordVisible,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isConfirmPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Apptheme.grayInput,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isConfirmPasswordVisible =
                                          !_isConfirmPasswordVisible;
                                    });
                                  },
                                ),
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
                              child: SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _resetPassword,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Apptheme.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: const Text(
                                    'Restablecer Contraseña',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: Apptheme.textFamily,
                                    ),
                                  ),
                                ),
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
