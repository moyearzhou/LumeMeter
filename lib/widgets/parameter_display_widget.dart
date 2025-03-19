import 'package:flutter/material.dart';
import '../theme/retro_camera_theme.dart';
import '../models/light_meter_model.dart';

class ParameterDisplayWidget extends StatelessWidget {
  final LightMeterModel lightMeter;

  const ParameterDisplayWidget({super.key, required this.lightMeter});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: RetroCameraTheme.displayDecoration,
            child: Text(
              'EV ${lightMeter.ev.toStringAsFixed(1)}',
              style: const TextStyle(
                color: RetroCameraTheme.primaryText,
                fontFamily: 'monospace',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: RetroCameraTheme.displayDecoration,
            child: const Text(
              'LUX 710',
              style: TextStyle(
                color: RetroCameraTheme.primaryText,
                fontFamily: 'monospace',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: RetroCameraTheme.metallicDecoration,
            child: const Text(
              'F.AUTO',
              style: TextStyle(
                color: RetroCameraTheme.accentColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: RetroCameraTheme.displayDecoration,
            child: Text(
              'ISO ${lightMeter.iso}',
              style: const TextStyle(
                color: RetroCameraTheme.primaryText,
                fontFamily: 'monospace',
                fontSize: 18,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: RetroCameraTheme.displayDecoration,
            child: Text(
              'F ${lightMeter.aperture.toStringAsFixed(1)}',
              style: const TextStyle(
                color: RetroCameraTheme.primaryText,
                fontFamily: 'monospace',
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    ]);
  }
}