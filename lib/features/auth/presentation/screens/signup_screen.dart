import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey        = GlobalKey<FormState>();
  final _usernameCtrl   = TextEditingController();
  final _phoneCtrl      = TextEditingController();
  final _passwordCtrl   = TextEditingController();
  final _confirmCtrl    = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading       = false;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    await ref.read(authStateProvider.notifier).signup(
          username: _usernameCtrl.text.trim(),
          password: _passwordCtrl.text,
          phone:    _phoneCtrl.text.trim().isNotEmpty ? _phoneCtrl.text.trim() : null,
        );

    setState(() => _isLoading = false);
    if (!mounted) return;
    final authState = ref.read(authStateProvider);
    authState.whenOrNull(
      error: (e, _) => _showError(e.toString()),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // -------------------------------------------------------
                // Back button + title
                // -------------------------------------------------------
                Row(children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppColors.textSecondary),
                    onPressed: () => context.pop(),
                  ),
                ]),

                const SizedBox(height: 8),

                Text('Create Account', style: AppTextStyles.headlineLarge)
                    .animate()
                    .slideX(begin: -0.2, duration: 400.ms)
                    .fade(),

                const SizedBox(height: 4),

                Text(
                  'Join the Kazhutha Kali table',
                  style: AppTextStyles.bodyMedium,
                ).animate().fade(delay: 100.ms),

                const SizedBox(height: 32),

                // -------------------------------------------------------
                // Signup form
                // -------------------------------------------------------
                GlassCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppTextField(
                          controller: _usernameCtrl,
                          label: 'Username',
                          hint: 'e.g. donkey_king',
                          prefixIcon: const Icon(Icons.alternate_email_rounded,
                              color: AppColors.textSecondary),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Username required';
                            if (v.length < 3) return 'At least 3 characters';
                            if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(v)) {
                              return 'Letters, numbers, underscores only';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 14),

                        AppTextField(
                          controller: _phoneCtrl,
                          label: 'Phone Number (optional)',
                          hint: '+91 98765 43210',
                          prefixIcon: const Icon(Icons.phone_outlined,
                              color: AppColors.textSecondary),
                          keyboardType: TextInputType.phone,
                        ),

                        const SizedBox(height: 14),

                        AppTextField(
                          controller: _passwordCtrl,
                          label: 'Password',
                          hint: '••••••••',
                          obscureText: _obscurePassword,
                          prefixIcon: const Icon(Icons.lock_outline_rounded,
                              color: AppColors.textSecondary),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () =>
                                setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Password required';
                            if (v.length < 6) return 'At least 6 characters';
                            return null;
                          },
                        ),

                        const SizedBox(height: 14),

                        AppTextField(
                          controller: _confirmCtrl,
                          label: 'Confirm Password',
                          hint: '••••••••',
                          obscureText: _obscurePassword,
                          prefixIcon: const Icon(Icons.lock_outline_rounded,
                              color: AppColors.textSecondary),
                          validator: (v) {
                            if (v != _passwordCtrl.text) return 'Passwords do not match';
                            return null;
                          },
                        ),

                        const SizedBox(height: 24),

                        AppButton(
                          label: 'Create Account',
                          onPressed: _isLoading ? null : _signup,
                          isLoading: _isLoading,
                          icon: Icons.person_add_alt_1_rounded,
                        ),
                      ],
                    ),
                  ),
                ).animate().slideY(begin: 0.2, duration: 500.ms, delay: 200.ms).fade(delay: 200.ms),

                const SizedBox(height: 20),

                // -------------------------------------------------------
                // Sign in redirect
                // -------------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? ', style: AppTextStyles.bodyMedium),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: Text('Sign In',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.primary,
                          )),
                    ),
                  ],
                ).animate().fade(delay: 400.ms),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
