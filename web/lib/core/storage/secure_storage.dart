import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage for sensitive data like auth tokens.
/// Uses flutter_secure_storage which provides encrypted storage.
class SecureStorage {
  final FlutterSecureStorage _storage;

  SecureStorage()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock,
          ),
          webOptions: WebOptions(
            dbName: 'codegen_manager_secure',
            publicKey: 'codegen_manager_public_key',
          ),
        );

  // ═══════════════════════════════════════════════════════════════
  // KEYS
  // ═══════════════════════════════════════════════════════════════

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';

  // ═══════════════════════════════════════════════════════════════
  // ACCESS TOKEN
  // ═══════════════════════════════════════════════════════════════

  /// Save access token
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Delete access token
  Future<void> deleteAccessToken() async {
    await _storage.delete(key: _accessTokenKey);
  }

  // ═══════════════════════════════════════════════════════════════
  // REFRESH TOKEN
  // ═══════════════════════════════════════════════════════════════

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Delete refresh token
  Future<void> deleteRefreshToken() async {
    await _storage.delete(key: _refreshTokenKey);
  }

  // ═══════════════════════════════════════════════════════════════
  // USER ID
  // ═══════════════════════════════════════════════════════════════

  /// Save user ID
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  /// Get user ID
  Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  /// Delete user ID
  Future<void> deleteUserId() async {
    await _storage.delete(key: _userIdKey);
  }

  // ═══════════════════════════════════════════════════════════════
  // AUTH SESSION
  // ═══════════════════════════════════════════════════════════════

  /// Save complete auth session
  Future<void> saveAuthSession({
    required String accessToken,
    required String refreshToken,
    required String userId,
  }) async {
    await Future.wait([
      saveAccessToken(accessToken),
      saveRefreshToken(refreshToken),
      saveUserId(userId),
    ]);
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear all auth data (logout)
  Future<void> clearAuthSession() async {
    await Future.wait([
      deleteAccessToken(),
      deleteRefreshToken(),
      deleteUserId(),
    ]);
  }

  // ═══════════════════════════════════════════════════════════════
  // GENERIC STORAGE
  // ═══════════════════════════════════════════════════════════════

  /// Write any key-value pair
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Read any value by key
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// Delete any key
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Delete all stored data
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
