import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/routers/app_routes.dart';

class LandingScreen extends ConsumerWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Apptheme.primary,
        body: Container(
          decoration: const BoxDecoration(color: Apptheme.primary),
          child: Stack(
            children: [
              const _background(),
              Container(
                color: Apptheme.primaryopacity,
              ),
              MainContent()
            ],
          ),
        ));
  }
}

class MainContent extends ConsumerWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      bottom: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Container()),
          GestureDetector(
            onTap: () {
              ref.read(appRouterProvider).go('/login');
            },
            child: const Hero(
              tag: "logo",
              child:
                  Image(image: AssetImage('assets/icons/Logo_lorry_white.png')),
            ),
          ),
          Expanded(child: Container()),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _background extends StatefulWidget {
  const _background();

  @override
  State<_background> createState() => _backgroundState();
}

class _backgroundState extends State<_background> {
  @override
  void initState() {
    super.initState();
    _printHolaAfterDelay(context);
  }

  void _printHolaAfterDelay(BuildContext context) async {
    await Future.delayed(Duration(seconds: 2));
    Preferences pref = Preferences();
    await pref.init();
    String token = pref.getValue("token");
    if (token == "") {
      context.go("/login");
      
    }else{
      context.go("/home");
    }
    print("Hola");
  }

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
