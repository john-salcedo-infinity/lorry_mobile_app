import 'dart:async';

import 'package:app_lorry/services/AuthService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/providers/app/home/homeProvider.dart';
import 'package:app_lorry/routers/app_routes.dart';
import 'package:app_lorry/widgets/buttons/CustomButton.dart';
import 'package:app_lorry/widgets/items/ItemHistorial.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Timer? _debounce;

  void _onSearchChanged(String value) {
  
    if (_debounce?.isActive ?? false) _debounce!.cancel();

   
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchQueryProvider.notifier).state = value;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  final queryParamsProvider = Provider<Map<String, String>>((ref) {
    final search = ref.watch(searchQueryProvider);
    return {
      if (search.isNotEmpty) 'search': search,
    };
  });

  @override
  Widget build(BuildContext context) {
    final queryParams = ref.watch(queryParamsProvider);

    final inspectionService =
        ref.watch(inspectionAllServiceProvider(queryParams));

    return Scaffold(
      backgroundColor: Apptheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Apptheme.backgroundColor,
        title: const Image(image: AssetImage('assets/icons/logo_lorryv2.png')),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _Profile(),
                      const SizedBox(height: 10),
                      const Text(
                        "HISTORIAL INSPECCIONES",
                        style: Apptheme.subtitleStyle,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        child: TextFormField(
                          obscureText: false,
                          style: const TextStyle(fontSize: 15),
                          decoration: Apptheme.inputDecorationPrimaryv2(
                              "Buscar por VHC asociada"),
                          onChanged: _onSearchChanged,
                        ),
                      ),
                      const SizedBox(height: 20),
                      inspectionService.when(
                        data: (data) => ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.data.results.length,
                          itemBuilder: (context, index) {
                            return ItemHistorial(
                              historical: data.data.results[index],
                            );
                          },
                        ),
                        error: (error, stackTrace) => Text('Error: $error'),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: CustomButton(
              342,
              46,
              const Text(
                "Iniciar Nueva Inspección",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              () {
                ref.read(appRouterProvider).push('/ManualPlateRegister');
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Profile extends StatefulWidget {
  const _Profile();

  @override
  State<_Profile> createState() => _ProfileState();
}

class _ProfileState extends State<_Profile> {
  User authUser = User();

  @override
  void initState() {
    super.initState();
    HelpersGeneral.getAuthUser().then((value) {
      setState(() {
        authUser = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/icons/Vector.png'),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                authUser.name ?? 'Usuario',
                style: Apptheme.titleStylev2,
              ),
              Text(
                authUser.groups?.isNotEmpty == true
                    ? authUser.groups![0].name ?? ''
                    : '',
                style: Apptheme.subtitleStylev2,
              ),
            ],
          ),
          const Spacer(),
          HomeMenu(),
        ],
      ),
    );
  }
}

class HomeMenu extends ConsumerWidget {
  const HomeMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void logOut() async {
      try {
        final response = await Authservice.logout();
        if (!context.mounted) return;

        if (response.success == true) {
          ToastHelper.show_alert(context, "Sesión cerrada correctamente");

          // Clear stored data
          Preferences pref = Preferences();
          await pref.init();
          pref.removeKey("token");
          pref.removeKey("refresh-token");
          pref.removeKey("menu");
          pref.removeKey("user");
          await Future.delayed(Duration(seconds: 1));
          if (context.mounted) {
            ref.read(appRouterProvider).go('/');
          }
        } else {
          if (context.mounted) {
            ToastHelper.show_alert(context, "Error al cerrar sesión");
          }
        }
      } catch (e) {
        if (context.mounted) {
          ToastHelper.show_alert(context, "Error al cerrar sesión");
        }
      }
    }

    ;

    return PopupMenuButton<String>(
      color: Colors.white,
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      offset: const Offset(-30, 20),
      onSelected: (value) async {
        if (!context.mounted) return;

        switch (value) {
          case 'change_password':
            // Handle change password action
            break;
          case 'logout':
            logOut();
        }
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<String>(
          value: 'change_password',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Cambiar Contraseña'),
              Icon(Icons.lock_outline, size: 18),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Cerrar Sesión'),
              Icon(Icons.logout, size: 18),
            ],
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: Colors.grey),
    );
  }
}
