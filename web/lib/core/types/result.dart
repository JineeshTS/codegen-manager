import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

/// Result type for async operations that can succeed or fail.
/// Use this instead of throwing exceptions for expected failures.
///
/// Example:
/// ```dart
/// Future<Result<User>> getUser(String id) async {
///   try {
///     final user = await api.getUser(id);
///     return Result.success(user);
///   } on NetworkException {
///     return const Result.failure(Failure.network());
///   }
/// }
/// ```
@freezed
sealed class Result<T> with _$Result<T> {
  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(Failure failure) = _ResultFailure<T>;
}

/// Failure types for Result.
@freezed
sealed class Failure with _$Failure {
  /// Server error - API returned an error response
  const factory Failure.server({
    required String message,
    int? statusCode,
  }) = ServerFailure;

  /// Network error - no internet connection or request timeout
  const factory Failure.network({
    String? message,
  }) = NetworkFailure;

  /// Cache error - local storage operation failed
  const factory Failure.cache({
    required String message,
  }) = CacheFailure;

  /// Validation error - input validation failed
  const factory Failure.validation({
    required String message,
    Map<String, String>? errors,
  }) = ValidationFailure;

  /// Unauthorized error - user not authenticated or token expired
  const factory Failure.unauthorized({
    String? message,
  }) = UnauthorizedFailure;

  /// Not found error - resource doesn't exist
  const factory Failure.notFound({
    required String message,
  }) = NotFoundFailure;

  /// Forbidden error - user doesn't have permission
  const factory Failure.forbidden({
    String? message,
  }) = ForbiddenFailure;
}

/// Extension methods on Result for common operations
extension ResultExtension<T> on Result<T> {
  /// Returns true if the result is a success
  bool get isSuccess => this is Success<T>;

  /// Returns true if the result is a failure
  bool get isFailure => this is _ResultFailure<T>;

  /// Get the data if success, or null if failure
  T? get dataOrNull => when(
        success: (data) => data,
        failure: (_) => null,
      );

  /// Get the failure if failure, or null if success
  Failure? get failureOrNull => when(
        success: (_) => null,
        failure: (failure) => failure,
      );
}
