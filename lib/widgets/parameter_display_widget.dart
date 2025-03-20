import 'package:flutter/material.dart';
import '../bean/measure_mode.dart';
import '../theme/retro_camera_theme.dart';
import '../models/light_meter_model.dart';

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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: RetroCameraTheme.displayDecoration,
            child: ValueListenableBuilder<double>(
              valueListenable: widget.lightMeter.evNotifier,
              builder: (context, ev, child) {
                return Text(
                  'EV ${ev.toStringAsFixed(1)}',
                  style: const TextStyle(
                    color: RetroCameraTheme.primaryText,
                    fontFamily: 'monospace',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: RetroCameraTheme.displayDecoration,
            child: ValueListenableBuilder<double>(
              valueListenable: widget.lightMeter.luxNotifier,
              builder: (context, lux, child) {
                return Text(
                  'LUX ${lux.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: RetroCameraTheme.primaryText,
                    fontFamily: 'monospace',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  widget.lightMeter.exposureMode = widget.lightMeter.exposureMode == MeasureMode.aperturePriority
                      ? MeasureMode.shutterPriority
                      : MeasureMode.aperturePriority;
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: RetroCameraTheme.metallicDecoration,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    widget.lightMeter.exposureMode == MeasureMode.aperturePriority ? 'F.AUTO' : 'S.AUTO',
                    key: ValueKey<MeasureMode>(widget.lightMeter.exposureMode),
                    style: const TextStyle(
                      color: RetroCameraTheme.accentColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
              'ISO ${widget.lightMeter.iso}',
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
              'F ${widget.lightMeter.aperture.toStringAsFixed(1)}',
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