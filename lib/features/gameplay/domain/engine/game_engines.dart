import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/websocket/websocket_client.dart';
import '../../../../core/websocket/websocket_events.dart';
import '../../data/repositories/gameplay_repository.dart';
import '../../data/models/match_model.dart';
import '../../data/models/game_data_models.dart';
import '../../../auth/domain/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../rooms/data/repositories/rooms_repository.dart';
import '../../../rooms/data/models/room_player_model.dart';
import '../../presentation/providers/gameplay_providers.dart';
import 'game_engine.dart';
import 'bot_engine.dart';
import 'card_engine.dart';

abstract class IGameEngine {
  GameplayState get state;
  Stream<GameplayState> get stateStream;
  Future<void> init();
  Future<void> playCard(String cardCode);
  Future<void> reconnectGame();
  void clearError();
  void dispose();
}

// ---------------------------------------------------------------------------
// ONLINE ENGINE
// ---------------------------------------------------------------------------
class OnlineGameEngine implements IGameEngine {
  OnlineGameEngine(this.matchId, this.ref) {
    _state = GameplayState.initial();
  }

  final int matchId;
  final Ref ref;
  
  late GameplayState _state;
  final _stateController = StreamController<GameplayState>.broadcast();
  StreamSubscription<WsEvent>? _subscription;

  @override
  GameplayState get state => _state;

  @override
  Stream<GameplayState> get stateStream => _stateController.stream;

  void _emit(GameplayState newState) {
    _state = newState;
    if (!_stateController.isClosed) {
      _stateController.add(_state);
    }
  }

