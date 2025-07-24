import 'dart:io';
import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/widgets/buttons/CustomButtonBorderOrange.dart';
import 'package:app_lorry/widgets/buttons/CustomButtonSecondary.dart';
import 'package:app_lorry/widgets/buttons/CustomButtondisabled.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraSectionTow extends StatelessWidget {
  final bool isCameraInitialized;
  final XFile? capturedImage;
  final CameraController? cameraController;
  final VoidCallback onCapturePhoto;
  final VoidCallback onSavePhoto;
  final VoidCallback onClearPhoto;

  const CameraSectionTow({
    required this.isCameraInitialized,
    required this.capturedImage,
    required this.cameraController,
    required this.onCapturePhoto,
    required this.onSavePhoto,
    required this.onClearPhoto,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 342,
      height: _calculateContainerHeight(),
      padding: const EdgeInsets.only(top: 22, bottom: 26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 0,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Si la cámara está inicializada, mostrar siempre la vista previa
          if (isCameraInitialized && cameraController != null)
            SizedBox(
              width: 292,
              height: 364,
              child: CameraPreview(cameraController!),
            )
          // Si se capturó una imagen, mostrarla
          else if (capturedImage != null)
            SizedBox(
              width: 292,
              height: 364,
              child: Image.file(File(capturedImage!.path)),
            )
          // Mientras se inicializa la cámara, muestra un indicador de carga
          else
            SizedBox(
              width: 292,
              height: 364,
              child: Center(child: Apptheme.loadingIndicator()),
            ),

          const SizedBox(height: 10),

          // Botón "Tomar Foto" si la cámara está activa
          if (isCameraInitialized && capturedImage == null) ...[
            CustomButtonBorderOrange(
              292,
              46,
              const Text(
                "Tomar Foto",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Apptheme
                      .primary, // Asegura que el texto también sea naranja
                ),
              ),
              onCapturePhoto,
            ),
            const SizedBox(height: 2),
            CustomButtonDisabled(
              292,
              46,
              const Text(
                "Repetir Foto",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              onClearPhoto,
            ),
          ],
          // Botones "Guardar Foto" y "Repetir Foto" si ya se capturó una imagen
          if (capturedImage != null) ...[
            CustomButtonBorderOrange(
              292,
              46,
              const Text(
                "Guardar Foto",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              onSavePhoto,
            ),
            const SizedBox(height: 2),
            CustomButtonSecondary(
              292,
              46,
              const Text(
                "Repetir Foto",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              onClearPhoto,
            ),
          ],
        ],
      ),
    );
  }

  // Función para calcular la altura del contenedor
  double _calculateContainerHeight() {
    return 540; // Altura base
  }
}
