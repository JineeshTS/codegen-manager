import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_icons.dart';

/// Platform badge widget to display platform type (Mobile, Web, Backend, etc.).
class PlatformBadge extends StatelessWidget {
  final String platform;
  final bool isSmall;

  const PlatformBadge({
    super.key,
    required this.platform,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final platformInfo = _getPlatformInfo(platform);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? AppSpacing.spacing6 : AppSpacing.spacing8,
        vertical: isSmall ? AppSpacing.spacing2 : AppSpacing.spacing4,
      ),
      decoration: BoxDecoration(
        color: platformInfo.backgroundColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: platformInfo.borderColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            platformInfo.icon,
            size: isSmall ? 12 : 14,
            color: platformInfo.color,
          ),
          SizedBox(width: isSmall ? 4 : AppSpacing.spacing4),
          Text(
            platformInfo.label,
            style: (isSmall
                    ? AppTextStyles.micro
                    : AppTextStyles.bodySmall)
                .copyWith(
              color: platformInfo.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  _PlatformInfo _getPlatformInfo(String platform) {
    switch (platform.toLowerCase()) {
      case 'mobile':
      case 'flutter':
      case 'android':
      case 'ios':
        return _PlatformInfo(
          label: 'Mobile',
          icon: Icons.smartphone,
          color: AppColors.primary,
          backgroundColor: AppColors.infoLight,
          borderColor: AppColors.primary.withOpacity(0.3),
        );

      case 'web':
      case 'webapp':
        return _PlatformInfo(
          label: 'Web',
          icon: Icons.language,
          color: AppColors.secondary,
          backgroundColor: AppColors.secondaryLight.withOpacity(0.2),
          borderColor: AppColors.secondary.withOpacity(0.3),
        );

      case 'backend':
      case 'api':
      case 'server':
        return _PlatformInfo(
          label: 'Backend',
          icon: AppIcons.cpu,
          color: AppColors.success,
          backgroundColor: AppColors.successLight,
          borderColor: AppColors.success.withOpacity(0.3),
        );

      case 'desktop':
      case 'macos':
      case 'windows':
      case 'linux':
        return _PlatformInfo(
          label: 'Desktop',
          icon: Icons.computer,
          color: AppColors.warning,
          backgroundColor: AppColors.warningLight,
          borderColor: AppColors.warning.withOpacity(0.3),
        );

      default:
        return _PlatformInfo(
          label: platform,
          icon: AppIcons.code,
          color: AppColors.textSecondary,
          backgroundColor: AppColors.backgroundTertiary,
          borderColor: AppColors.borderLight,
        );
    }
  }
}

class _PlatformInfo {
  final String label;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final Color borderColor;

  _PlatformInfo({
    required this.label,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.borderColor,
  });
}

// Add spacing6 to AppSpacing for consistency
extension AppSpacingExtension on double {
  static const double spacing6 = 6.0;
}
