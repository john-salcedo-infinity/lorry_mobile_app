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

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inspections = ref.watch(inspectionsProvider);
    final inspectionService = ref.watch(inspectionAllServiceProvider);
    print("ref: $ref");
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: false,
      backgroundColor: Apptheme.backgroundColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Apptheme.backgroundColor,
        automaticallyImplyLeading: false,
        title: const Image(image: AssetImage('assets/icons/logo_lorryv2.png')),
        // actions: [
        //   IconButton(
        //     padding: const EdgeInsets.all(10),
        //     icon: const Image(image: AssetImage('assets/icons/Group_6.png')),
        //     onPressed: () {
        //       // Lógica para cerrar sesión o realizar otra acción
        //     },
        //   ),
        // ],
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

                      // Campo de búsqueda
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
                          onChanged: (value) {
                            // Aquí puedes implementar la lógica de búsqueda
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Lista de historial de inspecciones
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
                        error: (error, stackTrace) =>
                            Text('Error: $error'), // Manejo de errores
                        loading: () => const Center(
                            child:
                                CircularProgressIndicator()), // Indicador de carga
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Botón fijo en la parte inferior
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: CustomButton(
              342,
              46,
              const Text(
                "Iniciar Nueva Inspección",
                style: TextStyle(
                  fontWeight: FontWeight.bold, // ✅ Ajusta el estilo del texto
                  fontSize: 14,
                ),
              ),
              () {
                // ref.read(appRouterProvider).push('/PlateRegister');
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
  const _Profile({super.key});

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
          IconButton(
            onPressed: () {
              // Lógica para más acciones
            },
            icon: const Icon(Icons.more_vert, color: Apptheme.backgroundColor),
          ),
        ],
      ),
    );
  }
}
