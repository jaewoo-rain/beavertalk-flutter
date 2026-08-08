/// App-facing error type. Repositories translate `DioException`s into one of
/// these so the presentation layer never touches dio.
///
/// `sealed` lets controllers `switch` over every case exhaustively.
sealed class AppException implements Exception {
  const AppException(this.message, {this.fromServer = false});

  /// Human-readable message safe to show in the UI.
  final String message;

  /// Whether [message] is the server's own `detail.message` rather than this
  /// class's built-in fallback.
  ///
  /// **The fallbacks below are hardcoded Korean.** A screen that renders
  /// [message] unconditionally therefore shows Korean in all 30 locales
  /// whenever the failure was classified client-side — and an offline device
  /// never reaches a server, so it always lands on the fallback. That is
  /// exactly what happened: `네트워크 연결을 확인해주세요` under an otherwise
  /// English UI, caught on a real device with wifi off.
  ///
  /// The fallbacks cannot be localized where they are written — this layer has
  /// no [BuildContext]. So the flag lets the UI decide instead: render
  /// [message] when the server wrote it (it is the only source of a specific
  /// reason), and fall back to the screen's own l10n copy otherwise.
  final bool fromServer;

  @override
  String toString() => '$runtimeType($message)';
}

/// No connection / timeout / DNS — the request never reached the server.
class NetworkFailure extends AppException {
  const NetworkFailure([super.message = '네트워크 연결을 확인해주세요']);

  /// The server supplied this message — see [AppException.fromServer].
  const NetworkFailure.server(super.message) : super(fromServer: true);
}

/// 401 — missing/expired/invalid credentials. Triggers session expiry.
class UnauthorizedFailure extends AppException {
  const UnauthorizedFailure([super.message = '로그인이 필요해요']);

  /// The server supplied this message — see [AppException.fromServer].
  const UnauthorizedFailure.server(super.message) : super(fromServer: true);
}

/// 403 — authenticated but not allowed. Distinct from [UnauthorizedFailure] so
/// callers (e.g. the auth gate) don't sign the user out on a mere permission
/// error — the session is still valid.
class ForbiddenFailure extends AppException {
  const ForbiddenFailure([super.message = '권한이 없어요']);

  /// The server supplied this message — see [AppException.fromServer].
  const ForbiddenFailure.server(super.message) : super(fromServer: true);
}

/// 404 — resource not found.
class NotFoundFailure extends AppException {
  const NotFoundFailure([super.message = '대상을 찾을 수 없어요']);

  /// The server supplied this message — see [AppException.fromServer].
  const NotFoundFailure.server(super.message) : super(fromServer: true);
}

/// 409 — conflict, e.g. signing up with an email that already exists.
class ConflictFailure extends AppException {
  const ConflictFailure([super.message = '이미 존재하는 정보예요']);

  /// The server supplied this message — see [AppException.fromServer].
  const ConflictFailure.server(super.message) : super(fromServer: true);
}

/// 409 with `code: "PRICE_CHANGED"` — the price moved between the moment the
/// screen rendered it and the moment the purchase reached the server.
///
/// A limited-time discount ending mid-tap is the case this exists for: the user
/// saw `$5` and the server would have charged `$10`. The server refuses rather
/// than billing an amount the user never agreed to, and returns both figures so
/// the app can re-confirm at the real price.
///
/// Prices are **minor units (cents)**, like everywhere else in the app.
class PriceChangedFailure extends AppException {
  const PriceChangedFailure(
    super.message, {
    required this.expectedPrice,
    required this.actualPrice,
    super.fromServer,
  });

  /// What the client sent as "the price I showed the user".
  final int expectedPrice;

  /// What the server actually charges now.
  final int actualPrice;
}

/// 422 — request validation failed. [fieldErrors] maps a field name to its
/// first error message (empty when the server sent a non-field message).
class ValidationFailure extends AppException {
  const ValidationFailure(super.message,
      {this.fieldErrors = const {}, super.fromServer});

  /// Per-field messages, keyed by the field name (e.g. `email`).
  final Map<String, String> fieldErrors;
}

/// 5xx — the server failed to handle a valid request.
class ServerFailure extends AppException {
  const ServerFailure([super.message = '서버에 문제가 발생했어요']);

  /// The server supplied this message — see [AppException.fromServer].
  const ServerFailure.server(super.message) : super(fromServer: true);
}

/// Anything we could not classify.
class UnknownFailure extends AppException {
  const UnknownFailure([super.message = '알 수 없는 오류가 발생했어요']);

  /// The server supplied this message — see [AppException.fromServer].
  const UnknownFailure.server(super.message) : super(fromServer: true);
}
