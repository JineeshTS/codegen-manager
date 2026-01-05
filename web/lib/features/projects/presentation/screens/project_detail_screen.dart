import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/progress_bar.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../../../core/widgets/delete_confirmation_dialog.dart';
import '../../domain/entities/project.dart';
import '../providers/project_detail_provider.dart';
import '../providers/projects_provider.dart';
import '../widgets/platform_badge.dart';
import '../widgets/github_connect_dialog.dart';

/// Screen showing detailed view of a single project.
class ProjectDetailScreen extends ConsumerWidget {
  final String projectId;

  const ProjectDetailScreen({
    super.key,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectAsync = ref.watch(projectDetailNotifierProvider(projectId));

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: projectAsync.when(
        data: (project) {
          if (project == null) {
            return ErrorState(
              message: 'Project not found',
              onRetry: () {
                ref
                    .read(projectDetailNotifierProvider(projectId).notifier)
                    .refresh();
              },
            );
          }
          return _ProjectDetailContent(project: project);
        },
        loading: () => const LoadingIndicator(
          message: 'Loading project...',
        ),
        error: (error, stack) => ErrorState(
          message: error.toString(),
          onRetry: () {
            ref
                .read(projectDetailNotifierProvider(projectId).notifier)
                .refresh();
          },
        ),
      ),
    );
  }
}

class _ProjectDetailContent extends ConsumerWidget {
  final Project project;

