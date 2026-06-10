/// All WebSocket event type strings emitted by the backend
class WsEventTypes {
  WsEventTypes._();

  // -------------------------------------------------------
  // Room channel events
  // -------------------------------------------------------
  static const String userJoined      = 'user_joined';
  static const String userLeft        = 'user_left';
  static const String chatMessage     = 'chat_message';
  static const String gameStarted     = 'game_started';
  static const String roomUpdated     = 'room_updated';
  static const String playerReady     = 'player_ready';
  static const String presenceUpdate  = 'presence_update';
  static const String roomState       = 'room_state';

  // -------------------------------------------------------
  // Game channel events
  // -------------------------------------------------------
  static const String dealCards         = 'deal_cards';
  static const String yourTurn          = 'your_turn';
  static const String cardPlayed        = 'card_played';
  static const String trickComplete     = 'trick_complete';
  static const String playerCut         = 'player_cut';
  static const String playerFinished    = 'player_finished';
  static const String gameOver          = 'game_over';
  static const String playerDisconnected = 'player_disconnected';
  static const String playerReconnected  = 'player_reconnected';
  static const String moveTimeout       = 'move_timeout';
  static const String reconnectedState  = 'reconnected_state';

  // -------------------------------------------------------
  // Presence channel events
  // -------------------------------------------------------
  static const String friendPresence    = 'friend_presence';

  // -------------------------------------------------------
  // Client-side synthetic events
  // -------------------------------------------------------
  static const String connectionFailed  = 'connection_failed';
  static const String connectionRestored = 'connection_restored';
}

/// Typed WebSocket event received from the server
class WsEvent {
  final String type;
  final Map<String, dynamic> data;
  final Map<String, dynamic> raw;

  const WsEvent({
    required this.type,
    required this.data,
    required this.raw,
  });

  // -------------------------------------------------------
  // Typed accessors for game events
  // -------------------------------------------------------
  bool get isGameEvent => [
        WsEventTypes.dealCards,
        WsEventTypes.yourTurn,
        WsEventTypes.cardPlayed,
        WsEventTypes.trickComplete,
        WsEventTypes.playerFinished,
        WsEventTypes.gameOver,
        WsEventTypes.moveTimeout,
      ].contains(type);

  bool get isRoomEvent => [
        WsEventTypes.userJoined,
        WsEventTypes.userLeft,
        WsEventTypes.chatMessage,
        WsEventTypes.gameStarted,
        WsEventTypes.roomState,
        WsEventTypes.playerReady,
      ].contains(type);

  @override
  String toString() => 'WsEvent(type: $type, data: $data)';
}
