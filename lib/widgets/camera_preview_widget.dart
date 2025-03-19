import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../theme/retro_camera_theme.dart';

class CameraPreviewWidget extends StatelessWidget {
  final CameraController controller;

  const CameraPreviewWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'H.3 20MP ${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}',
              style: const TextStyle(color: RetroCameraTheme.secondaryText, fontSize: 12),
            ),
          ],
        ),
      ),
      Expanded(
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: RetroCameraTheme.viewfinderDecoration,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CameraPreview(controller),
          ),
        ),
      ),
    ]);
  }
}