  @override
  Future<void> init() async {
    final wsClient = getIt<WebSocketClient>();
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

      _emit(state.copyWith(
        match: AsyncValue.data(matchModel),
        playerNames: names,
        playerAvatars: avatars,
      ));
    } catch (e, stack) {
      _emit(state.copyWith(match: AsyncValue.error(e, stack)));
    }
  }

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
        case WsEventTypes.dealCards:
          final hand = List<String>.from(data['hand'] as List? ?? []);
          final sorted = GameEngine.sortHand(hand);
          final counts = Map<int, int>.from(state.cardCounts);
          if (currentUserId != null) counts[currentUserId] = hand.length;
          _emit(state.copyWith(
            myHand: hand,
            sortedHand: sorted,
            playableCards: const [],
            timeoutSeconds: 30,
            cardCounts: counts,
          ));
          break;

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

          _emit(state.copyWith(
            currentTurn: firstPlayerId,
            isMyTurn: isMyTurn,
            playerOrder: order,
            activePlayers: order,
            cardCounts: initialCounts,
            playableCards: playable,
          ));
          break;

        case WsEventTypes.yourTurn:
          final leadingSuit = data['leading_suit'] as String?;
          final trickPileRaw = data['trick_pile'] as List? ?? [];
          final trickPile = trickPileRaw.map((e) => Map<String, dynamic>.from(e as Map)).toList();

          final playable = GameEngine.getPlayableCards(
            hand: state.myHand,
            leadingSuit: leadingSuit,
            isMyTurn: true,
          );

          _emit(state.copyWith(
            currentTurn: currentUserId,
            isMyTurn: true,
            leadingSuit: leadingSuit,
            trickPile: trickPile,
            timeoutSeconds: data['timeout_seconds'] as int? ?? 30,
            moveSeq: data['move_seq'] as int? ?? state.moveSeq,
            playableCards: playable,
          ));
          break;

        case WsEventTypes.cardPlayed:
          final playedCard = data['card'] as String;
          final playerId = int.parse(data['player_id'].toString());
          final trickPileRaw = data['trick_pile'] as List? ?? [];
          final trickPile = trickPileRaw.map((e) => Map<String, dynamic>.from(e as Map)).toList();

          List<String> newHand = state.myHand;
          List<String> newSorted = state.sortedHand;
          if (playerId == currentUserId) {
            newHand = List<String>.from(state.myHand)..remove(playedCard);
            newSorted = GameEngine.sortHand(newHand);
          }

          final counts = Map<int, int>.from(state.cardCounts);
          if (counts.containsKey(playerId)) {
            counts[playerId] = (counts[playerId]! - 1).clamp(0, 52);
          }

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

          _emit(state.copyWith(
            myHand: newHand,
            sortedHand: newSorted,
            trickPile: trickPile,
            moveSeq: data['move_seq'] as int? ?? state.moveSeq,
            currentTurn: nextTurn ?? state.currentTurn,
            isMyTurn: nextTurn == currentUserId,
            cardCounts: counts,
            playableCards: nextTurn == currentUserId ? state.playableCards : const [],
            clearError: true,
          ));
          break;

        case WsEventTypes.trickComplete:
          final nextLeaderId = int.parse(data['next_leader_id'].toString());
          final wasCut = data['was_cut'] as bool? ?? false;
          final penalizedId = data['penalized_player_id'] != null
              ? int.parse(data['penalized_player_id'].toString())
              : null;

          final counts = Map<int, int>.from(state.cardCounts);
          if (wasCut && penalizedId != null) {
            final pileSize = state.trickPile.length;
            counts[penalizedId] = (counts[penalizedId] ?? 0) + pileSize;
          }

          List<String> newHand = state.myHand;
          List<String> newSorted = state.sortedHand;

          if (wasCut && penalizedId == currentUserId) {
            final collectedCardsRaw = data['collected_cards'] as List? ?? [];
            final collectedCards = collectedCardsRaw.map((e) => e.toString()).toList();
            newHand = List<String>.from(state.myHand)..addAll(collectedCards);
            newSorted = GameEngine.sortHand(newHand);
          }

          _emit(state.copyWith(
            myHand: newHand,
            sortedHand: newSorted,
            currentTurn: nextLeaderId,
            isMyTurn: nextLeaderId == currentUserId,
            clearLeadingSuit: true,
            trickPile: const [],
            currentTrick: data['trick_number'] as int? ?? state.currentTrick,
            cardCounts: counts,
            playableCards: nextLeaderId == currentUserId
                ? GameEngine.getPlayableCards(hand: newHand, leadingSuit: null, isMyTurn: true)
                : const [],
          ));
          break;

        case WsEventTypes.playerCut:
          final penalizedId = int.parse(data['penalized_id'].toString());
          final pileSize = data['pile_size'] as int? ?? state.trickPile.length;
          final counts = Map<int, int>.from(state.cardCounts);
          counts[penalizedId] = (counts[penalizedId] ?? 0) + pileSize;
          _emit(state.copyWith(cardCounts: counts));
          break;

        case WsEventTypes.playerFinished:
          final finishedUserId = int.parse(data['user_id'].toString());
          final updatedFinished = List<int>.from(state.finishedPlayers);
          if (!updatedFinished.contains(finishedUserId)) updatedFinished.add(finishedUserId);
          final updatedActive = List<int>.from(state.activePlayers)..remove(finishedUserId);
          
          final counts = Map<int, int>.from(state.cardCounts);
          counts[finishedUserId] = 0;

          var newState = state.copyWith(
            finishedPlayers: updatedFinished,
            activePlayers: updatedActive,
            cardCounts: counts,
          );
          if (finishedUserId == currentUserId) {
            newState = newState.copyWith(isMyTurn: false, playableCards: const []);
          }
          _emit(newState);
          break;

        case WsEventTypes.gameOver:
          final donkeyId = int.parse(data['donkey_id'].toString());
          final donkeyName = data['donkey_name'] as String;
          final ranksList = List<Map<String, dynamic>>.from(data['final_ranks'] as List? ?? []);
          _emit(state.copyWith(
            donkeyId: donkeyId,
            donkeyName: donkeyName,
            finalRanks: ranksList,
            isMyTurn: false,
            playableCards: const [],
          ));
          _fetchMatch();
          break;

        case WsEventTypes.playerDisconnected:
          final disconnectedId = int.parse(data['user_id'].toString());
          final updated = Set<int>.from(state.disconnectedPlayers)..add(disconnectedId);
          _emit(state.copyWith(disconnectedPlayers: updated));
          break;

        case WsEventTypes.playerReconnected:
          final rId = int.parse(data['user_id'].toString());
          final rCount = data['hand_count'] as int? ?? 0;
          final counts = Map<int, int>.from(state.cardCounts);
          counts[rId] = rCount;
          final disconnected = Set<int>.from(state.disconnectedPlayers)..remove(rId);
          _emit(state.copyWith(cardCounts: counts, disconnectedPlayers: disconnected));
          break;

        case WsEventTypes.moveTimeout:
          final timedOutUserId = data['user_id'] != null ? int.parse(data['user_id'].toString()) : null;
          final autoCard = data['card_played'] as String?;
          if (timedOutUserId == currentUserId) {
            List<String> newHand = state.myHand;
            List<String> newSorted = state.sortedHand;
            if (autoCard != null) {
              newHand = List<String>.from(state.myHand)..remove(autoCard);
              newSorted = GameEngine.sortHand(newHand);
            }
            _emit(state.copyWith(
              isMyTurn: false,
              playableCards: const [],
              myHand: newHand,
              sortedHand: newSorted,
            ));
          }
          break;

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
          final trickPile = trickPileRaw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
          final serverCounts = data['card_counts'] as Map? ?? {};
          final counts = <int, int>{};
          for (final entry in serverCounts.entries) {
            counts[int.parse(entry.key.toString())] = entry.value as int;
          }
          final playable = isMyTurn ? GameEngine.getPlayableCards(hand: hand, leadingSuit: leadingSuit, isMyTurn: true) : <String>[];
          _emit(state.copyWith(
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
          ));
          break;
      }
    } catch (e, stack) {
      print('ERROR PARSING WS EVENT: ${event.type} -> $e');
      print(stack);
    }
  }

  @override
  Future<void> playCard(String cardCode) async {
    final validation = GameEngine.validateMove(
      hand: state.myHand,
      cardCode: cardCode,
      leadingSuit: state.leadingSuit,
      isMyTurn: state.isMyTurn,
    );

    if (!validation.isValid) {
      _emit(state.copyWith(lastErrorMessage: validation.errorMessage));
      throw Exception(validation.errorMessage);
    }

    final repository = ref.read(gameplayRepositoryProvider);
    await repository.playCard(matchId: matchId, cardCode: cardCode, moveSeq: state.moveSeq);
  }

  @override
  Future<void> reconnectGame() async {
    try {
      _emit(state.copyWith(isReconnecting: true));
      final repository = ref.read(gameplayRepositoryProvider);
      await repository.reconnectGame(matchId);
    } finally {
      _emit(state.copyWith(isReconnecting: false));
    }
  }

  @override
  void clearError() {
    _emit(state.copyWith(clearError: true));
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _stateController.close();
  }
}

