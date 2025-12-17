import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_state.dart';
import '../providers/projects_provider.dart';
import '../widgets/project_card.dart';

/// Dashboard screen showing list of user's projects.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPrimary,
        elevation: 0,
        title: Text('My Projects', style: AppTextStyles.headingLarge),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.refresh),
            onPressed: () {
              ref.read(projectsNotifierProvider.notifier).refresh();
            },
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(AppIcons.settings),
            onPressed: () {
              // Navigate to settings
            },
            tooltip: 'Settings',
          ),
          const SizedBox(width: AppSpacing.spacing8),
        ],
      ),
      body: projectsAsync.when(
        data: (projects) {
          if (projects.isEmpty) {
            return EmptyState(
              icon: AppIcons.folder,
              title: 'No Projects Yet',
              message:
                  'Create your first project to start generating code with AI',
              action: ElevatedButton.icon(
                onPressed: () => context.push('/projects/create'),
                icon: const Icon(AppIcons.add),
                label: const Text('Create Project'),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(projectsNotifierProvider.notifier).refresh();
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.spacing16),
              itemCount: projects.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.spacing16),
              itemBuilder: (context, index) {
                final project = projects[index];
                return ProjectCard(
                  project: project,
                  onTap: () => context.push('/projects/${project.id}'),
                );
              },
            ),
          );
        },
        loading: () => const LoadingIndicator(
          message: 'Loading projects...',
        ),
        error: (error, stack) => ErrorState(
          message: error.toString(),
          onRetry: () {
            ref.read(projectsNotifierProvider.notifier).refresh();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/projects/create'),
        icon: const Icon(AppIcons.add),
        label: const Text('New Project'),
      ),
    );
  }
}
