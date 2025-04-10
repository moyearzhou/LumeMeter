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
        IsoSelectWidget(iso: lightMeter.iso, onIsoChanged: (selectedIso) {
          lightMeter.setIso(selectedIso);
        }),
      ],
    );
  }
}