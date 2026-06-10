import '../../../../core/storage/secure_storage.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

/// Auth repository — coordinates between remote datasource and local storage
class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorage _secureStorage;

  AuthRepository({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorage secureStorage,
  })  : _remoteDataSource = remoteDataSource,
        _secureStorage = secureStorage;

  // -------------------------------------------------------
  // Login
  // -------------------------------------------------------
  Future<UserModel> login({
    required String identifier,
    required String password,
    String? deviceUid,
    String? platform,
  }) async {
    final result = await _remoteDataSource.login(
      identifier: identifier,
      password:   password,
      deviceUid:  deviceUid,
      platform:   platform,
    );

    await _persistSession(result.user, result.tokens.accessToken, result.tokens.refreshToken);
    return result.user;
  }

  // -------------------------------------------------------
  // Signup
  // -------------------------------------------------------
  Future<UserModel> signup({
    required String username,
    required String password,
    String? phone,
    String? email,
    String? displayName,
    String? deviceUid,
  }) async {
    final result = await _remoteDataSource.signup(
      username:    username,
      password:    password,
      phone:       phone,
      email:       email,
      displayName: displayName,
      deviceUid:   deviceUid,
    );

    await _persistSession(result.user, result.tokens.accessToken, result.tokens.refreshToken);
    return result.user;
  }

  // -------------------------------------------------------
  // Guest login
  // -------------------------------------------------------
  Future<UserModel> guestLogin() async {
    final result = await _remoteDataSource.guestLogin();
    await _persistSession(result.user, result.tokens.accessToken, result.tokens.refreshToken);
    return result.user;
  }

  // -------------------------------------------------------
  // Auto-login (check stored session)
  // -------------------------------------------------------
  Future<UserModel?> tryAutoLogin() async {
    final hasSession = await _secureStorage.hasValidSession();
    if (!hasSession) return null;

    try {
      return await _remoteDataSource.getMe();
    } catch (_) {
      // Token expired or invalid — clear and return null
      await _secureStorage.clearSession();
      return null;
    }
  }

  // -------------------------------------------------------
  // OTP
  // -------------------------------------------------------
  Future<void> sendOtp(String phone) => _remoteDataSource.sendOtp(phone);

  Future<void> verifyOtp({required String phone, required String otp}) =>
      _remoteDataSource.verifyOtp(phone: phone, otp: otp);

  // -------------------------------------------------------
  // Logout
  // -------------------------------------------------------
  Future<void> logout() async {
    final refreshToken = await _secureStorage.getRefreshToken();
    final deviceUid    = await _secureStorage.getDeviceUid();

    await _remoteDataSource.logout(
      refreshToken: refreshToken,
      deviceUid:    deviceUid,
    );
    await _secureStorage.clearSession();
  }

  // -------------------------------------------------------
  // Helper — persist tokens + session
  // -------------------------------------------------------
  Future<void> _persistSession(
    UserModel user,
    String accessToken,
    String refreshToken,
  ) async {
    await Future.wait([
      _secureStorage.saveTokens(
        accessToken:  accessToken,
        refreshToken: refreshToken,
      ),
      _secureStorage.saveUserSession(
        userId:   user.id,
        username: user.username,
        isGuest:  user.isGuest,
      ),
    ]);
  }
}
