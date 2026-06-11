import 'package:flutter_dotenv/flutter_dotenv.dart';

// App-level constants — API endpoints, WebSocket URL, timeouts
class ApiConstants {
  ApiConstants._();

  // -------------------------------------------------------
  // Base URLs — change for staging/production
  // -------------------------------------------------------
  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'http://192.168.1.42:3000';

  static String get wsBaseUrl => dotenv.env['WS_BASE_URL'] ?? 'ws://192.168.1.42:3000';

  // -------------------------------------------------------
  // API version prefix
  // -------------------------------------------------------
  static const String apiV1 = '/api/v1';

  // -------------------------------------------------------
  // Auth endpoints
  // -------------------------------------------------------
  static const String signup = '$apiV1/auth/signup';
  static const String login = '$apiV1/auth/login';
  static const String guestLogin = '$apiV1/auth/guest';
  static const String logout = '$apiV1/auth/logout';
  static const String refreshToken = '$apiV1/auth/refresh';
  static const String sendOtp = '$apiV1/auth/send_otp';
  static const String verifyPhone = '$apiV1/auth/verify_phone';
  static const String registerDevice = '$apiV1/auth/devices';

  // -------------------------------------------------------
  // User endpoints
  // -------------------------------------------------------
  static const String users = '$apiV1/users';
  static const String me = '$apiV1/users/me';
  static const String updateMe = '$apiV1/users/me';
  static const String myMatches = '$apiV1/users/me/matches';
  static String userProfile(int id) => '$apiV1/users/$id';
  static String userStats(int id) => '$apiV1/users/$id/statistics';
  static String userMatches(int id) => '$apiV1/users/$id/matches';

  // -------------------------------------------------------
  // Room endpoints
  // -------------------------------------------------------
  static const String rooms = '$apiV1/rooms';
  static const String joinByCode = '$apiV1/rooms/join_by_code';
  static String room(int id) => '$apiV1/rooms/$id';
  static String joinRoom(int id) => '$apiV1/rooms/$id/join';
  static String leaveRoom(int id) => '$apiV1/rooms/$id/leave';
  static String startRoom(int id) => '$apiV1/rooms/$id/start';
  static String roomChat(int id) => '$apiV1/rooms/$id/chat';

  // -------------------------------------------------------
  // Game endpoints
  // -------------------------------------------------------
  static String playCard(int matchId) => '$apiV1/game/$matchId/play';
  static String reconnect(int matchId) => '$apiV1/game/$matchId/reconnect';

  // -------------------------------------------------------
  // Match endpoints
  // -------------------------------------------------------
  static String match(int id) => '$apiV1/matches/$id';
  static String matchReplay(int id) => '$apiV1/matches/$id/replay';

  // -------------------------------------------------------
  // Social endpoints
  // -------------------------------------------------------
  static const String friendships = '$apiV1/friendships';
  static String friendship(int id) => '$apiV1/friendships/$id';
  static const String groups = '$apiV1/groups';
  static String group(int id) => '$apiV1/groups/$id';
  static String groupMembers(int id) => '$apiV1/groups/$id/members';
  static const String contactSync = '$apiV1/contacts/sync';

  // -------------------------------------------------------
  // Invitations & Notifications
  // -------------------------------------------------------
  static const String invitations = '$apiV1/invitations';
  static String invitation(int id) => '$apiV1/invitations/$id';
  static const String notifications = '$apiV1/notifications';
  static const String markNotifRead = '$apiV1/notifications/mark_read';

  // -------------------------------------------------------
  // Leaderboard & Presence
  // -------------------------------------------------------
  static const String leaderboard = '$apiV1/leaderboard';
  static const String friendPresences = '$apiV1/presences/friends';

  // -------------------------------------------------------
  // WebSocket
  // -------------------------------------------------------
  static String wsUrl(String token) => '$wsBaseUrl/cable?token=$token';

  // -------------------------------------------------------
  // HTTP Timeouts
  // -------------------------------------------------------
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
