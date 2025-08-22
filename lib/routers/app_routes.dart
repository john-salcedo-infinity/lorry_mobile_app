import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/screens/app/InpectionTire/rotation/spinAndRotationScreen.dart';
import 'package:app_lorry/screens/app/InpectionTire/services/services_screen.dart';
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
      path: '/forgotPassword',
      builder: (context, state) => const Forgotpassscreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/inspectionDetails',
      builder: (context, state) {
        final data = state.extra as Map<String, HistoricalResult>;
        return InspectionDetails(historical: data['historical']);
      },
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
          final data = state.extra as ObservationSceenParams;
          return ObservationScreen(data: data);
        })),
    GoRoute(
      path: '/services',
      builder: (context, state) {
        final data = state.extra as ServiceScreenParams;
        return ServicesScreen(data: data);
      },
    ),
    GoRoute(
      path: '/rotation',
      builder: ((context, state) {
        final data = state.extra as SpinandrotationParams;
        return SpinAndRotationScreen(data: data);
      }),
    ),
  ]);
}
