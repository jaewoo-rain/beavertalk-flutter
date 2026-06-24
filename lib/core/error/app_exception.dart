/// App-facing error type. Repositories translate `DioException`s into one of
/// these so the presentation layer never touches dio.
///
/// `sealed` lets controllers `switch` over every case exhaustively.
sealed class AppException implements Exception {
  const AppException(this.message);

  /// Human-readable message safe to show in the UI.
  final String message;

  @override
  String toString() => '$runtimeType($message)';
}

/// No connection / timeout / DNS — the request never reached the server.
class NetworkFailure extends AppException {
  const NetworkFailure([super.message = '네트워크 연결을 확인해주세요']);
}

/// 401 — missing/expired/invalid credentials. Triggers session expiry.
class UnauthorizedFailure extends AppException {
  const UnauthorizedFailure([super.message = '로그인이 필요해요']);
}

/// 404 — resource not found.
class NotFoundFailure extends AppException {
  const NotFoundFailure([super.message = '대상을 찾을 수 없어요']);
}

/// 409 — conflict, e.g. signing up with an email that already exists.
class ConflictFailure extends AppException {
  const ConflictFailure([super.message = '이미 존재하는 정보예요']);
}

/// 422 — request validation failed. [fieldErrors] maps a field name to its
/// first error message (empty when the server sent a non-field message).
class ValidationFailure extends AppException {
  const ValidationFailure(super.message, {this.fieldErrors = const {}});

  /// Per-field messages, keyed by the field name (e.g. `email`).
  final Map<String, String> fieldErrors;
}

/// 5xx — the server failed to handle a valid request.
class ServerFailure extends AppException {
  const ServerFailure([super.message = '서버에 문제가 발생했어요']);
}

/// Anything we could not classify.
class UnknownFailure extends AppException {
  const UnknownFailure([super.message = '알 수 없는 오류가 발생했어요']);
}
