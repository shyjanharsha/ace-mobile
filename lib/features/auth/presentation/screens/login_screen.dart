import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey        = GlobalKey<FormState>();
  final _identifierCtrl = TextEditingController();
  final _passwordCtrl   = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading       = false;

  @override
  void dispose() {
    _identifierCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    await ref.read(authStateProvider.notifier).login(
          identifier: _identifierCtrl.text.trim(),
          password:   _passwordCtrl.text,
          platform:   Theme.of(context).platform.name,
        );

    setState(() => _isLoading = false);

    if (!mounted) return;
    final authState = ref.read(authStateProvider);
    authState.whenOrNull(
      error: (e, _) => _showError(e.toString()),
    );
  }

  Future<void> _guestLogin() async {
    setState(() => _isLoading = true);
    await ref.read(authStateProvider.notifier).guestLogin();
    setState(() => _isLoading = false);
    if (!mounted) return;
    final authState = ref.read(authStateProvider);
    authState.whenOrNull(error: (e, _) => _showError(e.toString()));
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
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              height: size.height - MediaQuery.of(context).padding.top,
              child: Column(
                children: [
                  const SizedBox(height: 60),

                  // -------------------------------------------------------
                  // Logo + title
                  // -------------------------------------------------------
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.style_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  )
                      .animate()
                      .scale(duration: 500.ms, curve: Curves.elasticOut)
                      .fade(),

                  const SizedBox(height: 20),

                  Text('Welcome Back', style: AppTextStyles.headlineLarge)
                      .animate()
                      .slideY(begin: 0.2, duration: 400.ms, delay: 100.ms)
                      .fade(),

                  const SizedBox(height: 4),

                  Text(
                    'Sign in to play Kazhutha Kali',
                    style: AppTextStyles.bodyMedium,
                  ).animate().fade(delay: 200.ms),

                  const SizedBox(height: 40),

                  // -------------------------------------------------------
                  // Login form
                  // -------------------------------------------------------
                  GlassCard(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppTextField(
                            controller: _identifierCtrl,
                            label: 'Phone, Email or Username',
                            hint: 'Enter your credentials',
                            prefixIcon: const Icon(Icons.person_outline_rounded,
                                color: AppColors.textSecondary),
                            validator: (v) => v?.isEmpty == true
                                ? 'Please enter your phone, email or username'
                                : null,
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 16),

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
                            validator: (v) =>
                                v?.isEmpty == true ? 'Please enter your password' : null,
                          ),

                          const SizedBox(height: 24),

                          AppButton(
                            label: 'Sign In',
                            onPressed: _isLoading ? null : _login,
                            isLoading: _isLoading,
                            icon: Icons.login_rounded,
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate()
                      .slideY(begin: 0.2, duration: 500.ms, delay: 200.ms, curve: Curves.easeOutCubic)
                      .fade(delay: 200.ms),

                  const SizedBox(height: 20),

                  // -------------------------------------------------------
                  // Divider
                  // -------------------------------------------------------
                  Row(children: [
                    const Expanded(child: Divider(color: AppColors.divider)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('or', style: AppTextStyles.bodySmall),
                    ),
                    const Expanded(child: Divider(color: AppColors.divider)),
                  ]),

                  const SizedBox(height: 20),

                  // -------------------------------------------------------
                  // Guest login
                  // -------------------------------------------------------
                  AppButton(
                    label: 'Play as Guest',
                    onPressed: _isLoading ? null : _guestLogin,
                    isLoading: _isLoading,
                    variant: AppButtonVariant.outlined,
                    icon: Icons.person_rounded,
                  ).animate().fade(delay: 400.ms),

                  const Spacer(),

                  // -------------------------------------------------------
                  // Sign up redirect
                  // -------------------------------------------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ", style: AppTextStyles.bodyMedium),
                      TextButton(
                        onPressed: () => context.push(RouteNames.signup),
                        child: Text(
                          'Sign Up',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fade(delay: 500.ms),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
