import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lightmeter/theme/retro_camera_theme.dart';
import 'package:lightmeter/widgets/display_value_widget.dart';
import 'dart:math' as math;

class IsoSelectWidget extends StatefulWidget {
  const IsoSelectWidget({
    super.key,
    required this.iso,
    this.onIsoChanged,
  });
  final int iso;
  final ValueChanged<int>? onIsoChanged;

  @override
  State<IsoSelectWidget> createState() => _IsoSelectWidgetState();
}

class _IsoSelectWidgetState extends State<IsoSelectWidget>
    with SingleTickerProviderStateMixin {
  static const List<int> _isoValues = [100, 200, 400, 800, 1600, 3200, 6400];
  int _currentIndex = 0;
  double _dragOffset = 0.0;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  @override
  void initState() {
    super.initState();
    _currentIndex = _isoValues.indexOf(widget.iso);
    if (_currentIndex < 0) _currentIndex = 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    _dragOffset += details.delta.dy;
    final sensitivity = 50.0;
    if (_dragOffset.abs() > sensitivity) {
      final direction = _dragOffset.sign;
      setState(() {
        if (direction > 0) {
          _currentIndex =
              (_currentIndex - 1 + _isoValues.length) % _isoValues.length;
        } else {
          _currentIndex = (_currentIndex + 1) % _isoValues.length;
        }
        widget.onIsoChanged?.call(_isoValues[_currentIndex]);
      });
      _dragOffset = 0.0;
      _controller.forward(from: 0.0);
    }
  }

  void _handleVerticalDragEnd(DragEndDetails details) {
    _dragOffset = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: _handleVerticalDragUpdate,
      onVerticalDragEnd: _handleVerticalDragEnd,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: RetroCameraTheme.displayDecoration,
            child: Row(
              children: [
                const Text(
                  'ISO ',
                  style: TextStyle(
                    color: RetroCameraTheme.primaryText,
                    fontFamily: 'monospace',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    final value = _isoValues[_currentIndex];
                    return Transform.translate(
                      offset:
                          Offset(0, math.sin(_animation.value * math.pi) * 10),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: Text(
                          value.toString(),
                          style: const TextStyle(
                            color: RetroCameraTheme.primaryText,
                            fontFamily: 'monospace',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
