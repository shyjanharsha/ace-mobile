import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/domain/auth_state.dart';
import '../providers/friends_providers.dart';
import '../../data/models/friendship_model.dart';

class FriendsScreen extends ConsumerStatefulWidget {
  const FriendsScreen({super.key});

  @override
  ConsumerState<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends ConsumerState<FriendsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final currentUser = authState.value?.user;

    return AppScaffold(
      currentTab: AppTab.friends,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Social Hub', style: AppTextStyles.titleMedium),
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          bottom: TabBar(
            controller: _tabCtrl,
            indicatorColor: AppColors.primary,
            labelColor: Colors.white,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold),
            unselectedLabelStyle: AppTextStyles.labelLarge,
            tabs: const [
              Tab(text: 'My Friends'),
              Tab(text: 'Requests'),
              Tab(text: 'Find Players'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabCtrl,
          children: [
            _MyFriendsTab(currentUser: currentUser),
            _RequestsTab(currentUser: currentUser),
            _SearchTab(currentUser: currentUser, searchCtrl: _searchCtrl),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------
// Tab 1: My Friends Tab
// -------------------------------------------------------
class _MyFriendsTab extends ConsumerWidget {
  final dynamic currentUser;
  const _MyFriendsTab({required this.currentUser});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendshipsAsync = ref.watch(friendshipsProvider);
    final actionState = ref.watch(friendActionProvider);

    return friendshipsAsync.when(
      data: (friendships) {
        final acceptedFriends = friendships.where((f) => f.status == 'accepted').toList();

        if (acceptedFriends.isEmpty) {
          return Center(
            child: Text(
              'No friends added yet.\nGo to "Find Players" to search and add friends!',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            )
                .animate()
                .fade(duration: 300.ms)
                .scale(begin: const Offset(0.9, 0.9), duration: 300.ms),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          itemCount: acceptedFriends.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final friendship = acceptedFriends[index];
            final friend = friendship.requester.id == currentUser?.id
                ? friendship.receiver
                : friendship.requester;

            return GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  UserAvatar(
                    avatarUrl: friend.avatarUrl,
                    username: friend.username,
                    status: 'online', // Standard check, can bind websocket presence later
                    size: 44,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          friend.displayName ?? friend.username,
                          style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '@${friend.username}',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_remove_rounded, color: AppColors.error),
                    onPressed: actionState.isLoading
                        ? null
                        : () => _confirmUnfriend(context, ref, friendship, friend),
                  ),
                ],
              ),
            )
                .animate()
                .fade(duration: 250.ms, delay: (index * 50).ms)
                .slideX(begin: 0.1, duration: 250.ms, delay: (index * 50).ms);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Failed to load friends list', style: TextStyle(color: AppColors.error))),
    );
  }

  void _confirmUnfriend(
    BuildContext context,
    WidgetRef ref,
    FriendshipModel friendship,
    FriendshipUser friend,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Remove Friend', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to remove ${friend.displayName ?? friend.username} from your friends list?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Remove', style: TextStyle(color: AppColors.error)),
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(friendActionProvider.notifier).removeFriend(friendship.id);
            },
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------
// Tab 2: Requests Tab
// -------------------------------------------------------
class _RequestsTab extends ConsumerWidget {
  final dynamic currentUser;
  const _RequestsTab({required this.currentUser});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendshipsAsync = ref.watch(friendshipsProvider);
    final actionState = ref.watch(friendActionProvider);

    return friendshipsAsync.when(
      data: (friendships) {
        final pending = friendships.where((f) => f.status == 'pending').toList();

        final incoming = pending.where((f) => f.receiver.id == currentUser?.id).toList();
        final outgoing = pending.where((f) => f.requester.id == currentUser?.id).toList();

        if (incoming.isEmpty && outgoing.isEmpty) {
          return Center(
            child: Text(
              'No pending friend requests.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          children: [
            if (incoming.isNotEmpty) ...[
              Text('Incoming Requests', style: AppTextStyles.titleMedium),
              const SizedBox(height: 12),
              ...incoming.map((req) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          UserAvatar(
                            avatarUrl: req.requester.avatarUrl,
                            username: req.requester.username,
                            showStatus: false,
                            size: 40,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              req.requester.displayName ?? req.requester.username,
                              style: AppTextStyles.titleMedium,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.check_circle_rounded, color: AppColors.success),
                            onPressed: actionState.isLoading
                                ? null
                                : () => ref
                                    .read(friendActionProvider.notifier)
                                    .respondToFriendRequest(friendshipId: req.id, actionType: 'accept'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel_rounded, color: AppColors.error),
                            onPressed: actionState.isLoading
                                ? null
                                : () => ref
                                    .read(friendActionProvider.notifier)
                                    .respondToFriendRequest(friendshipId: req.id, actionType: 'decline'),
                          ),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 20),
            ],
            if (outgoing.isNotEmpty) ...[
              Text('Sent Requests', style: AppTextStyles.titleMedium),
              const SizedBox(height: 12),
              ...outgoing.map((req) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          UserAvatar(
                            avatarUrl: req.receiver.avatarUrl,
                            username: req.receiver.username,
                            showStatus: false,
                            size: 40,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              req.receiver.displayName ?? req.receiver.username,
                              style: AppTextStyles.titleMedium,
                            ),
                          ),
                          TextButton(
                            onPressed: actionState.isLoading
                                ? null
                                : () => ref.read(friendActionProvider.notifier).removeFriend(req.id),
                            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Failed to load requests', style: TextStyle(color: AppColors.error))),
    );
  }
}

// -------------------------------------------------------
// Tab 3: Search Tab
// -------------------------------------------------------
class _SearchTab extends ConsumerWidget {
  final dynamic currentUser;
  final TextEditingController searchCtrl;

  const _SearchTab({
    required this.currentUser,
    required this.searchCtrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResultsAsync = ref.watch(userSearchProvider);
    final friendshipsAsync = ref.watch(friendshipsProvider);
    final actionState = ref.watch(friendActionProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: AppTextField(
            controller: searchCtrl,
            label: 'Search Players',
            hint: 'Enter username or display name',
            prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
            onChanged: (val) {
              ref.read(userSearchQueryProvider.notifier).setQuery(val);
            },
          ),
        ),
        Expanded(
          child: searchResultsAsync.when(
            data: (users) {
              if (users.isEmpty) {
                return Center(
                  child: Text(
                    searchCtrl.text.trim().isEmpty
                        ? 'Type to search players'
                        : 'No players found matching that name',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                );
              }

              final friendships = friendshipsAsync.value ?? [];

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                physics: const BouncingScrollPhysics(),
                itemCount: users.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final user = users[index];

                  // Find friendship relationship
                  final friendship = friendships.firstWhere(
                    (f) => f.requester.id == user.id || f.receiver.id == user.id,
                    orElse: () => const FriendshipModel(
                      id: -1,
                      status: 'none',
                      requester: FriendshipUser(id: -1, username: ''),
                      receiver: FriendshipUser(id: -1, username: ''),
                      createdAt: '',
                    ),
                  );

                  return GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        UserAvatar(
                          avatarUrl: user.avatarUrl,
                          username: user.username,
                          showStatus: false,
                          size: 40,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.displayName ?? user.username,
                                style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '@${user.username}',
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        _buildAction(context, ref, friendship, user, actionState.isLoading),
                      ],
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error searching players', style: TextStyle(color: AppColors.error))),
          ),
        ),
      ],
    );
  }

  Widget _buildAction(
    BuildContext context,
    WidgetRef ref,
    FriendshipModel friendship,
    FriendshipUser user,
    bool isLoading,
  ) {
    if (friendship.id == -1) {
      return SizedBox(
        width: 100,
        height: 32,
        child: AppButton(
          label: 'Add Friend',
          isLoading: isLoading,
          onPressed: () => ref.read(friendActionProvider.notifier).sendFriendRequest(user.id),
        ),
      );
    }

    if (friendship.status == 'accepted') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check, size: 14, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(
              'Friends',
              style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      );
    }

    if (friendship.status == 'pending') {
      if (friendship.requester.id == currentUser?.id) {
        return TextButton(
          child: const Text('Pending', style: TextStyle(color: AppColors.textSecondary)),
          onPressed: () {},
        );
      } else {
        return SizedBox(
          width: 90,
          height: 32,
          child: AppButton(
            label: 'Accept',
            isLoading: isLoading,
            onPressed: () => ref.read(friendActionProvider.notifier).respondToFriendRequest(
                  friendshipId: friendship.id,
                  actionType: 'accept',
                ),
          ),
        );
      }
    }

    return const SizedBox.shrink();
  }
}
