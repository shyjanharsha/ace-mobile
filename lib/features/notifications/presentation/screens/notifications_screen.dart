import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../friends/presentation/providers/friends_providers.dart';
import '../providers/notifications_providers.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return AppScaffold(
      currentTab: AppTab.notifications,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Notifications', style: AppTextStyles.titleMedium),
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.done_all_rounded, size: 18, color: AppColors.primary),
              label: const Text('Mark all read', style: TextStyle(color: AppColors.primary)),
              onPressed: () => ref.read(notificationsProvider.notifier).markAllAsRead(),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => ref.read(notificationsProvider.notifier).fetchNotifications(),
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          child: notificationsAsync.when(
            data: (notifications) {
              if (notifications.isEmpty) {
                return Center(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_none_rounded,
                            size: 64,
                            color: AppColors.textSecondary.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'All caught up!',
                            style: AppTextStyles.titleMedium.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'No new alerts or invitations.',
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
                itemCount: notifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final notif = notifications[index];

                  return GestureDetector(
                    onTap: notif.read
                        ? null
                        : () => ref.read(notificationsProvider.notifier).markAsRead(notif.id),
                    child: GlassCard(
                      padding: const EdgeInsets.all(16),
                      borderColor: notif.read
                          ? Colors.white.withValues(alpha: 0.05)
                          : AppColors.primary.withValues(alpha: 0.3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Read/Unread indicator
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: notif.read ? Colors.transparent : AppColors.primary,
                              shape: BoxShape.circle,
                              boxShadow: notif.read
                                  ? null
                                  : [
                                      const BoxShadow(
                                        color: AppColors.primary,
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Content & Actions
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        notif.title,
                                        style: AppTextStyles.titleMedium.copyWith(
                                          fontWeight: notif.read ? FontWeight.normal : FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      _formatTime(notif.sent_at),
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  notif.body,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: notif.read ? AppColors.textSecondary : Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                                if (_hasActions(notif)) ...[
                                  const SizedBox(height: 12),
                                  _buildActionButtons(context, ref, notif),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate()
                      .fade(duration: 250.ms, delay: (index * 40).ms)
                      .slideX(begin: 0.05, duration: 250.ms, delay: (index * 40).ms);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Failed to load notifications', style: TextStyle(color: AppColors.error)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => ref.read(notificationsProvider.notifier).fetchNotifications(),
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

  bool _hasActions(dynamic notif) {
    return notif.type == 'friend_request' || notif.type == 'group_invite';
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref, dynamic notif) {
    if (notif.type == 'friend_request') {
      final friendshipId = notif.payload?['friendship_id'];
      if (friendshipId == null) return const SizedBox.shrink();

      return Row(
        children: [
          SizedBox(
            width: 100,
            height: 32,
            child: AppButton(
              label: 'Accept',
              onPressed: () async {
                await ref.read(friendActionProvider.notifier).respondToFriendRequest(
                      friendshipId: friendshipId,
                      actionType: 'accept',
                    );
                ref.read(notificationsProvider.notifier).markAsRead(notif.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Friend request accepted!')),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 100,
            height: 32,
            child: AppButton(
              label: 'Decline',
              variant: AppButtonVariant.outlined,
              onPressed: () async {
                await ref.read(friendActionProvider.notifier).respondToFriendRequest(
                      friendshipId: friendshipId,
                      actionType: 'decline',
                    );
                ref.read(notificationsProvider.notifier).markAsRead(notif.id);
              },
            ),
          ),
        ],
      );
    }

    if (notif.type == 'group_invite') {
      final groupId = notif.payload?['group_id'];
      if (groupId == null) return const SizedBox.shrink();

      return Row(
        children: [
          SizedBox(
            width: 120,
            height: 32,
            child: AppButton(
              label: 'View Group',
              onPressed: () {
                ref.read(notificationsProvider.notifier).markAsRead(notif.id);
                context.push('/groups');
              },
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  String _formatTime(String isoString) {
    try {
      final dt = DateTime.parse(isoString).toLocal();
      final diff = DateTime.now().difference(dt);

      if (diff.inSeconds < 60) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${dt.day}/${dt.month}';
    } catch (_) {
      return '';
    }
  }
}
