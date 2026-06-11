import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../auth/domain/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../friends/presentation/providers/friends_providers.dart';
import '../providers/rooms_providers.dart';
import '../../data/models/game_room_model.dart';
import '../../data/models/room_player_model.dart';
import '../../../../core/router/route_names.dart';

class RoomLobbyScreen extends ConsumerStatefulWidget {
  final int roomId;
  const RoomLobbyScreen({super.key, required this.roomId});

  @override
  ConsumerState<RoomLobbyScreen> createState() => _RoomLobbyScreenState();
}

class _RoomLobbyScreenState extends ConsumerState<RoomLobbyScreen> {
  final _chatCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void dispose() {
    _chatCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final currentUserId = authState.value?.user?.id;
    final lobbyState = ref.watch(lobbyProvider(widget.roomId));

    // Listen for redirection to match screen once the game starts
    ref.listen<LobbyState>(lobbyProvider(widget.roomId), (previous, next) {
      if (next.matchId != null) {
        context.go(RouteNames.gamePath(next.matchId!));
      }
      // Auto-scroll chat on new message
      if (previous != null && next.messages.length > previous.messages.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Game Lobby'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => _confirmLeave(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              ref.read(lobbyProvider(widget.roomId).notifier).fetchRoom();
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: lobbyState.room.when(
          data: (room) {
            final players = room.players ?? [];
            final isHost = room.hostId == currentUserId;
            final myPlayer = players.firstWhere(
              (p) => p.userId == currentUserId,
              orElse: () => const RoomPlayerModel(
                userId: -1,
                username: '',
                seatPosition: -1,
                status: 'none',
                ready: false,
              ),
            );

            final isReady = myPlayer.ready;

            // Enable start match button if:
            // 1. Current user is host
            // 2. Total players >= 2
            // 3. All non-host players are ready
            final nonHostPlayers = players.where((p) => p.userId != room.hostId);
            final allOthersReady = nonHostPlayers.isNotEmpty && nonHostPlayers.every((p) => p.ready);
            final canStartGame = isHost && players.length >= 2 && allOthersReady;

            final isTablet = MediaQuery.sizeOf(context).width > 800;

            return isTablet
                ? Row(
                    children: [
                      // Left Section: Player cards + Start/Ready Actions
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _RoomInfoCard(room: room),
                              const SizedBox(height: 24),
                              Expanded(
                                child: _buildPlayerGrid(room, players, currentUserId),
                              ),
                              const SizedBox(height: 24),
                              _buildActionControls(
                                context: context,
                                isHost: isHost,
                                isReady: isReady,
                                canStart: canStartGame,
                                onReadyToggle: () {
                                  ref.read(lobbyProvider(widget.roomId).notifier).toggleReady(!isReady);
                                },
                                onStartGame: () async {
                                  await ref.read(lobbyProvider(widget.roomId).notifier).startGame();
                                },
                                onInviteFriends: () => _showInviteDialog(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Right Section: Chat + Invite Shortcuts
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 24.0, top: 24.0, bottom: 24.0),
                          child: _ChatPanel(
                            messages: lobbyState.messages,
                            chatCtrl: _chatCtrl,
                            scrollCtrl: _scrollCtrl,
                            onSend: (msg) {
                              ref.read(lobbyProvider(widget.roomId).notifier).sendChatMessage(msg);
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _RoomInfoCard(room: room),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            children: [
                              SizedBox(
                                height: 260,
                                child: _buildPlayerGrid(room, players, currentUserId),
                              ),
                              const SizedBox(height: 16),
                              _buildActionControls(
                                context: context,
                                isHost: isHost,
                                isReady: isReady,
                                canStart: canStartGame,
                                onReadyToggle: () {
                                  ref.read(lobbyProvider(widget.roomId).notifier).toggleReady(!isReady);
                                },
                                onStartGame: () async {
                                  await ref.read(lobbyProvider(widget.roomId).notifier).startGame();
                                },
                                onInviteFriends: () => _showInviteDialog(context),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                height: 300,
                                child: _ChatPanel(
                                  messages: lobbyState.messages,
                                  chatCtrl: _chatCtrl,
                                  scrollCtrl: _scrollCtrl,
                                  onSend: (msg) {
                                    ref.read(lobbyProvider(widget.roomId).notifier).sendChatMessage(msg);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Failed to join lobby.',
                  style: AppTextStyles.titleMedium.copyWith(color: AppColors.error),
                ),
                const SizedBox(height: 12),
                AppButton(
                  label: 'Go Home',
                  onPressed: () => context.goNamed('home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // Dynamic Player Grid / Slots
  // -------------------------------------------------------
  Widget _buildPlayerGrid(GameRoomModel room, List<RoomPlayerModel> players, int? currentUserId) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.2,
      ),
      itemCount: room.maxPlayers,
      itemBuilder: (context, index) {
        // Seat position is index based
        final player = players.firstWhere(
          (p) => p.seatPosition == index,
          orElse: () => const RoomPlayerModel(
            userId: -1,
            username: '',
            seatPosition: -1,
            status: 'none',
            ready: false,
          ),
        );

        final isOccupied = player.userId != -1;

        if (!isOccupied) {
          return GlassCard(
            padding: const EdgeInsets.all(12),
            borderColor: Colors.white.withValues(alpha: 0.05),
            child: Center(
              child: Text(
                'Waiting for player...',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
            ),
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .fade(begin: 0.5, end: 0.8, duration: 1200.ms);
        }

        final isMe = player.userId == currentUserId;
        final isHost = player.userId == room.hostId;

        return GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          borderColor: isMe ? AppColors.primary.withValues(alpha: 0.4) : AppColors.glassBorder,
          child: Row(
            children: [
              UserAvatar(
                avatarUrl: player.avatarUrl,
                username: player.username,
                showStatus: false,
                size: 44,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            player.username,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.titleSmall.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isMe ? AppColors.primary : Colors.white,
                            ),
                          ),
                        ),
                        if (isHost) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.star, color: AppColors.gold, size: 14),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isHost
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : player.ready
                                ? AppColors.success.withValues(alpha: 0.1)
                                : AppColors.textSecondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isHost
                              ? AppColors.primary.withValues(alpha: 0.3)
                              : player.ready
                                  ? AppColors.success.withValues(alpha: 0.3)
                                  : AppColors.textSecondary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        isHost
                            ? 'HOST'
                            : player.ready
                                ? 'READY'
                                : 'NOT READY',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: isHost
                              ? AppColors.primary
                              : player.ready
                                  ? AppColors.success
                                  : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // -------------------------------------------------------
  // Action Controls (Host start game or client toggle ready)
  // -------------------------------------------------------
  Widget _buildActionControls({
    required BuildContext context,
    required bool isHost,
    required bool isReady,
    required bool canStart,
    required VoidCallback onReadyToggle,
    required VoidCallback onStartGame,
    required VoidCallback onInviteFriends,
  }) {
    return Row(
      children: [
        Expanded(
          child: isHost
              ? AppButton(
                  label: 'Start Match',
                  onPressed: canStart ? onStartGame : null,
                )
              : AppButton(
                  label: isReady ? 'Not Ready' : 'Ready',
                  variant: isReady ? AppButtonVariant.outlined : AppButtonVariant.primary,
                  onPressed: onReadyToggle,
                ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 56,
          height: 48,
          child: AppButton(
            label: '',
            variant: AppButtonVariant.outlined,
            onPressed: onInviteFriends,
            icon: Icons.person_add_alt_1_rounded,
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------
  // Confirmation Dialogue before leaving lobby
  // -------------------------------------------------------
  void _confirmLeave(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Leave Lobby', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to leave the game lobby?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Pop dialog
              await ref.read(lobbyProvider(widget.roomId).notifier).leaveRoom();
              if (context.mounted) {
                context.goNamed('home');
              }
            },
            child: const Text('Leave', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------
  // Friends list Invite Overlay Dialog
  // -------------------------------------------------------
  void _showInviteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _InviteFriendsDialog(roomId: widget.roomId),
    );
  }
}

// -------------------------------------------------------
// Header Room Details Widget
// -------------------------------------------------------
class _RoomInfoCard extends StatelessWidget {
  final GameRoomModel room;
  const _RoomInfoCard({required this.room});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lobby: ${room.code}',
                style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Bet Amount: ${room.betCoins} coins',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.people_rounded, color: AppColors.textSecondary, size: 16),
              const SizedBox(width: 6),
              Text(
                '${room.playerCount} / ${room.maxPlayers}',
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------
// Chat Panel Widget
// -------------------------------------------------------
class _ChatPanel extends StatelessWidget {
  final List<LobbyMessage> messages;
  final TextEditingController chatCtrl;
  final ScrollController scrollCtrl;
  final Function(String) onSend;

  const _ChatPanel({
    required this.messages,
    required this.chatCtrl,
    required this.scrollCtrl,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Lobby Chat', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
          const Divider(color: AppColors.glassBorder, height: 20),
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Text(
                      'Welcome to the lobby!\nSay hello to your opponents.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                  )
                : ListView.builder(
                    controller: scrollCtrl,
                    physics: const BouncingScrollPhysics(),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UserAvatar(
                              avatarUrl: msg.avatarUrl,
                              username: msg.username,
                              showStatus: false,
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    msg.username,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    msg.message,
                                    style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: chatCtrl,
                  label: 'Message',
                  hint: 'Type message...',
                  onSubmitted: (val) {
                    if (val.trim().isNotEmpty) {
                      onSend(val);
                      chatCtrl.clear();
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send_rounded, color: AppColors.primary),
                onPressed: () {
                  if (chatCtrl.text.trim().isNotEmpty) {
                    onSend(chatCtrl.text);
                    chatCtrl.clear();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------
// Dialog to search and invite active friends
// -------------------------------------------------------
class _InviteFriendsDialog extends ConsumerStatefulWidget {
  final int roomId;
  const _InviteFriendsDialog({required this.roomId});

  @override
  ConsumerState<_InviteFriendsDialog> createState() => _InviteFriendsDialogState();
}

class _InviteFriendsDialogState extends ConsumerState<_InviteFriendsDialog> {
  final Set<int> _invitedUserIds = {};

  @override
  Widget build(BuildContext context) {
    final friendshipsAsync = ref.watch(friendshipsProvider);
    final currentUser = ref.watch(authStateProvider).value?.user;

    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text('Invite Friends', style: TextStyle(color: Colors.white)),
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: friendshipsAsync.when(
          data: (friendships) {
            final accepted = friendships.where((f) => f.status == 'accepted').toList();

            if (accepted.isEmpty) {
              return Center(
                child: Text(
                  'No friends online or added yet.',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
              );
            }

            return ListView.separated(
              itemCount: accepted.length,
              separatorBuilder: (_, __) => const Divider(color: Colors.white10),
              itemBuilder: (context, index) {
                final friendship = accepted[index];
                final friend = friendship.requester.id == currentUser?.id
                    ? friendship.receiver
                    : friendship.requester;

                final isInvited = _invitedUserIds.contains(friend.id);

                return Row(
                  children: [
                    UserAvatar(
                      avatarUrl: friend.avatarUrl,
                      username: friend.username,
                      showStatus: false,
                      size: 36,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        friend.displayName ?? friend.username,
                        style: AppTextStyles.titleSmall,
                      ),
                    ),
                    SizedBox(
                      height: 32,
                      width: 90,
                      child: isInvited
                          ? Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Invited',
                                style: AppTextStyles.bodySmall.copyWith(color: Colors.white54),
                              ),
                            )
                          : AppButton(
                              label: 'Invite',
                              onPressed: () async {
                                final success = await ref
                                    .read(lobbyProvider(widget.roomId).notifier)
                                    .invitePlayer(friend.id);
                                if (success) {
                                  setState(() {
                                    _invitedUserIds.add(friend.id);
                                  });
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Invitation sent to ${friend.username}!'),
                                        backgroundColor: AppColors.success,
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                    ),
                  ],
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Failed to load friends list', style: TextStyle(color: AppColors.error))),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close', style: TextStyle(color: Colors.white70)),
        ),
      ],
    );
  }
}
