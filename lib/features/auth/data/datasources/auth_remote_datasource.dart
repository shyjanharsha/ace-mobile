import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../models/user_model.dart';
import '../models/auth_tokens.dart';

/// Remote data source — raw API calls for auth endpoints
class AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSource({required ApiClient apiClient})
      : _apiClient = apiClient;

  // -------------------------------------------------------
  // Login
  // -------------------------------------------------------
  Future<({UserModel user, AuthTokens tokens})> login({
    required String identifier,
    required String password,
    String? deviceUid,
    String? platform,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.login,
        data: {
          'identifier': identifier,
          'password':   password,
          if (deviceUid != null) 'device_uid': deviceUid,
          if (platform  != null) 'platform':   platform,
        },
      );
      final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      return (
        user:   UserModel.fromJson(data['user'] as Map<String, dynamic>),
        tokens: AuthTokens.fromJson(data['tokens'] as Map<String, dynamic>),
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // -------------------------------------------------------
  // Signup
  // -------------------------------------------------------
  Future<({UserModel user, AuthTokens tokens})> signup({
    required String username,
    required String password,
    String? phone,
    String? email,
    String? displayName,
    String? deviceUid,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.signup,
        data: {
          'username':     username,
          'password':     password,
          if (phone       != null) 'phone':        phone,
          if (email       != null) 'email':        email,
          if (displayName != null) 'display_name': displayName,
          if (deviceUid   != null) 'device_uid':   deviceUid,
        },
      );
      final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      return (
        user:   UserModel.fromJson(data['user'] as Map<String, dynamic>),
        tokens: AuthTokens.fromJson(data['tokens'] as Map<String, dynamic>),
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // -------------------------------------------------------
  // Guest login
  // -------------------------------------------------------
  Future<({UserModel user, AuthTokens tokens})> guestLogin() async {
    try {
      final response = await _apiClient.post(ApiConstants.guestLogin);
      final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      return (
        user:   UserModel.fromJson(data['user'] as Map<String, dynamic>),
        tokens: AuthTokens.fromJson(data['tokens'] as Map<String, dynamic>),
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // -------------------------------------------------------
  // Send OTP
  // -------------------------------------------------------
  Future<void> sendOtp(String phone) async {
    try {
      await _apiClient.post(ApiConstants.sendOtp, data: {'phone': phone});
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // -------------------------------------------------------
  // Verify OTP
  // -------------------------------------------------------
  Future<void> verifyOtp({required String phone, required String otp}) async {
    try {
      await _apiClient.post(
        ApiConstants.verifyPhone,
        data: {'phone': phone, 'otp': otp},
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // -------------------------------------------------------
  // Refresh tokens
  // -------------------------------------------------------
  Future<AuthTokens> refreshTokens(String refreshToken) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.refreshToken,
        data: {'refresh_token': refreshToken},
      );
      final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      return AuthTokens.fromJson(data['tokens'] as Map<String, dynamic>);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // -------------------------------------------------------
  // Get current user (me)
  // -------------------------------------------------------
  Future<UserModel> getMe() async {
    try {
      final response = await _apiClient.get(ApiConstants.me);
      final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      return UserModel.fromJson(data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // -------------------------------------------------------
  // Logout
  // -------------------------------------------------------
  Future<void> logout({String? refreshToken, String? deviceUid}) async {
    try {
      await _apiClient.delete(
        ApiConstants.logout,
        data: {
          if (refreshToken != null) 'refresh_token': refreshToken,
          if (deviceUid    != null) 'device_uid':    deviceUid,
        },
      );
    } catch (_) {
      // Ignore logout errors — clear local session regardless
    }
  }
}
