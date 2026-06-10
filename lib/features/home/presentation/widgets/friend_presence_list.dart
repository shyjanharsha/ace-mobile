import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../providers/home_providers.dart';

class FriendPresenceList extends ConsumerWidget {
  const FriendPresenceList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presencesAsync = ref.watch(friendPresencesProvider);

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Friends Presence', style: AppTextStyles.titleMedium),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.people_rounded, size: 20, color: AppColors.primary),
                    tooltip: 'Social Hub',
                    onPressed: () => context.goNamed('friends'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded, size: 20, color: AppColors.textSecondary),
                    tooltip: 'Refresh',
                    onPressed: () => ref.invalidate(friendPresencesProvider),
                  ),
                ],
              ),
            ],
          ),
          const Divider(color: AppColors.glassBorder, height: 16),
          Expanded(
            child: presencesAsync.when(
              data: (presences) {
                if (presences.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'No friends online.\nInvite some friends to play!',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: presences.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final friend = presences[index];
                    return Row(
                      children: [
                        UserAvatar(
                          avatarUrl: friend.avatarUrl,
                          username: friend.username,
                          status: friend.status,
                          size: 40,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                friend.displayName ?? friend.username,
                                style: AppTextStyles.titleSmall,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                friend.status == 'in_game' ? 'Playing' : friend.status.toUpperCase(),
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: friend.status == 'online'
                                      ? AppColors.online
                                      : friend.status == 'in_game'
                                          ? AppColors.inGame
                                          : friend.status == 'away'
                                              ? AppColors.away
                                              : AppColors.textSecondary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
              error: (err, _) => Center(
                child: Text(
                  'Failed to load friends.',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
