import 'dart:ui';

import 'package:app_lorry/models/ManualPlateRegisterResponse.dart';
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
  // static const double _containerWidth = 342.0;
  // static const double _fieldWidth = 292.0;
  // static const double _fieldHeight = 46.0;
  static const int _maxPlateLength = 6;
  static const String _plateHint = "WMB 268";
  static const String _alertMessage = "Digite manualmente la placa";
  static const String _screenTitle = "Registro de placa";

  final TextEditingController _plateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Apptheme.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10),
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
          Row(
            children: [
              IconButton(
                onPressed: () => context.go('/home'),
                icon: SvgPicture.asset(
                  'assets/icons/Icono_Casa_Lorry.svg',
                  width: 40,
                  height: 40,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      _screenTitle,
      style: const TextStyle(
        fontSize: 23,
        color: Apptheme.textColorSecondary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildAlertSection() {
    return Container(
      width: double.infinity,
      height: 68,
      padding: const EdgeInsets.only(top: 26, bottom: 22),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          const Image(image: AssetImage('assets/icons/Alert_Icon.png')),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _alertMessage,
              softWrap: true,
              style: const TextStyle(
                fontSize: 12,
                color: Apptheme.textColorSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlateInputSection() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 35),
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

  Widget _buildPlateInputField() {
    return Container(
      width: double.infinity,
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/Car_Icon.svg',
            width: 24,
            height: 24,
            // colorFilter: Apptheme.,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: TextField(
              controller: _plateController,
              maxLength: _maxPlateLength,
              textCapitalization: TextCapitalization.characters,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Apptheme.textColorPrimary,
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
                hintStyle: const TextStyle(
                  color: Apptheme.textColorPrimary,
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
          isLoading ? Apptheme.loadingIndicatorButton() : const Text("Guardar"),
          isLoading ? null : () => _validateAndShowDialog(context)),
    );
  }

  /// Validates the plate input and shows the confirmation dialog
  void _validateAndShowDialog(BuildContext context) {
    final plateText = _plateController.text.trim();

    if (plateText.isEmpty) {
      ToastHelper.show_alert(context, "La placa es requerida.");
      return;
    }

    _showSaveConfirmationDialog(context, plateText);
  }

  /// Shows the confirmation dialog for plate inspection
  void _showSaveConfirmationDialog(BuildContext context, String plate) {
    showDialog(
      context: context,
      barrierColor: Apptheme.secondary.withValues(alpha: 0.5),
      builder: (dialogContext) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              "PLACA $plate",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Apptheme.textColorPrimary,
              ),
            ),
          ),
          content: const Text(
            "¿Deseas iniciar el proceso de inspección con este vehículo?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Apptheme.textColorSecondary,
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCancelButton(dialogContext),
                const SizedBox(width: 16),
                _buildAcceptButton(dialogContext, plate),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext dialogContext) {
    return TextButton(
      onPressed: () => Navigator.of(dialogContext).pop(),
      style: TextButton.styleFrom(
        minimumSize: const Size(130, 40),
      ),
      child: const Text(
        "Cancelar",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Apptheme.primary,
        ),
      ),
    );
  }

  Widget _buildAcceptButton(BuildContext dialogContext, String plate) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Apptheme.primary,
        minimumSize: const Size(130, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(width: 2, color: Apptheme.darkorange),
        ),
      ),
      onPressed: () async {
        Navigator.of(dialogContext).pop();
        await _proceedWithPlateInspection(plate);
      },
      child: const Text(
        "Aceptar",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Shows loading dialog only if not already shown
  void _showLoadingDialog() {
    if (!ref.read(manualPlateRegisterLoadingProvider)) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Container(
          color: Colors.white.withAlpha(230),
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
    print('Error completo: $error');

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

    // Limpiar el estado del provider al salir de la pantalla
    super.dispose();
  }
}
