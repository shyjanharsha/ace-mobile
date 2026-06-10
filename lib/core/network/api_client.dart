import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../constants/api_constants.dart';
import '../storage/secure_storage.dart';
import 'auth_interceptor.dart';

/// Dio HTTP client — configured with base options, interceptors
/// All requests go through this single instance
class ApiClient {
  final Dio _dio;
  final Logger _logger;

  ApiClient({
    required SecureStorage secureStorage,
    Logger? logger,
  })  : _logger = logger ?? Logger(),
        _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: ApiConstants.connectTimeout,
            receiveTimeout: ApiConstants.receiveTimeout,
            sendTimeout:    ApiConstants.sendTimeout,
            headers: {
              'Content-Type': 'application/json',
              'Accept':        'application/json',
            },
          ),
        ) {
    // Add interceptors in order: auth → log → error
    _dio.interceptors.addAll([
      AuthInterceptor(dio: _dio, secureStorage: secureStorage),
      _buildLogInterceptor(),
    ]);
  }

  // -------------------------------------------------------
  // HTTP methods
  // -------------------------------------------------------
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.get<T>(path, queryParameters: queryParameters, options: options);

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.post<T>(path, data: data, queryParameters: queryParameters, options: options);

  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Options? options,
  }) =>
      _dio.patch<T>(path, data: data, options: options);

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Options? options,
  }) =>
      _dio.put<T>(path, data: data, options: options);

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Options? options,
  }) =>
      _dio.delete<T>(path, data: data, options: options);

  // -------------------------------------------------------
  // Log interceptor (dev only)
  // -------------------------------------------------------
  LogInterceptor _buildLogInterceptor() => LogInterceptor(
        requestHeader: false,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        logPrint: (log) => _logger.d(log),
      );
}
