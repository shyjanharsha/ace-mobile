import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/domain/auth_state.dart';
import '../providers/profile_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value?.user;

    if (user == null) {
      return const AppScaffold(
        currentTab: AppTab.profile,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final statsAsync = ref.watch(userStatisticsProvider(user.id));

    return AppScaffold(
      currentTab: AppTab.profile,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('My Profile', style: AppTextStyles.titleMedium),
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_rounded, color: Colors.white),
              onPressed: () => context.push('/settings'),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // User profile header card
              _buildProfileHeader(user),
              const SizedBox(height: 24),

              // Player Statistics
              Text(
                'Statistics',
                style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
              ).animate().fade(duration: 300.ms),
              const SizedBox(height: 12),

              statsAsync.when(
                data: (stats) => _buildStatsGrid(stats),
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (err, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Failed to load stats', style: TextStyle(color: AppColors.error)),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Navigation Options
              _buildMenuOption(
                context,
                title: 'Match History',
                subtitle: 'View your past card games',
                icon: Icons.history_rounded,
                color: AppColors.primary,
                onTap: () => context.push('/matches'),
              ).animate().fade(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1, duration: 400.ms, delay: 100.ms),

              const SizedBox(height: 12),

              _buildMenuOption(
                context,
                title: 'Sync Contacts',
                subtitle: 'Find friends playing Kazhutha Kali',
                icon: Icons.contact_phone_rounded,
                color: AppColors.gold,
                onTap: () => context.push('/settings/sync_contacts'),
              ).animate().fade(duration: 450.ms, delay: 150.ms).slideY(begin: 0.1, duration: 450.ms, delay: 150.ms),
              
              const SizedBox(height: 12),

              _buildMenuOption(
                context,
                title: 'Sign Out',
                subtitle: 'Logout from this device',
                icon: Icons.exit_to_app_rounded,
                color: AppColors.error,
                onTap: () => ref.read(authStateProvider.notifier).logout(),
              ).animate().fade(duration: 500.ms, delay: 200.ms).slideY(begin: 0.1, duration: 500.ms, delay: 200.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(dynamic user) {
    final xpNeeded = user.level * 500;
    final xpPercent = (user.xp / xpNeeded).clamp(0.0, 1.0);

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              UserAvatar(
                avatarUrl: user.avatarUrl,
                username: user.username,
                showStatus: false,
                size: 64,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName ?? user.username,
                      style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '@${user.username}',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // XP Progress Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'LVL ${user.level}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${user.xp} / ${xpNeeded} XP',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: xpPercent,
              backgroundColor: Colors.white.withValues(alpha: 0.05),
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 16),
          // Coins and info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.monetization_on, color: AppColors.gold, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      '${user.coins} Coins',
                      style: AppTextStyles.labelLarge.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              if (user.isGuest)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Guest User',
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                  ),
                ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fade(duration: 350.ms)
        .scale(begin: const Offset(0.95, 0.95), duration: 350.ms);
  }

  Widget _buildStatsGrid(Map<String, dynamic> stats) {
    final winRate = stats['win_rate'] ?? 0.0;
    final totalGames = stats['total_games'] ?? 0;
    final wins = stats['wins'] ?? 0;
    final losses = stats['losses'] ?? 0;
    final donkeys = stats['donkey_count'] ?? 0;
    final streak = stats['win_streak'] ?? 0;
    final bestStreak = stats['best_streak'] ?? 0;
    final coinsWon = stats['total_coins_won'] ?? 0;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard('Win Rate', '${winRate}%', Icons.pie_chart_rounded, AppColors.primary),
        _buildStatCard('Games Played', '$totalGames', Icons.style_rounded, AppColors.secondary),
        _buildStatCard('Wins / Losses', '$wins / $losses', Icons.thumbs_up_down_rounded, AppColors.success),
        _buildStatCard('Donkeys 🫏', '$donkeys', Icons.cancel_presentation_rounded, AppColors.error),
        _buildStatCard('Current Streak', '$streak Wins', Icons.local_fire_department_rounded, AppColors.gold),
        _buildStatCard('Best Streak', '$bestStreak Wins', Icons.emoji_events_rounded, Colors.orange),
      ],
    ).animate().fade(duration: 400.ms);
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      borderColor: color.withValues(alpha: 0.15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        borderColor: color.withValues(alpha: 0.1),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }
}
