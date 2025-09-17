// ignore_for_file: deprecated_member_use

import 'package:app_lorry/models/ManualPlateRegisterResponse.dart';
import 'package:app_lorry/widgets/shared/ballBeatLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/providers/providers.dart';
import 'package:app_lorry/routers/app_routes.dart';
import 'package:app_lorry/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class ManualPlateRegister extends ConsumerStatefulWidget {
  const ManualPlateRegister({super.key});

  @override
  ConsumerState<ManualPlateRegister> createState() =>
      _ManualPlateRegisterState();
}

class _ManualPlateRegisterState extends ConsumerState<ManualPlateRegister> {
  static const int _maxPlateLength = 6;
  static const String _plateHint = " ___ ___";
  static const String _alertMessage = "Digite manualmente la placa";
  static const String _screenTitle = "Registro de placa";

  final TextEditingController _plateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Apptheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(),
                    const SizedBox(height: 30),
                    _buildAlertSection(),
                    const SizedBox(height: 2),
                    _buildPlateInputSection(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final isLoading = ref.watch(manualPlateRegisterLoadingProvider);
    return Back(
      showHome: true,
      showNotifications: true,
      isLoading: isLoading,
      interceptSystemBack: true,
      onBackPressed: () => context.go("/home"),
    );
  }

  Widget _buildTitle() {
    return Text(
      _screenTitle,
      style: Apptheme.h1Title(context, color: Apptheme.textColorSecondary),
    );
  }

