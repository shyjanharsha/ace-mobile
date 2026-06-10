// Game-level constants
class AppConstants {
  AppConstants._();

  // Player limits
  static const int minPlayers = 2;
  static const int maxPlayers = 8;

  // Move timeout (matches backend)
  static const int moveTimeoutSeconds = 30;

  // WebSocket reconnect
  static const int wsMaxReconnectAttempts = 10;
  static const Duration wsInitialReconnectDelay = Duration(seconds: 2);
  static const Duration wsMaxReconnectDelay = Duration(seconds: 30);

  // Heartbeat interval (matches backend's 20s)
  static const Duration heartbeatInterval = Duration(seconds: 20);

  // Presence cleanup window
  static const Duration presenceReconnectWindow = Duration(seconds: 30);

  // UI
  static const Duration cardAnimationDuration = Duration(milliseconds: 400);
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const double cardAspectRatio = 0.7; // standard playing card ratio

  // Room join code length
  static const int roomCodeLength = 6;

  // Notification poll interval (fallback if WS drops)
  static const Duration notifPollInterval = Duration(seconds: 30);

  // Pagination
  static const int defaultPageSize = 20;

  // Starting coins (mirrors backend defaults)
  static const int defaultStartingCoins = 1000;
  static const int guestStartingCoins = 100;
}
