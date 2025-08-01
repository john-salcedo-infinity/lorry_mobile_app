import 'package:app_lorry/config/configs.dart';
import 'package:app_lorry/providers/app/novelty/noveltyProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/models/models.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

// Clase para manejar los datos que se envían de vuelta
class NoveltySelection {
  final int? id;
  final String? description;

  NoveltySelection({this.id, this.description});
}

class SelectNovelty extends ConsumerStatefulWidget {
  final int? selectedId;
  final ValueChanged<NoveltySelection?>? onChanged;
  final String? hintText;
  final bool enabled;

  const SelectNovelty({
    super.key,
    this.selectedId,
    this.onChanged,
    this.hintText = 'Selecciona una novedad',
    this.enabled = true,
  });

  @override
  ConsumerState<SelectNovelty> createState() => _SelectNoveltyState();
}

class _SelectNoveltyState extends ConsumerState<SelectNovelty> {
  int? _selectedValue;
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedId;
  }

  @override
  void didUpdateWidget(SelectNovelty oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedId != oldWidget.selectedId) {
      _selectedValue = widget.selectedId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final noveltyAsync = ref.watch(noveltyServiceProvider);

    return noveltyAsync.when(
      data: (noveltyResponse) {
        final List<Novelty> novelties = noveltyResponse.data.results ?? [];

        return Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(
              color: _isDropdownOpen ? Colors.orange : Colors.grey,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(4),
            color: Apptheme.backgroundColor,
          ),
          child: DropdownButtonFormField2<int>(
            value: _selectedValue,
            hint: Text(widget.hintText ?? 'Selecciona una novedad'),
            isExpanded: true,
            style: TextStyle(
              color: widget.enabled
                  ? Apptheme.textColorSecondary
                  : Apptheme.grayInput,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            buttonStyleData: ButtonStyleData(
              decoration: BoxDecoration(
                color: Apptheme.backgroundColor,
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.only(right: 12),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 600,
              offset: Offset(0, -3),
              useSafeArea: true,
              direction: DropdownDirection.textDirection,
              decoration: BoxDecoration(
                color: Apptheme.backgroundColor,
                borderRadius: BorderRadius.circular(4),
              ),
              scrollbarTheme: ScrollbarThemeData(
                thumbColor: WidgetStateProperty.all(Apptheme.secondaryv3),
                trackColor: WidgetStateProperty.all(Apptheme.lightGreen),
              ),
            ),
            iconStyleData: IconStyleData(
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: widget.enabled
                    ? Apptheme.textColorSecondary
                    : Apptheme.textColorPrimary,
              ),
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            items:
                novelties.asMap().entries.map<DropdownMenuItem<int>>((entry) {
              Novelty novelty = entry.value;

              return DropdownMenuItem<int>(
                value: novelty.id,
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        novelty.name ?? 'Sin nombre',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: widget.enabled
                ? (int? newValue) {
                    setState(() {
                      _selectedValue = newValue;
                    });
                    if (widget.onChanged != null) {
                      // Buscar la novedad seleccionada para obtener su descripción
                      Novelty? selectedNovelty = novelties.firstWhere(
                        (novelty) => novelty.id == newValue,
                        orElse: () =>
                            Novelty(), // Asegúrate de tener un constructor vacío o maneja el null
                      );

                      widget.onChanged!(NoveltySelection(
                        id: newValue,
                        description: selectedNovelty
                            .description, // Asume que Novelty tiene un campo description
                      ));
                    }
                  }
                : null,
            onMenuStateChange: (isOpen) {
              setState(() {
                _isDropdownOpen = isOpen;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Por favor selecciona una opción';
              }
              return null;
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          const Center(child: Text('Error al cargar datos')),
    );
  }
}
