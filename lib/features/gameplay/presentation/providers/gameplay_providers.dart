import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/websocket/websocket_client.dart';
import '../../../../core/websocket/websocket_events.dart';
import '../../data/repositories/gameplay_repository.dart';
import '../../data/models/match_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/domain/auth_state.dart';
import '../../../rooms/data/repositories/rooms_repository.dart';
import '../../../rooms/data/models/room_player_model.dart';

final gameplayRepositoryProvider = Provider<GameplayRepository>(
  (ref) => getIt<GameplayRepository>(),
);

class GameplayState {
  final AsyncValue<MatchModel> match;
  final List<String> myHand;
  final String? leadingSuit;
  final List<Map<String, dynamic>> trickPile; // [{ "player_id": int, "card": String }]
  final int? currentTurn;
  final int? trickLeader;
  final List<int> playerOrder;
  final List<int> activePlayers;
  final List<int> finishedPlayers;
  final Map<int, int> cardCounts; // user_id -> card count
  final Map<int, String> playerNames; // user_id -> username
  final Map<int, String?> playerAvatars; // user_id -> avatar_url
  final int moveSeq;
  final int currentTrick;
  final int currentRound;
  final int timeoutSeconds;
  final bool isMyTurn;
  final bool isReconnecting;
  final int? donkeyId;
  final String? donkeyName;
  final List<Map<String, dynamic>> finalRanks; // [{ "user_id": int, "rank": int, "is_donkey": bool }]

  GameplayState({
    required this.match,
    required this.myHand,
    this.leadingSuit,
    required this.trickPile,
    this.currentTurn,
    this.trickLeader,
    required this.playerOrder,
    required this.activePlayers,
    required this.finishedPlayers,
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
  });

  GameplayState copyWith({
    AsyncValue<MatchModel>? match,
    List<String>? myHand,
    String? leadingSuit,
    List<Map<String, dynamic>>? trickPile,
    int? currentTurn,
    int? trickLeader,
    List<int>? playerOrder,
    List<int>? activePlayers,
    List<int>? finishedPlayers,
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
  }) {
    return GameplayState(
      match: match ?? this.match,
      myHand: myHand ?? this.myHand,
      leadingSuit: leadingSuit ?? this.leadingSuit,
      trickPile: trickPile ?? this.trickPile,
      currentTurn: currentTurn ?? this.currentTurn,
      trickLeader: trickLeader ?? this.trickLeader,
      playerOrder: playerOrder ?? this.playerOrder,
      activePlayers: activePlayers ?? this.activePlayers,
      finishedPlayers: finishedPlayers ?? this.finishedPlayers,
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
    );
  }
}

class GameplayNotifier extends Notifier<GameplayState> {
  GameplayNotifier(this.matchId);
  final int matchId;
  StreamSubscription<WsEvent>? _subscription;

  @override
  GameplayState build() {
    ref.onDispose(() {
      _subscription?.cancel();
    });

    state = GameplayState(
      match: const AsyncValue.loading(),
      myHand: [],
      trickPile: [],
      playerOrder: [],
      activePlayers: [],
      finishedPlayers: [],
      cardCounts: const {},
      playerNames: const {},
      playerAvatars: const {},
      moveSeq: 0,
      currentTrick: 1,
      currentRound: 1,
      timeoutSeconds: 30,
      isMyTurn: false,
      isReconnecting: false,
      finalRanks: [],
    );

    _initGameplay();

    return state;
  }

  Future<void> _initGameplay() async {
    // 1. Fetch match details via HTTP
    await _fetchMatch();

    // 2. Subscribe to WebSocket GameChannel
    final wsClient = getIt<WebSocketClient>();
    wsClient.subscribeToGame(matchId);

    // 3. Listen to ActionCable events
    _subscription = wsClient.eventStream.listen((event) {
      _handleGameEvent(event);
    });
  }

