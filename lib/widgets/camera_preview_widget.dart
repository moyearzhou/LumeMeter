import 'dart:math';

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
      // EV值
      final ev = widget.lightMeter.calculateEV(image);
      final lux = widget.lightMeter.calculateLuminance(ev);
      widget.lightMeter.lux = lux;

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
      Expanded(
        child: Container(
          margin: const EdgeInsets.only(top: 12, bottom: 12),
          padding: const EdgeInsets.only(left: 12, right: 12, top: 18, bottom: 18),
          decoration: RetroCameraTheme.viewfinderDecoration,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CameraPreview(widget.controller),
              ),
              Container(
                margin: const EdgeInsets.only(right: 24.0),
                child: Transform.rotate(
                  angle: 90 * (pi / 180), // 旋转角度（弧度制，-90 为顺时针）
                  child: Row(
                    children: [
                      Text(
                          'H.3 20MP ${DateTime.now().day}.${DateTime.now().month}',
                          style: const TextStyle(color: RetroCameraTheme.secondaryText, fontSize: 12),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}