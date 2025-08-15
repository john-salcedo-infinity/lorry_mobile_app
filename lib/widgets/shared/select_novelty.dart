import 'package:app_lorry/config/configs.dart';
import 'package:app_lorry/providers/app/novelty/noveltyProvider.dart';
import 'package:app_lorry/widgets/shared/select_loading.dart';
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

        if (_selectedValue != null &&
            !novelties.any((novelty) => novelty.id == _selectedValue)) {
          _selectedValue = null;
        }

        return DropdownButtonHideUnderline(
          child: DropdownButtonFormField2<int>(
            value: _selectedValue,
            hint: Text(
              widget.hintText ?? 'Selecciona una novedad',
              style: Apptheme.h4Medium(
                context,
                color: widget.enabled
                    ? Apptheme.textColorSecondary
                    : Apptheme.grayInput,
              ),
            ),
            isExpanded: true,
            items: novelties.map<DropdownMenuItem<int>>((novelty) {
              return DropdownMenuItem<int>(
                value: novelty.id,
                child: Text(
                  novelty.name ?? 'Sin nombre',
                  overflow: TextOverflow.ellipsis,
                  style: Apptheme.h4Medium(
                    context,
                    color: Apptheme.textColorSecondary,
                  ),
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
                      Novelty? selectedNovelty = novelties
                          .where(
                            (novelty) => novelty.id == newValue,
                          )
                          .firstOrNull;

                      widget.onChanged!(NoveltySelection(
                        id: newValue,
                        description: selectedNovelty?.description,
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
            buttonStyleData: ButtonStyleData(
              height: 40,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                border: Border.all(
                  color: _isDropdownOpen
                      ? Apptheme.selectActiveBorder
                      : Apptheme.lightGray,
                  width: 1,
                ),
                color: _isDropdownOpen
                    ? Apptheme.selectActiveBackground
                    : Apptheme.backgroundColor,
              ),
            ),
            iconStyleData: IconStyleData(
              icon: Icon(
                !_isDropdownOpen
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_up,
                color: _isDropdownOpen
                    ? Apptheme.selectActiveSelectChevron
                    : Apptheme.grayInput,
                size: 20,
              ),
            ),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 250,
              elevation: 0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Apptheme.lightGray,
                  width: 1,
                ),
                color: Colors.white,
              ),
              offset: Offset(0, -5),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: WidgetStateProperty.all<double>(4),
              ),
            ),
          ),
        );
      },
      loading: () => const SelectLoading(),
      error: (error, stack) =>
          const Center(child: Text('Error al cargar datos')),
    );
  }
}
