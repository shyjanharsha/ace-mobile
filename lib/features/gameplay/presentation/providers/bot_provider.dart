import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../data/models/game_data_models.dart';
import '../../data/repositories/gameplay_repository.dart';
import '../../domain/engine/game_engine.dart';
import '../../domain/engine/bot_engine.dart';
import 'gameplay_providers.dart';

/// Configuration for a bot-controlled player slot in this match.
class BotConfig {
  const BotConfig({
    required this.userId,
    required this.difficulty,
    required this.name,
  });

  final int userId;
  final BotDifficulty difficulty;
  final String name;
}

/// State for the BotManager.
class BotState {
  final List<BotConfig> bots;
  final bool isThinkingForBot;
  final int? thinkingBotId;

  const BotState({
    required this.bots,
    required this.isThinkingForBot,
    this.thinkingBotId,
  });

  bool isBotPlayer(int userId) => bots.any((b) => b.userId == userId);

  BotConfig? configFor(int userId) {
    try {
      return bots.firstWhere((b) => b.userId == userId);
    } catch (_) {
      return null;
    }
  }
}

/// Bot manager as a StateNotifier-style controller.
///
/// In Riverpod 3.x, NotifierProvider.family<N, S, Arg> requires
/// the Notifier to receive arg via build(Arg arg).
class BotNotifier extends Notifier<BotState> {
  Timer? _thinkTimer;

  // Stored from build arg — Riverpod family passes this via override
  late int _matchId;
  late List<BotConfig> _bots;

  @override
  BotState build() {
    // Args are wired via the provider override below
    ref.onDispose(() => _thinkTimer?.cancel());
    return BotState(bots: _bots, isThinkingForBot: false);
  }

  void init(int matchId, List<BotConfig> bots) {
    _matchId = matchId;
    _bots = bots;
  }

  int get matchId => _matchId;

  /// Called whenever GameplayState changes — checks if a bot needs to move.
  void onGameStateChanged(GameplayState gameplayState) {
    if (!state.isThinkingForBot == false) return;  // already scheduled
    final currentTurn = gameplayState.currentTurn;
    if (currentTurn == null) return;
    if (!state.isBotPlayer(currentTurn)) return;
    if (!gameplayState.isMyTurn) return;
    if (state.isThinkingForBot) return;

    final config = state.configFor(currentTurn)!;
    _scheduleBot(config, gameplayState);
  }

  void _scheduleBot(BotConfig config, GameplayState gameplayState) {
    state = BotState(
      bots: state.bots,
      isThinkingForBot: true,
      thinkingBotId: config.userId,
    );
    final delayMs = _thinkDelayFor(config.difficulty);
    _thinkTimer?.cancel();
    _thinkTimer = Timer(Duration(milliseconds: delayMs), () async {
      await _executeBotMove(config, gameplayState);
    });
  }

  Future<void> _executeBotMove(BotConfig config, GameplayState gameplayState) async {
    try {
      final strategy = BotEngine.create(config.difficulty);
      final trickPile = gameplayState.trickPile
          .map((m) => TrickPlay.fromMap(m))
          .toList();

      final botHand = _getBotHand(config.userId, gameplayState);
      if (botHand.isEmpty) return;

      final chosenCard = GameEngine.botChooseCard(
        bot: strategy,
        hand: botHand,
        leadingSuit: gameplayState.leadingSuit,
        trickPile: trickPile,
        activePlayers: gameplayState.activePlayers,
        cardCounts: gameplayState.cardCounts,
      );

      final repo = getIt<GameplayRepository>();
      await repo.playCard(
        matchId: _matchId,
        cardCode: chosenCard,
        moveSeq: gameplayState.moveSeq,
      );
    } catch (_) {
      // Bot move failed — server timeout will handle it
    } finally {
      state = BotState(bots: state.bots, isThinkingForBot: false);
    }
  }

  /// Online mode: bot hands are on the server. Override for offline mode.
  List<String> _getBotHand(int botUserId, GameplayState gs) => const [];

  int _thinkDelayFor(BotDifficulty difficulty) {
    switch (difficulty) {
      case BotDifficulty.easy:   return 1000;
      case BotDifficulty.medium: return 1200;
      case BotDifficulty.hard:   return 1800;
    }
  }
}

/// Simple (matchId → provider) family.
/// Call .notifier.init(matchId, bots) after creation.
final botProvider = Provider.family<BotNotifier, int>((ref, matchId) {
  final notifier = BotNotifier()
    .._matchId = matchId
    .._bots = const [];
  return notifier;
});