// ---------------------------------------------------------------------------
// OFFLINE ENGINE
// ---------------------------------------------------------------------------
class OfflineGameEngine implements IGameEngine {
  OfflineGameEngine(this.matchId, this.bots, this.humanId) {
    _state = GameplayState.initial();
  }

  final int matchId;
  final List<BotPlayerModel> bots;
  final int humanId;

  late GameplayState _state;
  final _stateController = StreamController<GameplayState>.broadcast();
  Timer? _botTimer;
  final GameMemory memory = GameMemory();
  Map<int, List<String>> _allHands = {};

  @override
  GameplayState get state => _state;

  @override
  Stream<GameplayState> get stateStream => _stateController.stream;

  void _emit(GameplayState newState) {
    _state = newState;
    if (!_stateController.isClosed) {
      _stateController.add(_state);
    }
  }

  @override
  Future<void> init() async {
    memory.reset();
    final allPlayers = [humanId, ...bots.map((b) => b.userId)];
    allPlayers.shuffle();

    final botMap = {for (final b in bots) b.userId: b};
    final deck = CardEngine.shuffleDeck();
    final dealt = CardEngine.dealCards(deck, allPlayers.length);

    _allHands.clear();
    final cardCounts = <int, int>{};
    final names = <int, String>{ humanId: 'You' };
    final avatars = <int, String?>{ humanId: null };
    final matchPlayers = <MatchPlayerModel>[];

    for (var i = 0; i < allPlayers.length; i++) {
      final pid = allPlayers[i];
      final handCodes = dealt[i].map((c) => c.code).toList();
      _allHands[pid] = GameEngine.sortHand(handCodes);
      cardCounts[pid] = handCodes.length;
      if (pid != humanId) {
        names[pid] = botMap[pid]!.name;
        avatars[pid] = null;
      }
      matchPlayers.add(MatchPlayerModel(
        userId: pid,
        seatPosition: i,
        isDonkey: false,
        tricksWon: 0,
        coinsWon: 0,
      ));
    }

    final firstPlayer = CardEngine.findAceOfSpadesHolder(_allHands) ?? allPlayers.first;
    final isMyTurn = firstPlayer == humanId;
    final myHand = _allHands[humanId] ?? [];
    
    // Mock match data
    final mockRoom = MatchRoomModel(id: -1, code: 'OFFLINE');
    final mockMatch = MatchModel(
      id: matchId,
      status: 'active',
      room: mockRoom,
      players: matchPlayers,
    );

    _emit(state.copyWith(
      match: AsyncValue.data(mockMatch),
      myHand: myHand,
      sortedHand: GameEngine.sortHand(myHand),
      playerOrder: allPlayers,
      activePlayers: allPlayers,
      cardCounts: cardCounts,
      playerNames: names,
      playerAvatars: avatars,
      currentTurn: firstPlayer,
      currentTrick: 1,
      isMyTurn: isMyTurn,
      playableCards: isMyTurn ? GameEngine.getPlayableCards(hand: myHand, leadingSuit: null, isMyTurn: true) : const [],
    ));

    _triggerBotTurnIfNeeded();
  }

