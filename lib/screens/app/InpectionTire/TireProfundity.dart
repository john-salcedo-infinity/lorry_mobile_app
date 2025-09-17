import 'dart:async';
import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/providers/auth/loginProvider.dart';
import 'package:app_lorry/routers/app_routes.dart';
import 'package:app_lorry/screens/app/InpectionTire/DetailTire.dart';
import 'package:app_lorry/screens/app/InpectionTire/services/services_screen.dart';
import 'package:app_lorry/services/bluetooth/bluetooth_service.dart';
import 'package:app_lorry/widgets/buttons/BottomButton.dart';
import 'package:app_lorry/widgets/dialogs/confirmation_dialog.dart';
import 'package:app_lorry/widgets/shared/back.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/config/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'widgets/tire_inspection_form.dart';

class TireProfundityParams {
  final List<MountingResult> data;
  final int vehicle;
  final double mileage;
  final int? startIndex; // Índice desde donde empezar la inspección

  TireProfundityParams({
    required this.data,
    required this.vehicle,
    required this.mileage,
    this.startIndex,
  });
}

class TireProfundity extends ConsumerStatefulWidget {
  final TireProfundityParams data;

  const TireProfundity({super.key, required this.data});

  @override
  ConsumerState<TireProfundity> createState() => _TireProfundityState();
}

