import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';

class DonkeyAnimation extends StatelessWidget {
  final String donkeyName;
  final bool isMe;
  final VoidCallback onExit;

  const DonkeyAnimation({
    super.key,
    required this.donkeyName,
    required this.isMe,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.9),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Top Title Banner
                Text(
                  isMe ? 'YOU LOST!' : 'MATCH OVER',
                  style: AppTextStyles.headlineLarge.copyWith(
                    color: isMe ? AppColors.error : AppColors.gold,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    shadows: [
                      Shadow(
                        color: (isMe ? AppColors.error : AppColors.gold).withValues(alpha: 0.5),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.05, 1.05), duration: 1000.ms),

                const SizedBox(height: 24),

                // Donkey Image Mascot Card
                Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.error.withValues(alpha: 0.3),
                        blurRadius: 32,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'assets/images/neon_donkey_loser.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                )
                    .animate()
                    .scale(begin: const Offset(0.3, 0.3), duration: 600.ms, curve: Curves.elasticOut)
                    .rotate(begin: -0.1, end: 0.0, duration: 600.ms),

                const SizedBox(height: 32),

                // Loser Name Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        isMe ? 'KAZHUTHA! (DONKEY)' : '$donkeyName IS THE DONKEY!',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.titleLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isMe
                            ? 'You ran out of luck and cards. Better luck next time!'
                            : 'All other players successfully exited.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ).animate().fade(delay: 400.ms, duration: 400.ms).slideY(begin: 0.2, end: 0),

                const SizedBox(height: 48),

                // Exit Button
                SizedBox(
                  width: 200,
                  child: AppButton(
                    label: 'Exit to Lobby',
                    onPressed: onExit,
                  ),
                ).animate().fade(delay: 800.ms, duration: 400.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
