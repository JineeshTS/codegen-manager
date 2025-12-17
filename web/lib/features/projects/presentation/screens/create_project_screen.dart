import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/projects_provider.dart';
import '../widgets/platform_selector.dart';

/// Screen for creating a new project.
class CreateProjectScreen extends ConsumerStatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  ConsumerState<CreateProjectScreen> createState() =>
      _CreateProjectScreenState();
}

class _CreateProjectScreenState extends ConsumerState<CreateProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _githubRepoController = TextEditingController();
  List<String> _selectedPlatforms = [];
  bool _isLoading = false;
  String? _platformError;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _githubRepoController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
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

    final result = await ref.read(projectsNotifierProvider.notifier).createProject(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          platforms: _selectedPlatforms,
          githubRepo: _githubRepoController.text.trim(),
        );

    if (!mounted) return;

    result.when(
      success: (project) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Project "${project.name}" created successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        // Navigate to project detail
        context.go('/projects/${project.id}');
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
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(AppIcons.back),
          onPressed: () => context.pop(),
        ),
        title: Text('Create New Project', style: AppTextStyles.headingMedium),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.spacing24),
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
                    'Fill in the details below to create a new code generation project.',
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
                  const SizedBox(height: AppSpacing.spacing32),

                  // Create button
                  PrimaryButton(
                    text: 'Create Project',
                    onPressed: _handleCreate,
                    isLoading: _isLoading,
                    icon: AppIcons.add,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