  Future<void> _fetchMatch() async {
    try {
      final repository = ref.read(gameplayRepositoryProvider);
      final matchModel = await repository.getMatch(matchId);

      // Fetch room details to get usernames and avatars
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

  void _handleGameEvent(WsEvent event) {
    // Only handle gameplay events
    if (!event.isGameEvent &&
        event.type != WsEventTypes.reconnectedState &&
        event.type != WsEventTypes.playerReconnected) {
      return;
    }

    final data = event.data;
    final currentUserId = ref.read(authStateProvider).value?.user?.id;

    switch (event.type) {
      case WsEventTypes.dealCards:
        final hand = List<String>.from(data['hand'] as List? ?? []);
        final currentCounts = Map<int, int>.from(state.cardCounts);
        if (currentUserId != null) {
          currentCounts[currentUserId] = hand.length;
        }
        state = state.copyWith(
          myHand: hand,
          timeoutSeconds: 30,
          cardCounts: currentCounts,
        );
        break;

      case WsEventTypes.gameStarted:
        final firstPlayerId = data['first_player_id'] as int?;
        final orderRaw = data['player_order'] as List? ?? [];
        final order = orderRaw.map((e) => int.parse(e.toString())).toList();
        final cardsPerPlayer = data['cards_per_player'] as int? ?? 13;
        final initialCounts = {for (var id in order) id: cardsPerPlayer};
        state = state.copyWith(
          currentTurn: firstPlayerId,
          isMyTurn: firstPlayerId == currentUserId,
          playerOrder: order,
          activePlayers: order,
          cardCounts: initialCounts,
        );
        break;

      case WsEventTypes.yourTurn:
        state = state.copyWith(
          currentTurn: currentUserId,
          isMyTurn: true,
          leadingSuit: data['leading_suit'] as String?,
          trickPile: List<Map<String, dynamic>>.from(data['trick_pile'] as List? ?? []),
          timeoutSeconds: data['timeout_seconds'] as int? ?? 30,
          moveSeq: data['move_seq'] as int? ?? state.moveSeq,
        );
        break;

      case WsEventTypes.cardPlayed:
        final playedCard = data['card'] as String;
        final playerId = int.parse(data['player_id'].toString());

        // If it was my card, remove it from hand
        if (playerId == currentUserId) {
          final newHand = List<String>.from(state.myHand)..remove(playedCard);
          state = state.copyWith(myHand: newHand);
        }

        // Decrement card count for player
        final currentCounts = Map<int, int>.from(state.cardCounts);
        if (currentCounts.containsKey(playerId)) {
          currentCounts[playerId] = (currentCounts[playerId]! - 1).clamp(0, 52);
        }

        // Client-side turn calculation to next active player
        int? nextTurn;
        final order = state.playerOrder.isNotEmpty
            ? state.playerOrder
            : (state.match.value?.players.map((p) => p.userId).toList() ?? []);
        final finished = state.finishedPlayers;
        final active = order.where((id) => !finished.contains(id)).toList();

        if (active.isNotEmpty) {
          final idx = active.indexOf(playerId);
          if (idx != -1) {
            nextTurn = active[(idx + 1) % active.length];
          }
        }

        state = state.copyWith(
          trickPile: List<Map<String, dynamic>>.from(data['trick_pile'] as List? ?? []),
          moveSeq: data['move_seq'] as int? ?? state.moveSeq,
          currentTurn: nextTurn ?? state.currentTurn,
          isMyTurn: nextTurn == currentUserId,
          cardCounts: currentCounts,
        );
        break;

      case WsEventTypes.trickComplete:
        final nextLeaderId = int.parse(data['next_leader_id'].toString());
        state = state.copyWith(
          currentTurn: nextLeaderId,
          isMyTurn: nextLeaderId == currentUserId,
          leadingSuit: null,
          trickPile: [],
          currentTrick: data['trick_number'] as int? ?? state.currentTrick,
        );
        break;

      case WsEventTypes.playerFinished:
        final finishedUserId = int.parse(data['user_id'].toString());
        final updatedFinished = List<int>.from(state.finishedPlayers);
        if (!updatedFinished.contains(finishedUserId)) {
          updatedFinished.add(finishedUserId);
        }
        state = state.copyWith(finishedPlayers: updatedFinished);
        break;

      case WsEventTypes.gameOver:
        final donkeyId = int.parse(data['donkey_id'].toString());
        final donkeyName = data['donkey_name'] as String;
        final ranksList = List<Map<String, dynamic>>.from(data['final_ranks'] as List? ?? []);
        state = state.copyWith(
          donkeyId: donkeyId,
          donkeyName: donkeyName,
          finalRanks: ranksList,
        );
        _fetchMatch(); // Refresh final scores
        break;

      case WsEventTypes.playerReconnected:
        final rId = int.parse(data['user_id'].toString());
        final rCount = data['hand_count'] as int? ?? 0;
        final reCounts = Map<int, int>.from(state.cardCounts);
        reCounts[rId] = rCount;
        state = state.copyWith(cardCounts: reCounts);
        break;

      case WsEventTypes.reconnectedState:
        final activeRaw = data['active_players'] as List? ?? [];
        final activeList = activeRaw.map((e) => int.parse(e.toString())).toList();
        final currentCounts = Map<int, int>.from(state.cardCounts);
        if (currentUserId != null) {
          currentCounts[currentUserId] = (data['hand'] as List? ?? []).length;
        }

        state = state.copyWith(
          myHand: List<String>.from(data['hand'] as List? ?? []),
          leadingSuit: data['leading_suit'] as String?,
          trickPile: List<Map<String, dynamic>>.from(data['trick_pile'] as List? ?? []),
          isMyTurn: data['is_my_turn'] as bool? ?? false,
          currentTurn: (data['is_my_turn'] as bool? ?? false) ? currentUserId : null,
          currentTrick: data['current_trick'] as int? ?? 1,
          activePlayers: activeList,
          moveSeq: data['move_seq'] as int? ?? 0,
          timeoutSeconds: data['timeout_seconds'] as int? ?? 30,
          cardCounts: currentCounts,
        );
        break;
    }
  }

  Future<void> playCard(String cardCode) async {
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

  Future<void> reconnectGame() async {
    try {
      state = state.copyWith(isReconnecting: true);
      final repository = ref.read(gameplayRepositoryProvider);
      await repository.reconnectGame(matchId);
    } finally {
      state = state.copyWith(isReconnecting: false);
    }
  }
}

final gameplayProvider = NotifierProvider.family<GameplayNotifier, GameplayState, int>(
  GameplayNotifier.new,
);
