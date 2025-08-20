import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/models/ManualPlateRegisterResponse.dart';
import 'package:app_lorry/models/Service_data.dart';
import 'package:app_lorry/providers/auth/loginProvider.dart';
import 'package:app_lorry/routers/app_routes.dart';
import 'package:app_lorry/services/InspectionService.dart';
import 'package:app_lorry/widgets/dialogs/confirmation_dialog.dart';
import 'package:app_lorry/widgets/dialogs/service_selection_dialog.dart';
import 'package:app_lorry/widgets/shared/Back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/widgets/buttons/BottomButton.dart';
import 'widgets/tire_grid.dart';

class TirePosition {
  final String? id;
  final String position;
  final String? mounting;
  final String? serialNumber;
  final bool isSpare;
  final bool isSelected;
  final String?
      destinationPosition; // Nueva posición donde quedará en la nueva configuración

  TirePosition({
    this.id,
    required this.position,
    this.mounting,
    this.serialNumber,
    this.isSpare = false,
    this.isSelected = false,
    this.destinationPosition,
  });

  // Método para clonar la posición (útil para arrastrar y soltar)
  TirePosition copyWith({
    String? id,
    String? position,
    String? serialNumber,
    String? mounting,
    bool? isSpare,
    bool? isSelected,
    String? destinationPosition,
    bool clearId = false,
    bool clearSerialNumber = false,
  }) {
    return TirePosition(
      id: clearId ? null : (id ?? this.id),
      position: position ?? this.position,
      serialNumber:
          clearSerialNumber ? null : (serialNumber ?? this.serialNumber),
      mounting: mounting ?? this.mounting,
      isSpare: isSpare ?? this.isSpare,
      isSelected: isSelected ?? this.isSelected,
      destinationPosition: destinationPosition ?? this.destinationPosition,
    );
  }

  // Verifica si la posición tiene una llanta
  bool get hasTire => serialNumber != null;
}

// Clase para representar un movimiento realizado (para poder deshacerlo)
class TireMovement {
  final String tireId;
  final String serialNumber;
  final String sourcePosition;
  final String destinationPosition;
  final String sourceMounting;
  final String destinationMounting;
  final ServiceData service;
  final int sourceIndex;
  final int destinationIndex;

  TireMovement({
    required this.tireId,
    required this.serialNumber,
    required this.sourcePosition,
    required this.destinationPosition,
    required this.sourceMounting,
    required this.destinationMounting,
    required this.service,
    required this.sourceIndex,
    required this.destinationIndex,
  });
}

class SpinandrotationParams {
  final List<MountingResult> results;
  final List<String>? turnRotationMountigs;
  final Map<String, Object>? inspectionData;

  SpinandrotationParams({
    required this.results,
    this.turnRotationMountigs,
    this.inspectionData,
  });
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
  bool canPlaceTire = false; // Para controlar cuando se puede colocar la llanta
  bool activeFinishBtn = false;

  // Historial de movimientos para la funcionalidad de deshacer
  List<TireMovement> movementHistory = [];

  @override
  void initState() {
    super.initState();
    _initializeConfigurations();
  }

  void _initializeConfigurations() {
    currentConfiguration = _buildCurrentConfigurationFromResults();
    newConfiguration = _buildNewConfigurationFromResults();
  }

  List<TirePosition> _buildCurrentConfigurationFromResults() {
    List<TirePosition> positions = [];

    // Crear posiciones desde los resultados de montaje
    for (int i = 0; i < widget.data.results.length; i++) {
      final result = widget.data.results[i];
      if (result.tire != null && result.position != null) {
        // Mostrar todas las posiciones, pero solo con neumáticos si están en turnRotationMountigs
        if (widget.data.turnRotationMountigs != null &&
            widget.data.turnRotationMountigs!.contains(result.id.toString())) {
          // Posición con neumático (está en la lista de rotación)
          positions.add(TirePosition(
              id: result.tire!.id.toString(),
              position: result.position!.toString(),
              serialNumber: result.tire!.integrationCode,
              isSpare: result.position! >= 100,
              mounting: result.id.toString(),
              destinationPosition: null));
        } else {
          // Posición vacía (no está en la lista de rotación)
          // La destinationPosition es la misma posición actual ya que no se mueve
          positions.add(TirePosition(
            id: null,
            position: result.position!.toString(),
            serialNumber: null,
            isSpare: result.position! >= 100,
            mounting: result.id.toString(),
            destinationPosition: result.position!.toString(),
          ));
        }
      }
    }

    // Ordenar por número de posición
    positions.sort(
        (a, b) => (int.parse(a.position)).compareTo(int.parse(b.position)));

    return positions;
  }

