import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../theme/app_icons.dart';
import 'primary_button.dart';

/// Error state display with optional retry button.
/// Shows error icon, message, and retry action.
class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;
  final String? retryButtonText;

  const ErrorState({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
    this.retryButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.spacing32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? AppIcons.error,
              size: AppIcons.iconXLarge * 2,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSpacing.spacing24),
            Text(
              'Something went wrong',
              style: AppTextStyles.headingMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.spacing8),
            Text(
              message,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.spacing24),
              PrimaryButton(
                text: retryButtonText ?? 'Retry',
                onPressed: onRetry,
                isFullWidth: false,
                icon: AppIcons.refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
