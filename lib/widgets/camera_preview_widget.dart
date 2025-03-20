import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../theme/retro_camera_theme.dart';
import '../models/light_meter_model.dart';

class CameraPreviewWidget extends StatefulWidget {
  final CameraController controller;
  final LightMeterModel lightMeter;

  const CameraPreviewWidget({
    super.key,
    required this.controller,
    required this.lightMeter,
  });

  @override
  State<CameraPreviewWidget> createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  @override
  void initState() {
    super.initState();
    // 设置图像流监听
    widget.controller.startImageStream((CameraImage image) {
      if (!mounted) return;
      // 计算亮度并更新EV值
      final luminance = widget.lightMeter.calculateLuminance(image);
      final ev = widget.lightMeter.calculateEV(luminance);
      widget.lightMeter.updateExposureParams(ev);
      setState(() {}); // 更新UI显示
    });
  }

  @override
  void dispose() {
    // 停止图像流
    widget.controller.stopImageStream();
    super.dispose();
  }

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
            child: CameraPreview(widget.controller),
          ),
        ),
      ),
    ]);
  }
}