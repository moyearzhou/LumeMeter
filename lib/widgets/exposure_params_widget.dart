import 'package:flutter/material.dart';
import 'package:lightmeter/widgets/display_value_widget.dart';
import 'package:lightmeter/widgets/iso_select_widget.dart';
import '../bean/measure_mode.dart';
import '../models/light_meter_model.dart';
import '../theme/retro_camera_theme.dart';

class ExposureParamsWidget extends StatelessWidget {
  final LightMeterModel lightMeter;

  const ExposureParamsWidget({
    super.key,
    required this.lightMeter,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: RetroCameraTheme.displayDecoration,
          child: Row(
            children: [
              Text(
                lightMeter.exposureMode == MeasureMode.aperturePriority ? 'S ' : 'F ',
                style: const TextStyle(
                  color: RetroCameraTheme.primaryText,
                  fontFamily: 'monospace',
                  fontSize: 18,
                ),
              ),
              Text(
                lightMeter.exposureMode == MeasureMode.aperturePriority
                    ? lightMeter.shutterSpeed.toStringAsFixed(1)
                    : lightMeter.aperture.toStringAsFixed(1),
                style: const TextStyle(
                  color: RetroCameraTheme.primaryText,
                  fontFamily: 'monospace',
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        IsoSelectWidget(iso: lightMeter.iso, onIsoChanged: null),
      ],
    );
  }
}