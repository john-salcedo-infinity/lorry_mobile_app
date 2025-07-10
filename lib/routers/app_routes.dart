import 'package:app_lorry/models/ManualPlateRegisterResponse.dart';
import 'package:app_lorry/screens/app/new_inspection/02_manual_plate_registe.dart';
import 'package:app_lorry/screens/app/new_inspection/03_new_plate_register.dart';
import 'package:app_lorry/screens/app/vehiclesData/InfoVehicles.dart';
import 'package:app_lorry/screens/app/InpectionTire/DetailTire.dart';
import 'package:app_lorry/screens/app/InpectionTire/TireProfundity.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:app_lorry/screens/app/dashboard/Dashboard.dart';
import 'package:app_lorry/screens/screens.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_routes.g.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(initialLocation: "/", routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LandingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/rotationview',
      builder: (context, state) => const RotationScreen(),
    ),
    GoRoute(
      path: '/Dashboard',
      builder: (context, state) => const Dashboard(),
    ),
    GoRoute(
      path: '/PlateRegister',
      builder: (context, state) {
        return PlateRegister.fromExtra(state.extra);
      },
    ),
    GoRoute(
      path: '/ManualPlateRegister',
      builder: (context, state) => ManualPlateRegister(),
    ),
    GoRoute(
      path: '/NewPlateRegister',
      builder: (context, state) => NewPlateRegister(),
    ),
    GoRoute(
      path: '/InfoVehicles',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return InfoVehicles(data: data);
      },
    ),
    GoRoute(
      path: '/DetailTire',
      builder: (BuildContext context, state) {
        final data = state.extra as Map<String, dynamic>;
        return DetailTire(data: data);
      },
    ),
    GoRoute(
      path: '/TireProfundity',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return TireProfundity(data: data);
      },
    ),
    GoRoute(path: "/test", builder: ((context, state) => const TestScreen()))
  ]);

  
}