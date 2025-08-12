import 'package:app_lorry/config/configs.dart';
import 'package:app_lorry/providers/app/provider/providerProvider.dart';
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
  final bool showBorder;

  const SelectProvider({
    super.key,
    this.selectedId,
    this.onChanged,
    this.hintText = 'Selecciona un proveedor',
    this.enabled = true,
    this.showBorder = true,
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

        return Container(
          width: double.infinity,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: _isDropdownOpen ? Colors.orange : Apptheme.grayInput,
              width: 1,
            ),
            color: Apptheme.backgroundColor,
          ),
          child: DropdownButtonFormField2<int>(
            value: _selectedValue,
            hint: Text(
              widget.hintText ?? 'Selecciona un proveedor',
              style: TextStyle(
                color: widget.enabled
                    ? Apptheme.textColorSecondary
                    : Apptheme.grayInput,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            isExpanded: true,
            style: TextStyle(
              color: widget.enabled
                  ? Apptheme.textColorSecondary
                  : Apptheme.grayInput,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            buttonStyleData: ButtonStyleData(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
              height: 40,
              width: double.infinity,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 600,
              offset: const Offset(0, 0),
              useSafeArea: true,
              direction: DropdownDirection.textDirection,
              decoration: BoxDecoration(
                color: Apptheme.backgroundColor,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: const Color.fromRGBO(148, 148, 148, 0.5),
                  width: 1,
                ),
              ),
              scrollbarTheme: ScrollbarThemeData(
                thumbColor: WidgetStateProperty.all(Apptheme.secondaryv3),
                trackColor: WidgetStateProperty.all(Apptheme.lightGreen),
              ),
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Color.fromRGBO(148, 148, 148, 1),
                size: 20,
              ),
              iconSize: 20,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
            items:
                providers.asMap().entries.map<DropdownMenuItem<int>>((entry) {
              ProviderModel.Provider provider = entry.value;

              return DropdownMenuItem<int>(
                value: provider.id,
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        provider.nameProvider ?? 'Sin nombre',
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
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          const Center(child: Text('Error al cargar datos')),
    );
  }
}