  Future<void> _triggerBotTurnIfNeeded() async {
    if (state.donkeyId != null) return;

    final currentTurn = state.currentTurn;
    if (currentTurn == null) return;
    if (currentTurn == humanId) return;

    final bot = bots.firstWhere((b) => b.userId == currentTurn);
    final botStrategy = GameEngine.createBot(bot.personality);

    final delay = 1 + Random().nextInt(3);

    _botTimer?.cancel();
    _botTimer = Timer(Duration(seconds: delay), () {
      if (state.currentTurn != currentTurn) return;

      final card = GameEngine.botChooseCard(
        bot: botStrategy,
        hand: _allHands[currentTurn]!,
        leadingSuit: state.leadingSuit,
        trickPile: state.trickPile.map((e) => TrickPlay.fromMap(e)).toList(),
        activePlayers: state.activePlayers,
        cardCounts: state.cardCounts,
        memory: memory,
      );

      _processPlay(currentTurn, card);
    });
  }

  @override
  Future<void> playCard(String cardCode) async {
    if (state.currentTurn != humanId) return;
    if (!state.playableCards.contains(cardCode)) return;

    _processPlay(humanId, cardCode);
  }

  void _processPlay(int playerId, String cardCode) {
    memory.updateMemory(cardCode, playerId, _allHands[playerId]!.length - 1);

    _allHands[playerId] = List<String>.from(_allHands[playerId]!)..remove(cardCode);
    
    final newCounts = Map<int, int>.from(state.cardCounts);
    newCounts[playerId] = _allHands[playerId]!.length;

    final newPile = List<Map<String, dynamic>>.from(state.trickPile)
      ..add({"player_id": playerId, "card": cardCode});

    final leadingSuit = state.leadingSuit ?? GameEngine.suitOf(cardCode);

    final nextPlayerId = GameEngine.nextPlayer(
      currentId: playerId,
      playerOrder: state.playerOrder,
      activePlayers: state.activePlayers,
    );

    var newState = state.copyWith(
      cardCounts: newCounts,
      trickPile: newPile,
      leadingSuit: leadingSuit,
      currentTurn: nextPlayerId,
      isMyTurn: nextPlayerId == humanId,
    );

    if (playerId == humanId) {
      newState = newState.copyWith(
        myHand: _allHands[humanId],
        sortedHand: GameEngine.sortHand(_allHands[humanId]!),
      );
    }
    
    _emit(newState);

    if (newPile.length == state.activePlayers.length) {
      Timer(const Duration(seconds: 1), _resolveTrick);
    } else {
      _updatePlayableCardsForHuman();
      _triggerBotTurnIfNeeded();
    }
  }

