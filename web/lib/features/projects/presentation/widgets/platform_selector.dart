import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_radius.dart';

/// Multi-select platform picker widget.
class PlatformSelector extends StatelessWidget {
  final List<String> selectedPlatforms;
  final ValueChanged<List<String>> onChanged;
  final String? errorText;

  static const List<String> availablePlatforms = [
    'mobile',
    'web',
    'backend',
    'desktop',
  ];

  const PlatformSelector({
    super.key,
    required this.selectedPlatforms,
    required this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Platforms', style: AppTextStyles.inputLabel),
        const SizedBox(height: AppSpacing.spacing8),
        Wrap(
          spacing: AppSpacing.spacing8,
          runSpacing: AppSpacing.spacing8,
          children: availablePlatforms.map((platform) {
            final isSelected = selectedPlatforms.contains(platform);
            return _buildPlatformChip(
              platform,
              isSelected,
              () {
                final newSelection = List<String>.from(selectedPlatforms);
                if (isSelected) {
                  newSelection.remove(platform);
                } else {
                  newSelection.add(platform);
                }
                onChanged(newSelection);
              },
            );
          }).toList(),
        ),
        if (errorText != null) ...[
          const SizedBox(height: AppSpacing.spacing8),
          Text(
            errorText!,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.error,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPlatformChip(
    String platform,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing16,
          vertical: AppSpacing.spacing12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.backgroundSecondary,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              size: 20,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.spacing8),
            Text(
              _capitalize(platform),
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
