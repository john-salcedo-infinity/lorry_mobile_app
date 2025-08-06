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
  static const double containerWidth = 342.0;
  static const double alertContainerHeight = 84.0;
  static const double mileageContainerHeight = 170.0;
  static const double inputFieldWidth = 292.0;
  static const double inputFieldHeight = 46.0;
  static const double borderRadius = 8.0;
  static const double iconSize = 24.0;
  static const double homeIconSize = 40.0;
  static const EdgeInsets containerPadding =
      EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0);
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
      body: SingleChildScrollView(
      
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildPageTitle(),
            ),
            const SizedBox(height: 20),
            _buildVehicleInfoContainer(),
            const SizedBox(height: 20),
            _buildAlertContainer(),
            const SizedBox(height: 1),
            _buildMileageUpdateContainer(),
          ],
        ),
      ),
    );
  }

  // Widget Builders
  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.only(top: 30, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Back(),
          IconButton(
            onPressed: () => context.go('/home'),
            icon: SvgPicture.asset(
              'assets/icons/Icono_Casa_Lorry.svg',
              width: _Constants.homeIconSize,
              height: _Constants.homeIconSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Datos de VHC",
          style: TextStyle(
            fontSize: 23,
            color: Apptheme.textColorSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        _buildLicensePlateContainer(),
      ],
    );
  }

  Widget _buildLicensePlateContainer() {
    return LicensePlate(
      licensePlate: _mountingResult.vehicle?.licensePlate ?? 'N/A',
      fontSize: 22,
    );
  }

  Widget _buildVehicleInfoContainer() {
    return Container(
      width: _Constants.containerWidth,
      padding: _Constants.containerPadding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_Constants.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InfoRow(
              title: 'Tipo de vehículo',
              value: _mountingResult.vehicle?.typeVehicle?.name ?? 'N/A'),
          const SizedBox(height: 12),
          InfoRow(
              title: 'Línea de trabajo',
              value: _mountingResult.vehicle?.workLine?.name ?? 'N/A'),
          const SizedBox(height: 12),
          InfoRow(
            title: 'Cliente asociado al vehículo',
            value: _mountingResult.vehicle?.customer?.businessName ?? 'N/A',
          ),
          const SizedBox(height: 20),
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
          style: TextStyle(
            fontSize: 14,
            color: Apptheme.textColorSecondary,
          ),
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
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Apptheme.textColorPrimary,
                    ),
                  ),
                  const TextSpan(
                    text: 'KM',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Apptheme.textColorPrimary,
                    ),
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
      width: _Constants.containerWidth,
      height: _Constants.alertContainerHeight,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(_Constants.borderRadius),
          topRight: Radius.circular(_Constants.borderRadius),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/Alert_Icon.png',
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Para realizar una nueva inspección, primero debes actualizar el kilometraje",
              style: TextStyle(
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

  Widget _buildMileageUpdateContainer() {
    return Container(
      width: _Constants.containerWidth,
      height: _Constants.mileageContainerHeight,
      padding: const EdgeInsets.only(top: 22, bottom: 26),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(_Constants.borderRadius),
          bottomRight: Radius.circular(_Constants.borderRadius),
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
      width: _Constants.inputFieldWidth,
      height: _Constants.inputFieldHeight,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/Icono_Velocimetro_Lorry.svg',
            width: _Constants.iconSize,
            height: _Constants.iconSize,
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
              style: const TextStyle(
                fontSize: 22,
                height: 0.2,
                fontWeight: FontWeight.bold,
                color: Apptheme.textColorPrimary,
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
          const Text(
            "KM",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
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
              _Constants.inputFieldWidth,
              _Constants.inputFieldHeight,
              const Text("Actualizar Kilometraje", 
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  )),
              () => _validateAndNavigate(context),
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

    setState(() {
      _isButtonEnabled.value = inputMileage >=
          ((_mountingResult.vehicle!.mileage?.first.km as num?) ?? 0.0);
      _currentMileage = inputMileage.toDouble();
    });
  }

  @override
  void dispose() {
    _mileageController.dispose();
    _isButtonEnabled.dispose();
    super.dispose();
  }
}
