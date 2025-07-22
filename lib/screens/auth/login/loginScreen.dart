import 'dart:convert';

import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/providers/providers.dart';
import 'package:app_lorry/routers/app_routes.dart';
import 'package:app_lorry/services/services.dart';
import 'package:app_lorry/widgets/buttons/CustomButton.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          decoration: const BoxDecoration(color: Apptheme.primary),
          child: Stack(
            children: [
              const _background(),
              Container(
                color: Apptheme.primaryopacity,
              ),
              _MainContent()
            ],
          ),
        ));
  }
}

class _MainContent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenHeight = MediaQuery.of(context).size.height * 0.38;
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        reverse: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            SizedBox(height: screenHeight),
            Container(
              height: MediaQuery.of(context).size.height - screenHeight,
              width: double.infinity,
              decoration: Apptheme.card_radius_only_top,
              child: const _CardLogin(),
            ),
          ],
        ),
      ),
    );
  }
}


class _CardLogin extends ConsumerWidget {
  const _CardLogin();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenwidth = MediaQuery.of(context).size.width * 0.9;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height:80),
            const Hero(
              tag: "logo",
              child: Image(
                image: AssetImage('assets/icons/lorry_logo_orange.png'),
              ),
            ),
            _FormLogin(screenwidth: screenwidth),
          ],
        ),
      ),
    );
  }
}


class _FormLogin extends ConsumerWidget {
  const _FormLogin({
    required this.screenwidth,
  });

  final double screenwidth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formValues = ref.watch(loginFormProviderProvider);
    final loading = ref.watch(loadingProviderProvider);

    return Column(
      children: [
        const SizedBox(
          width: double.infinity,
          height: 40,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "CORREO",
              style: TextStyle(
                  color: Apptheme.textColorSecondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: screenwidth,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(fontSize: 15),
            decoration: Apptheme.inputDecorationPrimary("correo"),
            textCapitalization: TextCapitalization.words,
            onChanged: (value) => ref
                .read(loginFormProviderProvider.notifier)
                .changeKey("email", value),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "CONTRASEÑA",
              style: TextStyle(
                  color: Apptheme.textColorSecondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: screenwidth,
          child: TextFormField(
            obscureText: true,
            style: const TextStyle(fontSize: 15),
            decoration: Apptheme.inputDecorationPrimary("Contraseña"),
            textCapitalization: TextCapitalization.words,
            onChanged: (value) => ref
                .read(loginFormProviderProvider.notifier)
                .changeKey("password", value),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        CustomButton(
            500,
            50,
            !loading
                ? const Text("Iniciar Sesión")
                : const SizedBox(
                    width: 50,
                    height: 20,
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballBeat,
                      strokeWidth: 3.0,
                      colors: [Colors.white],
                    ),
                  ), () async {
          ref.read(loadingProviderProvider.notifier).changeLoading(true);
          //  quitar foucs
          FocusScope.of(context).requestFocus(FocusNode());
          // ToastHelper.show_success(context, "Bienvenido");
          // Acción cuando se presiona el botón
          String? email = formValues['email'];
          String? password = formValues['password'];

          if ((email == null || email.isEmpty)) {
            ToastHelper.show_alert(context, "El correo es requerido.");
            ref.read(loadingProviderProvider.notifier).changeLoading(false);
            return;
          }

          if ((password == null || password.isEmpty)) {
            ToastHelper.show_alert(context, "La contraseña es requerida.");
            ref.read(loadingProviderProvider.notifier).changeLoading(false);
            return;
          }
          final response = await Authservice.login(email, password);

          if (!response.success!) {
            ToastHelper.show_alert(context, "Credenciales incorrectas!!");
            // ref.read(appRouterProvider).go('/home');
            ref.read(loadingProviderProvider.notifier).changeLoading(false);
            return;
          } else {
            ToastHelper.show_success(context, "Bienvenido!!");
            Preferences pref = Preferences();
            await pref.init();
            pref.saveKey("token", response.data!.token!);
            pref.saveKey("refresh-token", response.data!.refreshToken!);
            pref.saveKey("menu", jsonEncode(response.data!.menuAcces!));
            pref.saveKey("user", jsonEncode(response.data!.user!));
            await Future.delayed(Duration(seconds: 1));
            ref.read(appRouterProvider).go('/home');
            // ref.read(appRouterProvider).go('/rotationview');
          }
        })
      ],
    );
  }
}

class _background extends StatelessWidget {
  const _background();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        alignment: Alignment.bottomCenter,
        child: const Image(
          image: AssetImage('assets/truckimage.jpeg'),
          fit: BoxFit.fill,
          height: double.infinity,
        ));
  }
}
