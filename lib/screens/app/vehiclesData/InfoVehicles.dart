import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/screens/screens.dart';
import 'package:app_lorry/widgets/items/LicensePlate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/helpers/InfoRow.dart';
import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/routers/app_routes.dart';
import 'package:app_lorry/widgets/buttons/CustomButton.dart';
import 'package:app_lorry/widgets/shared/back.dart';

// Constants for UI dimensions and styling
class _Constants {
  // static const double containerWidth = 342.0;
  // static const double alertContainerHeight = 84.0;
  // static const double mileageContainerHeight = 170.0;
  // static const double inputFieldWidth = 292.0;
  // static const double inputFieldHeight = 46.0;
  // static const double borderRadius = 8.0;
  static const double iconSize = 20;
  static const EdgeInsets containerPadding = EdgeInsets.all(22);
}

/// Screen to display and update vehicle information and mileage
/// Allows users to view vehicle details and update the current mileage
/// before proceeding to tire inspection.
class InfoVehicles extends ConsumerStatefulWidget {
  final Vehicle vehicleData;
  final List<MountingResult> responseData;

  const InfoVehicles({
    super.key,
    required this.vehicleData,
    required this.responseData,
  });

  @override
  ConsumerState<InfoVehicles> createState() => _InfoVehiclesState();
}

class _InfoVehiclesState extends ConsumerState<InfoVehicles> {
  // Controllers and Notifiers
  late final TextEditingController _mileageController;
  late final ValueNotifier<bool> _isButtonEnabled;

