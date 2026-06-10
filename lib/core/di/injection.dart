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
}
