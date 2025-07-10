import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/config/configs.dart';
import 'package:app_lorry/routers/app_routes.dart';

void main() => runApp(
  const ProviderScope(child: MyApp())
);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final appRouter = ref.watch(appRouterProvider);
    
    return MaterialApp.router(
      title: 'Lorry app',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: Apptheme.lightTheme,
    );
  }
}