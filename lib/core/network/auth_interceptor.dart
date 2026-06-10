import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../storage/secure_storage.dart';

/// Injects Bearer token into every request.
/// On 401: refreshes token pair and retries the original request once.
class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final SecureStorage _secureStorage;
  bool _isRefreshing = false;

  AuthInterceptor({
    required Dio dio,
    required SecureStorage secureStorage,
  })  : _dio = dio,
        _secureStorage = secureStorage;

  // -------------------------------------------------------
  // Inject access token
  // -------------------------------------------------------
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  // -------------------------------------------------------
  // Handle 401 → refresh → retry
  // -------------------------------------------------------
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;

    // Skip refresh for auth endpoints themselves to avoid infinite loop
    final path = err.requestOptions.path;
    final isAuthPath = path == ApiConstants.login ||
        path == ApiConstants.refreshToken ||
        path == ApiConstants.guestLogin;

    if (statusCode == 401 && !isAuthPath && !_isRefreshing) {
      _isRefreshing = true;
      try {
        final refreshToken = await _secureStorage.getRefreshToken();
        if (refreshToken == null) {
          _isRefreshing = false;
          return handler.reject(err);
        }

        // Call refresh endpoint
        final refreshDio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
        final response = await refreshDio.post(
          ApiConstants.refreshToken,
          data: {'refresh_token': refreshToken},
        );

        final newAccessToken  = response.data['data']['tokens']['access_token'] as String;
        final newRefreshToken = response.data['data']['tokens']['refresh_token'] as String;

        await _secureStorage.saveTokens(
          accessToken:  newAccessToken,
          refreshToken: newRefreshToken,
        );

        // Retry original request with new token
        err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
        final retryResponse = await _dio.fetch(err.requestOptions);
        _isRefreshing = false;
        return handler.resolve(retryResponse);
      } catch (_) {
        _isRefreshing = false;
        // Refresh failed — clear session and propagate error
        await _secureStorage.clearSession();
        return handler.reject(err);
      }
    }

    return handler.next(err);
  }
}
