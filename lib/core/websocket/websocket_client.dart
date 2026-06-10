import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:logger/logger.dart';
import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import '../storage/secure_storage.dart';
import 'websocket_events.dart';

/// WebSocket connection manager with auto-reconnect and exponential backoff.
/// Streams typed [WsEvent] objects to subscribers.
class WebSocketClient {
  final SecureStorage _secureStorage;
  final Logger _logger;

  WebSocketChannel? _channel;
  StreamController<WsEvent>? _eventController;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;

  int _reconnectAttempts = 0;
  bool _intentionallyClosed = false;
  String? _currentMatchId;
  String? _currentRoomId;

  // Public stream of all incoming events
  Stream<WsEvent> get eventStream =>
      _eventController?.stream ?? const Stream.empty();

  WebSocketClient({
    required SecureStorage secureStorage,
    Logger? logger,
  })  : _secureStorage = secureStorage,
        _logger = logger ?? Logger();

  // -------------------------------------------------------
  // Connect
  // -------------------------------------------------------
  Future<void> connect() async {
    _intentionallyClosed = false;
    _eventController ??= StreamController<WsEvent>.broadcast();

    final token = await _secureStorage.getAccessToken();
    if (token == null) {
      _logger.w('[WS] No token — cannot connect');
      return;
    }

    final wsUrl = ApiConstants.wsUrl(token);
    _logger.i('[WS] Connecting to $wsUrl');

    try {
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      _reconnectAttempts = 0;

      _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone:  _onDone,
        cancelOnError: false,
      );

      _startHeartbeat();
      _logger.i('[WS] Connected');
    } catch (e) {
      _logger.e('[WS] Connection failed: $e');
      _scheduleReconnect();
    }
  }

  // -------------------------------------------------------
  // Subscribe to a channel (ActionCable protocol)
  // -------------------------------------------------------
  void subscribeToRoom(int roomId) {
    _currentRoomId = roomId.toString();
    _send({
      'command': 'subscribe',
      'identifier': jsonEncode({
        'channel': 'RoomChannel',
        'room_id': roomId,
      }),
    });
    _logger.d('[WS] Subscribed to RoomChannel $roomId');
  }

  void subscribeToGame(int matchId) {
    _currentMatchId = matchId.toString();
    _send({
      'command': 'subscribe',
      'identifier': jsonEncode({
        'channel': 'GameChannel',
        'match_id': matchId,
      }),
    });
    _logger.d('[WS] Subscribed to GameChannel $matchId');
  }

  void subscribeToPresence() {
    _send({
      'command': 'subscribe',
      'identifier': jsonEncode({'channel': 'PresenceChannel'}),
    });
  }

  // -------------------------------------------------------
  // Send a message via ActionCable
  // -------------------------------------------------------
  void sendMessage({
    required String channel,
    required String action,
    Map<String, dynamic>? data,
    Map<String, dynamic>? identifierExtra,
  }) {
    final identifier = jsonEncode({
      'channel': channel,
      ...?identifierExtra,
    });

    _send({
      'command': 'message',
      'identifier': identifier,
      'data': jsonEncode({'action': action, ...?data}),
    });
  }

  // -------------------------------------------------------
  // Heartbeat — keeps connection alive
  // -------------------------------------------------------
  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(AppConstants.heartbeatInterval, (_) {
      _send({
        'command': 'message',
        'identifier': jsonEncode({'channel': 'PresenceChannel'}),
        'data': jsonEncode({'action': 'heartbeat'}),
      });
    });
  }

  // -------------------------------------------------------
  // Disconnect
  // -------------------------------------------------------
  void disconnect() {
    _intentionallyClosed = true;
    _heartbeatTimer?.cancel();
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _channel = null;
    _logger.i('[WS] Disconnected intentionally');
  }

  // -------------------------------------------------------
  // Message handling
  // -------------------------------------------------------
  void _onMessage(dynamic raw) {
    try {
      final data = jsonDecode(raw as String) as Map<String, dynamic>;
      final type = data['type'] as String?;

      // ActionCable ping — ignore
      if (type == 'ping') return;

      // ActionCable welcome/confirm
      if (type == 'welcome' || type == 'confirm_subscription') {
        _logger.d('[WS] $type');
        return;
      }

      // Parse message payload
      final messageData = data['message'] as Map<String, dynamic>?;
      if (messageData == null) return;

      final eventType = messageData['type'] as String? ?? 'unknown';
      final eventData = messageData['data'] as Map<String, dynamic>? ?? {};

      final event = WsEvent(type: eventType, data: eventData, raw: messageData);
      _eventController?.add(event);
      _logger.d('[WS] Event: $eventType');
    } catch (e) {
      _logger.w('[WS] Parse error: $e');
    }
  }

  void _onError(dynamic error) {
    _logger.e('[WS] Error: $error');
    _scheduleReconnect();
  }

  void _onDone() {
    _logger.w('[WS] Connection closed');
    if (!_intentionallyClosed) {
      _scheduleReconnect();
    }
  }

  // -------------------------------------------------------
  // Reconnect with exponential backoff
  // -------------------------------------------------------
  void _scheduleReconnect() {
    if (_intentionallyClosed) return;
    if (_reconnectAttempts >= AppConstants.wsMaxReconnectAttempts) {
      _logger.e('[WS] Max reconnect attempts reached');
      _eventController?.add(const WsEvent(
        type: WsEventTypes.connectionFailed,
        data: {},
        raw: {},
      ));
      return;
    }

    _reconnectTimer?.cancel();
    final delay = _calculateBackoff();
    _reconnectAttempts++;

    _logger.i('[WS] Reconnecting in ${delay.inSeconds}s (attempt $_reconnectAttempts)');

    _reconnectTimer = Timer(delay, () async {
      await connect();
      // Re-subscribe to previously active channels
      if (_currentRoomId != null) {
        subscribeToRoom(int.parse(_currentRoomId!));
      }
      if (_currentMatchId != null) {
        subscribeToGame(int.parse(_currentMatchId!));
      }
    });
  }

  Duration _calculateBackoff() {
    final seconds = AppConstants.wsInitialReconnectDelay.inSeconds *
        (1 << _reconnectAttempts.clamp(0, 4));
    return Duration(
      seconds: seconds.clamp(
        AppConstants.wsInitialReconnectDelay.inSeconds,
        AppConstants.wsMaxReconnectDelay.inSeconds,
      ),
    );
  }

  void _send(Map<String, dynamic> data) {
    try {
      _channel?.sink.add(jsonEncode(data));
    } catch (e) {
      _logger.w('[WS] Send failed: $e');
    }
  }

  void dispose() {
    disconnect();
    _eventController?.close();
    _eventController = null;
  }
}
