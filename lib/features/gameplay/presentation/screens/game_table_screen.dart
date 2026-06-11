import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/gameplay_providers.dart';
import '../widgets/playing_card_widget.dart';
import '../widgets/winner_confetti.dart';
import '../widgets/donkey_animation.dart';

import '../../../auth/domain/auth_state.dart';
import '../../data/models/match_model.dart';

class GameTableScreen extends ConsumerStatefulWidget {
  final int matchId;

  const GameTableScreen({super.key, required this.matchId});

  @override
  ConsumerState<GameTableScreen> createState() => _GameTableScreenState();
}

class _GameTableScreenState extends ConsumerState<GameTableScreen> {
  String? _hoveredCard;

  @override
  void initState() {
    super.initState();
    // Snackbar listener — show error from server rejection
    ref.listenManual(
      gameplayProvider(widget.matchId).select((s) => s.lastErrorMessage),
      (_, message) {
        if (message != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 2),
            ),
          );
          ref.read(gameplayProvider(widget.matchId).notifier).clearError();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameplayState = ref.watch(gameplayProvider(widget.matchId));
    final authState = ref.watch(authStateProvider);
    final currentUserId = authState.value?.user?.id;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F172A), // Slate 900
              Color(0xFF020617), // Slate 950
              Color(0xFF0A0F1D), // Darker midnight blue
            ],
          ),
        ),
        child: SafeArea(
          child: gameplayState.match.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
            error: (err, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Failed to load match state',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(gameplayProvider(widget.matchId).notifier)
                          .reconnectGame();
                    },
                    child: const Text('Retry Connection'),
                  ),
                ],
              ),
            ),
            data: (match) {
              // Retrieve local user model to calculate relative positions
              final myPlayer = match.players.firstWhere(
                (p) => p.userId == currentUserId,
                orElse: () => match.players.first,
              );
              final mySeat = myPlayer.seatPosition;
              final totalPlayers = match.players.length;

              // Check if game is over
              final isGameOver = gameplayState.donkeyId != null;
              final isMeDonkey = gameplayState.donkeyId == currentUserId;

              // Check if I am safe (exited cards)
              final myMatchPlayer = match.players.firstWhere(
                (p) => p.userId == currentUserId,
                orElse: () => myPlayer,
              );
              final isMeSafe = myMatchPlayer.finalRank != null && !isGameOver;

              return Stack(
                children: [
                  // Cyber Grid Background Texture
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.05,
                      child: Image.network(
                        'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=600&auto=format&fit=crop',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox(),
                      ),
                    ),
                  ),

                  // Table Layout & Gameplay Elements
                  Column(
                    children: [
                      // Header Row
                      _buildHeader(match, gameplayState),

                      // Circular Card Table Area
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final radius =
                                min(
                                  constraints.maxWidth,
                                  constraints.maxHeight,
                                ) *
                                0.38;

                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                // The Central Table Ring
                                Container(
                                  width: radius * 2,
                                  height: radius * 2,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        AppColors.primary.withValues(
                                          alpha: 0.05,
                                        ),
                                        AppColors.secondary.withValues(
                                          alpha: 0.1,
                                        ),
                                        Colors.transparent,
                                      ],
                                    ),
                                    border: Border.all(
                                      color: (_hoveredCard != null
                                          ? AppColors.primary
                                          : Colors.white.withValues(
                                              alpha: 0.1,
                                            )),
                                      width: _hoveredCard != null ? 3.0 : 1.5,
                                    ),
                                    boxShadow: [
                                      if (_hoveredCard != null)
                                        BoxShadow(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 20,
                                          spreadRadius: 2,
                                        ),
                                    ],
                                  ),
                                ),

                                // Drag Target in the Center Pile
                                Center(
                                  child: DragTarget<String>(
                                    onWillAcceptWithDetails: (details) {
                                      setState(
                                        () => _hoveredCard = details.data,
                                      );
                                      return gameplayState.isMyTurn &&
                                          !isMeSafe;
                                    },
                                    onLeave: (_) {
                                      setState(() => _hoveredCard = null);
                                    },
                                    onAcceptWithDetails: (details) {
                                      setState(() => _hoveredCard = null);
                                      _playCard(details.data);
                                    },
                                    builder: (context, candidateData, rejectedData) {
                                      return Container(
                                        width: radius * 1.1,
                                        height: radius * 1.1,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.transparent,
                                        ),
                                        child: Center(
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              if (gameplayState
                                                  .trickPile
                                                  .isEmpty)
                                                Text(
                                                      gameplayState.isMyTurn
                                                          ? 'DRAG HERE TO PLAY'
                                                          : 'WAITING FOR TURNS',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: AppTextStyles
                                                          .bodySmall
                                                          .copyWith(
                                                            color:
                                                                gameplayState
                                                                    .isMyTurn
                                                                ? AppColors
                                                                      .primary
                                                                : Colors
                                                                      .white38,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            letterSpacing: 1.2,
                                                          ),
                                                    )
                                                    .animate(
                                                      onPlay: (c) => c.repeat(
                                                        reverse: true,
                                                      ),
                                                    )
                                                    .fade(
                                                      begin: 0.4,
                                                      end: 1.0,
                                                      duration: 1000.ms,
                                                    )
                                              else
                                                ...gameplayState.trickPile.map((
                                                  play,
                                                ) {
                                                  final playerId = int.parse(
                                                    play['player_id']
                                                        .toString(),
                                                  );
                                                  final card =
                                                      play['card'] as String;

                                                  final seatPlayer = match
                                                      .players
                                                      .firstWhere(
                                                        (p) =>
                                                            p.userId ==
                                                            playerId,
                                                        orElse: () =>
                                                            match.players.first,
                                                      );
                                                  final relSeat =
                                                      (seatPlayer.seatPosition -
                                                          mySeat +
                                                          totalPlayers) %
                                                      totalPlayers;

                                                  // Calculate radial layout coordinates for trick pile card stack
                                                  final angle =
                                                      -pi / 2 +
                                                      (relSeat *
                                                          2 *
                                                          pi /
                                                          totalPlayers);
                                                  final cardX =
                                                      cos(angle) * 32.0;
                                                  final cardY =
                                                      sin(angle) * 32.0;

                                                  return Transform.translate(
                                                    offset: Offset(
                                                      cardX,
                                                      cardY,
                                                    ),
                                                    child: Transform.rotate(
                                                      angle: angle + pi / 2,
                                                      child: PlayingCardWidget(
                                                        cardCode: card,
                                                        width: 52,
                                                        height: 76,
                                                      ),
                                                    ),
                                                  ).animate().slide(
                                                    begin: Offset(
                                                      cos(angle) * 2,
                                                      sin(angle) * 2,
                                                    ),
                                                    end: Offset.zero,
                                                    duration: 400.ms,
                                                    curve: Curves.easeOutQuad,
                                                  );
                                                }),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                // Player Avatars distributed around the table
                                ...match.players.map((player) {
                                  final relSeat =
                                      (player.seatPosition -
                                          mySeat +
                                          totalPlayers) %
                                      totalPlayers;
                                  final alignment =
                                      _getAlignmentForRelativeSeat(
                                        relSeat,
                                        totalPlayers,
                                      );
                                  final isTurn =
                                      gameplayState.currentTurn ==
                                      player.userId;
                                  final cardCount =
                                      player.userId == currentUserId
                                      ? gameplayState.myHand.length
                                      : (gameplayState.cardCounts[player
                                                .userId] ??
                                            0);
                                  final username =
                                      gameplayState.playerNames[player
                                          .userId] ??
                                      'Player';
                                  final avatarUrl = gameplayState
                                      .playerAvatars[player.userId];
                                  final isSafe = player.finalRank != null;
                                  final isDisconnected = gameplayState
                                      .disconnectedPlayers
                                      .contains(player.userId);

                                  // Do not display local user twice (we render hand area below)
                                  if (relSeat == 0) {
                                    return const SizedBox();
                                  }

                                  return Align(
                                        alignment: alignment,
                                        child: _buildPlayerAvatar(
                                          username: username,
                                          avatarUrl: avatarUrl,
                                          cardCount: cardCount,
                                          isTurn: isTurn,
                                          isSafe: isSafe,
                                          rank: player.finalRank,
                                          timeoutSeconds:
                                              gameplayState.timeoutSeconds,
                                          isDisconnected: isDisconnected,
                                        ),
                                      )
                                      .animate()
                                      .fade(duration: 500.ms)
                                      .slide(
                                        begin: alignment.y > 0
                                            ? const Offset(0, 0.5)
                                            : (alignment.y < 0
                                                  ? const Offset(0, -0.5)
                                                  : Offset(
                                                      alignment.x > 0
                                                          ? 0.5
                                                          : -0.5,
                                                      0,
                                                    )),
                                        curve: Curves.easeOut,
                                      );
                                }),
                              ],
                            );
                          },
                        ),
                      ),

                      // Player Hand & Status Area at the bottom
                      _buildBottomHandArea(gameplayState, isMeSafe),
                    ],
                  ),

                  // Spectator Overlay (Safe! banner)
                  if (isMeSafe)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black45,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.success,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'YOU ARE SAFE!',
                                  style: AppTextStyles.headlineMedium.copyWith(
                                    color: AppColors.success,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Rank: #${myMatchPlayer.finalRank}',
                                  style: AppTextStyles.titleMedium.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Spectating remaining players...',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: Colors.white60,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Winner Confetti celebration
                  if (isMeSafe || (isGameOver && !isMeDonkey))
                    const WinnerConfetti(),

                  // Game Over Donkey animation screen
                  if (isGameOver)
                    Positioned.fill(
                      child: DonkeyAnimation(
                        donkeyName: gameplayState.donkeyName ?? 'Donkey',
                        isMe: isMeDonkey,
                        onExit: () {
                          context.go('/home');
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Header Bar
  Widget _buildHeader(MatchModel match, GameplayState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => context.go('/home'),
          ),
          Column(
            children: [
              Text(
                'KAZHUTHA KALI',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Room: ${match.room.code}  |  Wager: ${match.room.id}', // Wait, bet coins isn't directly on Room model, we show Code
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white60),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.sync, color: Colors.white70),
                tooltip: 'Force Sync',
                onPressed: () {
                  ref.read(gameplayProvider(match.id).notifier).reconnectGame();
                },
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.style, size: 16, color: AppColors.gold),
                    const SizedBox(width: 6),
                    Text(
                      'Trick: ${state.currentTrick}',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Active Timer Avatar Widget
  Widget _buildPlayerAvatar({
    required String username,
    required String? avatarUrl,
    required int cardCount,
    required bool isTurn,
    required bool isSafe,
    required int? rank,
    required int timeoutSeconds,
    bool isDisconnected = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Turn Timer Ring Animation
            if (isTurn && !isSafe)
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 1.0, end: 0.0),
                duration: Duration(seconds: timeoutSeconds),
                builder: (context, value, child) {
                  return SizedBox(
                    width: 74,
                    height: 74,
                    child: CircularProgressIndicator(
                      value: value,
                      strokeWidth: 4,
                      color: AppColors.primary,
                      backgroundColor: Colors.white10,
                    ),
                  );
                },
              ),

            // Actual Avatar representation
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDisconnected
                      ? Colors.orange
                      : (isSafe
                            ? AppColors.success
                            : (isTurn ? AppColors.primary : Colors.white24)),
                  width: 2,
                ),
                boxShadow: [
                  if (isTurn)
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: ClipOval(
                child: avatarUrl != null && avatarUrl.isNotEmpty
                    ? Image.network(avatarUrl, fit: BoxFit.cover)
                    : Container(
                        color: Colors.white10,
                        child: Center(
                          child: Text(
                            username.isNotEmpty
                                ? username[0].toUpperCase()
                                : 'P',
                            style: AppTextStyles.titleLarge.copyWith(
                              color: isDisconnected
                                  ? Colors.orange
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
              ),
            ),

            // Safe overlay badge
            if (isSafe)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '#$rank',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            // Disconnected indicator badge
            if (isDisconnected && !isSafe)
              const Positioned(
                top: 0,
                right: 0,
                child: Icon(Icons.wifi_off, color: Colors.orange, size: 14),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          username,
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.white,
            fontWeight: isTurn ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        if (!isSafe) ...[
          const SizedBox(height: 2),
          Text(
            '$cardCount cards',
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white60,
              fontSize: 10,
            ),
          ),
        ],
      ],
    );
  }

  // Bottom hand UI area
  Widget _buildBottomHandArea(GameplayState state, bool isMeSafe) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black26,
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // User Turn Alert / Suit Alert
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 4.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isMeSafe
                      ? 'SPECTATOR MODE'
                      : (state.isMyTurn
                            ? 'YOUR TURN TO PLAY'
                            : "WAITING FOR OTHERS' TURNS"),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: state.isMyTurn ? AppColors.primary : Colors.white38,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                if (state.leadingSuit != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      'Suit Lead: ${state.leadingSuit}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // User Card Hand Slider
          SizedBox(
            height: 110,
            child: state.myHand.isEmpty
                ? Center(
                    child: Text(
                      isMeSafe ? 'Exited!' : 'No Cards Dealt',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white38,
                      ),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    // Use sortedHand for display — engine-sorted by suit then rank
                    itemCount: state.sortedHand.isNotEmpty
                        ? state.sortedHand.length
                        : state.myHand.length,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemBuilder: (context, index) {
                      final hand = state.sortedHand.isNotEmpty
                          ? state.sortedHand
                          : state.myHand;
                      final cardCode = hand[index];
                      // Use engine-computed playable cards list
                      final isPlayable =
                          state.isCardPlayable(cardCode) && !isMeSafe;

                      // OVERLAPPING HORIZONTAL CARDS fan-out effect
                      return Align(
                        widthFactor: index == hand.length - 1 ? 1.0 : 0.65,
                        alignment: Alignment.centerLeft,
                        child: Draggable<String>(
                          data: cardCode,
                          maxSimultaneousDrags: isPlayable ? 1 : 0,
                          feedback: Material(
                            color: Colors.transparent,
                            child: PlayingCardWidget(
                              cardCode: cardCode,
                              width: 76,
                              height: 112,
                              isPlayable: true,
                            ),
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.3,
                            child: PlayingCardWidget(
                              cardCode: cardCode,
                              isPlayable: false,
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              if (isPlayable) {
                                _playCard(cardCode);
                              }
                            },
                            child:
                                PlayingCardWidget(
                                  cardCode: cardCode,
                                  isPlayable: isPlayable,
                                ).animate().slideY(
                                  begin: 0.5,
                                  end: 0.0,
                                  duration: 300.ms,
                                  delay: (index * 40).ms,
                                  curve: Curves.easeOut,
                                ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Action methods
  void _playCard(String cardCode) {
    ref
        .read(gameplayProvider(widget.matchId).notifier)
        .playCard(cardCode)
        .catchError((err) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cannot play card: $err'),
              backgroundColor: AppColors.error,
            ),
          );
        });
  }

  // Positioning mapper helper (Trigonometry layout & Alignment bounds)
  Alignment _getAlignmentForRelativeSeat(int relativeSeat, int total) {
    if (relativeSeat == 0) return Alignment.bottomCenter;
    if (total == 2) {
      return Alignment.topCenter;
    }
    if (total == 3) {
      return relativeSeat == 1 ? Alignment.topLeft : Alignment.topRight;
    }
    if (total == 4) {
      switch (relativeSeat) {
        case 1:
          return Alignment.centerLeft;
        case 2:
          return Alignment.topCenter;
        case 3:
          return Alignment.centerRight;
      }
    }
    // Generic unit circle mapper for larger games
    final angle = pi / 2 - (relativeSeat * 2 * pi / total);
    return Alignment(cos(angle) * 0.95, sin(angle) * 0.95);
  }
}
