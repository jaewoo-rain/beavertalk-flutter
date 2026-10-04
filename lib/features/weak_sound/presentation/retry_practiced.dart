import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 「자주 틀린 소리」 목록(A5 · M2)을 연 뒤 **결과 화면까지 마친** 소리 키.
///
/// 목록은 이 값으로 「모두 연습했어요」(M19 · Figma `6564:15695`)를 판단한다. 점수 80 이상으로
/// 판단하지 않는 이유: 연습을 마쳤어도 점수가 목표에 못 미칠 수 있고, 그래도 「모은 소리를
/// 연습했다」는 사실은 같다. 목록을 새로 열 때 [RetryPracticedNotifier.reset] 으로 비운다.
final retryPracticedProvider =
    NotifierProvider<RetryPracticedNotifier, Set<String>>(
  RetryPracticedNotifier.new,
);

/// [retryPracticedProvider] 의 상태.
class RetryPracticedNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => const {};

  /// [soundKey] 를 마친 소리로 기록한다(결과 화면에서 목록으로 돌아갈 때).
  void mark(String soundKey) {
    if (state.contains(soundKey)) return;
    state = {...state, soundKey};
  }

  /// 목록을 새로 열 때 비운다 — 지난 방문의 기록이 「모두 연습했어요」를 미리 켜지 않게.
  void reset() => state = const {};
}
