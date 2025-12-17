import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';

/// Card container following the design system.
/// Use for grouping related content.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final Color? color;
  final bool withShadow;
  final BorderRadius? borderRadius;
  final Border? border;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
    this.withShadow = true,
    this.borderRadius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.spacing16),
      decoration: BoxDecoration(
        color: color ?? AppColors.backgroundSecondary,
        borderRadius: borderRadius ??
            BorderRadius.circular(AppRadius.radiusLarge),
        boxShadow: withShadow ? AppShadows.shadowSmall : null,
        border: border,
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: borderRadius ??
            BorderRadius.circular(AppRadius.radiusLarge),
        child: content,
      );
    }

    return content;
  }
}
