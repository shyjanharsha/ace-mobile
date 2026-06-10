import 'package:dio/dio.dart';

/// Unified exception hierarchy for the app
sealed class AppException implements Exception {
  final String message;
  final int? statusCode;
  const AppException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// Network connectivity issue
class NetworkException extends AppException {
  const NetworkException([String message = 'No internet connection'])
      : super(message);
}

/// HTTP 401 — authentication failed
class AuthException extends AppException {
  const AuthException([String message = 'Session expired. Please log in again.'])
      : super(message, statusCode: 401);
}

/// HTTP 403 — authorization failed
class ForbiddenException extends AppException {
  const ForbiddenException([String message = 'You are not allowed to do that.'])
      : super(message, statusCode: 403);
}

/// HTTP 404
class NotFoundException extends AppException {
  const NotFoundException([String message = 'Resource not found'])
      : super(message, statusCode: 404);
}

/// HTTP 422 — validation error
class ValidationException extends AppException {
  const ValidationException(String message)
      : super(message, statusCode: 422);
}

/// HTTP 429 — rate limited
class RateLimitException extends AppException {
  const RateLimitException([String message = 'Too many requests. Please slow down.'])
      : super(message, statusCode: 429);
}

/// HTTP 5xx — server error
class ServerException extends AppException {
  const ServerException([String message = 'Something went wrong on our end.'])
      : super(message, statusCode: 500);
}

/// Game-specific logic errors
class GameException extends AppException {
  const GameException(String message) : super(message);
}

/// Timeout
class TimeoutException extends AppException {
  const TimeoutException([String message = 'Request timed out']) : super(message);
}

/// Parse / unexpected format
class ParseException extends AppException {
  const ParseException([String message = 'Failed to parse response']) : super(message);
}

/// Converts DioException into typed AppException
class ErrorHandler {
  static AppException handle(Object error) {
    if (error is DioException) {
      return _handleDio(error);
    }
    return ServerException(error.toString());
  }

  static AppException _handleDio(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();

      case DioExceptionType.connectionError:
        return const NetworkException();

      case DioExceptionType.badResponse:
        return _handleHttpStatus(error.response);

      case DioExceptionType.cancel:
        return const NetworkException('Request cancelled');

      default:
        return ServerException(error.message ?? 'Unknown error');
    }
  }

  static AppException _handleHttpStatus(Response? response) {
    final code    = response?.statusCode ?? 0;
    final message = _extractMessage(response);

    return switch (code) {
      401 => const AuthException(),
      403 => ForbiddenException(message),
      404 => NotFoundException(message),
      422 => ValidationException(message),
      429 => const RateLimitException(),
      >= 500 => ServerException(message),
      _ => ServerException(message),
    };
  }

  static String _extractMessage(Response? response) {
    try {
      final data = response?.data;
      if (data is Map<String, dynamic>) {
        return data['error'] as String? ??
            data['message'] as String? ??
            'An error occurred';
      }
    } catch (_) {}
    return 'An error occurred (${response?.statusCode})';
  }
}
