import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/routers/app_routes.dart';
import 'package:app_lorry/widgets/buttons/CustomButton.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard ({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenwidth = MediaQuery.of(context).size.width * 0.44;

    return Scaffold(
      appBar: AppBar(
        title: const Image(image: AssetImage('assets/icons/logo_lorryv2.png')),
        actions: [
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
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                SizedBox(width: 10),
                CustomButton(
                    screenwidth,
                    100,
                    const Text("Rotaciones Test View"),
                    () {
                      ref.read(appRouterProvider).push('/rotationview');
                      }),
                SizedBox(width: 10),
                CustomButton(screenwidth, 100, const Text("Bluethoo test view"),
                    () {ref.read(appRouterProvider).push('/test');})
              ],
            )
          ],
        ),
      )),
    );
  }
}
