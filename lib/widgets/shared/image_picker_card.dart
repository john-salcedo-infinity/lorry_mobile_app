import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:app_lorry/helpers/helpers.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_lorry/config/app_theme.dart';
import 'package:app_lorry/helpers/permission_helper.dart';

class ImagePickerCard extends ConsumerStatefulWidget {
  final String? initialImageBase64;
  final Function(String?) onImageChanged;
  final double width;
  final double height;

  const ImagePickerCard({
    super.key,
    this.initialImageBase64,
    required this.onImageChanged,
    this.width = 150,
    this.height = 150,
  });

  @override
  ConsumerState<ImagePickerCard> createState() => _ImagePickerCardState();
}

class _ImagePickerCardState extends ConsumerState<ImagePickerCard> {
  String? _imageBase64;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _imageBase64 = widget.initialImageBase64;
  }

  @override
  void didUpdateWidget(covariant ImagePickerCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialImageBase64 != widget.initialImageBase64) {
      setState(() {
        _imageBase64 = widget.initialImageBase64;
      });
    }
  }

  Future<bool> _checkPermissions(ImageSource source) async {
    if (source == ImageSource.camera) {
      return await PermissionHandler.checkCameraPermission();
    } else {
      return await PermissionHandler.checkStoragePermission();
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      // Verificar permisos antes de tomar/seleccionar imagen
      final hasPermission = await _checkPermissions(source);
      if (!hasPermission) {
        if (mounted) {
          ToastHelper.show_alert(
              context,
              source == ImageSource.camera
                  ? 'Permisos de cámara requeridos'
                  : 'Permisos de galería requeridos');

          // pedir los permisos
          await PermissionHandler.requestInitialPermissions();
          // Volver a intentar la selección de imagen
          _pickImage(source);
        }
        return;
      }

      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        final Uint8List imageBytes = await imageFile.readAsBytes();
        final String base64String = base64Encode(imageBytes);

        setState(() {
          _imageBase64 = base64String;
        });

        widget.onImageChanged(base64String);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al seleccionar imagen: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showImageSourceDialog() async {
    showDialog(
      context: context,
      barrierColor: Apptheme.secondary.withValues(alpha: 0.5),
      builder: (dialogContext) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
        child: AlertDialog(
          insetPadding: const EdgeInsets.all(5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Colors.white,
          title: const Center(
            child: Column(
              children: [
                Text(
                  "Agregar imágenes",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Apptheme.textColorPrimary,
                  ),
                ),
                Text(
                  "Puedes adjuntar hasta 1 fotografía",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Apptheme.textColorSecondary,
                  ),
                ),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 10,
                width: double.infinity,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 20,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(dialogContext);
                      _pickImage(ImageSource.camera);
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Apptheme.secondary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(4)),
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/Camera_Icon.svg',
                                width: 40,
                                height: 40,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Tomar foto',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: Apptheme.textColorPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(dialogContext);
                      _pickImage(ImageSource.gallery);
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 35, vertical: 20),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Apptheme.secondary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(4)),
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/Archivo_Icon.svg',
                                width: 40,
                                height: 40,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Subir foto',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: Apptheme.textColorPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _removeImage() {
    setState(() {
      _imageBase64 = null;
    });
    widget.onImageChanged(null);
  }

  Widget _buildImageCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _imageBase64 == null ? _showImageSourceDialog : null,
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              radius: const Radius.circular(4),
              dashPattern: [7, 8],
              strokeWidth: 2,
              padding: const EdgeInsets.all(8),
              color: Apptheme.grayInput,
            ),
            child: SizedBox(
              width: widget.width,
              height: widget.height,
              child: _imageBase64 != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.memory(
                        base64Decode(_imageBase64!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Column(
                            children: [
                              Icon(Icons.error, color: Colors.red),
                              Text('Error al cargar imagen'),
                            ],
                          );
                        },
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/Add_image.svg',
                          width: 30,
                          height: 30,
                        ),
                      ],
                    ),
            ),
          ),
        ),
        if (_imageBase64 != null) ...[
          const SizedBox(height: 8),
          SizedBox(
            width: widget.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: SvgPicture.asset(
                      'assets/icons/Edit_icon.svg',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 1,
                  height: 20,
                  color: Apptheme.grayInput,
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _removeImage,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: SvgPicture.asset(
                      'assets/icons/Trash_Icon.svg',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildImageCard();
  }
}
