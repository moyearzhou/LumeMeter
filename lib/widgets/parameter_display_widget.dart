import 'package:flutter/material.dart';
import '../bean/measure_mode.dart';
import '../models/light_meter_model.dart';
import 'display_value_widget.dart';
import 'mode_toggle_button.dart';
import 'exposure_params_widget.dart';

class ParameterDisplayWidget extends StatefulWidget {
  final LightMeterModel lightMeter;

  const ParameterDisplayWidget({super.key, required this.lightMeter});

  @override
  State<ParameterDisplayWidget> createState() => _ParameterDisplayWidgetState();
}

class _ParameterDisplayWidgetState extends State<ParameterDisplayWidget> {

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ValueListenableBuilder<double>(
            valueListenable: widget.lightMeter.evNotifier,
            builder: (context, ev, child) {
              return DisplayValueWidget(label: 'EV', value: ev);
            },
          ),
          ValueListenableBuilder<double>(
            valueListenable: widget.lightMeter.luxNotifier,
            builder: (context, lux, child) {
              return DisplayValueWidget(label: 'LUX', value: lux, fractionDigits: 0);
            },
          ),
          ModeToggleButton(
            exposureMode: widget.lightMeter.exposureMode,
            onToggle: () {
              setState(() {
                widget.lightMeter.exposureMode = widget.lightMeter.exposureMode == MeasureMode.aperturePriority
                    ? MeasureMode.shutterPriority
                    : MeasureMode.aperturePriority;
              });
            },
          ),
        ],
      ),
      const SizedBox(height: 20),
      ExposureParamsWidget(lightMeter: widget.lightMeter),
    ]);
  }
}