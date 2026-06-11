import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/websocket/websocket_client.dart';
import '../../../../core/websocket/websocket_events.dart';
import '../../data/repositories/gameplay_repository.dart';
import '../../data/models/match_model.dart';
import '../../domain/engine/game_engine.dart';
import '../../../auth/domain/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../rooms/data/models/room_player_model.dart';
import '../../data/models/game_data_models.dart';
import '../../domain/engine/game_engines.dart';

class OfflineBotsNotifier extends Notifier<List<BotPlayerModel>> {
  @override
  List<BotPlayerModel> build() => [];
}

final offlineBotsProvider = NotifierProvider<OfflineBotsNotifier, List<BotPlayerModel>>(
  OfflineBotsNotifier.new,
);

final gameplayRepositoryProvider = Provider<GameplayRepository>(
  (ref) => getIt<GameplayRepository>(),
);

// -------------------------------------------------------
// State
// -------------------------------------------------------

class GameplayState {
  final AsyncValue<MatchModel> match;
  final List<String> myHand;
  final List<String> sortedHand;       // engine-sorted for display
  final List<String> playableCards;    // highlighted for UX
  final String? leadingSuit;
  final List<Map<String, dynamic>> trickPile; // [{ "player_id": int, "card": String }]
  final int? currentTurn;
  final int? trickLeader;
  final List<int> playerOrder;
  final List<int> activePlayers;
  final List<int> finishedPlayers;
  final Set<int> disconnectedPlayers;   // currently disconnected
  final Map<int, int> cardCounts;       // user_id → card count
  final Map<int, String> playerNames;   // user_id → username
  final Map<int, String?> playerAvatars; // user_id → avatar_url
  final int moveSeq;
  final int currentTrick;
  final int currentRound;
  final int timeoutSeconds;
  final bool isMyTurn;
  final bool isReconnecting;
  final int? donkeyId;
  final String? donkeyName;
  final List<Map<String, dynamic>> finalRanks;
  final String? lastErrorMessage;        // snackbar message for invalid move

  GameplayState({
    required this.match,
    required this.myHand,
    required this.sortedHand,
    required this.playableCards,
    this.leadingSuit,
    required this.trickPile,
    this.currentTurn,
    this.trickLeader,
    required this.playerOrder,
    required this.activePlayers,
    required this.finishedPlayers,
    required this.disconnectedPlayers,
    required this.cardCounts,
    required this.playerNames,
    required this.playerAvatars,
    required this.moveSeq,
    required this.currentTrick,
    required this.currentRound,
    required this.timeoutSeconds,
    required this.isMyTurn,
    required this.isReconnecting,
    this.donkeyId,
    this.donkeyName,
    required this.finalRanks,
    this.lastErrorMessage,
  });

  factory GameplayState.initial() => GameplayState(
        match: const AsyncValue.loading(),
        myHand: const [],
        sortedHand: const [],
        playableCards: const [],
        trickPile: const [],
        playerOrder: const [],
        activePlayers: const [],
        finishedPlayers: const [],
        disconnectedPlayers: const {},
        cardCounts: const {},
        playerNames: const {},
        playerAvatars: const {},
        moveSeq: 0,
        currentTrick: 1,
        currentRound: 1,
        timeoutSeconds: 30,
        isMyTurn: false,
        isReconnecting: false,
        finalRanks: const [],
      );

  GameplayState copyWith({
    AsyncValue<MatchModel>? match,
    List<String>? myHand,
    List<String>? sortedHand,
    List<String>? playableCards,
    String? leadingSuit,
    bool clearLeadingSuit = false,
    List<Map<String, dynamic>>? trickPile,
    int? currentTurn,
    int? trickLeader,
    List<int>? playerOrder,
    List<int>? activePlayers,
    List<int>? finishedPlayers,
    Set<int>? disconnectedPlayers,
    Map<int, int>? cardCounts,
    Map<int, String>? playerNames,
    Map<int, String?>? playerAvatars,
    int? moveSeq,
    int? currentTrick,
    int? currentRound,
    int? timeoutSeconds,
    bool? isMyTurn,
    bool? isReconnecting,
    int? donkeyId,
    String? donkeyName,
    List<Map<String, dynamic>>? finalRanks,
    String? lastErrorMessage,
    bool clearError = false,
  }) {
    return GameplayState(
      match: match ?? this.match,
      myHand: myHand ?? this.myHand,
      sortedHand: sortedHand ?? this.sortedHand,
      playableCards: playableCards ?? this.playableCards,
      leadingSuit: clearLeadingSuit ? null : (leadingSuit ?? this.leadingSuit),
      trickPile: trickPile ?? this.trickPile,
      currentTurn: currentTurn ?? this.currentTurn,
      trickLeader: trickLeader ?? this.trickLeader,
      playerOrder: playerOrder ?? this.playerOrder,
      activePlayers: activePlayers ?? this.activePlayers,
      finishedPlayers: finishedPlayers ?? this.finishedPlayers,
      disconnectedPlayers: disconnectedPlayers ?? this.disconnectedPlayers,
      cardCounts: cardCounts ?? this.cardCounts,
      playerNames: playerNames ?? this.playerNames,
      playerAvatars: playerAvatars ?? this.playerAvatars,
      moveSeq: moveSeq ?? this.moveSeq,
      currentTrick: currentTrick ?? this.currentTrick,
      currentRound: currentRound ?? this.currentRound,
      timeoutSeconds: timeoutSeconds ?? this.timeoutSeconds,
      isMyTurn: isMyTurn ?? this.isMyTurn,
      isReconnecting: isReconnecting ?? this.isReconnecting,
      donkeyId: donkeyId ?? this.donkeyId,
      donkeyName: donkeyName ?? this.donkeyName,
      finalRanks: finalRanks ?? this.finalRanks,
      lastErrorMessage: clearError ? null : (lastErrorMessage ?? this.lastErrorMessage),
    );
  }

  /// Derived: is the local user already safe (finished)?
  bool isUserSafe(int? userId) =>
      userId != null && finishedPlayers.contains(userId);

  /// Derived: is this specific card playable right now?
  bool isCardPlayable(String cardCode) => playableCards.contains(cardCode);
}

// -------------------------------------------------------
// Notifier
// -------------------------------------------------------

class GameplayNotifier extends Notifier<GameplayState> {
  GameplayNotifier(this.matchId);
  final int matchId;
  late final IGameEngine _engine;
  StreamSubscription? _sub;

  @override
  GameplayState build() {
    if (matchId < 0) {
      final bots = ref.read(offlineBotsProvider);
      final humanId = ref.read(authStateProvider).value?.user?.id ?? 999;
      _engine = OfflineGameEngine(matchId, bots, humanId);
    } else {
      _engine = OnlineGameEngine(matchId, ref);
    }

    ref.onDispose(() {
      _sub?.cancel();
      _engine.dispose();
    });

    _sub = _engine.stateStream.listen((newState) {
      state = newState;
    });

    state = _engine.state;
    _engine.init();
    return state;
  }

  Future<void> playCard(String cardCode) => _engine.playCard(cardCode);
  Future<void> reconnectGame() => _engine.reconnectGame();
  void clearError() => _engine.clearError();
}

// -------------------------------------------------------
// Provider
// -------------------------------------------------------

final gameplayProvider =
    NotifierProvider.family<GameplayNotifier, GameplayState, int>(
  GameplayNotifier.new,
);
