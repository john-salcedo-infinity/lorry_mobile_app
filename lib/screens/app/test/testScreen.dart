import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:bluetooth_classic/models/device.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/helpers/helpers.dart';
import 'package:app_lorry/routers/app_routes.dart';
import 'package:permission_handler/permission_handler.dart';

class TestScreen extends ConsumerWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void requestPermissions() async {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.location,
      ].request();
      if (statuses[Permission.bluetoothScan]!.isGranted &&
          statuses[Permission.bluetoothConnect]!.isGranted &&
          statuses[Permission.location]!.isGranted) {
        print("Permisos concedidos");
      } else {
        print("Permisos no concedidos");
      }
    }

    void da() async {
        final _bluetoothClassicPlugin = BluetoothClassic();
      try {
        await _bluetoothClassicPlugin.initPermissions();
        _bluetoothClassicPlugin.onDeviceDataReceived().listen((data) {
          print("data received: $data");
          print("data received: ${data.hashCode}");
          print("data received: ${data.buffer}");
          print("data receivedv2: ${data.runtimeType}");
          print("data receivedv2: ${data.toString()}");

          // Si data es de tipo Uint8List
          if (data is Uint8List) {
            String receivedString = String.fromCharCodes(data);
            print("Received String: $receivedString");
            ToastHelper.show_success(context, "${receivedString} mm");

            // También puedes procesar bytes individuales si es necesario
            for (int byte in data) {
              print("Byte: $byte");
            }
          
          }
          // print("data received: ${String.fromCharCode(data.hashCode)}");
        });
      } catch (e) {
        print("se exploto la pedida de permiso porque ya habia sido pedida");
      }

        bool finded = false;
            await _bluetoothClassicPlugin.getPairedDevices().then((value) async {
              for (var device in value) {
                if (device.name!.contains("Trans-Logik")) {
                try {
                       await _bluetoothClassicPlugin.connect(device.address,
                            "00001101-0000-1000-8000-00805f9b34fb");
                } catch (e) {
                  print("opps");
                }
                  finded = true;
                }
              }
            });
            if (!finded) {
              ToastHelper.show_alert(context, "no se encontro el dispositivo!!");
              print("no se encontro el dispositivo");
            } else {
              print("se encontro el dispositivo");
            ToastHelper.show_success(context, "se encontro el dispositivo!!");
            }
      print("hola");
    }
    // void da() async {
    //   requestPermissions();
    //   final allb = AllBluetooth();
    //   allb.startBluetoothServer();
    //   final devices = await allb.getBondedDevices();
    //   String adres = "";
    //   for (var device in devices) {
    //     if (device.name.contains("Trans-Logik")) {
    //       print(device.toString());
    //       adres = device.address;
    //       print(device.bondedState);
    //     }
    //   }
    //       print("int");
    //       await allb.connectToDevice(adres);
    //       print("connected");

    //   // print(devices);
    // }

    da();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () {
            ref.read(appRouterProvider).pop();
          },
          child: const Row(
            children: [
              Icon(Icons.arrow_back_ios_new_rounded,
                  color: Apptheme.textColorPrimary),
              Text(
                'Atrás',
                style: TextStyle(
                    color: Apptheme.textColorPrimary,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.all(10),
            icon: const Image(image: AssetImage('assets/icons/Group 7.png')),
            onPressed: () {
              // Add the following line:
              // Preferences().saveKey("isLogin", "false");
              // Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
          IconButton(
            padding: const EdgeInsets.all(10),
            icon: const Image(image: AssetImage('assets/icons/Group_6.png')),
            onPressed: () {
              // Add the following line:
              // Preferences().saveKey("isLogin", "false");
              // Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
