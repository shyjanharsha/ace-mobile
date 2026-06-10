/// All route name constants — prevents magic strings throughout the app
class RouteNames {
  RouteNames._();

  static const String splash        = '/';
  static const String login         = '/login';
  static const String signup        = '/signup';
  static const String home          = '/home';
  static const String friends       = '/friends';
  static const String rooms         = '/rooms';
  static const String roomLobby     = '/rooms/:roomId';
  static const String game          = '/game/:matchId';
  static const String leaderboard   = '/leaderboard';
  static const String notifications = '/notifications';
  static const String profile       = '/profile';
  static const String matchHistory  = '/matches';
  static const String groups        = '/groups';
  static const String settings      = '/settings';

  // Path helpers with parameters
  static String roomLobbyPath(int roomId)   => '/rooms/$roomId';
  static String gamePath(int matchId)       => '/game/$matchId';
}
