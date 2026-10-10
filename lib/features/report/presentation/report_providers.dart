import 'dart:ui' show PlatformDispatcher;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/datasources/report_remote_data_source.dart';
import '../data/repositories/report_repository_impl.dart';
import '../domain/repositories/report_repository.dart';

/// 신고 적재용 Supabase 데이터 소스.
final reportRemoteDataSourceProvider = Provider<ReportRemoteDataSource>((ref) {
  return ReportRemoteDataSource(Supabase.instance.client);
});

/// 유해 콘텐츠 신고 리포지토리.
///
/// 로케일은 신고 시점의 기기 언어를 남기려는 것이다 — 어떤 언어로 오간 대화에
/// 대한 신고인지가 검토에 필요하다.
final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepositoryImpl(
    ref.watch(reportRemoteDataSourceProvider),
    locale: () => PlatformDispatcher.instance.locale.toLanguageTag(),
  );
});