  // Vehicle Data
  late final MountingResult _mountingResult;
  late double _currentMileage;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _setupControllers();
  }

  /// Initialize vehicle data from widget parameters
  void _initializeData() {
    _mountingResult = widget.responseData.isNotEmpty
        ? widget.responseData.first
        : MountingResult(); // Default empty mounting result

    _currentMileage = (_mountingResult.vehicle?.mileage?.first.km) ?? 0.0;
  }

  /// Setup text controllers and listeners
  void _setupControllers() {
    _mileageController = TextEditingController();
    _isButtonEnabled = ValueNotifier(false);

    _updateMileageDisplay();
    _mileageController.addListener(_onMileageChanged);
    _onMileageChanged(); // Initial button state evaluation
  }

  /// Update the mileage display in the text field
  void _updateMileageDisplay() {
    final formattedMileage =
        NumberFormat('#,###').format(_currentMileage.toInt());
    _mileageController.text = formattedMileage;
    _mileageController.selection =
        TextSelection.collapsed(offset: formattedMileage.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Apptheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _buildPageTitle(),
                    const SizedBox(height: 20),
                    _buildVehicleInfoContainer(),
                    const SizedBox(height: 20),
                    _buildAlertContainer(),
                    const SizedBox(height: 1),
                    _buildMileageUpdateContainer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Builders
  Widget _buildHeader() {
    return Back(
        showHome: true,
        showNotifications: true,
        interceptSystemBack: true,
        onBackPressed: () => context.push("/ManualPlateRegister"));
  }

  Widget _buildPageTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Datos de VHC",
          style: Apptheme.h1Title(context, color: Apptheme.textColorSecondary),
        ),
        _buildLicensePlateContainer(),
      ],
    );
  }

  Widget _buildLicensePlateContainer() {
    return LicensePlate(
      licensePlate: _mountingResult.vehicle?.licensePlate ?? 'N/A',
      fontSize: 18,
    );
  }

  Widget _buildVehicleInfoContainer() {
    final String typeVehicle =
        _mountingResult.vehicle?.typeVehicle?.name ?? 'N/A';
    final String workLine = _mountingResult.vehicle?.workLine?.name ?? 'N/A';
    final String customer =
        _mountingResult.vehicle?.customer?.businessName ?? 'N/A';

    return Container(
      padding: _Constants.containerPadding,
      decoration: BoxDecoration(
        color: Apptheme.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InfoRow(title: 'Tipo de vehículo', value: typeVehicle),
          const SizedBox(height: 12),
          InfoRow(title: 'Línea de trabajo', value: workLine),
          const SizedBox(height: 12),
          InfoRow(
            title: 'Cliente asociado al vehículo',
            value: customer,
          ),
          const SizedBox(height: 12),
          _buildMileageDisplay(),
        ],
      ),
    );
  }

  Widget _buildMileageDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Última medición Kilometraje',
          style: Apptheme.h5Body(context, color: Apptheme.textColorSecondary),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/Icono_Velocimetro_Lorry.svg',
              width: _Constants.iconSize,
              height: _Constants.iconSize,
              colorFilter:
                  ColorFilter.mode(Apptheme.textColorPrimary, BlendMode.srcIn),
            ),
            const SizedBox(width: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        '${NumberFormat('#,###').format((_mountingResult.vehicle!.mileage?.first.km) ?? 0.0)} ',
                    style: Apptheme.h5TitleDecorative(context,
                        color: Apptheme.textColorPrimary),
                  ),
                  TextSpan(
                    text: 'KM',
                    style: Apptheme.h5TitleDecorative(context,
                        color: Apptheme.textColorPrimary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAlertContainer() {
    return Container(
      // width: _Constants.containerWidth,
      // height: _Constants.alertContainerHeight,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Apptheme.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.error, color: Apptheme.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Para realizar una nueva inspección, primero debes actualizar el kilometraje",
              style:
                  Apptheme.h5Body(context, color: Apptheme.textColorSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMileageUpdateContainer() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Apptheme.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Column(
        children: [
          _buildMileageInputField(),
          const SizedBox(height: 10),
          _buildUpdateButton(),
        ],
      ),
    );
  }

  Widget _buildMileageInputField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Apptheme.lightGray, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/Icono_Velocimetro_Lorry.svg',
            width: 24,
            height: 24,
            colorFilter:
                ColorFilter.mode(Apptheme.textColorPrimary, BlendMode.srcIn),
          ),
          const SizedBox(width: 3),
          IntrinsicWidth(
            child: TextField(
              controller: _mileageController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                ThousandsSeparatorInputFormatter(),
              ],
              textAlign: TextAlign.center,
              style: Apptheme.h1TitleDecorative(context,
                      color: Apptheme.textColorPrimary)
                  .copyWith(
                height: 0.2,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Apptheme.textColorPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 3),
          Text(
            "KM",
            style: Apptheme.h1Title(
              context,
              color: Apptheme.textColorPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isButtonEnabled,
      builder: (context, enabled, _) {
        return Opacity(
          opacity: enabled ? 1.0 : 0.5,
          child: IgnorePointer(
            ignoring: !enabled,
            child: CustomButton(
              double.infinity,
              46,
              const Text("Actualizar Kilometraje",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  )),
              () => _validateAndNavigate(context),
              type: 1,
            ),
          ),
        );
      },
    );
  }

  // Event Handlers and Business Logic
  void _validateAndNavigate(BuildContext context) {
    if (_mileageController.text.isEmpty) {
      ToastHelper.show_alert(context, "El kilometraje es requerido.");
      return;
    }

    final navigationData = _toNavigationData(_currentMileage);
    ref.read(appRouterProvider).push('/DetailTire', extra: navigationData);
  }

  DetailTireParams _toNavigationData(double updatedMileage) {
    return DetailTireParams(
      results: widget.responseData,
      vehicle: widget.vehicleData,
      mileage: updatedMileage,
    );
  }

  void _onMileageChanged() {
    final cleanedInput =
        _mileageController.text.replaceAll(RegExp(r'[.,]'), '');
    final inputMileage = int.tryParse(cleanedInput) ?? 0;
    final minMileage =
        (_mountingResult.vehicle!.mileage?.first.km as num?) ?? 0.0;
    final isValid = inputMileage >= minMileage;

    setState(() {
      _isButtonEnabled.value = isValid;
      _currentMileage = inputMileage.toDouble();
    });

    if (!isValid && cleanedInput.isNotEmpty) {
      ValidationToastHelper.showValidationToast(
        context: context,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Alerta ",
                style: Apptheme.h4HighlightBody(context, color: Apptheme.black),
              ),
              TextSpan(
                text: "kilometraje",
                style:
                    Apptheme.h4HighlightBody(context, color: Apptheme.primary),
              ),
            ],
          ),
        ),
        message: "La cifra no puede ser menor a la de la inspección anterior",
      );
    } else if (isValid) {
      // Cancelar toast pendiente si ahora es válido
      ValidationToastHelper.cancelPendingToasts();
    }
  }

  @override
  void dispose() {
    _mileageController.dispose();
    _isButtonEnabled.dispose();
    super.dispose();
  }
}
