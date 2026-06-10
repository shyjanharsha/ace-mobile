import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/auth_provider.dart';
import '../../domain/auth_state.dart';

/// Splash screen — shows logo, then checks auto-login
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    // Minimum 2s splash for branding
    await Future.delayed(const Duration(milliseconds: 2200));

    if (!mounted) return;

    final authState = ref.read(authStateProvider);
    authState.when(
      data: (state) {
        if (state.isAuthenticated) {
          context.go(RouteNames.home);
        } else {
          context.go(RouteNames.login);
        }
      },
      loading: () {
        // Still loading — wait for auth to resolve
        ref.listenManual(authStateProvider, (_, next) {
          if (!mounted) return;
          next.whenData((state) {
            if (state.isAuthenticated) {
              context.go(RouteNames.home);
            } else {
              context.go(RouteNames.login);
            }
          });
        });
      },
      error: (_, __) => context.go(RouteNames.login),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // -------------------------------------------------------
              // Donkey logo / card icon
              // -------------------------------------------------------
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 40,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.style_rounded, // card icon
                  size: 60,
                  color: Colors.white,
                ),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                  )
                  .fade(duration: 400.ms),

              const SizedBox(height: 32),

              // -------------------------------------------------------
              // Game title
              // -------------------------------------------------------
              Text(
                'Kazhutha Kali',
                style: AppTextStyles.displayMedium.copyWith(
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                    ).createShader(
                      const Rect.fromLTWH(0, 0, 280, 60),
                    ),
                ),
              )
                  .animate()
                  .slideY(
                    begin: 0.3,
                    duration: 600.ms,
                    delay: 200.ms,
                    curve: Curves.easeOutCubic,
                  )
                  .fade(duration: 400.ms, delay: 200.ms),

              const SizedBox(height: 8),

              Text(
                'Donkey Card Game',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 2,
                ),
              )
                  .animate()
                  .fade(duration: 400.ms, delay: 400.ms),

              const SizedBox(height: 64),

              // -------------------------------------------------------
              // Loading indicator
              // -------------------------------------------------------
              SizedBox(
                width: 40,
                height: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: const LinearProgressIndicator(
                    backgroundColor: AppColors.glass,
                    valueColor: AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
              )
                  .animate()
                  .fade(duration: 400.ms, delay: 600.ms),
            ],
          ),
        ),
      ),
    );
  }
}