  List<TirePosition> _buildNewConfigurationFromResults() {
    List<TirePosition> newConfig = [];

    for (int i = 0; i < widget.data.results.length; i++) {
      final result = widget.data.results[i];
      if (result.tire != null && result.position != null) {
        // Si está en turnRotationMountigs, crear posición vacía
        if (widget.data.turnRotationMountigs != null &&
            widget.data.turnRotationMountigs!.contains(result.id.toString())) {
          newConfig.add(TirePosition(
            id: null,
            position: result.position!.toString(),
            serialNumber: null,
            isSpare: result.position! >= 100,
            mounting: result.id.toString(),
            isSelected: false,
          ));
        } else {
          // Si NO está en turnRotationMountigs, colocar el neumático en nueva configuración
          newConfig.add(TirePosition(
            id: result.tire!.id.toString(),
            position: result.position!.toString(),
            serialNumber: result.tire!.integrationCode,
            isSpare: result.position! >= 100,
            mounting: result.id.toString(),
            isSelected: false,
          ));
        }
      }
    }

    // Ordenar por número de posiciones
    newConfig.sort(
        (a, b) => (int.parse(a.position)).compareTo(int.parse(b.position)));

    return newConfig;
  }

  /// Maneja la selección/deselección de una llanta
  void _toggleTireSelection(TirePosition tire) {
    // No permitir selección si la posición está vacía (no tiene neumático)
    if (!tire.hasTire) {
      return;
    }

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
        currentConfiguration[i] = currentConfiguration[i].copyWith(
          isSelected: false,
        );
      }

