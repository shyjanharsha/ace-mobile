import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/domain/auth_state.dart';
import '../../../friends/presentation/providers/friends_providers.dart';
import '../providers/groups_providers.dart';
import '../../data/models/group_model.dart';

class GroupDetailsScreen extends ConsumerStatefulWidget {
  final int groupId;
  const GroupDetailsScreen({super.key, required this.groupId});

  @override
  ConsumerState<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends ConsumerState<GroupDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final _searchUserCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _searchUserCtrl.dispose();
    super.dispose();
  }

  void _copyInviteCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invite code copied to clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final currentUser = authState.value?.user;
    final groupAsync = ref.watch(groupDetailsProvider(widget.groupId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: groupAsync.maybeWhen(
          data: (g) => Text(g.name, style: AppTextStyles.titleMedium),
          orElse: () => const Text('Group Details'),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: groupAsync.when(
          data: (group) {
            final isOwner = group.ownerId == currentUser?.id;
            final userMembership = group.members?.firstWhere(
              (m) => m.userId == currentUser?.id,
              orElse: () => const GroupMemberModel(id: -1, userId: -1, role: 'none', joinedAt: '', username: ''),
            );
            final isAdmin = isOwner || userMembership?.role == 'admin';

            return Column(
              children: [
                // Group Info Header Card
                _buildGroupHeaderCard(group, isOwner),
                const SizedBox(height: 12),

                // Tabs
                TabBar(
                  controller: _tabCtrl,
                  indicatorColor: AppColors.primary,
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.textSecondary,
                  tabs: const [
                    Tab(text: 'Members'),
                    Tab(text: 'Invite Players'),
                  ],
                ),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabCtrl,
                    children: [
                      _buildMembersTab(group, currentUser?.id, isAdmin, userMembership?.id),
                      _buildInviteTab(group, isAdmin),
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Text('Failed to load group details.', style: TextStyle(color: AppColors.error)),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupHeaderCard(GroupModel group, bool isOwner) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white10,
                  backgroundImage: group.avatarUrl != null ? NetworkImage(group.avatarUrl!) : null,
                  child: group.avatarUrl == null
                      ? const Icon(Icons.group_rounded, color: Colors.white70)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name,
                        style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        group.description ?? 'No description provided.',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isOwner) ...[
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: const Icon(Icons.delete_forever_rounded, color: AppColors.error, size: 18),
                  label: const Text('Delete Group', style: TextStyle(color: AppColors.error)),
                  onPressed: () => _confirmDeleteGroup(group.name),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMembersTab(GroupModel group, int? currentUserId, bool isAdmin, int? myMembershipId) {
    final members = group.members ?? [];

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      itemCount: members.length + 1, // +1 for Leave Group row if not owner
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == members.length) {
          // Leave Group Row
          if (group.ownerId == currentUserId) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: AppButton(
              label: 'Leave Group',
              variant: AppButtonVariant.outlined,
              onPressed: () => _confirmLeaveGroup(myMembershipId),
            ),
          );
        }

        final member = members[index];
        final isMemberOwner = member.userId == group.ownerId;
        final isMe = member.userId == currentUserId;

        return GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              UserAvatar(
                avatarUrl: member.avatarUrl,
                username: member.username ?? '',
                showStatus: false,
                size: 40,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.displayName?.isNotEmpty == true
                          ? member.displayName!
                          : (member.username ?? 'Group Member'),
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '@${member.username}',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                        ),
                        if (isMemberOwner) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppColors.gold.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Owner',
                              style: TextStyle(color: AppColors.gold, fontSize: 8, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ] else if (member.role == 'admin') ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Admin',
                              style: TextStyle(color: AppColors.primary, fontSize: 8, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (isAdmin && !isMemberOwner && !isMe)
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline_rounded, color: AppColors.error),
                  onPressed: () => _confirmKickMember(member),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInviteTab(GroupModel group, bool isAdmin) {
    final searchResultsAsync = ref.watch(userSearchProvider);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Invite Code card
          if (group.inviteCode != null)
            GlassCard(
              padding: const EdgeInsets.all(16),
              borderColor: AppColors.primary.withValues(alpha: 0.15),
              child: Column(
                children: [
                  Text(
                    'Group Invite Code',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        group.inviteCode!,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.copy_rounded, color: Colors.white70),
                        onPressed: () => _copyInviteCode(group.inviteCode!),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          const SizedBox(height: 20),

          // Search & invite users directly
          Text(
            'Invite Players directly',
            style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _searchUserCtrl,
            label: 'Search Players',
            hint: 'Search by username...',
            prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
            onChanged: (val) {
              ref.read(userSearchQueryProvider.notifier).setQuery(val);
            },
          ),
          const SizedBox(height: 16),

          searchResultsAsync.when(
            data: (users) {
              if (users.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _searchUserCtrl.text.trim().isEmpty ? 'Search for users' : 'No users found.',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: users.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final user = users[index];
                  final isAlreadyMember = group.members?.any((m) => m.userId == user.id) ?? false;

                  return GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        UserAvatar(
                          avatarUrl: user.avatarUrl,
                          username: user.username,
                          showStatus: false,
                          size: 36,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.displayName ?? user.username,
                                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '@${user.username}',
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 90,
                          height: 32,
                          child: AppButton(
                            label: isAlreadyMember ? 'Member' : 'Invite',
                            variant: isAlreadyMember ? AppButtonVariant.outlined : AppButtonVariant.primary,
                            onPressed: isAlreadyMember
                                ? null
                                : () async {
                                    final ok = await ref
                                        .read(groupDetailsProvider(widget.groupId).notifier)
                                        .inviteUser(user.id);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            ok ? 'Invitation sent!' : 'Failed to send invitation.',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error searching players', style: TextStyle(color: AppColors.error))),
          ),
        ],
      ),
    );
  }

  void _confirmKickMember(GroupMemberModel member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Kick Member', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to remove ${member.displayName ?? member.username} from this group?',
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
              final ok = await ref
                  .read(groupDetailsProvider(widget.groupId).notifier)
                  .removeOrLeaveMember(member.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(ok ? 'Member kicked.' : 'Failed to remove member.')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _confirmLeaveGroup(int? membershipId) {
    if (membershipId == null) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Leave Group', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to leave this group?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Leave', style: TextStyle(color: AppColors.error)),
            onPressed: () async {
              Navigator.pop(context);
              final ok = await ref
                  .read(groupDetailsProvider(widget.groupId).notifier)
                  .removeOrLeaveMember(membershipId);
              if (mounted) {
                if (ok) {
                  ref.read(groupsProvider.notifier).fetchGroups();
                  context.pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to leave group.')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _confirmDeleteGroup(String groupName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Delete Group', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to permanently delete "$groupName"? All memberships will be dissolved.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
            onPressed: () async {
              Navigator.pop(context);
              final ok = await ref
                  .read(groupDetailsProvider(widget.groupId).notifier)
                  .deleteGroup();
              if (mounted) {
                if (ok) {
                  ref.read(groupsProvider.notifier).fetchGroups();
                  context.pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to delete group.')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
