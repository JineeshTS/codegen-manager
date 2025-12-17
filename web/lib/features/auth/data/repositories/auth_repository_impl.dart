import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/types/result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Implementation of AuthRepository using API client.
class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  final SecureStorage _secureStorage;

  AuthRepositoryImpl({
    required ApiClient apiClient,
    required SecureStorage secureStorage,
  })  : _apiClient = apiClient,
        _secureStorage = secureStorage;

  @override
  Future<Result<User>> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'full_name': fullName,
        },
      );

      // Extract data from response
      final data = response.data['data'];
      final user = User.fromJson(data['user']);
      final accessToken = data['access_token'] as String;

      // Save token
      await _secureStorage.saveAccessToken(accessToken);
      await _secureStorage.saveUserId(user.id);

      return Result.success(user);
    } on DioException catch (e) {
      return Result.failure(ApiClient.handleError(e));
    } catch (e) {
      return Result.failure(
        Failure.server(message: 'Failed to register: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      // Extract data from response
      final data = response.data['data'];
      final user = User.fromJson(data['user']);
      final accessToken = data['access_token'] as String;
      final refreshToken = data['refresh_token'] as String;

      // Save auth session
      await _secureStorage.saveAuthSession(
        accessToken: accessToken,
        refreshToken: refreshToken,
        userId: user.id,
      );

      return Result.success(user);
    } on DioException catch (e) {
      return Result.failure(ApiClient.handleError(e));
    } catch (e) {
      return Result.failure(
        Failure.server(message: 'Failed to login: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      // Call logout endpoint
      await _apiClient.post('/auth/logout');

      // Clear local auth data
      await _secureStorage.clearAuthSession();

      return const Result.success(null);
    } on DioException catch (e) {
      // Even if API call fails, clear local data
      await _secureStorage.clearAuthSession();
      return Result.failure(ApiClient.handleError(e));
    } catch (e) {
      await _secureStorage.clearAuthSession();
      return Result.failure(
        Failure.server(message: 'Failed to logout: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<User>> getCurrentUser() async {
    try {
      final response = await _apiClient.get('/auth/me');

      // Extract user from response
      final data = response.data['data'];
      final user = User.fromJson(data);

      return Result.success(user);
    } on DioException catch (e) {
      return Result.failure(ApiClient.handleError(e));
    } catch (e) {
      return Result.failure(
        Failure.server(message: 'Failed to get current user: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<User>> updateProfile({
    String? fullName,
    String? currentPassword,
    String? newPassword,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (fullName != null) {
        data['full_name'] = fullName;
      }

      if (currentPassword != null && newPassword != null) {
        data['current_password'] = currentPassword;
        data['new_password'] = newPassword;
      }

      final response = await _apiClient.put('/auth/me', data: data);

      // Extract user from response
      final responseData = response.data['data'];
      final user = User.fromJson(responseData);

      return Result.success(user);
    } on DioException catch (e) {
      return Result.failure(ApiClient.handleError(e));
    } catch (e) {
      return Result.failure(
        Failure.server(message: 'Failed to update profile: ${e.toString()}'),
      );
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return await _secureStorage.isAuthenticated();
  }
}
