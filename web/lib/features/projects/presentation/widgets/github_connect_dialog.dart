import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';

/// Dialog to connect GitHub repository with access token.
class GitHubConnectDialog extends StatefulWidget {
  final Future<void> Function(String accessToken) onConnect;

  const GitHubConnectDialog({
    super.key,
    required this.onConnect,
  });

  static Future<void> show(
    BuildContext context, {
    required Future<void> Function(String accessToken) onConnect,
  }) {
    return showDialog(
      context: context,
      builder: (context) => GitHubConnectDialog(onConnect: onConnect),
    );
  }

  @override
  State<GitHubConnectDialog> createState() => _GitHubConnectDialogState();
}

class _GitHubConnectDialogState extends State<GitHubConnectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  bool _isLoading = false;
  bool _obscureToken = true;

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _handleConnect() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await widget.onConnect(_tokenController.text.trim());
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusLarge),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(AppSpacing.spacing24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    AppIcons.github,
                    color: AppColors.primary,
                    size: 28,
                  ),
                  const SizedBox(width: AppSpacing.spacing12),
                  Expanded(
                    child: Text(
                      'Connect GitHub Repository',
                      style: AppTextStyles.headingMedium,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(AppIcons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.spacing16),

              // Description
              Text(
                'Enter your GitHub personal access token to connect this project to your repository. '
                'This will allow the system to commit generated code directly to your repo.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.spacing24),

              // Token field
              AppTextField(
                label: 'GitHub Personal Access Token',
                hint: 'ghp_xxxxxxxxxxxx',
                controller: _tokenController,
                obscureText: _obscureToken,
                prefixIcon: const Icon(AppIcons.password),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureToken ? AppIcons.eyeClosed : AppIcons.eyeOpen,
                  ),
                  onPressed: () {
                    setState(() => _obscureToken = !_obscureToken);
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your access token';
                  }
                  if (!value.startsWith('ghp_') && !value.startsWith('github_pat_')) {
                    return 'Invalid token format';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.spacing16),

              // Info message
              Container(
                padding: const EdgeInsets.all(AppSpacing.spacing12),
                decoration: BoxDecoration(
                  color: AppColors.infoLight,
                  borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      AppIcons.info,
                      color: AppColors.info,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.spacing8),
                    Expanded(
                      child: Text(
                        'Need a token? Go to GitHub Settings > Developer settings > Personal access tokens',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.info,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.spacing24),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SecondaryButton(
                    text: 'Cancel',
                    onPressed: () => Navigator.of(context).pop(),
                    isFullWidth: false,
                  ),
                  const SizedBox(width: AppSpacing.spacing12),
                  PrimaryButton(
                    text: 'Connect',
                    onPressed: _handleConnect,
                    isLoading: _isLoading,
                    isFullWidth: false,
                    icon: AppIcons.github,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
