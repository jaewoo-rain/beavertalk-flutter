import 'dart:async';
import 'dart:io' show SocketException;

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/app_exception.dart';
import '../../domain/entities/report_reason.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/report_remote_data_source.dart';

/// [ReportRepository] 구현. Supabase 예외를 [AppException] 으로 옮긴다.
class ReportRepositoryImpl implements ReportRepository {
  /// [ds] 로 적재하고, [locale] 로 신고 당시 표시 언어를 남긴다.
  ReportRepositoryImpl(this._ds, {String? Function()? locale})
      : _locale = locale;

  final ReportRemoteDataSource _ds;
  final String? Function()? _locale;

  @override
  Future<void> submit({
    required ReportReason reason,
    required ReportSource source,
    int? callId,
    String? detail,
  }) async {
    try {
      await _ds.insert(
        reason: reason.code,
        source: source.code,
        callId: callId,
        detail: detail?.trim(),
        locale: _locale?.call(),
      );
    } on PostgrestException catch (e) {
      // RLS 위반·제약 위반은 코드로 갈린다. 42501 = insufficient_privilege.
      if (e.code == '42501' || e.code == 'PGRST301') {
        throw const UnauthorizedFailure();
      }
      throw ServerFailure.server(e.message);
    } on AuthException {
      throw const UnauthorizedFailure();
    } on SocketException {
      throw const NetworkFailure();
    } on TimeoutException {
      throw const NetworkFailure();
    } catch (e) {
      throw UnknownFailure('$e');
    }
  }
}
