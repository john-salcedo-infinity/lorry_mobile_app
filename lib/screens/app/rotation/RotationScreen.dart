import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/providers/providers.dart';
import 'package:app_lorry/routers/app_routes.dart';
import 'package:app_lorry/widgets/items/TireDragTarget.dart';
import 'package:app_lorry/widgets/widgets.dart';

class RotationScreen extends ConsumerWidget {
  const RotationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenwidth = MediaQuery.of(context).size.width * 0.44;
    final tires = ref.watch(tireListProvider);
    final dividedTires = ref.watch(tireListDivProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () {
            ref.read(appRouterProvider).pop();
          },
          child: const Row(
            children: [
              Icon(Icons.arrow_back_ios_new_rounded,
                  color: Apptheme.textColorPrimary),
              Text(
                'Atrás',
                style: TextStyle(
                    color: Apptheme.textColorPrimary,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.all(10),
            icon: const Image(image: AssetImage('assets/icons/Group 7.png')),
            onPressed: () {
              // Add the following line:
              // Preferences().saveKey("isLogin", "false");
              // Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
          IconButton(
            padding: const EdgeInsets.all(10),
            icon: const Image(image: AssetImage('assets/icons/Group_6.png')),
            onPressed: () {
              // Add the following line:
              // Preferences().saveKey("isLogin", "false");
              // Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Rotaciones & Giros",
                style: Apptheme.titleStyle,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text("Configuración Actual", style: Apptheme.subtitleStyle),
              const SizedBox(
                height: 20,
              ),
              const _drag_tires(),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                      type: 0,
                      (screenwidth * 0.8),
                      50,
                      const Text(
                        "Deshacer",
                        style: Apptheme.textPrimary,
                      ), () {
                    print("hos");
                    ref.read(tireListProvider.notifier).restore();
                    ref.read(tireListDivProvider.notifier).setDiv(tires);
                    ref.read(tireMovedPositionsProvider.notifier).clear();
                  
                  }),
                  const SizedBox(
                    width: 20,
                  ),
                  CustomButton(
                      (screenwidth * 0.8),
                      50,
                      const Text(
                        "Finalizar",
                        style: Apptheme.textPrimary,
                      ),
                      () {}),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _drag_tires extends ConsumerWidget {
  const _drag_tires();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tires = ref.watch(tireListProvider);
    final dividedTires = ref.watch(tireListDivProvider);
    ref.read(tireListDivProvider.notifier).setDiv(tires);
    double screenwidth = MediaQuery.of(context).size.width;

    // Dividir la lista de neumáticos en sublistas de longitud 6

    return Column(
      children: [
        for (final row in dividedTires)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (var i = 0; i < row.length; i++)
                Column(
                  children: [
                    TireDragItem(
                        tire: row[i], ispaced: (i % 2 == 0) ? true : false),
                  ],
                ),
            ],
          ),
        const SizedBox(
          height: 20,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nueva Configuración", style: Apptheme.subtitleStyle),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          width: screenwidth - 50,
          padding: const EdgeInsets.symmetric(vertical: 40),
          height: 310,
          decoration: BoxDecoration(
            color: Apptheme.lightOrange,
            border: Border.all(
              color: Apptheme.lightOrange,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            children: [
              for (final row in dividedTires)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (var i = 0; i < row.length; i++)
                      Column(
                        children: [
                          TireDragTarget(
                            tire: row[i],
                            onAcceptWithDetails: (details) {
                              ref
                                  .read(tireMovedPositionsProvider.notifier)
                                  .setposition(row[i].id);
                              ref
                                  .read(tireListProvider.notifier)
                                  .setposition(details.data, row[i].id);
                              ref
                                  .read(tireListDivProvider.notifier)
                                  .setDiv(tires);
                            },
                          ),
                        ],
                      ),
                  ],
                )
            ],
          ),
        ),
      ],
    );
  }
}
