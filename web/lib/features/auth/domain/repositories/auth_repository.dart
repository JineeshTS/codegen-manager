import '../../../../core/types/result.dart';
import '../entities/user.dart';

/// Abstract authentication repository interface.
/// Defines the contract for authentication operations.
abstract class AuthRepository {
  /// Register a new user
  Future<Result<User>> register({
    required String email,
    required String password,
    required String fullName,
  });

  /// Login with email and password
  Future<Result<User>> login({
    required String email,
    required String password,
  });

  /// Logout the current user
  Future<Result<void>> logout();

  /// Get the current authenticated user
  Future<Result<User>> getCurrentUser();

  /// Update the current user's profile
  Future<Result<User>> updateProfile({
    String? fullName,
    String? currentPassword,
    String? newPassword,
  });

  /// Check if user is authenticated
  Future<bool> isAuthenticated();
}
