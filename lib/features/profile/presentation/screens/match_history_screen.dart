import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../providers/profile_providers.dart';
import '../../data/models/match_history_model.dart';

class MatchHistoryScreen extends ConsumerWidget {
  const MatchHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(matchHistoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Match History', style: AppTextStyles.titleMedium),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: RefreshIndicator(
          onRefresh: () => ref.read(matchHistoryProvider.notifier).fetchMatches(),
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          child: historyAsync.when(
            data: (matches) {
              if (matches.isEmpty) {
                return Center(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.7,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history_toggle_off_rounded,
                            size: 64,
                            color: AppColors.textSecondary.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No matches played yet',
                            style: AppTextStyles.titleMedium.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Join a lobby and start playing to build your history.',
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(20),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: matches.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final match = matches[index];
                  return _buildMatchCard(context, match)
                      .animate()
                      .fade(duration: 250.ms, delay: (index * 40).ms)
                      .slideY(begin: 0.05, duration: 250.ms, delay: (index * 40).ms);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Failed to load history', style: TextStyle(color: AppColors.error)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => ref.read(matchHistoryProvider.notifier).fetchMatches(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMatchCard(BuildContext context, MatchHistoryModel match) {
    final isWinner = match.finalRank == 1;
    final isDonkey = match.isDonkey;
    final coinColor = match.coinsWon >= 0 ? AppColors.gold : AppColors.error;
    final coinSign = match.coinsWon >= 0 ? '+' : '';

    Color statusColor;
    String statusText;
    if (isDonkey) {
      statusColor = AppColors.error;
      statusText = '🫏 DONKEY';
    } else if (isWinner) {
      statusColor = AppColors.success;
      statusText = '🏆 VICTORY';
    } else {
      statusColor = AppColors.primary;
      statusText = 'RANK #${match.finalRank}';
    }

    return GlassCard(
      padding: const EdgeInsets.all(16),
      borderColor: statusColor.withValues(alpha: 0.2),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                _formatDate(match.playedAt),
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tricks Won',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${match.tricksWon} Tricks',
                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Coins Transferred',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.monetization_on, color: coinColor, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '$coinSign${match.coinsWon}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: coinColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.white.withValues(alpha: 0.05)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Match ID: #${match.matchId}',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 10),
              ),
              Text(
                'Status: ${match.matchStatus.toUpperCase()}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: match.matchStatus == 'completed' ? Colors.white54 : AppColors.gold,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String isoString) {
    try {
      final dt = DateTime.parse(isoString).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
    } catch (_) {
      return '';
    }
  }
}
