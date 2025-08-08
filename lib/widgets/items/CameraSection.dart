import 'dart:io';

import 'package:app_lorry/widgets/buttons/CustomButtonSecondary.dart';
import 'package:app_lorry/widgets/buttons/CustomButtondisabled.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:app_lorry/widgets/buttons/CustomButton.dart';

class CameraSection extends StatelessWidget {
  final bool isCameraInitialized;
  final XFile? capturedImage;
  final CameraController? cameraController;
  final VoidCallback onAccessCamera;
  final VoidCallback onCapturePhoto;
  final VoidCallback onSavePhoto;
  final VoidCallback onClearPhoto;
  final bool showExtraButtons;

  const CameraSection({
    required this.isCameraInitialized,
    required this.capturedImage,
    required this.cameraController,
    required this.onAccessCamera,
    required this.onCapturePhoto,
    required this.onSavePhoto,
    required this.onClearPhoto,
    this.showExtraButtons = false, // Parámetro nuevo
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
          //  Mostrar imagen capturada, vista previa o placeholder
          if (capturedImage != null)
            SizedBox(
              width: 292,
              height: 364,
              child: Image.file(File(capturedImage!.path)),
            )
          else if (isCameraInitialized && cameraController != null)
            SizedBox(
              width: 292,
              height: 364,
              child: CameraPreview(cameraController!),
            )
          else
            const SizedBox(
              width: 292,
              height: 364,
              child: Image(image: AssetImage('assets/icons/Permisos.png')),
            ),

          const SizedBox(height: 10),

          //  Botón para acceder a la cámara
          if (!isCameraInitialized && !showExtraButtons)
            CustomButton(
              292,
              46,
              const Text(
                "Acceder a la Cámara",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              onAccessCamera,
            ),

          //  Botón de "Tomar Foto" o "Repetir Foto"
          if (isCameraInitialized && capturedImage == null) ...[
            CustomButton(
              292,
              46,
              const Text(
                "Tomar foto",
                 style: TextStyle(
                  fontWeight: FontWeight.bold, //  Ajusta el estilo del texto
                  fontSize: 14,
                ),
              ),
              onCapturePhoto,
            ),
            const SizedBox(height: 2),
            CustomButtonDisabled(
              292,
              50,
              const Text(
                "Repetir foto",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              onClearPhoto,
            ),
          ],
          //  Botones para guardar o repetir foto
          if (capturedImage != null) ...[
            CustomButton(
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
              50,
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

  //  Función para calcular la altura según el estado
  double _calculateContainerHeight() {
    double baseHeight = 545;
    if (showExtraButtons) {
      baseHeight += 200; // Ajustar altura si hay nuevos botones
    }
    return baseHeight;
  }
}
