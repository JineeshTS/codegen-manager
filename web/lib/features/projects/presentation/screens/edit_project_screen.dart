import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/error_state.dart';
import '../../domain/entities/project.dart';
import '../providers/project_detail_provider.dart';
import '../widgets/platform_selector.dart';

/// Screen for editing an existing project.
class EditProjectScreen extends ConsumerStatefulWidget {
  final String projectId;

  const EditProjectScreen({
    super.key,
    required this.projectId,
  });

  @override
  ConsumerState<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends ConsumerState<EditProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _githubRepoController = TextEditingController();
  List<String> _selectedPlatforms = [];
  ProjectStatus _selectedStatus = ProjectStatus.draft;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _platformError;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _githubRepoController.dispose();
    super.dispose();
  }

  void _initializeForm(Project project) {
    if (!_isInitialized) {
      _nameController.text = project.name;
      _descriptionController.text = project.description;
      _githubRepoController.text = project.githubRepo;
      _selectedPlatforms = List.from(project.platforms);
      _selectedStatus = project.status;
      _isInitialized = true;
    }
  }

  Future<void> _handleUpdate(Project currentProject) async {
    // Validate platforms
    if (_selectedPlatforms.isEmpty) {
      setState(() => _platformError = 'Please select at least one platform');
      return;
    } else {
      setState(() => _platformError = null);
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final notifier =
        ref.read(projectDetailNotifierProvider(widget.projectId).notifier);

    final result = await notifier.updateProject(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      platforms: _selectedPlatforms,
      githubRepo: _githubRepoController.text.trim(),
      status: _selectedStatus,
    );

    if (!mounted) return;

    result.when(
      success: (project) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Project "${project.name}" updated successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        // Navigate back to project detail
        context.pop();
      },
      failure: (failure) {
        setState(() => _isLoading = false);

        // Show error message
        final message = failure.when(
          server: (msg, code) => msg,
          network: (msg) => msg ?? 'Network error. Please try again.',
          validation: (msg, errors) => msg,
          unauthorized: (msg) => msg ?? 'Unauthorized.',
          notFound: (msg) => msg,
          cache: (msg) => msg,
          forbidden: (msg) => msg ?? 'Access forbidden.',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: AppColors.error,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final projectAsync =
        ref.watch(projectDetailNotifierProvider(widget.projectId));

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(AppIcons.back),
          onPressed: () => context.pop(),
        ),
        title: Text('Edit Project', style: AppTextStyles.headingMedium),
      ),
      body: projectAsync.when(
        data: (project) {
          if (project == null) {
            return ErrorState(
              message: 'Project not found',
              onRetry: () {
                ref
                    .read(
                        projectDetailNotifierProvider(widget.projectId).notifier)
                    .refresh();
              },
            );
          }

          // Initialize form with project data
          _initializeForm(project);

          return _buildForm(project);
        },
        loading: () => const LoadingIndicator(
          message: 'Loading project...',
        ),
        error: (error, stack) => ErrorState(
          message: error.toString(),
          onRetry: () {
            ref
                .read(projectDetailNotifierProvider(widget.projectId).notifier)
                .refresh();
          },
        ),
      ),
    );
  }

  Widget _buildForm(Project project) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.spacing24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Text(
                    'Project Details',
                    style: AppTextStyles.headingLarge,
                  ),
                  const SizedBox(height: AppSpacing.spacing8),
                  Text(
                    'Update the project details below.',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.spacing32),

                  // Project name
                  AppTextField(
                    label: 'Project Name',
                    hint: 'My Awesome App',
                    controller: _nameController,
                    prefixIcon: const Icon(AppIcons.folder),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a project name';
                      }
                      if (value.length > 100) {
                        return 'Name must be 100 characters or less';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.spacing16),

                  // Description
                  AppTextField(
                    label: 'Description',
                    hint: 'Describe what your project does...',
                    controller: _descriptionController,
                    prefixIcon: const Icon(AppIcons.fileText),
                    textInputAction: TextInputAction.next,
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      if (value.length > 500) {
                        return 'Description must be 500 characters or less';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.spacing16),

                  // GitHub repository
                  AppTextField(
                    label: 'GitHub Repository',
                    hint: 'username/repo-name',
                    controller: _githubRepoController,
                    prefixIcon: const Icon(AppIcons.github),
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a GitHub repository';
                      }
                      if (!value.contains('/')) {
                        return 'Format should be: username/repo-name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.spacing24),

                  // Platform selector
                  PlatformSelector(
                    selectedPlatforms: _selectedPlatforms,
                    onChanged: (platforms) {
                      setState(() {
                        _selectedPlatforms = platforms;
                        if (platforms.isNotEmpty) {
                          _platformError = null;
                        }
                      });
                    },
                    errorText: _platformError,
                  ),
                  const SizedBox(height: AppSpacing.spacing24),

                  // Status selector
                  _buildStatusSelector(),
                  const SizedBox(height: AppSpacing.spacing32),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          text: 'Cancel',
                          onPressed: () => context.pop(),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.spacing16),
                      Expanded(
                        child: PrimaryButton(
                          text: 'Save Changes',
                          onPressed: () => _handleUpdate(project),
                          isLoading: _isLoading,
                          icon: AppIcons.save,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Status', style: AppTextStyles.labelLarge),
        const SizedBox(height: AppSpacing.spacing8),
        Wrap(
          spacing: AppSpacing.spacing8,
          runSpacing: AppSpacing.spacing8,
          children: ProjectStatus.values.map((status) {
            final isSelected = _selectedStatus == status;
            return ChoiceChip(
              label: Text(status.displayName),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedStatus = status);
                }
              },
              selectedColor: _getStatusColor(status).withOpacity(0.2),
              labelStyle: AppTextStyles.labelMedium.copyWith(
                color: isSelected
                    ? _getStatusColor(status)
                    : AppColors.textSecondary,
              ),
              side: BorderSide(
                color: isSelected
                    ? _getStatusColor(status)
                    : AppColors.borderLight,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getStatusColor(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.draft:
        return AppColors.textSecondary;
      case ProjectStatus.inProgress:
        return AppColors.warning;
      case ProjectStatus.completed:
        return AppColors.success;
      case ProjectStatus.failed:
        return AppColors.error;
    }
  }
}
