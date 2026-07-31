import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../screens/home/learning_summary.dart';
import '../data/datasources/normalcall_remote_data_source.dart';
import '../data/repositories/normalcall_repository_impl.dart';
import '../domain/entities/call_result.dart';
import '../domain/entities/pron_summary.dart';
import '../domain/repositories/normalcall_repository.dart';

/// Remote data source bound to the configured [dioProvider].
final normalcallRemoteDataSourceProvider =
    Provider<NormalcallRemoteDataSource>((ref) {
  return NormalcallRemoteDataSource(ref.watch(dioProvider));
});

/// Normalcall analysis repository (domain interface) backed by the remote
/// data source.
final normalcallRepositoryProvider = Provider<NormalcallRepository>((ref) {
  return NormalcallRepositoryImpl(
    remote: ref.watch(normalcallRemoteDataSourceProvider),
  );
});

/// Paginated past-call state for the record list — accumulates pages so the
/// list can grow via infinite scroll.
class CallListState {
  const CallListState({
    this.items = const [],
    this.isLoadingMore = false,
    this.hasMore = true,
  });

  /// Calls loaded so far (newest first), across all pages fetched.
  final List<CallSummary> items;

  /// A next-page request is in flight (drives the bottom spinner).
  final bool isLoadingMore;

  /// The last page was full, so more may exist. False once a short/empty page
  /// comes back — the end of the list.
  final bool hasMore;

  CallListState copyWith({
    List<CallSummary>? items,
    bool? isLoadingMore,
    bool? hasMore,
  }) =>
      CallListState(
        items: items ?? this.items,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        hasMore: hasMore ?? this.hasMore,
      );
}

/// Past calls for the record list (`GET /calls`), paginated. The first page
/// loads as the `AsyncValue`; [loadMore] appends the next page for infinite
/// scroll. Auto-disposes so re-entering refetches; `ref.invalidate` retries.
class CallListNotifier extends AutoDisposeAsyncNotifier<CallListState> {
  static const _pageSize = 20;

  @override
  Future<CallListState> build() async {
    final first = await ref
        .watch(normalcallRepositoryProvider)
        .listCalls(limit: _pageSize, offset: 0);
    return CallListState(items: first, hasMore: first.length == _pageSize);
  }

  /// Fetch and append the next page. No-op while already loading or exhausted;
  /// on error keeps what's loaded (a later scroll retries).
  Future<void> loadMore() async {
    final s = state.valueOrNull;
    if (s == null || s.isLoadingMore || !s.hasMore) return;
    state = AsyncData(s.copyWith(isLoadingMore: true));
    try {
      final next = await ref
          .read(normalcallRepositoryProvider)
          .listCalls(limit: _pageSize, offset: s.items.length);
      state = AsyncData(
        CallListState(
          items: [...s.items, ...next],
          hasMore: next.length == _pageSize,
        ),
      );
    } catch (_) {
      state = AsyncData(s.copyWith(isLoadingMore: false));
    }
  }
}

final callListProvider =
    AsyncNotifierProvider.autoDispose<CallListNotifier, CallListState>(
  CallListNotifier.new,
);

/// 복습 종료 발음 리포트 (`GET /calls/{callId}/pronunciation-report`), callId 로
/// 파라미터화. Auto-disposes 하여 재진입 시 재조회; `ref.invalidate` 로 재시도.
final pronunciationReportProvider =
    FutureProvider.autoDispose.family<LearningSummary, int>((ref, callId) async {
  return ref.watch(normalcallRepositoryProvider).getPronunciationReport(callId);
});

/// 마이페이지 발음 카드 — 최근 10세션 발음 4지표 평균.
///
/// autoDispose: 마이페이지를 벗어나면 버리고 재진입 시 다시 읽는다(통화 후 값이
/// 바뀌므로 캐시를 오래 들고 있을 이유가 없다).
final pronunciationSummaryProvider =
    FutureProvider.autoDispose<PronSummary>((ref) async {
  return ref.watch(normalcallRepositoryProvider).getPronunciationSummary();
});
