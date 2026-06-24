import 'package:dio/dio.dart';

import 'app_exception.dart';

/// Converts a [DioException] into a typed [AppException].
///
/// The backend reports errors as `{"detail": {"code", "message"}}`, but
/// FastAPI's 422 validation responses use `{"detail": [ {loc, msg, type} ]}`.
/// [parseDetail] defends against both shapes.
AppException mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      return const NetworkFailure();
    case DioExceptionType.cancel:
      return const UnknownFailure('요청이 취소되었어요');
    case DioExceptionType.badCertificate:
      return const NetworkFailure('보안 인증서 오류가 발생했어요');
    case DioExceptionType.badResponse:
    case DioExceptionType.unknown:
      break;
  }

  final status = e.response?.statusCode;
  final detail = _ParsedDetail.from(e.response?.data);

  switch (status) {
    case 400:
      return detail.message != null
          ? UnknownFailure(detail.message!)
          : const UnknownFailure('잘못된 요청이에요');
    case 401:
      return UnauthorizedFailure(detail.message ?? '로그인이 필요해요');
    case 403:
      return UnauthorizedFailure(detail.message ?? '권한이 없어요');
    case 404:
      return NotFoundFailure(detail.message ?? '대상을 찾을 수 없어요');
    case 409:
      return ConflictFailure(detail.message ?? '이미 존재하는 정보예요');
    case 422:
      return ValidationFailure(
        detail.message ?? '입력값을 확인해주세요',
        fieldErrors: detail.fieldErrors,
      );
  }

  if (status != null && status >= 500) {
    return ServerFailure(detail.message ?? '서버에 문제가 발생했어요');
  }
  if (e.error is AppException) return e.error as AppException;
  return UnknownFailure(detail.message ?? '알 수 없는 오류가 발생했어요');
}

/// Result of defensively parsing the `detail` field of an error body.
class _ParsedDetail {
  const _ParsedDetail({this.message, this.fieldErrors = const {}});

  final String? message;
  final Map<String, String> fieldErrors;

  /// Reads `data['detail']`, tolerating a String, a `{code, message}` Map, or a
  /// list of `{loc, msg, type}` validation entries.
  factory _ParsedDetail.from(Object? data) {
    if (data is! Map) return const _ParsedDetail();
    final detail = data['detail'];

    // Plain string detail.
    if (detail is String) return _ParsedDetail(message: detail);

    // `{code, message}` shape.
    if (detail is Map) {
      final msg = detail['message'];
      return _ParsedDetail(message: msg is String ? msg : null);
    }

    // FastAPI 422 list of validation errors.
    if (detail is List) {
      final errors = <String, String>{};
      String? firstMsg;
      for (final item in detail) {
        if (item is! Map) continue;
        final msg = item['msg'];
        if (msg is! String) continue;
        firstMsg ??= msg;
        // `loc` is like ["body", "email"]; use the last segment as the field.
        final loc = item['loc'];
        if (loc is List && loc.isNotEmpty) {
          final field = loc.last.toString();
          errors.putIfAbsent(field, () => msg);
        }
      }
      return _ParsedDetail(message: firstMsg, fieldErrors: errors);
    }

    return const _ParsedDetail();
  }
}
