import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/models/ManualPlateRegisterResponse.dart';
import 'package:app_lorry/widgets/shared/back.dart';
import 'package:app_lorry/widgets/shared/select_novelty.dart';
import 'package:app_lorry/widgets/buttons/CustomButton.dart';
import 'package:app_lorry/widgets/shared/image_picker_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

// Clase para manejar cada novedad individual
class NoveltyItem {
  final TextEditingController descriptionController;
  int? conceptNovelty;
  String? imageBase64;

  NoveltyItem({
    required this.descriptionController,
    this.conceptNovelty,
    this.imageBase64,
  });

  void dispose() {
    descriptionController.dispose();
  }

  Map<String, dynamic> toMap() {
    final map = {
      'concept_novelty': conceptNovelty,
      'description': descriptionController.text,
    };

    // Solo agregar image si no es null
    if (imageBase64 != null) {
      map['image'] = imageBase64;
    }

    return map;
  }
}

class ObservationSceenParams {
  final MountingResult currentMountingResult;
  final List<Map<String, dynamic>>? existingNovelties;

  ObservationSceenParams({
    required this.currentMountingResult,
    this.existingNovelties,
  });
}

class ObservationScreen extends ConsumerStatefulWidget {
  final ObservationSceenParams data;
  const ObservationScreen({super.key, required this.data});

  @override
  ConsumerState<ObservationScreen> createState() => _ObservationScreenState();
}

class _ObservationScreenState extends ConsumerState<ObservationScreen> {
  late final MountingResult currentMounting;

  // Lista para manejar los items de novedad
  List<NoveltyItem> _noveltyItems = [];

  @override
  void initState() {
    super.initState();
    currentMounting = widget.data.currentMountingResult;

    // Cargar novedades existentes si las hay
    if (widget.data.existingNovelties != null &&
        widget.data.existingNovelties!.isNotEmpty) {
      _loadExistingNovelties(widget.data.existingNovelties!);
    } else {
      // Si no hay novedades existentes, agregar una por defecto
      _addNoveltyItem();
    }
  }

  // Método para cargar novedades existentes
  void _loadExistingNovelties(List<Map<String, dynamic>> existingNovelties) {
    for (var novelty in existingNovelties) {
      final controller =
          TextEditingController(text: novelty['description'] ?? '');
      _noveltyItems.add(NoveltyItem(
        descriptionController: controller,
        conceptNovelty: novelty['concept_novelty'],
        imageBase64: novelty['image'],
      ));
    }

    // Si no hay novedades, agregar una por defecto
    if (_noveltyItems.isEmpty) {
      _addNoveltyItem();
    }
  }

  @override
  void dispose() {
    // Dispose de todos los controladores
    for (var item in _noveltyItems) {
      item.dispose();
    }
    super.dispose();
  }

  // Método para agregar una nueva novedad
  void _addNoveltyItem() {
    setState(() {
      _noveltyItems.add(NoveltyItem(
        descriptionController: TextEditingController(),
      ));
    });
  }

  // Método para remover una novedad
  void _removeNoveltyItem(int index) {
    if (_noveltyItems.length > 1) {
      setState(() {
        _noveltyItems[index].dispose();
        _noveltyItems.removeAt(index);
      });
    }

    // Asegurar que siempre haya al menos una novedad
    if (_noveltyItems.isEmpty) {
      _addNoveltyItem();
    }
  }

  // Método para obtener el array de novedades en el formato requerido
  List<Map<String, dynamic>> _getNoveltiesArray() {
    return _noveltyItems
        .where((item) => item.conceptNovelty != null)
        .map((item) => item.toMap())
        .toList();
  }

  // Método público para obtener las novedades (para usar desde fuera de la clase)
  List<Map<String, dynamic>> get noveltiesArray => _getNoveltiesArray();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          _buildHeader(),
          Expanded(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: Apptheme.titleStyle,
                      children: [
                        const TextSpan(text: 'Novedad - '),
                        TextSpan(
                          text:
                              'LL-${currentMounting.tire?.integrationCode ?? ''}',
                          style:
                              const TextStyle(color: Apptheme.textColorPrimary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildNoveltyForm(),
                  const SizedBox(
                      height:
                          100), // Espacio adicional para evitar que el contenido se oculte detrás del botón
                ],
              ),
            ),
          )),
          // Botón fijo en la parte inferior
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: CustomButton(
              double.infinity,
              50,
              const Text(
                'Guardar Novedades',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              () {
                final novelties = _getNoveltiesArray();
                Navigator.of(context).pop(novelties);
              },
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.only(top: 30, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Back(),
          IconButton(
            onPressed: () => context.go('/home'),
            icon: SvgPicture.asset(
              'assets/icons/Icono_Casa_Lorry.svg',
              width: 40,
              height: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoveltyForm() {
    // Asegurar que siempre haya al menos una novedad
    if (_noveltyItems.isEmpty) {
      _addNoveltyItem();
    }

    return Column(
      children: [
        // Lista de novedades
        ...List.generate(_noveltyItems.length, (index) {
          return _buildNoveltyItem(index);
        }),
        // Botón para agregar nueva novedad
        const SizedBox(height: 20),
        Center(
          child: IconButton(
            onPressed: _addNoveltyItem,
            icon: const Icon(Icons.add, color: Apptheme.textColorPrimary),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: CircleBorder(),
              side: BorderSide(color: Apptheme.textColorPrimary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoveltyItem(int index) {
    final noveltyItem = _noveltyItems[index];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Apptheme.textColorSecondary,
                ),
                children: [
                  const TextSpan(text: 'NOVEDAD  '),
                  TextSpan(
                    text: '#${index + 1}',
                    style: TextStyle(
                      color: Apptheme.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            // Solo mostrar botón de eliminar si hay más de una novedad
            if (_noveltyItems.length > 1)
              TextButton(
                onPressed: () => _removeNoveltyItem(index),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: Text("Eliminar",
                    style: TextStyle(
                      color: Apptheme.secondary,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    )),
              ),
          ],
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Selector de tipo de novedad

              ImagePickerCard(
                initialImageBase64: noveltyItem.imageBase64,
                onImageChanged: (imageBase64) {
                  noveltyItem.imageBase64 = imageBase64;
                },
                width: 136,
                height: 136,
              ),

              const SizedBox(height: 20),

              Text(
                'TIPO DE NOVEDAD',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Apptheme.textColorSecondary,
                ),
              ),
              const SizedBox(height: 8),
              SelectNovelty(
                hintText: 'Selecciona una novedad',
                selectedId: noveltyItem.conceptNovelty,
                onChanged: (NoveltySelection? selection) {
                  if (selection != null) {
                    setState(() {
                      noveltyItem.conceptNovelty = selection.id;
                    });

                    // Actualizar el campo de descripción con la descripción de la novedad
                    noveltyItem.descriptionController.text =
                        selection.description ?? '';
                  }
                },
              ),
              const SizedBox(height: 16),
               Text(
                'OBSERVACIÓN',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Apptheme.textColorSecondary,
                ),
              ),
              TextFormField(
                controller: noveltyItem.descriptionController,
                minLines: 4,
                maxLines: 4,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Apptheme.grayInput, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Apptheme.AlertOrange, width: 2),
                  ),
                  fillColor: Apptheme.backgroundColor,
                  filled: true,
                  hintText: 'Escribe tu observación aquí...',
                ),
              ),
              const SizedBox(height: 20),

              // Selector de imagen
            ],
          ),
        ),
      ],
    );
  }
}
