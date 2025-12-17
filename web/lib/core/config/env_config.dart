/// Environment configuration for the application.
/// Values can be overridden at build time using --dart-define flags.
///
/// Example:
/// ```bash
/// flutter build web --dart-define=API_BASE_URL=https://api.production.com
/// flutter run --dart-define=API_BASE_URL=http://localhost:8000/api/v1
/// ```
class EnvConfig {
  EnvConfig._(); // Private constructor to prevent instantiation

  // ═══════════════════════════════════════════════════════════════
  // API CONFIGURATION
  // ═══════════════════════════════════════════════════════════════

  /// API base URL
  /// Default: http://localhost:8000/api/v1 (for local development)
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000/api/v1',
  );

  // ═══════════════════════════════════════════════════════════════
  // ENVIRONMENT
  // ═══════════════════════════════════════════════════════════════

  /// Environment name (development, staging, production)
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  /// Check if running in production
  static bool get isProduction => environment == 'production';

  /// Check if running in development
  static bool get isDevelopment => environment == 'development';

  /// Check if running in staging
  static bool get isStaging => environment == 'staging';

  // ═══════════════════════════════════════════════════════════════
  // FEATURE FLAGS
  // ═══════════════════════════════════════════════════════════════

  /// Enable debug logging
  static const bool enableDebugLogging = bool.fromEnvironment(
    'ENABLE_DEBUG_LOGGING',
    defaultValue: true,
  );

  /// Enable performance monitoring
  static const bool enablePerformanceMonitoring = bool.fromEnvironment(
    'ENABLE_PERFORMANCE_MONITORING',
    defaultValue: false,
  );

  // ═══════════════════════════════════════════════════════════════
  // TIMEOUTS
  // ═══════════════════════════════════════════════════════════════

  /// API connection timeout in seconds
  static const int connectionTimeoutSeconds = int.fromEnvironment(
    'CONNECTION_TIMEOUT',
    defaultValue: 30,
  );

  /// API receive timeout in seconds
  static const int receiveTimeoutSeconds = int.fromEnvironment(
    'RECEIVE_TIMEOUT',
    defaultValue: 30,
  );

  // ═══════════════════════════════════════════════════════════════
  // APP INFO
  // ═══════════════════════════════════════════════════════════════

  /// App name
  static const String appName = 'CodeGen Manager';

  /// App version
  static const String appVersion = '1.0.0';

  // ═══════════════════════════════════════════════════════════════
  // DEBUG INFO
  // ═══════════════════════════════════════════════════════════════

  /// Print all environment configuration (useful for debugging)
  static void printConfig() {
    if (!enableDebugLogging) return;

    print('═══════════════════════════════════════════════════════════');
    print('Environment Configuration');
    print('═══════════════════════════════════════════════════════════');
    print('App Name: $appName');
    print('App Version: $appVersion');
    print('Environment: $environment');
    print('API Base URL: $apiBaseUrl');
    print('Connection Timeout: ${connectionTimeoutSeconds}s');
    print('Receive Timeout: ${receiveTimeoutSeconds}s');
    print('Debug Logging: $enableDebugLogging');
    print('Performance Monitoring: $enablePerformanceMonitoring');
    print('═══════════════════════════════════════════════════════════');
  }
}
