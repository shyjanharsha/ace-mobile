import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:donkey_card_game/features/auth/domain/auth_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../widgets/create_room_dialog.dart';
import '../widgets/friend_presence_list.dart';
import '../widgets/join_room_dialog.dart';
import '../widgets/public_rooms_list.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _showCreateRoomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateRoomDialog(),
    );
  }

  void _showJoinRoomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const JoinRoomDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value?.user;

    // Use a responsive layout based on screen width
    final width = MediaQuery.sizeOf(context).width;
    final isTablet = width > 768;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                // -------------------------------------------------------
                // Header: Profile, Coins, Level, Logout
                // -------------------------------------------------------
                _buildHeader(context, ref, user)
                    .animate()
                    .fade(duration: 400.ms)
                    .slideY(begin: -0.1, duration: 400.ms),

                const SizedBox(height: 24),

                // -------------------------------------------------------
                // Main Content Area (Responsive)
                // -------------------------------------------------------
                Expanded(
                  child: isTablet
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left section: Actions and Public Rooms
                            Expanded(
                              flex: 3,
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  children: [
                                    _buildQuickActions(context),
                                    const SizedBox(height: 24),
                                    const PublicRoomsList(),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            // Right section: Friends Presence
                            const Expanded(
                              flex: 2,
                              child: FriendPresenceList(),
                            ),
                          ],
                        )
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildQuickActions(context),
                              const SizedBox(height: 24),
                              const PublicRoomsList(),
                              const SizedBox(height: 24),
                              const SizedBox(
                                height: 350,
                                child: FriendPresenceList(),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // Profile card header
  // -------------------------------------------------------
  Widget _buildHeader(BuildContext context, WidgetRef ref, dynamic user) {
    if (user == null) return const SizedBox.shrink();

    final xpNeeded = user.level * 500;
    final xpPercent = (user.xp / xpNeeded).clamp(0.0, 1.0);

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // User avatar with online status
          UserAvatar(
            avatarUrl: user.avatarUrl,
            username: user.username,
            status: 'online',
            size: 50,
          ),
          const SizedBox(width: 12),
          // User stats details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.displayName ?? user.username,
                      style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (user.isGuest) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Guest',
                          style: AppTextStyles.bodySmall.copyWith(fontSize: 8, color: Colors.white70),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                // Level and XP progress bar
                Row(
                  children: [
                    Text(
                      'LVL ${user.level}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: xpPercent,
                          backgroundColor: Colors.white.withValues(alpha: 0.05),
                          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                          minHeight: 6,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Coins counter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.monetization_on, color: AppColors.gold, size: 18),
                const SizedBox(width: 4),
                Text(
                  '${user.coins}',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.gold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Logout button
          IconButton(
            icon: const Icon(Icons.power_settings_new_rounded, color: AppColors.error),
            tooltip: 'Logout',
            onPressed: () {
              ref.read(authStateProvider.notifier).logout();
            },
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------
  // Host / Join table card shortcuts
  // -------------------------------------------------------
  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionCard(
            title: 'Host Table',
            subtitle: 'Create a new room',
            icon: Icons.add_box_rounded,
            gradientColors: const [AppColors.primary, AppColors.secondary],
            onTap: () => _showCreateRoomDialog(context),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _ActionCard(
            title: 'Join Table',
            subtitle: 'Enter room code',
            icon: Icons.style_rounded,
            gradientColors: const [AppColors.gold, Color(0xFFFFB300)],
            onTap: () => _showJoinRoomDialog(context),
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: EdgeInsets.zero,
        borderColor: gradientColors[0].withValues(alpha: 0.3),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                gradientColors[0].withValues(alpha: 0.05),
                gradientColors[1].withValues(alpha: 0.02),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradientColors),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.black, size: 24),
              ),
              const SizedBox(height: 16),
              Text(title, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
