import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/models/ManualPlateRegisterResponse.dart';
import 'package:app_lorry/models/Service_data.dart';
import 'package:app_lorry/routers/app_routes.dart';
import 'package:app_lorry/widgets/dialogs/confirmation_dialog.dart';
import 'package:app_lorry/widgets/dialogs/service_selection_dialog.dart';
import 'package:app_lorry/widgets/shared/Back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/widgets/buttons/BottomButton.dart';
import 'widgets/tire_grid.dart';

class TirePosition {
  final String id;
  final String? serialNumber;
  final bool isSpare;
  final bool isSelected;

  TirePosition({
    required this.id,
    this.serialNumber,
    this.isSpare = false,
    this.isSelected = false,
  });

  // Método para clonar la posición (útil para arrastrar y soltar)
  TirePosition copyWith({
    String? id,
    String? serialNumber,
    bool? isSpare,
    bool? isSelected,
  }) {
    return TirePosition(
      id: id ?? this.id,
      serialNumber: serialNumber ?? this.serialNumber,
      isSpare: isSpare ?? this.isSpare,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  // Verifica si la posición tiene una llanta
  bool get hasTire => serialNumber != null;
}

class SpinandrotationParams {
  final List<MountingResult> results;

  SpinandrotationParams({required this.results});
}

class SpinAndRotationScreen extends ConsumerStatefulWidget {
  final SpinandrotationParams data;

  const SpinAndRotationScreen({super.key, required this.data});

  @override
  ConsumerState<SpinAndRotationScreen> createState() =>
      _SpinAndRotationScreenState();
}

class _SpinAndRotationScreenState extends ConsumerState<SpinAndRotationScreen> {
  late List<TirePosition> currentConfiguration;
  late List<TirePosition> newConfiguration;
  TirePosition? selectedTire;
  TirePosition? tireWithActiveService;
  ServiceData? activeService;

  @override
  void initState() {
    super.initState();
    _initializeConfigurations();
  }

  void _initializeConfigurations() {
    currentConfiguration = _buildCurrentConfigurationFromResults();
    newConfiguration = _buildEmptyConfiguration();
  }

  List<TirePosition> _buildCurrentConfigurationFromResults() {
    List<TirePosition> positions = [];

    // Crear posiciones desde los resultados de montaje
    for (int i = 0; i < widget.data.results.length; i++) {
      final result = widget.data.results[i];
      if (result.tire != null && result.position != null) {
        positions.add(TirePosition(
          id: 'P${result.position}',
          serialNumber: result.tire!.integrationCode,
          isSpare: result.position! >= 100,
        ));
      }
    }

    // Ordenar por número de posición
    positions.sort((a, b) =>
        _extractPositionNumber(a.id).compareTo(_extractPositionNumber(b.id)));

    return positions;
  }

  List<TirePosition> _buildEmptyConfiguration() {
    final allPositions =
        currentConfiguration.map((t) => _extractPositionNumber(t.id)).toList();

    final regularPositions = allPositions.where((pos) => pos < 100).toList();
    final sparePositions = allPositions.where((pos) => pos >= 100).toList();

    final maxRegularPosition = regularPositions.isEmpty
        ? 12
        : regularPositions.reduce((a, b) => a > b ? a : b);

    List<TirePosition> newConfig = [];

    // Agregar posiciones regulares vacías
    for (int i = 1; i <= maxRegularPosition; i++) {
      newConfig.add(TirePosition(id: 'P$i'));
    }

    // Agregar posiciones de repuesto vacías
    for (int sparePos in sparePositions) {
      newConfig.add(TirePosition(id: 'P$sparePos', isSpare: true));
    }

    return newConfig;
  }

  int _extractPositionNumber(String positionId) {
    return int.tryParse(positionId.replaceAll('P', '')) ?? 0;
  }

  // ignore: unused_element
  void _moveTire(String fromPositionId, String toPositionId) {
    setState(() {
      final fromIndex =
          newConfiguration.indexWhere((t) => t.id == fromPositionId);
      final toIndex = newConfiguration.indexWhere((t) => t.id == toPositionId);

      if (fromIndex != -1 && toIndex != -1) {
        // Intercambiar las llantas
        final fromTire = newConfiguration[fromIndex];
        final toTire = newConfiguration[toIndex];

        newConfiguration[fromIndex] = toTire.copyWith(
          id: fromTire.id,
          isSpare: fromTire.isSpare,
        );
        newConfiguration[toIndex] = fromTire.copyWith(
          id: toTire.id,
          isSpare: toTire.isSpare,
        );
      }
    });
  }

  /// Copia una llanta de la configuración actual a la nueva configuración
  // ignore: unused_element
  void _copyTireToNewConfiguration(String fromPositionId, String toPositionId) {
    setState(() {
      final currentTire = currentConfiguration.firstWhere(
        (t) => t.id == fromPositionId,
        orElse: () => TirePosition(id: fromPositionId),
      );

      final toIndex = newConfiguration.indexWhere((t) => t.id == toPositionId);
      if (toIndex != -1) {
        newConfiguration[toIndex] = newConfiguration[toIndex].copyWith(
          serialNumber: currentTire.serialNumber,
        );
      }
    });
  }

  /// Limpia una posición en la nueva configuración
  // ignore: unused_element
  void _clearPosition(String positionId) {
    setState(() {
      final index = newConfiguration.indexWhere((t) => t.id == positionId);
      if (index != -1) {
        newConfiguration[index] = newConfiguration[index].copyWith(
          serialNumber: null,
        );
      }
    });
  }

  /// Maneja la selección/deselección de una llanta
  void _toggleTireSelection(TirePosition tire) {
    // Si hay un servicio activo, verificar si es la misma llanta o mostrar alerta
    if (tireWithActiveService != null) {
      if (tireWithActiveService!.id != tire.id) {
        _showActiveServiceAlert();
        return;
      }
    }

    setState(() {
      // Limpiar todas las selecciones previas en la configuración actual
      for (int i = 0; i < currentConfiguration.length; i++) {
        currentConfiguration[i] =
            currentConfiguration[i].copyWith(isSelected: false);
      }

      // Buscar en configuración actual
      final currentIndex =
          currentConfiguration.indexWhere((t) => t.id == tire.id);
      if (currentIndex != -1) {
        currentConfiguration[currentIndex] =
            currentConfiguration[currentIndex].copyWith(isSelected: true);
        selectedTire = currentConfiguration[currentIndex];
        print(
            'Llanta seleccionada en configuración actual: ${selectedTire!.id}, isSelected: ${selectedTire!.isSelected}');

        // Si la llanta tiene número de serie, mostrar el diálogo de selección de servicio
        if (selectedTire!.hasTire && selectedTire!.serialNumber != null) {
          _showServiceSelectionDialog();
        }
        return;
      }
    });
  }

  /// Muestra alerta cuando hay un servicio activo en otra llanta
  void _showActiveServiceAlert() {
    ToastHelper.show_alert(context,
        'Debe terminar el servicio de la llanta LL-${tireWithActiveService!.serialNumber} antes de seleccionar otra.');
  }

  /// Muestra el diálogo de selección de servicio
  void _showServiceSelectionDialog() {
    if (selectedTire?.serialNumber == null) return;

    ServiceSelectionDialog.show(
      context: context,
      tireSerial: selectedTire!.serialNumber!,
      onServiceSelected: (service) {
        setState(() {
          activeService = service;
          tireWithActiveService = selectedTire;
        });
        print(
            'Servicio ${service.id} asignado a llanta LL-${selectedTire!.serialNumber}');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Apptheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (selectedTire != null) ...[
                        _buildSelectedTireInfo(),
                        const SizedBox(height: 20),
                      ],
                      Row(
                        children: [
                          Text(
                            "Rotar & Girar",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Apptheme.textColorSecondary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.error, color: Apptheme.primary),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildConfigurationSection(
                        title: "Configuración Actual",
                        configuration: currentConfiguration,
                        isEmpty: false,
                        isSelectable: true,
                      ),
                      const SizedBox(height: 32),
                      _buildConfigurationSection(
                        title: "Nueva Configuración",
                        configuration: newConfiguration,
                        isEmpty: true,
                        isSelectable: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            BottomButton(
              gap: 20,
              buttons: [
                BottomButtonItem(
                  text: "Deshacer",
                  onPressed: () {},
                  buttonType: 2,
                ),
                BottomButtonItem(
                  text: "Finalizar",
                  onPressed: () {},
                  buttonType: 1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigurationSection({
    required String title,
    required List<TirePosition> configuration,
    required bool isEmpty,
    bool isSelectable = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Apptheme.textColorSecondary,
          ),
        ),
        const SizedBox(height: 16),
        TireGrid(
          configuration: configuration,
          isEmpty: isEmpty,
          onTireSelect: isSelectable ? _toggleTireSelection : null,
        ),
      ],
    );
  }

  Widget _buildSelectedTireInfo() {
    if (selectedTire == null) return Container();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tire_repair,
                color: Apptheme.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                "Información de Llanta Seleccionada",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Apptheme.textColorSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow("Posición:", selectedTire!.id),
          if (selectedTire!.hasTire) ...[
            _buildInfoRow("Serie:", selectedTire!.serialNumber ?? "N/A"),
            _buildInfoRow(
                "Tipo:", selectedTire!.isSpare ? "Repuesto" : "Regular"),
          ] else ...[
            _buildInfoRow("Estado:", "Posición vacía"),
            _buildInfoRow(
                "Tipo:", selectedTire!.isSpare ? "Repuesto" : "Regular"),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Apptheme.textColorSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Apptheme.textColorPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Back(
      showHome: true,
      showDelete: true,
      showNotifications: true,
      onDeletePressed: () {
        ConfirmationDialog.show(
          context: context,
          title: "Eliminar Inspección",
          message:
              "¿Estás seguro que deseas eliminar la inspección? No podrás deshacer esta acción",
          cancelText: "Cancelar",
          acceptText: "Aceptar",
          onAccept: () {
            ref.read(appRouterProvider).pushReplacement('/ManualPlateRegister');
          },
        );
      },
      onBackPressed: () {
        ConfirmationDialog.show(
          context: context,
          title: "Salir de acciones",
          message:
              "¿Estás seguro que deseas salir de las acciones? No podrás deshacer esta acción",
          cancelText: "Cancelar",
          acceptText: "Aceptar",
          onAccept: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
