import 'package:app_lorry/config/configs.dart';
import 'package:app_lorry/providers/app/provider/providerProvider.dart';
import 'package:app_lorry/widgets/shared/select_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/models/tire/provider.dart' as ProviderModel;
import 'package:dropdown_button2/dropdown_button2.dart';

// Clase para manejar los datos que se envían de vuelta
class ProviderSelection {
  final int? id;
  final String? nameProvider;

  ProviderSelection({this.id, this.nameProvider});
}

class SelectProvider extends ConsumerStatefulWidget {
  final int? selectedId;
  final ValueChanged<ProviderSelection?>? onChanged;
  final String? hintText;
  final bool enabled;

  const SelectProvider({
    super.key,
    this.selectedId,
    this.onChanged,
    this.hintText = 'Selecciona un proveedor',
    this.enabled = true,
  });

  @override
  ConsumerState<SelectProvider> createState() => _SelectProviderState();
}

class _SelectProviderState extends ConsumerState<SelectProvider> {
  int? _selectedValue;
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedId;
  }

  @override
  void didUpdateWidget(SelectProvider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedId != oldWidget.selectedId) {
      _selectedValue = widget.selectedId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerAsync = ref.watch(providerServiceProvider);

    return providerAsync.when(
      data: (providerResponse) {
        final List<ProviderModel.Provider> providers =
            providerResponse.data.results ?? [];

        if (_selectedValue != null &&
            !providers.any((provider) => provider.id == _selectedValue)) {
          _selectedValue = null;
        }

        return DropdownButtonHideUnderline(
          child: DropdownButtonFormField2<int>(
            value: _selectedValue,
            hint: Text(
              widget.hintText ?? 'Selecciona un proveedor',
              style: Apptheme.h4Medium(
                context,
                color: widget.enabled
                    ? Apptheme.textColorSecondary
                    : Apptheme.grayInput,
              ),
            ),
            isExpanded: true,
            items: providers.map<DropdownMenuItem<int>>((provider) {
              return DropdownMenuItem<int>(
                value: provider.id,
                child: Text(
                  provider.nameProvider ?? 'Sin nombre',
                  overflow: TextOverflow.ellipsis,
                  style: Apptheme.h4Medium(
                    context,
                    color: widget.enabled
                        ? Apptheme.textColorSecondary
                        : Apptheme.grayInput,
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
                      // Buscar el proveedor seleccionado para obtener su información
                      ProviderModel.Provider? selectedProvider;
                      try {
                        selectedProvider = providers.firstWhere(
                          (provider) => provider.id == newValue,
                        );
                      } catch (e) {
                        selectedProvider = null;
                      }

                      widget.onChanged!(ProviderSelection(
                        id: newValue,
                        nameProvider: selectedProvider?.nameProvider,
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