  const _ProjectDetailContent({required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          backgroundColor: AppColors.backgroundPrimary,
          elevation: 0,
          pinned: true,
          leading: IconButton(
            icon: const Icon(AppIcons.back),
            onPressed: () => context.pop(),
          ),
          title: Text(project.name, style: AppTextStyles.headingMedium),
          actions: [
            IconButton(
              icon: const Icon(AppIcons.refresh),
              onPressed: () {
                ref
                    .read(projectDetailNotifierProvider(project.id).notifier)
                    .refresh();
              },
              tooltip: 'Refresh',
            ),
            PopupMenuButton<String>(
              icon: const Icon(AppIcons.moreVertical),
              onSelected: (value) =>
                  _handleMenuAction(context, ref, value),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(AppIcons.edit, size: 20),
                      SizedBox(width: AppSpacing.spacing8),
                      Text('Edit Project'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'github',
                  child: Row(
                    children: [
                      Icon(AppIcons.github, size: 20),
                      SizedBox(width: AppSpacing.spacing8),
                      Text('GitHub Settings'),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(AppIcons.delete, size: 20, color: AppColors.error),
                      const SizedBox(width: AppSpacing.spacing8),
                      Text('Delete Project',
                          style: TextStyle(color: AppColors.error)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.spacing8),
          ],
        ),

        // Content
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.spacing24),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Status and Platforms Row
              _buildStatusSection(),
              const SizedBox(height: AppSpacing.spacing24),

              // Progress Section
              _buildProgressSection(),
              const SizedBox(height: AppSpacing.spacing24),

              // Description Section
              _buildDescriptionSection(),
              const SizedBox(height: AppSpacing.spacing24),

              // GitHub Section
              _buildGitHubSection(context, ref),
              const SizedBox(height: AppSpacing.spacing24),

              // Quick Actions
              _buildActionsSection(context, ref),
              const SizedBox(height: AppSpacing.spacing32),

              // Project Info
              _buildInfoSection(),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusSection() {
    return Row(
      children: [
        _StatusBadge(status: project.status),
        const SizedBox(width: AppSpacing.spacing12),
        Expanded(
          child: Wrap(
            spacing: AppSpacing.spacing8,
            runSpacing: AppSpacing.spacing8,
            children: project.platforms
                .map((platform) => PlatformBadge(platform: platform))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    final progress = project.progressPercentage;
    final completedTasks = project.completedTasks ?? 0;
    final totalTasks = project.totalTasks ?? 0;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Progress', style: AppTextStyles.labelLarge),
              Text(
                '${progress.toStringAsFixed(0)}%',
                style: AppTextStyles.headingMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacing12),
          ProgressBar(
            value: progress / 100,
            height: 8,
          ),
          const SizedBox(height: AppSpacing.spacing8),
          Text(
            '$completedTasks of $totalTasks tasks completed',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Description', style: AppTextStyles.labelLarge),
          const SizedBox(height: AppSpacing.spacing8),
          Text(
            project.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGitHubSection(BuildContext context, WidgetRef ref) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(AppIcons.github, size: 20, color: AppColors.textPrimary),
              const SizedBox(width: AppSpacing.spacing8),
              Text('GitHub Repository', style: AppTextStyles.labelLarge),
            ],
          ),
          const SizedBox(height: AppSpacing.spacing12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.githubRepo,
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.spacing4),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: project.githubConnected
                                ? AppColors.success
                                : AppColors.warning,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.spacing6),
                        Text(
                          project.githubConnected ? 'Connected' : 'Not connected',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: project.githubConnected
                                ? AppColors.success
                                : AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!project.githubConnected)
                SecondaryButton(
                  text: 'Connect',
                  onPressed: () => _showGitHubConnectDialog(context, ref),
                  isFullWidth: false,
                  icon: AppIcons.github,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Actions', style: AppTextStyles.labelLarge),
        const SizedBox(height: AppSpacing.spacing12),
        Row(
          children: [
            Expanded(
              child: PrimaryButton(
                text: 'Generate Code',
                onPressed: project.githubConnected
                    ? () => _handleGenerateCode(context, ref)
                    : null,
                icon: AppIcons.code,
              ),
            ),
            const SizedBox(width: AppSpacing.spacing12),
            Expanded(
              child: SecondaryButton(
                text: 'Edit Project',
                onPressed: () => context.push('/projects/${project.id}/edit'),
                icon: AppIcons.edit,
              ),
            ),
          ],
        ),
        if (!project.githubConnected) ...[
          const SizedBox(height: AppSpacing.spacing8),
          Text(
            'Connect GitHub to enable code generation',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.warning,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoSection() {
    return AppCard(
      color: AppColors.backgroundTertiary,
      withShadow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Project Information', style: AppTextStyles.labelLarge),
          const SizedBox(height: AppSpacing.spacing16),
          _InfoRow(label: 'Project ID', value: project.id),
          const SizedBox(height: AppSpacing.spacing8),
          _InfoRow(
            label: 'Created',
            value: _formatDate(project.createdAt),
          ),
          if (project.updatedAt != null) ...[
            const SizedBox(height: AppSpacing.spacing8),
            _InfoRow(
              label: 'Last Updated',
              value: _formatDate(project.updatedAt!),
            ),
          ],
          if (project.templateId != null) ...[
            const SizedBox(height: AppSpacing.spacing8),
            _InfoRow(label: 'Template ID', value: project.templateId!),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _handleMenuAction(
      BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'edit':
        context.push('/projects/${project.id}/edit');
        break;
      case 'github':
        _showGitHubConnectDialog(context, ref);
        break;
      case 'delete':
        _showDeleteConfirmation(context, ref);
        break;
    }
  }

  void _showGitHubConnectDialog(BuildContext context, WidgetRef ref) {
    GitHubConnectDialog.show(
      context,
      onConnect: (accessToken) async {
        final notifier =
            ref.read(projectDetailNotifierProvider(project.id).notifier);
        final result = await notifier.connectGitHub(accessToken);

        if (context.mounted) {
          result.when(
            success: (_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('GitHub connected successfully!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            failure: (failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to connect: ${failure.toString()}'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
          );
        }
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    DeleteConfirmationDialog.show(
      context,
      title: 'Delete Project',
      message:
          'Are you sure you want to delete "${project.name}"? This action cannot be undone.',
      onConfirm: () async {
        final result =
            await ref.read(projectsNotifierProvider.notifier).deleteProject(project.id);

        if (context.mounted) {
          result.when(
            success: (_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Project deleted successfully'),
                  backgroundColor: AppColors.success,
                ),
              );
              context.go('/projects');
            },
            failure: (failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to delete: ${failure.toString()}'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
          );
        }
      },
    );
  }

  void _handleGenerateCode(BuildContext context, WidgetRef ref) {
    // TODO: Implement code generation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Code generation started...'),
        backgroundColor: AppColors.info,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ProjectStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacing12,
        vertical: AppSpacing.spacing6,
      ),
      decoration: BoxDecoration(
        color: statusInfo.backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
        border: Border.all(color: statusInfo.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusInfo.icon, size: 16, color: statusInfo.color),
          const SizedBox(width: AppSpacing.spacing6),
          Text(
            status.displayName,
            style: AppTextStyles.labelMedium.copyWith(
              color: statusInfo.color,
            ),
          ),
        ],
      ),
    );
  }

  _StatusInfo _getStatusInfo(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.draft:
        return _StatusInfo(
          icon: AppIcons.edit,
          color: AppColors.textSecondary,
          backgroundColor: AppColors.backgroundTertiary,
          borderColor: AppColors.borderLight,
        );
      case ProjectStatus.inProgress:
        return _StatusInfo(
          icon: AppIcons.loader,
          color: AppColors.warning,
          backgroundColor: AppColors.warningLight,
          borderColor: AppColors.warning.withOpacity(0.3),
        );
      case ProjectStatus.completed:
        return _StatusInfo(
          icon: AppIcons.checkCircle,
          color: AppColors.success,
          backgroundColor: AppColors.successLight,
          borderColor: AppColors.success.withOpacity(0.3),
        );
      case ProjectStatus.failed:
        return _StatusInfo(
          icon: AppIcons.warning,
          color: AppColors.error,
          backgroundColor: AppColors.errorLight,
          borderColor: AppColors.error.withOpacity(0.3),
        );
    }
  }
}

class _StatusInfo {
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final Color borderColor;

  _StatusInfo({
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.borderColor,
  });
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
