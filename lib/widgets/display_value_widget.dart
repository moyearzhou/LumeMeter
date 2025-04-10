import 'package:flutter/material.dart';
import '../theme/retro_camera_theme.dart';

class DisplayValueWidget extends StatelessWidget {
  final String label;
  final double value;
  final int fractionDigits;

  const DisplayValueWidget({
    super.key,
    required this.label,
    required this.value,
    this.fractionDigits = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: RetroCameraTheme.displayDecoration,
      child: Text(
        '$label ${value.toStringAsFixed(fractionDigits)}',
        style: const TextStyle(
          color: RetroCameraTheme.primaryText,
          fontFamily: 'monospace',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}