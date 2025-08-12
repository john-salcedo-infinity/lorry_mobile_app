import 'package:app_lorry/widgets/items/CameraSectionTow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/widgets/buttons/CustomButton.dart';
import 'package:app_lorry/routers/app_routes.dart';

class NewPlateRegister extends ConsumerStatefulWidget {
  final bool showExtraButtons;

  const NewPlateRegister({super.key, this.showExtraButtons = false});

  static NewPlateRegister fromExtra(Object? extra) {
    return NewPlateRegister(showExtraButtons: extra as bool? ?? false);
  }

  @override
  ConsumerState<NewPlateRegister> createState() => _NewPlateRegisterState();
}

class _NewPlateRegisterState extends ConsumerState<NewPlateRegister> {
  CameraController? _cameraController;
  XFile? _capturedImage;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    debugPrint('showExtraButtons: ${widget.showExtraButtons}');
    _checkPermissionAndOpenCamera(); // Llama al método aquí
  }

  Future<void> _checkPermissionAndOpenCamera() async {
    var status = await Permission.camera.request();

    if (status.isGranted) {
      _initCamera();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permiso de cámara denegado.")),
      );
    }
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      _cameraController =
          CameraController(cameras.first, ResolutionPreset.medium);
      await _cameraController!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      debugPrint("Error al inicializar la cámara: \$e");
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      debugPrint(" Cámara no inicializada");
      return;
    }
    try {
      debugPrint(" Intentando capturar foto...");
      final image = await _cameraController!.takePicture();

      // 🚨 Pausar la vista previa
      await _cameraController!.pausePreview();

      setState(() {
        _capturedImage = image;
      });

      debugPrint(" Foto capturada: ${image.path}");
    } catch (e) {
      debugPrint(" Error al capturar la foto: $e");
    }
  }

  void _clearCapturedImage() async {
    if (_cameraController != null) {
      //  Reanudar la vista previa
      await _cameraController!.resumePreview();
    }
    setState(() {
      _capturedImage = null;
    });

    debugPrint(" Vista previa reanudada");
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Apptheme.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () {
            ref.read(appRouterProvider).push('/home');
          },
          child: const Row(
            children: [
              Icon(Icons.arrow_back_ios_new_rounded,
                  color: Apptheme.textColorPrimary),
              SizedBox(width: 4),
              Text(
                'Atrás',
                style: TextStyle(
                  fontSize: 20,
                  color: Apptheme.textColorPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
         actions: [
          IconButton(
            padding: const EdgeInsets.all(10),
            icon: SvgPicture.asset(
              'assets/icons/Icono_Casa_Lorry.svg',
              width: 40, // Ajusta el tamaño según sea necesario
              height: 40,
            ),
            onPressed: () {
              ref.read(appRouterProvider).push('/home');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //  _HeaderView es independiente
              const _HeaderView(),
              const SizedBox(height: 1),

              //  Nueva sección de cámara independiente
              CameraSectionTow(
                isCameraInitialized: _isCameraInitialized,
                capturedImage: _capturedImage,
                cameraController: _cameraController,
                onCapturePhoto: _capturePhoto,
                onSavePhoto: () => _showSaveConfirmationDialog(context),
                onClearPhoto: _clearCapturedImage,
                //  Aquí se pasa el parámetro
              ),
              const SizedBox(height: 20),
              CustomButton(
                342,
                46,
                const Text(
                  "Digitar Manualmente",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                () {
                  Navigator.of(context).pop();
                  ref.read(appRouterProvider).push('/ManualPlateRegister');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSaveConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: const Center(
            child: Text(
              "PLACA MKX 669",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Apptheme.textColorPrimary,
              ),
            ),
          ),
          content: const Text(
            "¿Esta es tu placa?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Apptheme.textColorSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Cierra el diálogo actual
              },
              child: Text(
                "Cancelar",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Apptheme.primary,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Apptheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(
                    width: 2,
                    color: Apptheme.darkorange,
                  ),
                ),
              ),
              onPressed: () {
                if (_capturedImage == null) {
                  debugPrint("Error: No hay imagen capturada");
                  return; // Previene errores si no hay imagen
                }

                debugPrint("Foto guardada: ${_capturedImage!.path}");
                Navigator.of(dialogContext).pop();
                ref.read(appRouterProvider).push('/ManualNewPlateRegister');
              },
              child: const Text(
                "Aceptar",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HeaderView extends StatelessWidget {
  const _HeaderView();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Registro de placa",
          style: TextStyle(
            fontSize: 23,
            color: Color(0xFF494D4C), // Color personalizado
            fontWeight: FontWeight.bold, // Texto en negrita
          ),
        ),

        const SizedBox(height: 10),

        // Fondo blanco con sombra alrededor del Row
        Container(
          width: 342, //  Ancho actualizado
          height: 90, //  Alto actualizado
          padding: const EdgeInsets.only(
              top: 32,
              bottom: 26,
              left: 12,
              right: 12), //  Padding superior/inferior y laterales
          decoration: BoxDecoration(
            color: Colors.white, //  Fondo blanco
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8), //  Borde superior izquierdo
              topRight: Radius.circular(8), //  Borde superior derecho
            ),
            border: Border(
              bottom: BorderSide(
                color: Colors.black12, //  Color del borde inferior
                width: 1, //  Grosor del borde inferior
              ),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12, //  Sombra ligera
                blurRadius: 0,
                offset: Offset(0, 0), //  Desplazamiento de la sombra
              ),
            ],
          ),
          child: Row(
            children: [
              const Image(image: AssetImage('assets/icons/Alert_Icon.png')),
              const SizedBox(width: 10), //  Espacio entre imagen y texto
              const Expanded(
                child: Text(
                  "Toma una foto de la placa para identificar el vehículo asociado",
                  softWrap: true,
                  style: TextStyle(
          fontSize: 12,
          color:
            Apptheme.textColorSecondary, //  Usa el color de tu tema
          fontWeight: FontWeight.bold, //  Texto en negrita
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
