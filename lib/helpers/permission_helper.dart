import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static Future<void> requestInitialPermissions() async {
    // Solicitar permisos de cámara y almacenamiento al inicializar la app
    await [
      Permission.camera,
      Permission.photos,
      Permission.storage,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.location
    ].request();
  }

  static Future<bool> checkCameraPermission() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  static Future<bool> checkStoragePermission() async {
    final photosStatus = await Permission.photos.status;
    final storageStatus = await Permission.storage.status;
    return photosStatus.isGranted || storageStatus.isGranted;
  }

  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  static Future<bool> requestStoragePermission() async {
    final results = await [
      Permission.photos,
      Permission.storage,
    ].request();
    return results.values.any((status) => status.isGranted);
  }

  static void showPermissionDeniedDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: const Text('Configuración'),
            ),
          ],
        );
      },
    );
  }
}
