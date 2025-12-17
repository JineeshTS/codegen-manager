import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/types/result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';

part 'auth_provider.g.dart';

// ═══════════════════════════════════════════════════════════════
// DEPENDENCIES
// ═══════════════════════════════════════════════════════════════

@riverpod
SecureStorage secureStorage(SecureStorageRef ref) {
  return SecureStorage();
}

@riverpod
ApiClient apiClient(ApiClientRef ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return ApiClient(secureStorage: secureStorage);
}

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthRepositoryImpl(
    apiClient: apiClient,
    secureStorage: secureStorage,
  );
}

// ═══════════════════════════════════════════════════════════════
// AUTH STATE
// ═══════════════════════════════════════════════════════════════

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<User?> build() async {
    // Check if user is authenticated on app start
    final repository = ref.read(authRepositoryProvider);
    final isAuth = await repository.isAuthenticated();

    if (!isAuth) {
      return null;
    }

    // Fetch current user
    final result = await repository.getCurrentUser();
    return result.when(
      success: (user) => user,
      failure: (_) => null,
    );
  }

  /// Register a new user
  Future<Result<User>> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final repository = ref.read(authRepositoryProvider);

    final result = await repository.register(
      email: email,
      password: password,
      fullName: fullName,
    );

    result.when(
      success: (user) {
        // Update state with the new user
        state = AsyncData(user);
      },
      failure: (_) {
        // Keep current state on failure
      },
    );

    return result;
  }

  /// Login with email and password
  Future<Result<User>> login({
    required String email,
    required String password,
  }) async {
    final repository = ref.read(authRepositoryProvider);

    final result = await repository.login(
      email: email,
      password: password,
    );

    result.when(
      success: (user) {
        // Update state with the logged in user
        state = AsyncData(user);
      },
      failure: (_) {
        // Keep current state on failure
      },
    );

    return result;
  }

  /// Logout the current user
  Future<Result<void>> logout() async {
    final repository = ref.read(authRepositoryProvider);

    final result = await repository.logout();

    result.when(
      success: (_) {
        // Clear user state
        state = const AsyncData(null);
      },
      failure: (_) {
        // Clear user state anyway on logout
        state = const AsyncData(null);
      },
    );

    return result;
  }

  /// Update user profile
  Future<Result<User>> updateProfile({
    String? fullName,
    String? currentPassword,
    String? newPassword,
  }) async {
    final repository = ref.read(authRepositoryProvider);

    final result = await repository.updateProfile(
      fullName: fullName,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    result.when(
      success: (user) {
        // Update state with updated user
        state = AsyncData(user);
      },
      failure: (_) {
        // Keep current state on failure
      },
    );

    return result;
  }

  /// Refresh current user data
  Future<void> refresh() async {
    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.getCurrentUser();

    state = result.when(
      success: (user) => AsyncData(user),
      failure: (_) => const AsyncData(null),
    );
  }
}
