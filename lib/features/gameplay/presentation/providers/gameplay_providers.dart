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
import '../../../rooms/data/repositories/rooms_repository.dart';
import '../../../rooms/data/models/room_player_model.dart';

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
  StreamSubscription<WsEvent>? _subscription;

  @override
  GameplayState build() {
    ref.onDispose(() {
      _subscription?.cancel();
    });

    state = GameplayState.initial();
    _initGameplay();
    return state;
  }

  // -------------------------------------------------------
  // Init
  // -------------------------------------------------------

  Future<void> _initGameplay() async {
    final wsClient = getIt<WebSocketClient>();
    
    // Listen to events immediately to avoid dropping events from ActionCable
    // that might arrive while _fetchMatch is executing.
    _subscription = wsClient.eventStream.listen(_handleGameEvent);

    await _fetchMatch();

    wsClient.subscribeToGame(matchId);
  }

  Future<void> _fetchMatch() async {
    try {
      final repository = ref.read(gameplayRepositoryProvider);
      final matchModel = await repository.getMatch(matchId);

      final roomsRepo = getIt<RoomsRepository>();
      final roomModel = await roomsRepo.getRoom(matchModel.room.id);

      final names = <int, String>{};
      final avatars = <int, String?>{};
      for (final p in roomModel.players ?? <RoomPlayerModel>[]) {
        names[p.userId] = p.username;
        avatars[p.userId] = p.avatarUrl;
      }

      state = state.copyWith(
        match: AsyncValue.data(matchModel),
        playerNames: names,
        playerAvatars: avatars,
      );
    } catch (e, stack) {
      state = state.copyWith(match: AsyncValue.error(e, stack));
    }
  }

  // -------------------------------------------------------
  // Event routing
  // -------------------------------------------------------

  void _handleGameEvent(WsEvent event) {
    if (!event.isGameEvent &&
        event.type != WsEventTypes.reconnectedState &&
        event.type != WsEventTypes.playerReconnected) {
      return;
    }

    final data = event.data;
    final currentUserId = ref.read(authStateProvider).value?.user?.id;

    try {
      switch (event.type) {

      // ---------------------------------------------------
      // Cards dealt to this player
      // ---------------------------------------------------
      case WsEventTypes.dealCards:
        final hand = List<String>.from(data['hand'] as List? ?? []);
        final sorted = GameEngine.sortHand(hand);
        final counts = Map<int, int>.from(state.cardCounts);
        if (currentUserId != null) counts[currentUserId] = hand.length;
        state = state.copyWith(
          myHand: hand,
          sortedHand: sorted,
          playableCards: const [],
          timeoutSeconds: 30,
          cardCounts: counts,
        );
        break;

      // ---------------------------------------------------
      // Game started — first turn assigned
      // ---------------------------------------------------
      case WsEventTypes.gameStarted:
        final firstPlayerId = data['first_player_id'] as int?;
        final orderRaw = data['player_order'] as List? ?? [];
        final order = orderRaw.map((e) => int.parse(e.toString())).toList();
        final cardsPerPlayer = data['cards_per_player'] as int? ?? 13;
        final initialCounts = {for (final id in order) id: cardsPerPlayer};

        final isMyTurn = firstPlayerId == currentUserId;
        final playable = isMyTurn
            ? GameEngine.getPlayableCards(
                hand: state.myHand,
                leadingSuit: null,
                isMyTurn: true,
              )
            : <String>[];

        state = state.copyWith(
          currentTurn: firstPlayerId,
          isMyTurn: isMyTurn,
          playerOrder: order,
          activePlayers: order,
          cardCounts: initialCounts,
          playableCards: playable,
        );
        break;

      // ---------------------------------------------------
      // My turn — server telling us to move
      // ---------------------------------------------------
      case WsEventTypes.yourTurn:
        final leadingSuit = data['leading_suit'] as String?;
        final trickPileRaw = data['trick_pile'] as List? ?? [];
        final trickPile = trickPileRaw
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();

        final playable = GameEngine.getPlayableCards(
          hand: state.myHand,
          leadingSuit: leadingSuit,
          isMyTurn: true,
        );

        state = state.copyWith(
          currentTurn: currentUserId,
          isMyTurn: true,
          leadingSuit: leadingSuit,
          trickPile: trickPile,
          timeoutSeconds: data['timeout_seconds'] as int? ?? 30,
          moveSeq: data['move_seq'] as int? ?? state.moveSeq,
          playableCards: playable,
        );
        break;

      // ---------------------------------------------------
      // A card was played by any player
      // ---------------------------------------------------
      case WsEventTypes.cardPlayed:
        final playedCard = data['card'] as String;
        final playerId = int.parse(data['player_id'].toString());
        final trickPileRaw = data['trick_pile'] as List? ?? [];
        final trickPile = trickPileRaw
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();

        // Update local hand if it was my card
        List<String> newHand = state.myHand;
        List<String> newSorted = state.sortedHand;
        if (playerId == currentUserId) {
          newHand = List<String>.from(state.myHand)..remove(playedCard);
          newSorted = GameEngine.sortHand(newHand);
        }

        // Update card count
        final counts = Map<int, int>.from(state.cardCounts);
        if (counts.containsKey(playerId)) {
          counts[playerId] = (counts[playerId]! - 1).clamp(0, 52);
        }

        // Calculate next turn clockwise (client-side estimate until yourTurn arrives)
        final finished = state.finishedPlayers;
        final order = state.playerOrder.isNotEmpty
            ? state.playerOrder
            : (state.match.value?.players.map((p) => p.userId).toList() ?? []);
        final active = order.where((id) => !finished.contains(id)).toList();

        int? nextTurn;
        if (active.isNotEmpty && active.contains(playerId)) {
          nextTurn = GameEngine.nextPlayer(
            currentId: playerId,
            playerOrder: order,
            activePlayers: active,
          );
        }

        state = state.copyWith(
          myHand: newHand,
          sortedHand: newSorted,
          trickPile: trickPile,
          moveSeq: data['move_seq'] as int? ?? state.moveSeq,
          currentTurn: nextTurn ?? state.currentTurn,
          isMyTurn: nextTurn == currentUserId,
          cardCounts: counts,
          // Clear playable cards when it's no longer our turn
          playableCards: nextTurn == currentUserId ? state.playableCards : const [],
          clearError: true,
        );
        break;

      // ---------------------------------------------------
      // Trick resolved (winner or cut)
      // ---------------------------------------------------
      case WsEventTypes.trickComplete:
        final nextLeaderId = int.parse(data['next_leader_id'].toString());
        final wasCut = data['was_cut'] as bool? ?? false;
        final penalizedId = data['penalized_player_id'] != null
            ? int.parse(data['penalized_player_id'].toString())
            : null;

        // If cut happened, add pile cards to penalized player's count
        final counts = Map<int, int>.from(state.cardCounts);
        if (wasCut && penalizedId != null) {
          final pileSize = state.trickPile.length;
          counts[penalizedId] = (counts[penalizedId] ?? 0) + pileSize;
        }

        state = state.copyWith(
          currentTurn: nextLeaderId,
          isMyTurn: nextLeaderId == currentUserId,
          clearLeadingSuit: true,
          trickPile: const [],
          currentTrick: data['trick_number'] as int? ?? state.currentTrick,
          cardCounts: counts,
          playableCards: nextLeaderId == currentUserId
              ? GameEngine.getPlayableCards(
                  hand: state.myHand,
                  leadingSuit: null,
                  isMyTurn: true,
                )
              : const [],
        );
        break;

      // ---------------------------------------------------
      // Cut event — penalized player collects pile
      // ---------------------------------------------------
      case WsEventTypes.playerCut:
        final penalizedId = int.parse(data['penalized_id'].toString());
        final pileSize = data['pile_size'] as int? ?? state.trickPile.length;

        final counts = Map<int, int>.from(state.cardCounts);
        counts[penalizedId] = (counts[penalizedId] ?? 0) + pileSize;

        state = state.copyWith(cardCounts: counts);
        break;

      // ---------------------------------------------------
      // Player eliminated (emptied their hand)
      // ---------------------------------------------------
      case WsEventTypes.playerFinished:
        final finishedUserId = int.parse(data['user_id'].toString());

        final updatedFinished = List<int>.from(state.finishedPlayers);
        if (!updatedFinished.contains(finishedUserId)) {
          updatedFinished.add(finishedUserId);
        }

        final updatedActive = List<int>.from(state.activePlayers)
          ..remove(finishedUserId);

        // Update rank in match model
        final counts = Map<int, int>.from(state.cardCounts);
        counts[finishedUserId] = 0;

        state = state.copyWith(
          finishedPlayers: updatedFinished,
          activePlayers: updatedActive,
          cardCounts: counts,
        );

        // Check if the local user just finished
        if (finishedUserId == currentUserId) {
          state = state.copyWith(isMyTurn: false, playableCards: const []);
        }
        break;

      // ---------------------------------------------------
      // Game over — donkey determined
      // ---------------------------------------------------
      case WsEventTypes.gameOver:
        final donkeyId = int.parse(data['donkey_id'].toString());
        final donkeyName = data['donkey_name'] as String;
        final ranksList = List<Map<String, dynamic>>.from(
            data['final_ranks'] as List? ?? []);

        state = state.copyWith(
          donkeyId: donkeyId,
          donkeyName: donkeyName,
          finalRanks: ranksList,
          isMyTurn: false,
          playableCards: const [],
        );
        _fetchMatch(); // Refresh final scores from server
        break;

      // ---------------------------------------------------
      // Player disconnected
      // ---------------------------------------------------
      case WsEventTypes.playerDisconnected:
        final disconnectedId = int.parse(data['user_id'].toString());
        final updated = Set<int>.from(state.disconnectedPlayers)
          ..add(disconnectedId);
        state = state.copyWith(disconnectedPlayers: updated);
        break;

      // ---------------------------------------------------
      // Player reconnected
      // ---------------------------------------------------
      case WsEventTypes.playerReconnected:
        final rId = int.parse(data['user_id'].toString());
        final rCount = data['hand_count'] as int? ?? 0;

        final counts = Map<int, int>.from(state.cardCounts);
        counts[rId] = rCount;

        final disconnected = Set<int>.from(state.disconnectedPlayers)
          ..remove(rId);

        state = state.copyWith(
          cardCounts: counts,
          disconnectedPlayers: disconnected,
        );
        break;

      // ---------------------------------------------------
      // Move timeout — server auto-played a card
      // ---------------------------------------------------
      case WsEventTypes.moveTimeout:
        final timedOutUserId = data['user_id'] != null
            ? int.parse(data['user_id'].toString())
            : null;
        final autoCard = data['card_played'] as String?;

        // If it was our timeout, clear isMyTurn
        if (timedOutUserId == currentUserId) {
          List<String> newHand = state.myHand;
          List<String> newSorted = state.sortedHand;
          if (autoCard != null) {
            newHand = List<String>.from(state.myHand)..remove(autoCard);
            newSorted = GameEngine.sortHand(newHand);
          }
          state = state.copyWith(
            isMyTurn: false,
            playableCards: const [],
            myHand: newHand,
            sortedHand: newSorted,
          );
        }
        break;

      // ---------------------------------------------------
      // Full reconnect resync
      // ---------------------------------------------------
      case WsEventTypes.reconnectedState:
        final hand = List<String>.from(data['hand'] as List? ?? []);
        final sorted = GameEngine.sortHand(hand);
        final activeRaw = data['active_players'] as List? ?? [];
        final activeList = activeRaw.map((e) => int.parse(e.toString())).toList();
        final orderRaw = data['player_order'] as List? ?? [];
        final orderList = orderRaw.map((e) => int.parse(e.toString())).toList();
        final isMyTurn = data['is_my_turn'] as bool? ?? false;
        final currentTurnRaw = data['current_turn'];
        final currentTurn = currentTurnRaw != null ? int.parse(currentTurnRaw.toString()) : state.currentTurn;
        final leadingSuit = data['leading_suit'] as String?;

        final trickPileRaw = data['trick_pile'] as List? ?? [];
        final trickPile = trickPileRaw
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();

        final serverCounts = data['card_counts'] as Map? ?? {};
        final counts = <int, int>{};
        for (final entry in serverCounts.entries) {
          counts[int.parse(entry.key.toString())] = entry.value as int;
        }

        final playable = isMyTurn
            ? GameEngine.getPlayableCards(
                hand: hand,
                leadingSuit: leadingSuit,
                isMyTurn: true,
              )
            : <String>[];

        state = state.copyWith(
          myHand: hand,
          sortedHand: sorted,
          leadingSuit: leadingSuit,
          trickPile: trickPile,
          isMyTurn: isMyTurn,
          currentTurn: currentTurn,
          currentTrick: data['current_trick'] as int? ?? 1,
          activePlayers: activeList,
          playerOrder: orderList.isNotEmpty ? orderList : state.playerOrder,
          moveSeq: data['move_seq'] as int? ?? 0,
          timeoutSeconds: data['timeout_seconds'] as int? ?? 30,
          cardCounts: counts,
          playableCards: playable,
          isReconnecting: false,
        );
        break;
      }
    } catch (e, stack) {
      print('ERROR PARSING WS EVENT: ${event.type} -> $e');
      print(stack);
    }
  }

  // -------------------------------------------------------
  // Actions
  // -------------------------------------------------------

  /// Play a card. Pre-validates client-side then submits to server.
  Future<void> playCard(String cardCode) async {
    // Client-side validation for immediate UX feedback
    final validation = GameEngine.validateMove(
      hand: state.myHand,
      cardCode: cardCode,
      leadingSuit: state.leadingSuit,
      isMyTurn: state.isMyTurn,
    );

    if (!validation.isValid) {
      state = state.copyWith(lastErrorMessage: validation.errorMessage);
      throw Exception(validation.errorMessage);
    }

    try {
      final repository = ref.read(gameplayRepositoryProvider);
      await repository.playCard(
        matchId: matchId,
        cardCode: cardCode,
        moveSeq: state.moveSeq,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Trigger reconnect — server will send reconnected_state event.
  Future<void> reconnectGame() async {
    try {
      state = state.copyWith(isReconnecting: true);
      final repository = ref.read(gameplayRepositoryProvider);
      await repository.reconnectGame(matchId);
    } finally {
      state = state.copyWith(isReconnecting: false);
    }
  }

  /// Clear last error (called after snackbar shown)
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

// -------------------------------------------------------
// Provider
// -------------------------------------------------------

final gameplayProvider =
    NotifierProvider.family<GameplayNotifier, GameplayState, int>(
  GameplayNotifier.new,
);
