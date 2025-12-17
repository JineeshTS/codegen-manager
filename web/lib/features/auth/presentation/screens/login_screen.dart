import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/app_text_button.dart';
import '../providers/auth_provider.dart';

/// Login screen with email and password form.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await ref.read(authNotifierProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (!mounted) return;

    result.when(
      success: (_) {
        // Navigation will be handled by the router redirect
        context.go('/');
      },
      failure: (failure) {
        setState(() {
          _isLoading = false;
          _errorMessage = failure.when(
            server: (message, statusCode) => message,
            network: (message) => message ?? 'Network error. Please try again.',
            validation: (message, errors) => message,
            unauthorized: (message) =>
                message ?? 'Invalid email or password.',
            notFound: (message) => message,
            cache: (message) => message,
            forbidden: (message) => message ?? 'Access forbidden.',
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.spacing24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo or Icon
                    const Icon(
                      AppIcons.code,
                      size: 64,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: AppSpacing.spacing24),

                    // Title
                    Text(
                      'Welcome Back',
                      style: AppTextStyles.displayMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.spacing8),
                    Text(
                      'Sign in to continue to CodeGen Manager',
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.spacing32),

                    // Error message
                    if (_errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.spacing12),
                        decoration: BoxDecoration(
                          color: AppColors.errorLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              AppIcons.error,
                              color: AppColors.error,
                              size: 20,
                            ),
                            const SizedBox(width: AppSpacing.spacing8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.spacing16),
                    ],

                    // Email field
                    AppTextField(
                      label: 'Email',
                      hint: 'Enter your email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(AppIcons.email),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.spacing16),

                    // Password field
                    AppTextField(
                      label: 'Password',
                      hint: 'Enter your password',
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      prefixIcon: const Icon(AppIcons.password),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? AppIcons.eyeClosed
                              : AppIcons.eyeOpen,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      onSubmitted: (_) => _handleLogin(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.spacing24),

                    // Login button
                    PrimaryButton(
                      text: 'Sign In',
                      onPressed: _handleLogin,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: AppSpacing.spacing16),

                    // Register link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: AppTextStyles.bodyMedium,
                        ),
                        AppTextButton(
                          text: 'Sign Up',
                          onPressed: () => context.go('/register'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
