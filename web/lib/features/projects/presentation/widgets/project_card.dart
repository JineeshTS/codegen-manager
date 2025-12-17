import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/project.dart';
import 'platform_badge.dart';

/// Project card widget for displaying in project list.
class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback? onTap;

  const ProjectCard({
    super.key,
    required this.project,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with name and status
          Row(
            children: [
              Expanded(
                child: Text(
                  project.name,
                  style: AppTextStyles.headingMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.spacing8),
              _buildStatusChip(project.status),
            ],
          ),
          const SizedBox(height: AppSpacing.spacing8),

          // Description
          Text(
            project.description,
            style: AppTextStyles.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.spacing16),

          // Platforms
          if (project.platforms.isNotEmpty) ...[
            Wrap(
              spacing: AppSpacing.spacing8,
              runSpacing: AppSpacing.spacing8,
              children: project.platforms
                  .map((platform) => PlatformBadge(platform: platform))
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.spacing16),
          ],

          // Progress bar (if has tasks)
          if (project.hasTasks) ...[
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: project.progressPercentage / 100,
                      minHeight: 6,
                      backgroundColor: AppColors.backgroundTertiary,
                      valueColor: const AlwaysStoppedAnimation(
                        AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.spacing12),
                Text(
                  '${project.completedTasks}/${project.totalTasks}',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.spacing12),
          ],

          // Footer row with GitHub and date
          Row(
            children: [
              // GitHub indicator
              Icon(
                project.githubConnected
                    ? AppIcons.gitBranch
                    : AppIcons.github,
                size: 16,
                color: project.githubConnected
                    ? AppColors.success
                    : AppColors.textTertiary,
              ),
              const SizedBox(width: AppSpacing.spacing4),
              Expanded(
                child: Text(
                  project.githubRepo,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: project.githubConnected
                        ? AppColors.success
                        : AppColors.textTertiary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.spacing8),
              Text(
                _formatDate(project.createdAt),
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(ProjectStatus status) {
    Color color;
    Color backgroundColor;

    switch (status) {
      case ProjectStatus.draft:
        color = AppColors.textSecondary;
        backgroundColor = AppColors.backgroundTertiary;
        break;
      case ProjectStatus.inProgress:
        color = AppColors.info;
        backgroundColor = AppColors.infoLight;
        break;
      case ProjectStatus.completed:
        color = AppColors.success;
        backgroundColor = AppColors.successLight;
        break;
      case ProjectStatus.failed:
        color = AppColors.error;
        backgroundColor = AppColors.errorLight;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacing8,
        vertical: AppSpacing.spacing4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.displayName,
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else {
      return '${(difference.inDays / 365).floor()}y ago';
    }
  }
}
