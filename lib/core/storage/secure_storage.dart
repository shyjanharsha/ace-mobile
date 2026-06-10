import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/storage_keys.dart';

/// Typed wrapper around FlutterSecureStorage
/// Handles all JWT and session data storage
class SecureStorage {
  final FlutterSecureStorage _storage;

  SecureStorage()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock_this_device,
          ),
        );

  // -------------------------------------------------------
  // Token management
  // -------------------------------------------------------
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: StorageKeys.accessToken, value: accessToken),
      _storage.write(key: StorageKeys.refreshToken, value: refreshToken),
    ]);
  }

  Future<String?> getAccessToken() =>
      _storage.read(key: StorageKeys.accessToken);

  Future<String?> getRefreshToken() =>
      _storage.read(key: StorageKeys.refreshToken);

  Future<void> deleteTokens() async {
    await Future.wait([
      _storage.delete(key: StorageKeys.accessToken),
      _storage.delete(key: StorageKeys.refreshToken),
    ]);
  }

  // -------------------------------------------------------
  // User session
  // -------------------------------------------------------
  Future<void> saveUserSession({
    required int userId,
    required String username,
    required bool isGuest,
  }) async {
    await Future.wait([
      _storage.write(key: StorageKeys.userId, value: userId.toString()),
      _storage.write(key: StorageKeys.username, value: username),
      _storage.write(key: StorageKeys.isGuest, value: isGuest.toString()),
    ]);
  }

  Future<int?> getUserId() async {
    final val = await _storage.read(key: StorageKeys.userId);
    return val != null ? int.tryParse(val) : null;
  }

  Future<String?> getUsername() => _storage.read(key: StorageKeys.username);

  Future<bool> getIsGuest() async {
    final val = await _storage.read(key: StorageKeys.isGuest);
    return val == 'true';
  }

  // -------------------------------------------------------
  // Device UID (persistent across logins)
  // -------------------------------------------------------
  Future<String?> getDeviceUid() => _storage.read(key: StorageKeys.deviceUid);

  Future<void> saveDeviceUid(String uid) =>
      _storage.write(key: StorageKeys.deviceUid, value: uid);

  // -------------------------------------------------------
  // Session check
  // -------------------------------------------------------
  Future<bool> hasValidSession() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // -------------------------------------------------------
  // Full clear (logout)
  // -------------------------------------------------------
  Future<void> clearSession() async {
    await Future.wait([
      _storage.delete(key: StorageKeys.accessToken),
      _storage.delete(key: StorageKeys.refreshToken),
      _storage.delete(key: StorageKeys.userId),
      _storage.delete(key: StorageKeys.username),
      _storage.delete(key: StorageKeys.isGuest),
      // Note: deviceUid is intentionally kept for re-login
    ]);
  }
}
