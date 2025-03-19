import 'package:flutter/material.dart';
import '../theme/retro_camera_theme.dart';
import '../models/light_meter_model.dart';

class ShutterSpeedWidget extends StatelessWidget {
  final LightMeterModel lightMeter;
  final ValueChanged<double> onChanged;

  const ShutterSpeedWidget({
    super.key,
    required this.lightMeter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Slider(
        value: lightMeter.shutterSpeed,
        min: 1/250,
        max: 1/60,
        activeColor: RetroCameraTheme.accentColor,
        inactiveColor: RetroCameraTheme.metallicLight,
        onChanged: onChanged,
      ),
      const SizedBox(height: 20),
    ]);
  }
}