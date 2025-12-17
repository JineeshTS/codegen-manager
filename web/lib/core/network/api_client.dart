import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../config/env_config.dart';
import '../storage/secure_storage.dart';
import '../types/result.dart' as result_types;

/// HTTP API client using Dio with interceptors for auth and error handling.
class ApiClient {
  late final Dio _dio;
  final SecureStorage _secureStorage;
  final Logger _logger = Logger();

  ApiClient({
    required SecureStorage secureStorage,
  }) : _secureStorage = secureStorage {
    _dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(_authInterceptor());
    _dio.interceptors.add(_loggingInterceptor());
    _dio.interceptors.add(_errorInterceptor());
  }

  // ═══════════════════════════════════════════════════════════════
  // HTTP METHODS
  // ═══════════════════════════════════════════════════════════════

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // INTERCEPTORS
  // ═══════════════════════════════════════════════════════════════

  /// Auth interceptor - adds bearer token to requests
  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Get token from secure storage
        final token = await _secureStorage.getAccessToken();

        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        return handler.next(options);
      },
      onError: (error, handler) async {
        // Handle 401 Unauthorized - token expired
        if (error.response?.statusCode == 401) {
          // Clear expired token
          await _secureStorage.deleteAccessToken();

          // Could implement token refresh logic here
          // For now, just pass the error through
        }

        return handler.next(error);
      },
    );
  }

  /// Logging interceptor - logs requests and responses
  Interceptor _loggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        _logger.d('📤 ${options.method} ${options.uri}');
        _logger.d('Headers: ${options.headers}');
        if (options.data != null) {
          _logger.d('Body: ${options.data}');
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        _logger.i('📥 ${response.statusCode} ${response.requestOptions.uri}');
        _logger.d('Response: ${response.data}');
        return handler.next(response);
      },
      onError: (error, handler) {
        _logger.e('❌ ${error.response?.statusCode} ${error.requestOptions.uri}');
        _logger.e('Error: ${error.message}');
        if (error.response?.data != null) {
          _logger.e('Error Data: ${error.response?.data}');
        }
        return handler.next(error);
      },
    );
  }

  /// Error interceptor - converts Dio errors to app-specific errors
  Interceptor _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        // Convert DioException to a custom exception that can be mapped to Failure
        // The repository layer will handle this conversion
        return handler.next(error);
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // ERROR HANDLING
  // ═══════════════════════════════════════════════════════════════

  /// Convert DioException to Failure
  static result_types.Failure handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const result_types.Failure.network(
            message: 'Connection timeout. Please check your internet connection.',
          );

        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = error.response?.data?['message'] ??
                         error.response?.data?['detail'] ??
                         'Server error occurred';

          switch (statusCode) {
            case 400:
              return result_types.Failure.validation(
                message: message,
                errors: error.response?.data?['errors'],
              );
            case 401:
              return result_types.Failure.unauthorized(message: message);
            case 403:
              return result_types.Failure.forbidden(message: message);
            case 404:
              return result_types.Failure.notFound(message: message);
            default:
              return result_types.Failure.server(
                message: message,
                statusCode: statusCode,
              );
          }

        case DioExceptionType.cancel:
          return const result_types.Failure.network(
            message: 'Request was cancelled',
          );

        case DioExceptionType.connectionError:
        case DioExceptionType.unknown:
          return const result_types.Failure.network(
            message: 'Network error. Please check your internet connection.',
          );

        default:
          return result_types.Failure.server(
            message: error.message ?? 'Unknown error occurred',
          );
      }
    }

    return result_types.Failure.server(
      message: error.toString(),
    );
  }
}
