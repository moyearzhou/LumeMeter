import 'package:flutter/material.dart';
import '../bean/measure_mode.dart';
import '../theme/retro_camera_theme.dart';

class ModeToggleButton extends StatelessWidget {
  final MeasureMode exposureMode;
  final VoidCallback onToggle;

  const ModeToggleButton({
    super.key,
    required this.exposureMode,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: RetroCameraTheme.metallicDecoration,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              exposureMode == MeasureMode.aperturePriority ? 'F.AUTO' : 'S.AUTO',
              key: ValueKey<MeasureMode>(exposureMode),
              style: const TextStyle(
                color: RetroCameraTheme.accentColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}