import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/auth_state.dart';

/// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => getIt<AuthRepository>(),
);

/// Auth state notifier — manages login, signup, guest, logout, auto-login
final authStateProvider =
    AsyncNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<AuthState> {
  AuthRepository get _repo => ref.read(authRepositoryProvider);

  @override
  Future<AuthState> build() async {
    // On startup — try auto-login from stored token
    final user = await _repo.tryAutoLogin();
    return user != null
        ? AuthState.authenticated(user: user)
        : const AuthState.unauthenticated();
  }

  // -------------------------------------------------------
  // Login with identifier (email/phone/username) + password
  // -------------------------------------------------------
  Future<void> login({
    required String identifier,
    required String password,
    String? deviceUid,
    String? platform,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = await _repo.login(
        identifier: identifier,
        password:   password,
        deviceUid:  deviceUid,
        platform:   platform,
      );
      return AuthState.authenticated(user: user);
    });
  }

  // -------------------------------------------------------
  // Register new account
  // -------------------------------------------------------
  Future<void> signup({
    required String username,
    required String password,
    String? phone,
    String? email,
    String? displayName,
    String? deviceUid,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = await _repo.signup(
        username:    username,
        password:    password,
        phone:       phone,
        email:       email,
        displayName: displayName,
        deviceUid:   deviceUid,
      );
      return AuthState.authenticated(user: user);
    });
  }

  // -------------------------------------------------------
  // Play as guest
  // -------------------------------------------------------
  Future<void> guestLogin() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = await _repo.guestLogin();
      return AuthState.authenticated(user: user);
    });
  }

  // -------------------------------------------------------
  // Logout
  // -------------------------------------------------------
  Future<void> logout() async {
    await _repo.logout();
    state = const AsyncValue.data(AuthState.unauthenticated());
  }

  // -------------------------------------------------------
  // OTP
  // -------------------------------------------------------
  Future<void> sendOtp(String phone) => _repo.sendOtp(phone);

  Future<void> verifyOtp({required String phone, required String otp}) =>
      _repo.verifyOtp(phone: phone, otp: otp);

  // -------------------------------------------------------
  // Convenience getters
  // -------------------------------------------------------
  bool get isAuthenticated =>
      state.value?.isAuthenticated ?? false;
}