  void _resolveTrick() {
    final tp = state.trickPile.map((e) => TrickPlay.fromMap(e)).toList();
    final result = GameEngine.resolveTrick(tp, state.leadingSuit!);
    
    final nextLeader = result.wasCut ? result.penalizedPlayerId : result.winnerId;
    final newCounts = Map<int, int>.from(state.cardCounts);
    
    if (result.wasCut && result.penalizedPlayerId != null) {
      final pId = result.penalizedPlayerId!;
      final collectedCards = state.trickPile.map((p) => p['card'] as String).toList();
      _allHands[pId] = GameEngine.sortHand([..._allHands[pId]!, ...collectedCards]);
      newCounts[pId] = _allHands[pId]!.length;
    }

    final finished = List<int>.from(state.finishedPlayers);
    final active = List<int>.from(state.activePlayers);
    final matchPlayers = List<MatchPlayerModel>.from(state.match.value!.players);
    int currentRank = finished.length + 1;
    
    for (final p in state.activePlayers) {
      if (_allHands[p]!.isEmpty && !finished.contains(p)) {
        finished.add(p);
        final idx = matchPlayers.indexWhere((mp) => mp.userId == p);
        if (idx != -1) {
          matchPlayers[idx] = matchPlayers[idx].copyWith(finalRank: currentRank);
          currentRank++;
        }
      }
    }
    
    active.removeWhere((p) => finished.contains(p));

    final isGameOver = GameEngine.isGameOver(cardCounts: newCounts, activePlayers: active);
    int? donkeyId = isGameOver ? GameEngine.detectDonkey(cardCounts: newCounts, activePlayers: active) : null;
    String? donkeyName = donkeyId != null ? state.playerNames[donkeyId] : null;

    if (donkeyId != null) {
      final idx = matchPlayers.indexWhere((mp) => mp.userId == donkeyId);
      if (idx != -1) {
        matchPlayers[idx] = matchPlayers[idx].copyWith(isDonkey: true, finalRank: currentRank);
      }
    }

    final updatedMatch = state.match.value!.copyWith(players: matchPlayers);

    var newState = state.copyWith(
      match: AsyncValue.data(updatedMatch),
      cardCounts: newCounts,
      trickPile: const [],
      clearLeadingSuit: true,
      currentTrick: state.currentTrick + 1,
      currentTurn: nextLeader,
      isMyTurn: nextLeader == humanId,
      finishedPlayers: finished,
      activePlayers: active,
      donkeyId: donkeyId,
      donkeyName: donkeyName,
    );

    if (result.wasCut && result.penalizedPlayerId == humanId) {
       newState = newState.copyWith(
         myHand: _allHands[humanId],
         sortedHand: GameEngine.sortHand(_allHands[humanId]!),
       );
    }
    
    _emit(newState);

    if (!isGameOver) {
      _updatePlayableCardsForHuman();
      _triggerBotTurnIfNeeded();
    }
  }

  void _updatePlayableCardsForHuman() {
    if (state.currentTurn == humanId) {
      _emit(state.copyWith(
        playableCards: GameEngine.getPlayableCards(
          hand: _allHands[humanId]!,
          leadingSuit: state.leadingSuit,
          isMyTurn: true,
        ),
      ));
    } else {
      _emit(state.copyWith(playableCards: const []));
    }
  }

  @override
  Future<void> reconnectGame() async {
    // Offline mode doesn't reconnect
  }

  @override
  void clearError() {
    _emit(state.copyWith(clearError: true));
  }

  @override
  void dispose() {
    _botTimer?.cancel();
    _stateController.close();
  }
}
