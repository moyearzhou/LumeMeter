import 'package:flutter/material.dart';
import '../theme/retro_camera_theme.dart';
import '../models/light_meter_model.dart';

// 样式常量
const _kDisplayStyles = {
  'secondary': TextStyle(
    color: RetroCameraTheme.secondaryText,
    fontFamily: 'monospace',
    fontSize: 16,
  ),
  'primary': TextStyle(
    color: RetroCameraTheme.primaryText,
    fontFamily: 'monospace',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    shadows: [Shadow(color: RetroCameraTheme.accentColor, blurRadius: 8)],
  ),
};

const _kAnimationDuration = Duration(milliseconds: 200);

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
  late final ValueNotifier<int> _currentIndexNotifier;
  late final ValueNotifier<double> _targetApertureNotifier;
  
  @override
  void initState() {
    super.initState();
    final initialIndex = LightMeterModel.shutterSpeedValues.indexOf(widget.lightMeter.shutterSpeed);
    _scrollController = FixedExtentScrollController(initialItem: initialIndex);
    _currentIndexNotifier = ValueNotifier(initialIndex);
    _targetApertureNotifier = ValueNotifier(_calculateTargetAperture());
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    _currentIndexNotifier.dispose();
    _targetApertureNotifier.dispose();
    super.dispose();
  }

  // 数据处理逻辑
  double _calculateTargetAperture() {
    return LightMeterModel.calAperture(
      widget.lightMeter.ev,
      widget.lightMeter.shutterSpeed,
      widget.lightMeter.iso,
    );
  }

  String _formatShutterSpeed(double speed) {
    if (speed >= 1) return '${speed.toStringAsFixed(1)}"';
    return '1/${(1 / speed).toStringAsFixed(0)}';
  }

  String _formatAperture(double aperture) => aperture.toStringAsFixed(1);

  // UI组件
  Widget _buildAnimatedText(String text, bool isPrimary) {
    return AnimatedSwitcher(
      duration: _kAnimationDuration,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: Text(
        text,
        key: ValueKey(text),
        textAlign: TextAlign.center,
        style: isPrimary ? _kDisplayStyles['primary'] : _kDisplayStyles['secondary'],
      ),
    );
  }

  // LED样式文本显示
  Widget _buildLEDDisplay(String leftValue, String currentValue, String rightValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildAnimatedText(leftValue, false),
        _buildAnimatedText(currentValue, true),
        _buildAnimatedText(rightValue, false),
      ],
    );
  }

  // 刻度条
  Widget _buildGraduation({bool isCenter = false}) {
    return Container(
      width: 2,
      height: isCenter ? 16 : 12,
      color: isCenter ? RetroCameraTheme.accentColor : RetroCameraTheme.metallicLight,
    );
  }

  Widget _buildScaleBar() {
    return SizedBox(
      height: 20,
      child: PageView.builder(
        controller: PageController(
          initialPage: _currentIndexNotifier.value,
          viewportFraction: 0.1,
        ),
        scrollDirection: Axis.horizontal,
        physics: const PageScrollPhysics(),
        onPageChanged: (index) {
          _currentIndexNotifier.value = index;
          widget.onChanged(LightMeterModel.shutterSpeedValues[index]);
          _targetApertureNotifier.value = _calculateTargetAperture();
        },
        itemCount: LightMeterModel.shutterSpeedValues.length,
        itemBuilder: (_, __) => Center(child: _buildGraduation()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, spreadRadius: 2)],
      ),
      child: ValueListenableBuilder<int>(
        valueListenable: _currentIndexNotifier,
        builder: (context, currentIndex, _) {
          final currentSpeed = LightMeterModel.shutterSpeedValues[currentIndex];
          final leftSpeed = currentIndex > 0 ? LightMeterModel.shutterSpeedValues[currentIndex - 1] : null;
          final rightSpeed = currentIndex < LightMeterModel.shutterSpeedValues.length - 1
              ? LightMeterModel.shutterSpeedValues[currentIndex + 1]
              : null;

          return Column(children: [
            _buildLEDDisplay(
              leftSpeed != null ? _formatShutterSpeed(leftSpeed) : '',
              _formatShutterSpeed(currentSpeed),
              rightSpeed != null ? _formatShutterSpeed(rightSpeed) : '',
            ),
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.center,
              children: [_buildScaleBar(), _buildGraduation(isCenter: true)],
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder<double>(
              valueListenable: _targetApertureNotifier,
              builder: (context, targetAperture, _) {
                final currentApertureIndex = LightMeterModel.apertureValues.indexOf(targetAperture);
                final leftAperture = currentApertureIndex > 0
                    ? LightMeterModel.apertureValues[currentApertureIndex - 1]
                    : null;
                final rightAperture = currentApertureIndex < LightMeterModel.apertureValues.length - 1
                    ? LightMeterModel.apertureValues[currentApertureIndex + 1]
                    : null;

                return _buildLEDDisplay(
                  leftAperture != null ? _formatAperture(leftAperture) : '',
                  _formatAperture(targetAperture),
                  rightAperture != null ? _formatAperture(rightAperture) : '',
                );
              },
            ),
          ]);
        },
      ),
    );
  }
}