import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/config/configs.dart';
import 'package:app_lorry/config/app_config.dart';
import 'package:app_lorry/routers/app_routes.dart';
import 'package:app_lorry/helpers/permission_helper.dart';
import 'package:intl/date_symbol_data_local.dart';

const String appFlavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.setFlavorFromString(appFlavor);
  await AppConfig.initialize();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await initializeDateFormatting('es_ES', null);
  await PermissionHandler.requestInitialPermissions();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: AppConfig.debugMode,
      routerConfig: appRouter,
      theme: Apptheme.lightTheme,
    );
  }
}