      // Buscar en configuración actual
      final currentIndex =
          currentConfiguration.indexWhere((t) => t.id == tire.id);
      if (currentIndex != -1) {
        currentConfiguration[currentIndex] =
            currentConfiguration[currentIndex].copyWith(
          isSelected: true,
        );
        selectedTire = currentConfiguration[currentIndex];

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
          canPlaceTire = true; // Habilitar la colocación de la llanta
        });
      },
    );
  }

  /// Deshace el último movimiento realizado
  void _undoLastMovement() {
    if (movementHistory.isEmpty) {
      ToastHelper.show_alert(context, 'No hay movimientos para deshacer.');
      return;
    }

    setState(() {
      // Obtener el último movimiento
      final lastMovement = movementHistory.removeLast();

      // Restaurar la llanta en la configuración actual
      currentConfiguration[lastMovement.sourceIndex] =
          currentConfiguration[lastMovement.sourceIndex].copyWith(
        id: lastMovement.tireId,
        serialNumber: lastMovement.serialNumber,
        isSelected: false,
        destinationPosition: null, // Limpiar destinationPosition
      );

      // Quitar la llanta de la nueva configuración
      newConfiguration[lastMovement.destinationIndex] =
          newConfiguration[lastMovement.destinationIndex].copyWith(
        clearId: true,
        clearSerialNumber: true,
      );

      // Limpiar cualquier selección activa
      selectedTire = null;
      tireWithActiveService = null;
      activeService = null;
      canPlaceTire = false;

      // Actualizar estado del botón basado en si todas las llantas están colocadas
      activeFinishBtn = checkAllTiresPlaced();

      // Mostrar mensaje de confirmación
      ToastHelper.show_success(context,
          'Movimiento deshecho: Llanta LL-${lastMovement.serialNumber} regresó a posición P${lastMovement.sourcePosition}');
    });
  }

  /// Maneja el tap en una posición de la nueva configuración
  void _handleNewConfigurationTap(TirePosition position) {
    // Solo permitir colocación si hay una llanta seleccionada con servicio activo
    if (!canPlaceTire || selectedTire == null || activeService == null) {
      return;
    }

    // Solo permitir colocación en posiciones vacías
    if (position.hasTire) {
      ToastHelper.show_alert(context,
          'Esta posición ya está ocupada. Selecciona una posición vacía.');
      return;
    }

    // VALIDACIÓN: Los giros (SERVICE_TURN id: 18) deben realizarse en el mismo montaje
    if (activeService!.id == 18) {
      // SERVICE_TURN
      if (selectedTire!.mounting != position.mounting) {
        ToastHelper.show_alert(context,
            'Los giros deben realizarse sobre el mismo montaje. Selecciona una posición en el mismo montaje.');
        return;
      }
    }

    setState(() {
      // Encontrar el índice de la posición en la nueva configuración
      final newConfigIndex =
          newConfiguration.indexWhere((t) => t.position == position.position);

      if (newConfigIndex != -1) {
        // Encontrar el índice de la llanta en la configuración actual
        final currentIndex =
            currentConfiguration.indexWhere((t) => t.id == selectedTire!.id);

        if (currentIndex != -1) {
          // Crear el registro del movimiento ANTES de hacer los cambios
          final movement = TireMovement(
            tireId: selectedTire!.id!,
            serialNumber: selectedTire!.serialNumber!,
            sourcePosition: selectedTire!.position,
            destinationPosition: position.position,
            sourceMounting: selectedTire!.mounting!,
            destinationMounting: position.mounting!,
            service: activeService!,
            sourceIndex: currentIndex,
            destinationIndex: newConfigIndex,
          );

          // Agregar el movimiento al historial
          movementHistory.add(movement);

          // Colocar la llanta en la nueva posición
          newConfiguration[newConfigIndex] =
              newConfiguration[newConfigIndex].copyWith(
            id: selectedTire!.id,
            serialNumber: selectedTire!.serialNumber,
          );

          // Convertir la posición en vacía pero mantener la información de posición y mounting
          currentConfiguration[currentIndex] =
              currentConfiguration[currentIndex].copyWith(
            isSelected: false,
            destinationPosition:
                position.position, // Usar la nueva posición como destino
            clearId: true,
            clearSerialNumber: true,
          );

          // Crear el objeto de movimiento
          // final movementData = {
          //   "movements_tire": int.parse(selectedTire!.id!),
          //   "type_service": activeService!.id,
          //   "source_mounting": int.parse(selectedTire!.mounting!),
          //   "destination_mounting": int.parse(position.mounting!),
          // };

          // print(movementData);
          // Limpiar selección
          selectedTire = null;
          tireWithActiveService = null;
          activeService = null;
          canPlaceTire = false;
        }
      }
      activeFinishBtn = checkAllTiresPlaced();
    });
  }

  bool checkAllTiresPlaced() {
    return newConfiguration.every((tire) => tire.id != null);
  }

  void _finishRotation() {
    if (widget.data.inspectionData == null) {
      ToastHelper.show_alert(context, "Error: No hay datos de inspección");
      return;
    }

    // Crear una copia del inspectionData actual
    Map<String, Object> updatedInspectionData =
        Map<String, Object>.from(widget.data.inspectionData!);

    if (updatedInspectionData.containsKey('inspections')) {
      List<dynamic> inspections = List<dynamic>.from(
          updatedInspectionData['inspections'] as List<dynamic>);

      // Actualizar service_action para cada movimiento realizado
      for (var movement in movementHistory) {
        // Validación: Si es rotación (type_service = 14) en el mismo montaje, no agregar
        if (movement.service.id == 14 &&
            movement.sourceMounting == movement.destinationMounting) {
          continue;
        }

        // Encontrar la inspección correspondiente al source_mounting (montaje de origen)
        final inspectionIndex = inspections.indexWhere(
          (inspection) =>
              inspection['mounting'].toString() == movement.sourceMounting,
        );

        if (inspectionIndex != -1) {
          Map<String, dynamic> inspection =
              Map<String, dynamic>.from(inspections[inspectionIndex]);

          // Crear el service_action con la estructura requerida
          final serviceAction = {
            "movements_tire": int.parse(movement.tireId),
            "type_service": movement.service.id,
            "source_mounting": int.parse(movement.sourceMounting),
            "destination_mounting": int.parse(movement.destinationMounting),
          };

          // Agregar a service_action (crear lista si no existe)
          if (!inspection.containsKey('service_action')) {
            inspection['service_action'] = [];
          }

          List<dynamic> serviceActions =
              List<dynamic>.from(inspection['service_action']);
          serviceActions.add(serviceAction);
          inspection['service_action'] = serviceActions;

          // Actualizar la inspección en la lista
          inspections[inspectionIndex] = inspection;

          print(
              'Service action agregado para mounting ${movement.sourceMounting}: $serviceAction');
        }
      }

      // Actualizar el inspectionData
      updatedInspectionData['inspections'] = inspections;

      ConfirmationDialog.show(
        context: context,
        title: "¿Enviar servicios?",
        message: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Se guardará",
              style: Apptheme.h5Body(
                context,
                color: Apptheme.textColorSecondary,
              ),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.3,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: movementHistory
                      .where((movement) => !(movement.service.id == 14 &&
                          movement.sourcePosition ==
                              movement.destinationPosition))
                      .map((movement) {
                    String serviceTypeText = movement.service.id == 14
                        ? "ROTACIÓN"
                        : movement.service.id == 18
                            ? "GIRO"
                            : "ROTACIÓN Y GIRO";
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        "(1) $serviceTypeText DE LLANTA P${movement.sourcePosition}",
                        style: Apptheme.h4HighlightBody(
                          context,
                          color: Apptheme.textColorSecondary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        onAccept: () {
          _finishInspection(updatedInspectionData);
        },
      );
    }
  }

  void _finishInspection(Map<String, Object>? inspectionData) async {
    try {
      ref.read(loadingProviderProvider.notifier).changeLoading(true);
      final response = await InspectionService.createInspection(
          inspectionData as Map<String, Object>);

      ref.read(loadingProviderProvider.notifier).changeLoading(false);

      if (!mounted) return;

      if (response.success == true) {
        ref.read(appRouterProvider).go("/home");
        ToastHelper.show_success(context, "Inspección enviada con éxito.");
      } else {
        ToastHelper.show_alert(context, "Error al enviar la inspección.");
      }
    } catch (e) {
      ref.read(loadingProviderProvider.notifier).changeLoading(false);

      if (!mounted) return;

      ToastHelper.show_alert(context, "Error al finalizar la inspección: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProviderProvider);
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
                      Row(
                        children: [
                          Text(
                            "Rotar & Girar",
                            style: Apptheme.h1Title(
                              context,
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
                        sectionType: 1, // 1 - Configuración Actual
                      ),
                      const SizedBox(height: 32),
                      _buildConfigurationSection(
                          title: "Nueva Configuración",
                          configuration: newConfiguration,
                          isEmpty: false,
                          isSelectable:
                              canPlaceTire, // Hacer seleccionable cuando se puede colocar
                          sectionType: 2, // 2 - Nueva Configuración
                          activeService: activeService),
                    ],
                  ),
                ),
              ),
            ),
            BottomButton(
              gap: 20,
              buttons: [
                _buildUndoButton(),
                BottomButtonItem(
                  text: "Finalizar",
                  onPressed: activeFinishBtn ? _finishRotation : null,
                  buttonType: 1,
                  disabled: !activeFinishBtn,
                  isLoading: isLoading,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Construye el botón de deshacer con el badge de contador de movimientos
  BottomButtonItem _buildUndoButton() {
    final bool hasMovements = movementHistory.isNotEmpty;
    final int movementCount = movementHistory.length;
    final isLoading = ref.watch(loadingProviderProvider);

    return BottomButtonItem(
        text: "Deshacer", // Texto de respaldo
        onPressed: hasMovements ? _undoLastMovement : null,
        buttonType: 2,
        disabled: !hasMovements || isLoading,
        customChild: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Deshacer",
              style: Apptheme.h4HighlightBody(
                context,
                color: Apptheme.darkorange,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Apptheme.primary,
              ),
              child: Text(
                movementCount.toString(),
                style: Apptheme.h5HighlightBody(context, color: Colors.white),
              ),
            )
          ],
        ));
  }

  Widget _buildConfigurationSection({
    required String title,
    required List<TirePosition> configuration,
    required bool isEmpty,
    required int sectionType,
    bool isSelectable = false,
    ServiceData? activeService,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Apptheme.h4HighlightBody(
            context,
            color: Apptheme.textColorSecondary,
          ),
        ),
        const SizedBox(height: 16),
        TireGrid(
          configuration: configuration,
          isEmpty: isEmpty,
          sectionType: sectionType,
          movements: sectionType == 2 ? movementHistory : [],
          onTireSelect: isSelectable
              ? (sectionType == 1
                  ? _toggleTireSelection
                  : _handleNewConfigurationTap)
              : null,
          activeService: activeService,
        ),
      ],
    );
  }

  Widget _buildHeader() {
    final isLoading = ref.watch(loadingProviderProvider);
    return Back(
      showHome: true,
      showDelete: true,
      showNotifications: true,
      isLoading: isLoading,
      showHomeDialogConfirm: true,
      interceptSystemBack: true,
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