  Widget _buildAlertSection() {
    return Container(
      width: double.infinity,
      height: 68,
      padding: const EdgeInsets.all(26),
      decoration: const BoxDecoration(
        color: Apptheme.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.error, color: Apptheme.primary, size: 20),
          const SizedBox(width: 5),
          Text(
            _alertMessage,
            style: Apptheme.h5Body(context, color: Apptheme.textColorSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildPlateInputSection() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Apptheme.white,
      ),
      child: Container(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            _buildPlateInputField(),
            const SizedBox(height: 10),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  late FocusNode _plateFocusNode;

  @override
  void initState() {
    super.initState();
    _plateFocusNode = FocusNode();
    _plateFocusNode.addListener(() {
      setState(() {});
    });
  }

  Widget _buildPlateInputField() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Apptheme.lightGray, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Ícono del carro
          SvgPicture.asset(
            'assets/icons/Car_Icon.svg',
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              _plateFocusNode.hasFocus
                  ? Apptheme.secondary // Sin opacidad
                  : Apptheme.secondary.withOpacity(0.5),
              BlendMode.srcIn,
            ),
          ),

          // Input de la placa
          Flexible(
            child: IntrinsicWidth(
              child: TextField(
                focusNode: _plateFocusNode,
                controller: _plateController,
                maxLength: _maxPlateLength,
                textCapitalization: TextCapitalization.characters,
                textAlign: TextAlign.center,
                style: Apptheme.h1TitleDecorative(
                  context,
                  color: Apptheme.textColorPrimary,
                ).copyWith(
                  height: 1,
                ),
                onChanged: (value) {
                  final upperValue = value.toUpperCase();
                  if (value != upperValue) {
                    _plateController.value = TextEditingValue(
                      text: upperValue,
                      selection:
                          TextSelection.collapsed(offset: upperValue.length),
                    );
                  }
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  counterText: "",
                  hintText: _plateHint,
                  hintStyle: TextStyle(
                    color: Apptheme.textColorPrimary.withOpacity(0.5),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 120,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    // Escuchar el estado de carga del provider
    final isLoading = ref.watch(manualPlateRegisterLoadingProvider);

    return Center(
      child: CustomButton(
          double.infinity,
          50,
          isLoading
              ? BallBeatLoading()
              : Text(
                  "Guardar",
                  style: Apptheme.h4HighlightBody(
                    context,
                    color: Apptheme.backgroundColor,
                  ),
                ),
          isLoading ? null : () => _validateAndShowDialog(context)),
    );
  }

  /// Validates the plate input and shows the confirmation dialog
  Future<void> _validateAndShowDialog(BuildContext context) async {
    final plateText = _plateController.text.trim();

    if (plateText.isEmpty) {
      ToastHelper.show_alert(context, "La placa es requerida.");
      return;
    }

    await _proceedWithPlateInspection(plateText);
    // _showSaveConfirmationDialog(context, plateText);
  }

  /// Shows loading dialog only if not already shown
  void _showLoadingDialog() {
    if (!ref.read(manualPlateRegisterLoadingProvider)) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Container(
          color: Apptheme.white.withAlpha(230),
          child: Center(
            child: Apptheme.loadingIndicator(),
          ),
        ),
      );
    }
  }

  /// Dismisses the loading dialog only if loading is active
  void _dismissLoadingDialog() {
    if (ref.read(manualPlateRegisterLoadingProvider)) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  /// Handles the plate inspection process
  Future<void> _proceedWithPlateInspection(String plate) async {
    // Establecer estado de carga
    ref.read(manualPlateRegisterLoadingProvider.notifier).setLoading(true);
    _showLoadingDialog();

    try {
      // Usar el provider en lugar del servicio directo
      final response = await ref.read(getMountingByPlateProvider(plate).future);

      // Guardar respuesta en el estado
      ref.read(manualPlateRegisterStateProvider.notifier).setResponse(response);

      ref.read(manualPlateRegisterLoadingProvider.notifier).setLoading(false);
      _dismissLoadingDialog();

      if (response.success != true) {
        _handleErrorResponse(response);
        return;
      }

      await _handleSuccessResponse(response);
    } catch (e) {
      ref.read(manualPlateRegisterLoadingProvider.notifier).setLoading(false);
      _dismissLoadingDialog();
      _handleException(e);
    }
  }

  /// Handles error response from the service
  void _handleErrorResponse(dynamic response) {
    final message = response.messages?.isNotEmpty == true
        ? response.messages!.first
        : "Vehículo no encontrado.";
    ToastHelper.show_alert(context, message);
  }

  /// Handles successful response from the service
  Future<void> _handleSuccessResponse(
      ManualPlateRegisterResponse response) async {
    if (!_isValidResult(response)) {
      ToastHelper.show_alert(context, "Vehículo no encontrado.");
      return;
    }

    final hasTires = _hasTires(response);

    if (!hasTires) {
      ToastHelper.show_alert(context, "Vehículo sin llantas registradas.");
      return;
    }

    ToastHelper.show_success(context, "Vehículo encontrado con éxito.");

    _navigateToVehicleInfo(response);
  }

  /// Validates if the result is valid
  bool _isValidResult(ManualPlateRegisterResponse result) {
    return result.data != null &&
        result.data!.results != null &&
        result.data!.results!.isNotEmpty &&
        result.data!.results!.first.vehicle != null &&
        result.data!.results!.first.vehicle!.licensePlate != null &&
        result.data!.results!.first.vehicle!.licensePlate!.isNotEmpty;
  }

  /// Checks if the vehicle has at least one tire in any mounting result
  bool _hasTires(ManualPlateRegisterResponse response) {
    if (response.data?.results == null || response.data!.results!.isEmpty) {
      return false;
    }

    // Verificar si al menos uno de los resultados tiene una llanta (tire no es null)
    return response.data!.results!.any((result) => result.tire != null);
  }

  /// Navigates to vehicle info screen with the vehicle data
  void _navigateToVehicleInfo(ManualPlateRegisterResponse response) {
    ref.read(appRouterProvider).push('/InfoVehicles', extra: response.data!);
  }

  /// Handles exceptions during the inspection process
  void _handleException(dynamic error) {
    // Log del error completo para debugging

    String errorMessage = "Error al consultar la placa";

    // Manejo específico de diferentes tipos de errores
    if (error is Exception) {
      errorMessage = "Error de conexión al servidor";
    } else if (error.toString().contains('FormatException')) {
      errorMessage = "Error en el formato de respuesta del servidor";
    } else if (error.toString().contains('SocketException')) {
      errorMessage = "Error de red. Verifique su conexión a internet";
    } else if (error.toString().contains('TimeoutException')) {
      errorMessage = "Tiempo de espera agotado. Intente nuevamente";
    } else if (error.toString().contains('type') &&
        error.toString().contains('subtype')) {
      errorMessage =
          "Error en el procesamiento de datos. Contacte al administrador";
    }

    ToastHelper.show_alert(context, errorMessage);
  }

  @override
  void dispose() {
    _plateController.dispose();
    _plateFocusNode.dispose();

    // Limpiar el estado del provider al salir de la pantalla
    super.dispose();
  }
}
