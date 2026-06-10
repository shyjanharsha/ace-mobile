import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../providers/leaderboard_providers.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(leaderboardProvider);

    return AppScaffold(
      currentTab: AppTab.leaderboard,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Leaderboard', style: AppTextStyles.titleMedium),
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            // Filter Selectors
            _buildFilters(ref, state),
            const SizedBox(height: 12),

            // Main List/Podium Area
            Expanded(
              child: state.players.when(
                data: (players) {
                  if (players.isEmpty) {
                    return Center(
                      child: Text(
                        'No rankings found.',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                    );
                  }

                  final top3 = players.take(3).toList();
                  final rest = players.skip(3).toList();

                  return RefreshIndicator(
                    onRefresh: () => ref.read(leaderboardProvider.notifier).fetchLeaderboard(),
                    color: AppColors.primary,
                    backgroundColor: AppColors.surface,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        if (top3.isNotEmpty) ...[
                          _buildPodium(top3),
                          const SizedBox(height: 24),
                        ],
                        if (rest.isNotEmpty) ...[
                          Text(
                            'Rankings',
                            style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: rest.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final player = rest[index];
                              final rank = index + 4; // 1-indexed rank starting after top 3

                              return GlassCard(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.05),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '$rank',
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    UserAvatar(
                                      avatarUrl: player.avatarUrl,
                                      username: player.username,
                                      showStatus: false,
                                      size: 36,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            player.displayName ?? player.username,
                                            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            'LVL ${player.level}',
                                            style: AppTextStyles.bodySmall.copyWith(
                                              color: AppColors.primary,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      _formatValue(player.value, state.type),
                                      style: AppTextStyles.titleMedium.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  .animate()
                                  .fade(duration: 200.ms, delay: (index * 30).ms)
                                  .slideY(begin: 0.1, duration: 200.ms, delay: (index * 30).ms);
                            },
                          ),
                        ],
                      ],
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Failed to load rankings', style: TextStyle(color: AppColors.error)),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => ref.read(leaderboardProvider.notifier).fetchLeaderboard(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(WidgetRef ref, LeaderboardState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          // Metric filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  label: 'Wins',
                  isSelected: state.type == 'wins',
                  onTap: () => ref.read(leaderboardProvider.notifier).setType('wins'),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Coins Won',
                  isSelected: state.type == 'coins',
                  onTap: () => ref.read(leaderboardProvider.notifier).setType('coins'),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Best Streak',
                  isSelected: state.type == 'streak',
                  onTap: () => ref.read(leaderboardProvider.notifier).setType('streak'),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Donkeys',
                  isSelected: state.type == 'donkeys',
                  onTap: () => ref.read(leaderboardProvider.notifier).setType('donkeys'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Period filters
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPeriodTab(ref, 'weekly', 'Weekly', state.period == 'weekly'),
              _buildPeriodTab(ref, 'monthly', 'Monthly', state.period == 'monthly'),
              _buildPeriodTab(ref, 'all_time', 'All Time', state.period == 'all_time'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({required String label, required bool isSelected, required VoidCallback onTap}) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: Colors.white.withValues(alpha: 0.05),
      selectedColor: AppColors.primary.withValues(alpha: 0.15),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : Colors.white70,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primary.withValues(alpha: 0.5) : Colors.transparent,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      showCheckmark: false,
    );
  }

  Widget _buildPeriodTab(WidgetRef ref, String period, String label, bool isSelected) {
    return GestureDetector(
      onTap: () => ref.read(leaderboardProvider.notifier).setPeriod(period),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPodium(List<dynamic> top3) {
    final first = top3.first;
    final second = top3.length > 1 ? top3[1] : null;
    final third = top3.length > 2 ? top3[2] : null;

    final state = first != null; // Dummy check

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 2nd Place
        if (second != null)
          _buildPodiumUser(
            user: second,
            rank: 2,
            color: const Color(0xFFC0C0C0), // Silver
            height: 120,
            avatarSize: 60,
          ).animate().fade(duration: 400.ms).slideY(begin: 0.2, duration: 400.ms),

        // 1st Place
        if (first != null)
          _buildPodiumUser(
            user: first,
            rank: 1,
            color: AppColors.gold, // Gold
            height: 150,
            avatarSize: 76,
            hasCrown: true,
          ).animate().fade(duration: 500.ms).slideY(begin: 0.2, duration: 500.ms),

        // 3rd Place
        if (third != null)
          _buildPodiumUser(
            user: third,
            rank: 3,
            color: const Color(0xFFCD7F32), // Bronze
            height: 100,
            avatarSize: 52,
          ).animate().fade(duration: 600.ms).slideY(begin: 0.2, duration: 600.ms),
      ],
    );
  }

  Widget _buildPodiumUser({
    required dynamic user,
    required int rank,
    required Color color,
    required double height,
    required double avatarSize,
    bool hasCrown = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            UserAvatar(
              avatarUrl: user.avatarUrl,
              username: user.username,
              showStatus: false,
              size: avatarSize,
            ),
            if (hasCrown)
              Positioned(
                top: -22,
                child: Icon(
                  Icons.emoji_events_rounded,
                  color: AppColors.gold,
                  size: 28,
                )
                    .animate(onPlay: (controller) => controller.repeat(reverse: true))
                    .scale(begin: const Offset(1, 1), end: const Offset(1.15, 1.15), duration: 1.seconds)
                    .rotate(begin: -0.05, end: 0.05, duration: 1.seconds),
              ),
            Positioned(
              bottom: -6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.5),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Text(
                  '#$rank',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          user.displayName ?? user.username,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, fontSize: rank == 1 ? 14 : 12),
        ),
        const SizedBox(height: 2),
        Text(
          'LVL ${user.level}',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 10),
        ),
        const SizedBox(height: 8),
        Container(
          height: height,
          width: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.withValues(alpha: 0.2),
                color.withValues(alpha: 0.03),
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${user.value}',
                style: AppTextStyles.titleMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: rank == 1 ? 20 : 16,
                ),
              ),
              Text(
                rank == 1 ? 'King' : 'Pro',
                style: TextStyle(
                  color: color.withValues(alpha: 0.7),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatValue(dynamic val, String type) {
    if (type == 'coins') {
      return '$val 🪙';
    } else if (type == 'streak') {
      return '$val 🔥';
    } else if (type == 'donkeys') {
      return '$val 🫏';
    }
    return '$val W';
  }
}
