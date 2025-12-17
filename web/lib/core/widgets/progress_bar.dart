import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Horizontal progress bar widget following the design system.
class ProgressBar extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final double height;
  final Color? color;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const ProgressBar({
    super.key,
    required this.value,
    this.height = 6,
    this.color,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        minHeight: height,
        backgroundColor:
            backgroundColor ?? AppColors.backgroundTertiary,
        valueColor: AlwaysStoppedAnimation(
          color ?? AppColors.primary,
        ),
      ),
    );
  }
}