class _TireProfundityState extends ConsumerState<TireProfundity>
    with WidgetsBindingObserver {
  late final int licensePlate; // id del vehículo
  late final List<MountingResult> mountings; // Lista de montajes

  // Mapa para almacenar los datos de inspección de cada mounting
  Map<int, Map<String, dynamic>> inspectionData = {};

  // Mapa para almacenar las novedades de cada mounting
  Map<int, List<Map<String, dynamic>>> noveltiesData = {};

  // Mapa para almacenar los servicios de cada mounting
  Map<int, List<Map<String, dynamic>>> servicesData = {};

  // Lista para trackear qué llantas han sido inspeccionadas
  Set<int> inspectedTires = {};

  int _currentTireIndex = 0;
  late PageController _pageController;

  final BluetoothService _bluetoothService = BluetoothService.instance;
  // Estado para mostrar datos de profundidad del dispositivo
  DepthGaugeData? currentDepth;
  DepthValueType? currentDepthType;

  // Variables para el manejo de los campos de entrada
  bool shouldFillNextField = false;
  String? latestDepthValue;
  DepthGaugeData? previousDepth;

  // Subscripciones a streams
  StreamSubscription<DepthGaugeData>? depthSubscription;

  // Nuevo: secuencia incremental para disparos únicos por lectura
  int _depthSequence = 0;

  // Estado para acción detectada
  bool _actionDetected = false;
  bool _hasErrors = false;
  Timer? _actionTimer;

  // Throttle simple para lecturas del profundímetro
  DateTime? _lastDepthAt;
  static const int _depthThrottleMs = 60; // ajustar si es necesario

  @override
  void initState() {
    super.initState();

    // Agregar observer para detectar cambios en el ciclo de vida de la app
    WidgetsBinding.instance.addObserver(this);

    final data = widget.data;
    licensePlate = data.vehicle;
    mountings = data.data;

    // Establecer el índice inicial (puede venir desde un botón específico)
    _currentTireIndex = data.startIndex ?? 0;

    // Inicializar el PageController
    _pageController = PageController(initialPage: _currentTireIndex);

    // Inicializar los datos de inspección con los valores originales
    _initializeInspectionData();
    _initializeStreams();

    // Marcar la llanta inicial como inspeccionada
    inspectedTires.add(_currentTireIndex);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Cuando la app vuelve a primer plano, reinicializar streams si es necesario
    if (state == AppLifecycleState.resumed) {
      if (mounted && depthSubscription == null) {
        print("App resumed - reinitializing streams");
        _initializeStreams();
      }
    }
  }

  void _initializeStreams() {
    // Escuchar datos de profundidad
    depthSubscription = _bluetoothService.depthDataStream.listen(
      (depthData) {
        // Throttle para evitar exceso de reconstrucciones
        final now = DateTime.now();
        if (_lastDepthAt != null &&
            now.difference(_lastDepthAt!).inMilliseconds < _depthThrottleMs) {
          return;
        }
        _lastDepthAt = now;

        if (!mounted) return;
        final phase = SchedulerBinding.instance.schedulerPhase;
        void update() {
          if (!mounted) return;

          // Manejar datos de acción
          if (depthData.valueType == DepthValueType.action) {
            _handleActionData(depthData.rawData);
            return;
          }

          setState(() {
            currentDepth = depthData;
            latestDepthValue = depthData.value.toString();
            shouldFillNextField = true;
            previousDepth = depthData;
            currentDepthType = depthData.valueType;
            _depthSequence++;
          });
        }

        if (phase == SchedulerPhase.persistentCallbacks ||
            phase == SchedulerPhase.postFrameCallbacks) {
          WidgetsBinding.instance.addPostFrameCallback((_) => update());
        } else {
          update();
        }
      },
      onError: (error) {
        if (!mounted) return;
        final phase = SchedulerBinding.instance.schedulerPhase;
        void update() {
          if (!mounted) return;
          setState(() {
            shouldFillNextField = false;
          });
        }

        if (phase == SchedulerPhase.persistentCallbacks ||
            phase == SchedulerPhase.postFrameCallbacks) {
          WidgetsBinding.instance.addPostFrameCallback((_) => update());
        } else {
          update();
        }
      },
    );
  }

  void _handleActionData(String actionData) {
    print("Action data received in TireProfundity: $actionData");

    // Verificar si el widget aún está montado y la suscripción es válida
    if (!mounted || depthSubscription == null) {
      return;
    }

    // Evitar acción si ya hay una en progreso de error
    if (_hasErrors) {
      return;
    }

    // Activar indicador visual
    setState(() {
      _actionDetected = true;
    });

    // Mostrar la indicación por 1 segundo
    _actionTimer?.cancel();
    _actionTimer = Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _actionDetected = false;
        });
      }
    });
    // Intentar avanzar a la siguiente inspección
    _handleActionNavigation();
  }

  void _handleActionNavigation() {
    // Evitar acción si ya hay errores en progreso
    if (_hasErrors) {
      return;
    }

    // Si es la última llanta, verificar si podemos finalizar
    if (_currentTireIndex >= mountings.length - 1) {
      // Validar la llanta actual
      final validation = _validateTireProfundity(_currentTireIndex);
      if (!validation['hasErrors'] && !btnDisabled) {
        // Si no hay errores y el botón de finalizar está habilitado, finalizar
        _onFinish();
      } else {
        VibrationHelper.playError();
        setState(() {
          _hasErrors = true;
        });

        // Desactivar después de 1 segundo
        Timer(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              _hasErrors = false;
            });
          }
        });

        // Mostrar mensaje indicando que no se puede finalizar
        ValidationToastHelper.showValidationToast(
          context: context,
          title: "No se puede finalizar",
          message:
              "Completa todas las inspecciones correctamente antes de finalizar.",
        );
      }
      return;
    }

    // Validar errores en la página actual antes de avanzar
    final validation = _validateTireProfundity(_currentTireIndex);
    if (validation['hasErrors']) {
      // Activar indicador visual de error temporalmente
      setState(() {
        _hasErrors = true;
      });

      // Desactivar después de 1 segundo
      Timer(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _hasErrors = false;
          });
        }
      });

      ValidationToastHelper.showValidationToast(
        context: context,
        title: "Errores en la inspección actual",
        message:
            "La llanta ${mountings[_currentTireIndex].position} tiene errores: ${validation['errors'].join(', ')}",
      );
      VibrationHelper.playError();
      return;
    }

    // Si no hay errores, avanzar a la siguiente llanta
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        _currentTireIndex + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      VibrationHelper.playSuccess();
    }

    // Quitar el foco del teclado
    FocusScope.of(context).unfocus();
  }

  void _initializeInspectionData() {
    for (int i = 0; i < mountings.length; i++) {
      final mounting = mountings[i];
      inspectionData[i] = {
        'mounting': mounting.id,
        'pressure': mounting.tire?.pressure?.toInt() ??
            mounting.tire?.design?.dimension?.pressure?.toInt() ??
            0,
        'prof_external': mounting.tire?.profExternalCurrent ?? 0.0,
        'prof_center': mounting.tire?.profCenterCurrent ?? 0.0,
        'prof_internal': mounting.tire?.profInternalCurrent ?? 0.0,
      };

      // Inicializar el array de novedades vacío para cada mounting
      noveltiesData[i] = [];
      servicesData[i] = [];
    }
  }

  // Método para validar errores de profundidad en una llanta específica
  Map<String, dynamic> _validateTireProfundity(int tireIndex) {
    final currentData = inspectionData[tireIndex];
    final tire = mountings[tireIndex].tire;

    if (currentData == null || tire == null) {
      return {'hasErrors': false, 'errors': []};
    }

    List<String> errors = [];

    // Validar profundidad externa
    final currentExternal = currentData["prof_external"] as double? ?? 0.0;
    final originalExternal = tire.profExternalCurrent ?? 0.0;
    if (currentExternal > originalExternal) {
      errors.add(
          'Profundidad externa: $currentExternal > $originalExternal (original)');
    }

    // Validar profundidad central
    final currentCenter = currentData["prof_center"] as double? ?? 0.0;
    final originalCenter = tire.profCenterCurrent ?? 0.0;
    if (currentCenter > originalCenter) {
      errors.add(
          'Profundidad central: $currentCenter > $originalCenter (original)');
    }

    // Validar profundidad interna
    final currentInternal = currentData["prof_internal"] as double? ?? 0.0;
    final originalInternal = tire.profInternalCurrent ?? 0.0;
    if (currentInternal > originalInternal) {
      errors.add(
          'Profundidad interna: $currentInternal > $originalInternal (original)');
    }

    return {
      'hasErrors': errors.isNotEmpty,
      'errors': errors,
    };
  }

  void _nextTire() {
    // Marcar la llanta actual como inspeccionada
    inspectedTires.add(_currentTireIndex);

    // Si ya inspeccionamos todas las llantas, finalizar
    if (inspectedTires.length >= mountings.length) {
      _currentTireIndex = 0;
      return;
    }

    // Buscar la siguiente llanta no inspeccionada
    int nextIndex = _findNextUninspectedTire();

    // Usar addPostFrameCallback para evitar setState durante build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _currentTireIndex = nextIndex;
        });
      }
    });
  }

  int _findNextUninspectedTire() {
    for (int i = 0; i < mountings.length; i++) {
      if (i != _currentTireIndex && !inspectedTires.contains(i)) {
        return i;
      }
    }
    // Si no encontramos ninguna, retornar la actual (esto no debería pasar)
    return _currentTireIndex;
  }

  bool get btnDisabled {
    final currentData = inspectionData[_currentTireIndex];
    if (currentData == null) return false;

    final tire = mountings[_currentTireIndex].tire;

    // Comparar todos los valores de profundidad de una vez
    final comparisons = [
      (currentData["prof_external"] as double? ?? 0.0) >
          (tire?.profExternalCurrent ?? 0.0),
      (currentData["prof_center"] as double? ?? 0.0) >
          (tire?.profCenterCurrent ?? 0.0),
      (currentData["prof_internal"] as double? ?? 0.0) >
          (tire?.profInternalCurrent ?? 0.0),
    ];

    // Verificar si todas las llantas han sido inspeccionadas
    bool allTiresInspected = inspectedTires.length >= mountings.length;

    return comparisons.any((isInvalid) => isInvalid) || !allTiresInspected;
  }

  // Método para obtener los servicios del mounting actual
  List<Map<String, dynamic>> _getCurrentMountingServices() {
    return servicesData[_currentTireIndex] ?? [];
  }

  void _onService() async {
    final currentMounting = mountings[_currentTireIndex];
    final currentServices = _getCurrentMountingServices();

    final result = await context.push(
      '/services',
      extra: ServiceScreenParams(
        currentMountingResult: currentMounting,
        existingServices: currentServices,
      ),
    );

    if (result != null && result is List<Map<String, dynamic>>) {
      servicesData[_currentTireIndex] = result;
      setState(() {});
    }
  }

  void _onFinish() async {
    // Marcar que estamos navegando para pausar temporalmente las acciones del botón
    setState(() {
      _actionDetected = true; // Esto bloqueará temporalmente nuevas acciones
    });

    List<Map<String, dynamic>> inspections = [];

    for (int i = 0; i < mountings.length; i++) {
      final data = inspectionData[i];
      final novelties = noveltiesData[i] ?? [];
      final services = servicesData[i] ?? [];

      inspections.add({
        "unmount": false,
        "tire_mounting": 0,
        "mounting": data?['mounting'] ?? 0,
        "pressure": data?['pressure'] ?? 0,
        "prof_external": data?['prof_external'] ?? 0,
        "prof_center": data?['prof_center'] ?? 0,
        "prof_internal": data?['prof_internal'] ?? 0,
        "novelty": novelties,
        "service": services,
        "service_action": []
      });
    }

    final jsonInspectionData = {
      "mileage": {"vehicle": licensePlate, "km": widget.data.mileage.toInt()},
      "inspections": inspections
    };

    // Pausar brevemente el stream durante la navegación
    depthSubscription?.cancel();
    depthSubscription = null;

    ref
        .read(appRouterProvider)
        .push(
          "/DetailTire",
          extra: DetailTireParams(
              results: mountings.reversed.toList(),
              vehicle: mountings.first.vehicle!,
              mileage: widget.data.mileage,
              inspectionData: jsonInspectionData),
        )
        .then((_) {
      // Cuando regresamos de DetailTire, reinicializar el stream
      if (mounted && depthSubscription == null) {
        print("Returned from DetailTire - reinitializing streams");
        _initializeStreams();
        setState(() {
          _actionDetected = false; // Reactivar acciones
        });
      }
    });
  }

  bool get _isKeyboardOpen {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProviderProvider);
    return Scaffold(
      backgroundColor: Apptheme.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  if (!mounted) return;
                  setState(() {
                    _currentTireIndex = index;
                    inspectedTires.add(index);
                    // Al cambiar de llanta, cancelar cualquier llenado pendiente
                    shouldFillNextField = false;
                  });
                },
                itemCount: mountings.length,
                itemBuilder: (context, index) {
                  return _buildHybridPageContent(index);
                },
              ),
            ),
            _buildBottomButtons(
              isLast: _currentTireIndex >= mountings.length - 1,
              isFirst: _currentTireIndex <= 0,
              isLoading: isLoading,
              onNext: _nextTire,
              onFinish: () => _onFinish(),
              onService: () => _onService(),
            ),
            const SizedBox(height: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(int index) {
    final currentMounting = mountings[index];
    final bool isActive =
        index == _currentTireIndex; // Solo la página activa recibe lecturas

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleWidget(currentMounting.position.toString()),
        const SizedBox(height: 10),
        TireInspectionForm(
          shouldFillNext: isActive && shouldFillNextField,
          newDepthValue: isActive ? latestDepthValue : null,
          depthSequence:
              isActive ? _depthSequence : null, // null para inactivas
          currentMounting: currentMounting,
          newDepthTypeValue: isActive ? currentDepthType : null,
          isActive: isActive,
          onDataChanged: (data) {
            final currentData = inspectionData[index] ?? {};
            inspectionData[index] = {
              'mounting': data['mounting'] ?? currentData['mounting'],
              'pressure': data['pressure'] ?? currentData['pressure'],
              'prof_external':
                  data['prof_external'] ?? currentData['prof_external'],
              'prof_center': data['prof_center'] ?? currentData['prof_center'],
              'prof_internal':
                  data['prof_internal'] ?? currentData['prof_internal'],
            };
            if (!mounted) return;
            void update() {
              if (!mounted) return;
              setState(() {});
            }

            final phase = SchedulerBinding.instance.schedulerPhase;
            if (phase == SchedulerPhase.idle) {
              update();
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) => update());
            }
          },
          existingNovelties: noveltiesData[index] ?? [],
          onNoveltiesChanged: (novelties) {
            noveltiesData[index] = novelties;
            if (!mounted) return;
            void update() {
              if (!mounted) return;
              setState(() {});
            }

            final phase = SchedulerBinding.instance.schedulerPhase;
            if (phase == SchedulerPhase.idle) {
              update();
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) => update());
            }
          },
          initialInspectionData: inspectionData[index],
        ),
      ],
    );
  }

  Widget _buildHybridPageContent(int index) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onPanEnd: (details) {
            final velocity = details.velocity.pixelsPerSecond.dy;
            final threshold = 150.0;

            if (velocity > threshold) {
              _handleScrollAttempt(isScrollingDown: false);
            } else if (velocity < -threshold) {
              _handleScrollAttempt(isScrollingDown: true);
            }
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo is ScrollStartNotification) {
                return false;
              }

              if (scrollInfo is ScrollUpdateNotification) {
                return false;
              }

              if (scrollInfo is ScrollEndNotification) {
                if (scrollInfo.metrics.maxScrollExtent <= 0) {
                  return false;
                }

                final scrollThreshold = 1.0;
                final currentPosition = scrollInfo.metrics.pixels;
                final maxExtent = scrollInfo.metrics.maxScrollExtent;
                final minExtent = scrollInfo.metrics.minScrollExtent;

                if (currentPosition >= maxExtent + scrollThreshold) {
                  _handleScrollAttempt(isScrollingDown: true);
                } else if (currentPosition <= minExtent - scrollThreshold) {
                  _handleScrollAttempt(isScrollingDown: false);
                }
                return true;
              }

              // Mantener la lógica de overscroll para casos donde hay contenido scrolleable
              if (scrollInfo is OverscrollNotification) {
                final overscrollThreshold =
                    30.0; // Píxeles de overscroll necesarios

                if (scrollInfo.overscroll > overscrollThreshold) {
                  _handleScrollAttempt(isScrollingDown: true);
                } else if (scrollInfo.overscroll < -overscrollThreshold) {
                  _handleScrollAttempt(isScrollingDown: false);
                }
                return true;
              }
              return false;
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              child: _buildContent(index),
            ),
          ),
        );
      },
    );
  }

  void _handleScrollAttempt({required bool isScrollingDown}) {
    if (_isKeyboardOpen) {
      // Si el teclado está abierto, no hacer nada
      return;
    }

    // Evitar acción si ya hay una en progreso
    if (_hasErrors || _actionDetected) {
      return;
    }

    if (isScrollingDown) {
      // Intentando ir a la siguiente página
      if (_currentTireIndex < mountings.length - 1) {
        // Validar errores en la página actual
        final validation = _validateTireProfundity(_currentTireIndex);

        if (validation['hasErrors']) {
          // Activar indicador visual de error temporalmente
          setState(() {
            _hasErrors = true;
          });

          // Desactivar después de 1 segundo
          Timer(const Duration(seconds: 1), () {
            if (mounted) {
              setState(() {
                _hasErrors = false;
              });
            }
          });

          ValidationToastHelper.showValidationToast(
            context: context,
            title: "Errores encontrados en la Inspección",
            message:
                "La llanta ${mountings[_currentTireIndex].position} tiene errores: ${validation['errors'].join(', ')}",
          );
          return; // Bloquear el scroll
        }

        // Si no hay errores, permitir el scroll con animación ligera
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            _currentTireIndex + 1,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );

          Future.delayed(const Duration(milliseconds: 400), () {
            if (mounted) {
              setState(() {
                _actionDetected = true;
              });
            }
          });

          // Mostrar la indicación por 1 segundo
          _actionTimer?.cancel();
          _actionTimer = Timer(const Duration(seconds: 1), () {
            if (mounted) {
              setState(() {
                _actionDetected = false;
              });
            }
          });
        }
        FocusScope.of(context).unfocus();
      }
    } else {
      // Intentando ir a la página anterior
      if (_currentTireIndex > 0) {
        FocusScope.of(context).unfocus();
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            _currentTireIndex - 1,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
          // Agregar indicador visual de acción
          Future.delayed(const Duration(milliseconds: 400), () {
            if (mounted) {
              setState(() {
                _actionDetected = true;
              });
            }
          });

          // Mostrar la indicación por 1 segundo
          _actionTimer?.cancel();
          _actionTimer = Timer(const Duration(seconds: 1), () {
            if (mounted) {
              setState(() {
                _actionDetected = false;
              });
            }
          });
        }
      }
    }
  }

  Widget _buildHeader() {
    return Back(
      showHome: true,
      showDelete: true,
      showNotifications: true,
      showHomeDialogConfirm: true,
      showNotificationDialogConfirm: true,
      interceptSystemBack: true,
      onBackPressed: () {
        ConfirmationDialog.show(
          context: context,
          title: "¿Estás seguro que deseas regresar?",
          message:
              "Todas las inspecciones registradas no podran ser resturadas",
          onAccept: () => {context.pop()},
        );
      },
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
    );
  }

  Widget _buildTitleWidget(String position) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _actionDetected
            ? _hasErrors
                ? Apptheme.highAlertBackground
                : Colors.green.withAlpha(30)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: _actionDetected
            ? _hasErrors
                ? Border.all(color: Apptheme.alertOrange, width: 1)
                : Border.all(color: Colors.green, width: 1)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            text: TextSpan(
              style:
                  Apptheme.h1Title(context, color: Apptheme.textColorSecondary),
              children: [
                const TextSpan(text: "Inspección llanta "),
                TextSpan(
                  text: 'P$position',
                  style: Apptheme.h1TitleDecorative(
                    context,
                    color: Apptheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _actionDetected
                ? !_hasErrors
                    ? const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        key: ValueKey('action'),
                      )
                    : const Icon(
                        Icons.cancel,
                        color: Apptheme.primary,
                        key: ValueKey('normal'),
                      )
                : const Icon(
                    Icons.error,
                    color: Apptheme.primary,
                    key: ValueKey('normal'),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons({
    required bool isLast,
    required bool isFirst,
    required VoidCallback onNext,
    required VoidCallback onService,
    required VoidCallback onFinish,
    required bool isLoading,
  }) {
    return BottomButton(
      gap: 18,
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 0, top: 12),
      buttons: [
        BottomButtonItem(
          text: "Servicios",
          buttonType: 2,
          onPressed: onService,
          customChild: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Servicios",
                style: Apptheme.h4HighlightBody(
                  context,
                  color: Apptheme.alertOrange,
                ),
              ),
              if (_getCurrentMountingServices().isNotEmpty) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: const BoxDecoration(
                    color: Apptheme.primary,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  child: Text(
                    '${_getCurrentMountingServices().length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        BottomButtonItem(
          text: 'Finalizar Inspección',
          onPressed: onFinish,
          disabled: !isLast || btnDisabled || isLoading,
          isLoading: isLoading,
          customChild: Text(
            'Finalizar Inspección',
            style: Apptheme.h4HighlightBody(
              context,
              color: Apptheme.backgroundColor,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Cancelar todas las suscripciones y timers antes de dispose
    depthSubscription?.cancel();
    depthSubscription = null;
    _actionTimer?.cancel();
    _actionTimer = null;

    _pageController.dispose();
    _currentTireIndex = 0; // Reset
    super.dispose();
  }
}
