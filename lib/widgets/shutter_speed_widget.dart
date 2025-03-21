import 'package:flutter/material.dart';
import '../theme/retro_camera_theme.dart';
import '../models/light_meter_model.dart';

class ShutterSpeedWidget extends StatefulWidget {
  final LightMeterModel lightMeter;
  final ValueChanged<double> onChanged;

  const ShutterSpeedWidget({
    super.key,
    required this.lightMeter,
    required this.onChanged,
  });

  @override
  State<ShutterSpeedWidget> createState() => _ShutterSpeedWidgetState();
}

class _ShutterSpeedWidgetState extends State<ShutterSpeedWidget> {
  late final FixedExtentScrollController _scrollController;
  late final int _initialIndex;
  
  @override
  void initState() {
    super.initState();
    _initialIndex = LightMeterModel.shutterSpeedValues.indexOf(widget.lightMeter.shutterSpeed);
    _scrollController = FixedExtentScrollController(initialItem: _initialIndex);
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildLEDDisplay(String leftValue, String currentValue, String rightValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: Text(
            leftValue,
            key: ValueKey(leftValue),
            style: const TextStyle(
              color: RetroCameraTheme.secondaryText,
              fontFamily: 'monospace',
              fontSize: 16,
            ),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: Text(
            currentValue,
            key: ValueKey(currentValue),
            style: const TextStyle(
              color: RetroCameraTheme.primaryText,
              fontFamily: 'monospace',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: RetroCameraTheme.accentColor,
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: Text(
            rightValue,
            key: ValueKey(rightValue),
            style: const TextStyle(
              color: RetroCameraTheme.secondaryText,
              fontFamily: 'monospace',
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGraduation() {
    return Container(
      width: 2,
      height: 12,
      color: RetroCameraTheme.metallicLight,
    );
  }

  Widget _buildCenterGraduation() {
    return Container(
      width: 2,
      height: 16,
      color: RetroCameraTheme.accentColor,
    );
  }

  Widget _buildScaleBar() {
    return SizedBox(
      height: 20,
      child: PageView.builder(
        controller: PageController(
          initialPage: _initialIndex,
          viewportFraction: 0.1,
        ),
        scrollDirection: Axis.horizontal,
        physics: const PageScrollPhysics(),
        onPageChanged: (index) {
          widget.onChanged(LightMeterModel.shutterSpeedValues[index]);
        },
        itemCount: LightMeterModel.shutterSpeedValues.length,
        itemBuilder: (context, index) {
          return Center(
            child: _buildGraduation(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int currentIndex = LightMeterModel.shutterSpeedValues.indexOf(widget.lightMeter.shutterSpeed);
    String leftValue = currentIndex > 0 
        ? formatShutterSpeed(LightMeterModel.shutterSpeedValues[currentIndex - 1])
        : '';
    String currentValue = formatShutterSpeed(widget.lightMeter.shutterSpeed);
    String rightValue = currentIndex < LightMeterModel.shutterSpeedValues.length - 1
        ? formatShutterSpeed(LightMeterModel.shutterSpeedValues[currentIndex + 1])
        : '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(children: [
        _buildLEDDisplay(leftValue, currentValue, rightValue),
        const SizedBox(height: 20),
        Stack(
          alignment: Alignment.center,
          children: [
            _buildScaleBar(),
            _buildCenterGraduation(),
          ],
        ),
      ]),
    );
  }

  String formatShutterSpeed(double speed) {
    if (speed >= 1) {
      return '${speed.toStringAsFixed(1)}"';
    } else {
      return '1/${(1 / speed).toStringAsFixed(0)}';
    }
  }
}