import 'package:flutter/material.dart';
import '../models/light_meter_model.dart';
import '../theme/retro_camera_theme.dart';
import '../services/storage_service.dart';
import 'package:camera/camera.dart';

import 'exposure_params_widget.dart';

class ControlsWidget extends StatelessWidget {
  final CameraController controller;
  final StorageService storage;
  final LightMeterModel lightMeter;

  const ControlsWidget({
    super.key,
    required this.controller,
    required this.storage,
    required this.lightMeter,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ExposureParamsWidget(lightMeter: lightMeter),
        IconButton(
          icon: const Icon(
            Icons.camera_alt_outlined,
            color: RetroCameraTheme.accentColor,
            size: 32,
          ),
          onPressed: () async {
            try {
              final image = await controller.takePicture();
              await storage.saveShot(
                ev: lightMeter.ev,
                iso: lightMeter.iso,
                shutterSpeed: lightMeter.shutterSpeed,
                aperture: lightMeter.aperture,
                meteringMode: lightMeter.meteringMode.toString(),
                imagePath: image.path,
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('拍摄已保存')),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('保存失败: $e')),
                );
              }
            }
          },
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(color: RetroCameraTheme.metallicLight),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(
            Icons.photo_library_outlined,
            color: RetroCameraTheme.primaryText,
          ),
        ),
      ],
    );
  }
}