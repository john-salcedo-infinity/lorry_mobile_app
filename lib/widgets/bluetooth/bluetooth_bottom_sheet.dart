import 'package:app_lorry/widgets/buttons/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:app_lorry/services/bluetooth/bluetooth_service.dart';
import 'package:app_lorry/models/models.dart';
import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/widgets/dialogs/confirmation_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/routers/routers.dart';
import 'dart:async';

class BluetoothBottomSheet extends ConsumerStatefulWidget {
  const BluetoothBottomSheet({super.key});

  @override
  ConsumerState<BluetoothBottomSheet> createState() =>
      _BluetoothBottomSheetState();
}

class _BluetoothBottomSheetState extends ConsumerState<BluetoothBottomSheet>
    with SingleTickerProviderStateMixin {
  final BluetoothService _bluetoothService = BluetoothService.instance;
  List<BluetoothDeviceModel> _devices = [];
  List<BluetoothDeviceModel> _bondedDevices = [];
  bool _isScanning = false;
  bool _isConnecting = false;
  bool _isDisconnecting = false;
  String? _connectingDeviceAddress;
  BluetoothDeviceModel? _connectedDevice;

  // Mensajes de estado
  String? _statusMessage;
  Color? _statusMessageColor;

  // Tab Controller
  late TabController _tabController;
  int _currentTabIndex = 0;

  // StreamSubscriptions para poder cancelarlas correctamente
  StreamSubscription<List<BluetoothDeviceModel>>? _devicesSubscription;
  StreamSubscription<bool>? _scanningSubscription;
  StreamSubscription<BluetoothDeviceModel?>? _connectedDeviceSubscription;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
    _initializeService();
    _listenToStreams();
  }

  void _initializeService() async {
    try {
      _bluetoothService.initialize();

      // Verificar el estado real de la conexión antes de cargar
      await _bluetoothService.verifyConnectionState();

      // Cargar estado inicial
      setState(() {
        _devices = List.from(_bluetoothService.discoveredDevices);
        _isScanning = _bluetoothService.isScanning;
        _connectedDevice = _bluetoothService.connectedDevice;
      });

      // Si hay un dispositivo conectado, asegurarse de que esté en la lista
      if (_connectedDevice != null) {
        final isInList =
            _devices.any((d) => d.address == _connectedDevice!.address);
        if (!isInList) {
          setState(() {
            _devices.insert(0, _connectedDevice!); // Añadirlo al principio
          });
        }
      }

      // También cargar dispositivos emparejados para mostrarlos
      _loadBondedDevices();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _loadBondedDevices() async {
    try {
      final bondedDevices = await _bluetoothService.getBondedDevices();
      if (mounted) {
        setState(() {
          _bondedDevices = bondedDevices;

          // También añadir a la lista general si no están
          for (final bonded in bondedDevices) {
            if (!_devices.any((d) => d.address == bonded.address)) {
              _devices.add(bonded);
            }
          }
        });
      }
    } catch (e) {
      print('Error cargando dispositivos emparejados: $e');
    }
  }

  void _listenToStreams() {
    _devicesSubscription = _bluetoothService.devicesStream.listen(
      (devices) {
        if (mounted) {
          setState(() {
            // Mantener dispositivos conectados y emparejados, agregar nuevos del escaneo
            final existingAddresses = _devices.map((d) => d.address).toSet();

            // Agregar nuevos dispositivos del stream que no están ya en la lista
            for (final device in devices) {
              if (!existingAddresses.contains(device.address)) {
                _devices.add(device);
              }
            }

            // Actualizar dispositivos existentes (por si cambió el estado de emparejado, etc.)
            for (int i = 0; i < _devices.length; i++) {
              final existingDevice = _devices[i];
              final updatedDevice = devices.firstWhere(
                  (d) => d.address == existingDevice.address,
                  orElse: () => existingDevice);
              if (updatedDevice != existingDevice) {
                _devices[i] = updatedDevice;
              }
            }

            // Asegurarse de que el dispositivo conectado esté siempre visible
            if (_connectedDevice != null) {
              final isInList =
                  _devices.any((d) => d.address == _connectedDevice!.address);
              if (!isInList) {
                _devices.insert(0, _connectedDevice!);
              }
            }
          });
        }
      },
    );

    _scanningSubscription = _bluetoothService.scanningStream.listen(
      (isScanning) {
        if (mounted) {
          setState(() {
            _isScanning = isScanning;
          });
        }
      },
    );

    _connectedDeviceSubscription =
        _bluetoothService.connectedDeviceStream.listen(
      (connectedDevice) {
        if (mounted) {
          setState(() {
            _connectedDevice = connectedDevice;

            // Si se conectó un dispositivo, agregarlo a la lista si no está
            if (_connectedDevice != null) {
              final isInList =
                  _devices.any((d) => d.address == _connectedDevice!.address);
              if (!isInList) {
                _devices.insert(0, _connectedDevice!);
              }
            }
          });
        }
      },
    );
  }

  Future<void> _startScanning() async {
    if (!mounted) return;
    await _bluetoothService.scanDevices(timeout: const Duration(seconds: 10));
  }

  void _showStatusMessage(String message, {Color? color}) {
    setState(() {
      _statusMessage = message;
      _statusMessageColor = color ?? Apptheme.secondary;
    });

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _statusMessage = null;
          _statusMessageColor = null;
        });
      }
    });
  }

  void connectToDevice(BluetoothDeviceModel device) async {
    // Evitar múltiples conexiones simultáneas
    if (_isConnecting || _isDisconnecting) return;

    setState(() {
      _isConnecting = true;
      _connectingDeviceAddress = device.address;
    });

    final result = await _bluetoothService.connectToDevice(device);

    if (mounted) {
      setState(() {
        _isConnecting = false;
        _connectingDeviceAddress = null;
      });

      _showStatusMessage(
        result.isSuccess
            ? '✅ Conectado a ${device.name}'
            : '❌ Error al conectar a ${device.name}',
        color: result.isSuccess ? Apptheme.secondary : Colors.red,
      );
    }
  }

  void _handleDeviceTap(BluetoothDeviceModel device) async {
    final isConnected = _connectedDevice?.address == device.address;

    if (isConnected) {
      // Si está conectado, preguntar si desea desconectar
      ConfirmationDialog.show(
        context: context,
        title: 'Desconectar Dispositivo',
        message: '¿Desea desconectar el dispositivo ${device.name}?',
        cancelText: 'Cancelar',
        acceptText: 'Desconectar',
        onAccept: () => _disconnectDevice(),
      );
    } else {
      // Si no está conectado, intentar conectar
      connectToDevice(device);
    }
  }

  void _disconnectDevice() async {
    if (_connectedDevice != null && !_isDisconnecting) {
      setState(() {
        _isDisconnecting = true;
      });

      await _bluetoothService.disconnectDevice();

      if (mounted) {
        setState(() {
          _isDisconnecting = false;
        });

        _showStatusMessage(
          '🔌 Dispositivo desconectado',
          color: Apptheme.alertOrange,
        );
      }
    }
  }

  void _showCalibrationContextMenu(BluetoothDeviceModel device) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                device.name.isEmpty ? 'Dispositivo desconocido' : device.name,
                style: Apptheme.h4HighlightBody(context,
                    color: Apptheme.textColorPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                device.address,
                style: Apptheme.h5Body(context,
                    color: Apptheme.textColorSecondary),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: Icon(
                  Icons.tune,
                  color: Apptheme.primary,
                ),
                title: Text(
                  'Comprobación dispositivo',
                  style: Apptheme.h4Medium(context,
                      color: Apptheme.textColorPrimary),
                ),
                subtitle: Text(
                  'Verifica la información enviada por el dispositivo',
                  style: Apptheme.h5Body(context,
                      color: Apptheme.textColorSecondary),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToCalibration(device);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _navigateToCalibration(BluetoothDeviceModel device) {
    ref.read(appRouterProvider).push(
      '/bluetooth-calibration',
      extra: {
        'deviceName': device.name,
        'deviceAddress': device.address,
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();

    // Solo detener el escaneo, pero NO cancelar las suscripciones
    // para mantener la conexión activa cuando el BottomSheet se cierre
    if (_isScanning) {
      _bluetoothService.stopScanning();
    }

    // Cancelar las suscripciones locales del widget
    _devicesSubscription?.cancel();
    _scanningSubscription?.cancel();
    _connectedDeviceSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle del bottom sheet
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Título
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _connectedDevice != null
                  ? 'Conectado: ${_connectedDevice!.name}'
                  : 'Dispositivos Bluetooth',
              style:
                  Apptheme.h2Title(context, color: Apptheme.textColorPrimary),
            ),
          ),

          // Área de mensajes de estado
          if (_statusMessage != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _statusMessageColor?.withOpacity(0.1),
                border: Border.all(
                  color: _statusMessageColor ?? Apptheme.secondary,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _statusMessage!,
                style: Apptheme.h5Body(context, color: _statusMessageColor),
                textAlign: TextAlign.center,
              ),
            ),

          if (_statusMessage != null) const SizedBox(height: 16),

          // Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: TabBar(
              controller: _tabController,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  color: Apptheme.primary,
                  width: 3,
                ),
                insets: const EdgeInsets.symmetric(horizontal: 16),
              ),
              labelColor: Apptheme.primary,
              labelStyle: Apptheme.h4HighlightBody(context),
              unselectedLabelStyle: Apptheme.h4Body(context),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(text: 'Todos'),
                Tab(text: 'Recientes'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAllDevicesTab(),
                _buildRecentDevicesTab(),
              ],
            ),
          ),

          // Loading overlay si está conectando/desconectando
          if (_isConnecting || _isDisconnecting)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Apptheme.loadingIndicator(),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _isConnecting ? 'Conectando...' : 'Desconectando...',
                    style: Apptheme.h4Medium(context, color: Apptheme.primary),
                  ),
                ],
              ),
            ),

          // Botón de escanear
          Padding(
            padding: const EdgeInsets.all(16),
            child: CustomButton(
              double.infinity,
              46,
              _isScanning
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Apptheme.loadingIndicatorButton(),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Escaneando...",
                          style: Apptheme.h4HighlightBody(
                            context,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : Text("Escanear dispositivos"),
              _isConnecting || _isDisconnecting
                  ? null
                  : (_isScanning
                      ? () => _bluetoothService.stopScanning()
                      : _startScanning),
              type: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllDevicesTab() {
    return _buildDeviceList(_devices,
        showEmptyMessage:
            'Presiona "Escanear Dispositivos" para buscar dispositivos cercanos');
  }

  Widget _buildRecentDevicesTab() {
    return _buildDeviceList(_bondedDevices,
        showEmptyMessage: 'No tienes dispositivos emparejados anteriormente');
  }

  Widget _buildDeviceList(List<BluetoothDeviceModel> devices,
      {required String showEmptyMessage}) {
    // Caso especial: dispositivo conectado pero lista vacía
    if (devices.isEmpty &&
        !_isScanning &&
        _connectedDevice != null &&
        _currentTabIndex == 0) {
      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildDeviceListTile(_connectedDevice!, true),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Presiona "Escanear Dispositivos" para buscar más dispositivos',
              style: Apptheme.h5Body(context, color: Apptheme.gray),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }

    if (devices.isEmpty && !_isScanning) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            showEmptyMessage,
            style: Apptheme.h4Body(context, color: Apptheme.gray),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (_isScanning && devices.isEmpty && _currentTabIndex == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Apptheme.loadingIndicator(),
            const SizedBox(height: 16),
            Text(
              'Buscando dispositivos...',
              style: Apptheme.h4Medium(context, color: Apptheme.primary),
            ),
          ],
        ),
      );
    }

    // Ordenar la lista para que el dispositivo conectado aparezca primero
    final sortedDevices = List<BluetoothDeviceModel>.from(devices);
    if (_connectedDevice != null) {
      sortedDevices.removeWhere((d) => d.address == _connectedDevice!.address);
      sortedDevices.insert(0, _connectedDevice!);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: sortedDevices.length,
      itemBuilder: (context, index) {
        final device = sortedDevices[index];
        final isConnected = _connectedDevice?.address == device.address;
        return _buildDeviceListTile(device, isConnected);
      },
    );
  }

  Widget _buildDeviceListTile(BluetoothDeviceModel device, bool isConnected) {
    final isLoading =
        _isConnecting && _connectingDeviceAddress == device.address;
    final isDisconnectingThis = _isDisconnecting && isConnected;
    final isInteractive = !_isConnecting && !_isDisconnecting;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isConnected ? Apptheme.selectActiveBackground : Colors.white,
        border: Border.all(
          color: isConnected ? Apptheme.selectActiveBorder : Apptheme.lightGray,
          width: isConnected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        enabled: isInteractive,
        leading: isLoading || isDisconnectingThis
            ? SizedBox(
                width: 24,
                height: 24,
                child: Apptheme.loadingIndicator(),
              )
            : Icon(
                isConnected ? Icons.bluetooth_connected : Icons.bluetooth,
                color: isConnected ? Apptheme.secondary : Apptheme.primary,
                size: 24,
              ),
        title: Text(
          device.name.isEmpty ? 'Dispositivo desconocido' : device.name,
          style: isConnected
              ? Apptheme.h4HighlightBody(context,
                  color: Apptheme.textColorPrimary)
              : Apptheme.h4Medium(context, color: Apptheme.textColorPrimary),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              device.address,
              style:
                  Apptheme.h5Body(context, color: Apptheme.textColorSecondary),
            ),
            if (device.isPaired)
              Text(
                'Emparejado',
                style: Apptheme.h5Body(context, color: Apptheme.secondary),
              ),
          ],
        ),
        trailing: isConnected
            ? Icon(
                Icons.check_circle,
                color: Apptheme.secondary,
                size: 24,
              )
            : Icon(
                Icons.arrow_forward_ios,
                color: Apptheme.gray,
                size: 16,
              ),
        onTap: isInteractive ? () => _handleDeviceTap(device) : null,
        onLongPress: isConnected && isInteractive
            ? () => _showCalibrationContextMenu(device)
            : null,
      ),
    );
  }
}
