import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/screens/screens.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_routes.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
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
      path: '/inspectionDetails',
      builder: (context, state) {
        final data = state.extra as Map<String, HistoricalResult>;
        return InspectionDetails(historical: data['historical']);
      },
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
      path: '/ChangePassword',
      builder: (context, state) => const ChangePass(),
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
    // GoRoute(
    //   path: '/NewPlateRegister',
    //   builder: (context, state) => NewPlateRegister(),
    // ),
    GoRoute(
      path: '/InfoVehicles',
      builder: (context, state) {
        final data = state.extra as MountingData;
        return InfoVehicles(
            vehicleData: data.results!.first.vehicle!,
            responseData: data.results!);
      },
    ),
    GoRoute(
      path: '/DetailTire',
      builder: (context, state) {
        final data = state.extra as DetailTireParams;
        return DetailTire(data: data);
      },
    ),
    GoRoute(
      path: '/TireProfundity',
      builder: (context, state) {
        final data = state.extra as TireProfundityParams;
        return TireProfundity(data: data);
      },
    ),
    GoRoute(
        path: "/observations",
        builder: ((context, state) {
          return ObservationScreen();
        })),
    GoRoute(path: "/test", builder: ((context, state) => const TestScreen()))
  ]);
}
