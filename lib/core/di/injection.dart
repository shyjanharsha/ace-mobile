import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import '../network/api_client.dart';
import '../storage/secure_storage.dart';
import '../websocket/websocket_client.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/home/data/datasources/home_remote_datasource.dart';
import '../../features/home/data/repositories/home_repository.dart';
import '../../features/friends/data/datasources/friends_remote_datasource.dart';
import '../../features/friends/data/repositories/friends_repository.dart';
import '../../features/rooms/data/datasources/rooms_remote_datasource.dart';
import '../../features/rooms/data/repositories/rooms_repository.dart';
import '../../features/gameplay/data/datasources/gameplay_remote_datasource.dart';
import '../../features/gameplay/data/repositories/gameplay_repository.dart';
import '../../features/leaderboard/data/datasources/leaderboard_remote_datasource.dart';
import '../../features/leaderboard/data/repositories/leaderboard_repository.dart';
import '../../features/notifications/data/datasources/notifications_remote_datasource.dart';
import '../../features/notifications/data/repositories/notifications_repository.dart';
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories/profile_repository.dart';
import '../../features/groups/data/datasources/groups_remote_datasource.dart';
import '../../features/groups/data/repositories/groups_repository.dart';

/// Global service locator instance
final getIt = GetIt.instance;

/// Initialize all dependencies — call this before runApp()
Future<void> setupDependencies() async {
  // -------------------------------------------------------
  // Core infrastructure
  // -------------------------------------------------------
  getIt.registerLazySingleton<Logger>(
    () => Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 80,
        colors: true,
        printEmojis: true,
      ),
      level: Level.debug,
    ),
  );

  getIt.registerLazySingleton<SecureStorage>(() => SecureStorage());

  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(
      secureStorage: getIt<SecureStorage>(),
      logger:        getIt<Logger>(),
    ),
  );

  getIt.registerLazySingleton<WebSocketClient>(
    () => WebSocketClient(secureStorage: getIt<SecureStorage>()),
  );

  // -------------------------------------------------------
  // Auth feature
  // -------------------------------------------------------
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(apiClient: getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      secureStorage:    getIt<SecureStorage>(),
    ),
  );

  // -------------------------------------------------------
  // Home feature
  // -------------------------------------------------------
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSource(apiClient: getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepository(remoteDataSource: getIt<HomeRemoteDataSource>()),
  );

  // -------------------------------------------------------
  // Friends feature
  // -------------------------------------------------------
  getIt.registerLazySingleton<FriendsRemoteDataSource>(
    () => FriendsRemoteDataSource(apiClient: getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<FriendsRepository>(
    () => FriendsRepository(remoteDataSource: getIt<FriendsRemoteDataSource>()),
  );

  // -------------------------------------------------------
  // Rooms feature
  // -------------------------------------------------------
  getIt.registerLazySingleton<RoomsRemoteDataSource>(
    () => RoomsRemoteDataSource(apiClient: getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<RoomsRepository>(
    () => RoomsRepository(remoteDataSource: getIt<RoomsRemoteDataSource>()),
  );

  // -------------------------------------------------------
  // Gameplay feature
  // -------------------------------------------------------
  getIt.registerLazySingleton<GameplayRemoteDataSource>(
    () => GameplayRemoteDataSource(apiClient: getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<GameplayRepository>(
    () => GameplayRepository(dataSource: getIt<GameplayRemoteDataSource>()),
  );

  // -------------------------------------------------------
  // Leaderboard feature
  // -------------------------------------------------------
  getIt.registerLazySingleton<LeaderboardRemoteDataSource>(
    () => LeaderboardRemoteDataSource(apiClient: getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<LeaderboardRepository>(
    () => LeaderboardRepository(remoteDataSource: getIt<LeaderboardRemoteDataSource>()),
  );

  // -------------------------------------------------------
  // Notifications feature
  // -------------------------------------------------------
  getIt.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSource(apiClient: getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepository(remoteDataSource: getIt<NotificationsRemoteDataSource>()),
  );

  // -------------------------------------------------------
  // Profile feature
  // -------------------------------------------------------
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSource(apiClient: getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepository(remoteDataSource: getIt<ProfileRemoteDataSource>()),
  );

  // -------------------------------------------------------
  // Groups feature
  // -------------------------------------------------------
  getIt.registerLazySingleton<GroupsRemoteDataSource>(
    () => GroupsRemoteDataSource(apiClient: getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<GroupsRepository>(
    () => GroupsRepository(remoteDataSource: getIt<GroupsRemoteDataSource>()),
  );
}
