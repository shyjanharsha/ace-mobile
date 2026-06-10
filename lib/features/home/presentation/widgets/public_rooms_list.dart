import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../providers/home_providers.dart';

class PublicRoomsList extends ConsumerWidget {
  const PublicRoomsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsAsync = ref.watch(publicRoomsProvider);
    final roomActionState = ref.watch(roomActionProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Public Tables', style: AppTextStyles.headlineSmall),
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: AppColors.textSecondary),
              onPressed: () => ref.invalidate(publicRoomsProvider),
            ),
          ],
        ),
        const SizedBox(height: 12),
        roomsAsync.when(
          data: (rooms) {
            if (rooms.isEmpty) {
              return GlassCard(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.style_outlined, size: 48, color: AppColors.textSecondary),
                      const SizedBox(height: 12),
                      Text(
                        'No public tables active',
                        style: AppTextStyles.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Create a custom room and invite your friends to start playing!',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rooms.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final room = rooms[index];
                final isJoining = roomActionState.isLoading;

                return GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Bet coins badge
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.monetization_on_rounded,
                          color: AppColors.gold,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Code: ${room.code}',
                              style: AppTextStyles.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  'Wager: ',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  '${room.betCoins} Coins',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.gold,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Player Count and Join Button
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.people_alt_rounded, size: 16, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text(
                                '${room.playerCount}/${room.maxPlayers}',
                                style: AppTextStyles.labelLarge.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 80,
                            height: 32,
                            child: AppButton(
                              label: 'Join',
                              height: 32,
                              isLoading: isJoining,
                              onPressed: isJoining
                                  ? null
                                  : () async {
                                      final joinedRoom = await ref
                                          .read(roomActionProvider.notifier)
                                          .joinRoom(room.id);
                                      if (joinedRoom != null && context.mounted) {
                                        context.goNamed(
                                          'roomLobby',
                                          pathParameters: {'roomId': joinedRoom.id.toString()},
                                        );
                                      }
                                    },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
          ),
          error: (err, _) => GlassCard(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Failed to fetch public tables.',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
