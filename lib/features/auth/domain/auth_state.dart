import 'package:freezed_annotation/freezed_annotation.dart';
import '../data/models/user_model.dart';

part 'auth_state.freezed.dart';

/// Sealed auth state managed by [AuthNotifier]
@freezed
sealed class AuthState with _$AuthState {
  /// Initial — checking stored tokens
  const factory AuthState.initial() = AuthInitial;

  /// Valid authenticated session
  const factory AuthState.authenticated({required UserModel user}) =
      AuthAuthenticated;

  /// No session or session expired
  const factory AuthState.unauthenticated() = AuthUnauthenticated;

  /// Error state (e.g. login failed)
  const factory AuthState.error({required String message}) = AuthError;
}

/// Extension for convenient access
extension AuthStateX on AuthState {
  bool get isAuthenticated => this is AuthAuthenticated;
  bool get isUnauthenticated => this is AuthUnauthenticated;
  bool get isInitial => this is AuthInitial;

  UserModel? get user => switch (this) {
        AuthAuthenticated(:final user) => user,
        _ => null,
      };
}
