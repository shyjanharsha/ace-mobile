import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/websocket/websocket_client.dart';
import '../../../../core/websocket/websocket_events.dart';
import '../../data/repositories/rooms_repository.dart';
import '../../data/models/game_room_model.dart';

final roomsRepositoryProvider = Provider<RoomsRepository>(
  (ref) => getIt<RoomsRepository>(),
);

class LobbyMessage {
  final int userId;
  final String username;
  final String? avatarUrl;
  final String message;
  final DateTime sentAt;

  LobbyMessage({
    required this.userId,
    required this.username,
    this.avatarUrl,
    required this.message,
    required this.sentAt,
  });
}

class LobbyState {
  final AsyncValue<GameRoomModel> room;
  final List<LobbyMessage> messages;
  final bool isSubscribed;
  final int? matchId;

  LobbyState({
    required this.room,
    required this.messages,
    required this.isSubscribed,
    this.matchId,
  });

  LobbyState copyWith({
    AsyncValue<GameRoomModel>? room,
    List<LobbyMessage>? messages,
    bool? isSubscribed,
    int? matchId,
  }) {
    return LobbyState(
      room: room ?? this.room,
      messages: messages ?? this.messages,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      matchId: matchId ?? this.matchId,
    );
  }
}

class LobbyNotifier extends Notifier<LobbyState> {
  LobbyNotifier(this.roomId);
  final int roomId;

  StreamSubscription<WsEvent>? _subscription;

  @override
  LobbyState build() {
    ref.onDispose(() {
      _subscription?.cancel();
    });

    // Initialize state
    state = LobbyState(
      room: const AsyncValue.loading(),
      messages: const [],
      isSubscribed: false,
    );

    // Initial load and connection
    _initLobby();

    return state;
  }

  Future<void> _initLobby() async {
    // 1. Fetch current room details via HTTP
    await _fetchRoom();

    // 2. Connect & subscribe to RoomChannel via WebSocket
    final wsClient = getIt<WebSocketClient>();
    wsClient.subscribeToRoom(roomId);
    state = state.copyWith(isSubscribed: true);

    // 3. Listen to stream events
    _subscription = wsClient.eventStream.listen((event) {
      // Filter events meant for this room
      if (event.raw['room_id'] == roomId) {
        _handleRoomEvent(event);
      }
    });
  }

  Future<void> _fetchRoom() async {
    try {
      final repository = ref.read(roomsRepositoryProvider);
      final roomModel = await repository.getRoom(roomId);
      state = state.copyWith(room: AsyncValue.data(roomModel));
    } catch (e, stack) {
      state = state.copyWith(room: AsyncValue.error(e, stack));
    }
  }

  void _handleRoomEvent(WsEvent event) {
    switch (event.type) {
      case 'room_state':
        try {
          final rawData = event.data;
          final playersList = rawData['players'] as List? ?? [];
          final roomMap = {
            'id': rawData['room_id'] ?? roomId,
            'code': rawData['code'],
            'status': rawData['status'],
            'room_type': 'public',
            'host_id': rawData['host_id'],
            'max_players': rawData['max_players'],
            'bet_coins': rawData['bet_coins'],
            'player_count': playersList.length,
            'players': playersList,
          };
          final roomModel = GameRoomModel.fromJson(roomMap);
          state = state.copyWith(room: AsyncValue.data(roomModel));
        } catch (_) {
          // If JSON parsing fails, fall back to HTTP refresh
          _fetchRoom();
        }
        break;

      case 'user_joined':
      case 'user_left':
      case 'player_ready':
        // Refresh room details to guarantee consistency
        _fetchRoom();
        break;

      case 'chat_message':
        final msg = LobbyMessage(
          userId: event.data['user_id'] as int,
          username: event.data['username'] as String,
          avatarUrl: event.data['avatar_url'] as String?,
          message: event.data['message'] as String,
          sentAt: DateTime.tryParse(event.data['sent_at'] as String? ?? '') ?? DateTime.now(),
        );
        state = state.copyWith(messages: [...state.messages, msg]);
        break;

      case 'game_started':
        final matchId = event.data['match_id'] as int?;
        if (matchId != null) {
          state = state.copyWith(matchId: matchId);
        }
        break;
    }
  }

  // -------------------------------------------------------
  // Outbound WebSockets / Action calls
  // -------------------------------------------------------
  void sendChatMessage(String message) {
    if (message.trim().isEmpty) return;
    getIt<WebSocketClient>().sendMessage(
      channel: 'RoomChannel',
      action: 'send_chat',
      data: {'message': message.trim()},
      identifierExtra: {'room_id': roomId},
    );
  }

  void toggleReady(bool isReady) {
    getIt<WebSocketClient>().sendMessage(
      channel: 'RoomChannel',
      action: 'set_ready',
      data: {'ready': isReady},
      identifierExtra: {'room_id': roomId},
    );
  }

  Future<void> leaveRoom() async {
    // HTTP leave
    await ref.read(roomsRepositoryProvider).leaveRoom(roomId);
  }

  Future<void> startGame() async {
    // HTTP start game (host only)
    await ref.read(roomsRepositoryProvider).startGame(roomId);
  }

  Future<bool> invitePlayer(int receiverId) async {
    try {
      await ref.read(roomsRepositoryProvider).invitePlayer(
            roomId: roomId,
            receiverId: receiverId,
          );
      return true;
    } catch (_) {
      return false;
    }
  }
}

final lobbyProvider = NotifierProvider.family<LobbyNotifier, LobbyState, int>(
  LobbyNotifier.new,
);
