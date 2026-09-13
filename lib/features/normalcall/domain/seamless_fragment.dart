/// 끊김 없는 5분 조각 전환(Pro·Max) — 순수 정책과 마이크 프리버퍼.
///
/// 계획: 서버 워크트리 `docs/plans/2026-09-13-끊김없는-조각-전환.md` §2·§3 F1~F6.
/// 사장님 결정(2026-09-13): 5:00 뒤 시트 없음(타이머 누적) · 그 뒤 첫 «사용자 발화 →
/// 비버 응답 turn_end» 에서 소켓만 뒤에서 갈아 끼움 · 조각2 첫 턴은 비버가 기다림 ·
/// 마지막 조각은 응답까지 하고 종료(재연결 없음) · Free 는 기존 5분 시트 그대로.
///
/// 컨트롤러가 소켓·재생·마이크를 실제로 다루고, **판정과 버퍼**는 여기에 둬서 소켓 없이
/// 시험한다(F6). `buildStartFrame` 을 밖으로 뺀 것과 같은 이유다.
library;

import 'dart:collection';
import 'dart:typed_data';

import 'entities/call_allowance.dart';
import 'entities/call_course.dart';

/// 5분 경계에 닿았을 때 무엇을 할지.
enum FragmentBoundaryAction {
  /// 아직 경계 전.
  none,

  /// 기존 «이어하기» 시트 — Free, 또는 끊김 없는 전환 대상이 아닌 코스(일반 통화는 다음 단계).
  /// **픽셀·프레임 종전과 동일.**
  sheet,

  /// 끊김 없는 전환 대기 — 아무 표시 없이 타이머 누적, 다음 «사용자 발화 → turn_end» 에
  /// 소켓만 갈아 끼운다.
  seamless,

  /// 마지막 조각 — 같은 규칙으로 응답이 끝나면 close 하고 결과 화면. 재연결 없음.
  finalClose,
}

/// 5분 경계 판정. 매초 틱마다 부른다.
///
/// [segmentsUsed] 는 **끝낸** 조각 수(첫 조각 진행 중 = 0). [elapsedSec] 은 조각을 건너
/// 누적된 값이라 경계는 `(segmentsUsed + 1) × 5분` 이다.
/// [maxFragments] 는 서버 `call_started.max_fragments` 가 있으면 그것, 없으면 로컬
/// [CallAllowance.segmentsFor].
FragmentBoundaryAction fragmentBoundaryAction({
  required int elapsedSec,
  required int segmentsUsed,
  required bool paidAccess,
  required bool seamlessEligible,
  required int maxFragments,
}) {
  final boundary = CallAllowance.segment.inSeconds * (segmentsUsed + 1);
  if (elapsedSec < boundary) return FragmentBoundaryAction.none;
  // Free 는 종전 시트. 유료라도 전환 대상이 아닌 코스(일반 통화·레벨테스트)는 종전대로.
  if (!paidAccess || !seamlessEligible) return FragmentBoundaryAction.sheet;
  // 지금 끝나는 조각이 마지막이면 다음은 없다 — 응답 뒤 close.
  final endingFragment = segmentsUsed + 1;
  if (endingFragment >= maxFragments) return FragmentBoundaryAction.finalClose;
  return FragmentBoundaryAction.seamless;
}

/// 이 코스가 끊김 없는 전환 대상인가 — 표현학습·프리토킹 먼저(사장님 결정 5).
/// 일반 통화(null)·레벨테스트는 같은 코드로 **다음 단계**라 아직 false.
bool seamlessEligibleCourse(CallCourse? course) =>
    course == CallCourse.expression || course == CallCourse.freetalk;

/// 재연결 뒤 마지막 조각인지 — 서버 값이 있으면 그것, 없으면 로컬 카운트.
///
/// 서버 `call_started` 에 `fragment_index`·`max_fragments`(S4, Optional) 가 오면 그걸로
/// 판단하고, 안 오면 `segmentsUsed + 1 >= maxFragmentsLocal`.
bool isFinalFragment({
  required int? serverFragmentIndex,
  required int? serverMaxFragments,
  required int segmentsUsed,
  required int maxFragmentsLocal,
}) {
  if (serverFragmentIndex != null && serverMaxFragments != null) {
    return serverFragmentIndex >= serverMaxFragments;
  }
  return segmentsUsed + 1 >= maxFragmentsLocal;
}

/// «5:00 뒤 사용자가 **정말** 말했나» — 전환 트리거의 증거 두 가지를 모은다.
///
/// 라이브에는 `user_turn_end` 프레임이 없다(양쪽 다 안 보낸다). 그래서 로컬 VAD 로
/// 봤는데, 그것만으로는 **주변 소음**이 표시를 세우고 서버 무음 넛지의 `turn_end` 에서
/// 전환이 새어 나간다. 서버가 라이브에서 학습자 전사를 `input_transcript{text}` 로
/// 내려주므로 둘을 **AND** 로 묶는다:
///
///   voiced      — 게이트가 열린 채 유성 프레임(로컬 RMS VAD)
///   transcript  — 비어 있지 않은 `input_transcript` 수신
///
/// ⚠ 3.1 은 학습자 전사의 마지막 조각을 비버 응답과 **같이** 내보내므로(protocol.py
///   ClientDiag 주석) 전사가 응답 `turn_end` 직전에 도착할 수 있다. 그래서 판정은
///   프레임이 올 때가 아니라 **`turn_end` 시점에** [confirmed] 를 읽는다 — 순서 무관.
class UserSpeechEvidence {
  /// [minVoicedRun] — 유성으로 치려면 **연속** 몇 프레임이 임계를 넘어야 하나.
  /// 기침·문소리 같은 한 프레임짜리 오탐을 거른다(QA 2026-09-14). 프레임이 80ms 면
  /// 2 = 160ms. 미탐(작은 목소리)은 전사와 AND 라 그대로 두고 계측으로 본다.
  UserSpeechEvidence({this.minVoicedRun = 2});

  final int minVoicedRun;

  bool _voiced = false;
  bool _transcript = false;
  int _run = 0;
  int _longestRun = 0;

  /// 마이크 프레임 하나. [loud] = RMS ≥ 임계, [gated] = 마이크 닫힘(비버 발화 중).
  ///
  /// ⛔ gated 프레임은 표시를 세우지 않고 **연속도 끊는다** — 그 소리는 비버 목소리의
  ///   되먹임이거나 끼어들기다. 조용한 프레임도 연속을 끊는다.
  /// 반환: 이 프레임으로 유성 표시가 **처음** 섰으면 true(계측용).
  bool onFrame({required bool loud, required bool gated}) {
    if (gated || !loud) {
      _run = 0;
      return false;
    }
    _run++;
    if (_run > _longestRun) _longestRun = _run;
    if (!_voiced && _run >= minVoicedRun) {
      _voiced = true;
      return true;
    }
    return false;
  }

  /// 유성 표시를 바로 세운다 — 캐스케이드의 `user_turn_end`(서버 판정) 같은 확정 신호용.
  void onVoiced() => _voiced = true;

  /// `input_transcript` 가 왔다. 공백뿐이면 세지 않는다.
  void onTranscript(String? text) {
    if (text != null && text.trim().isNotEmpty) _transcript = true;
  }

  /// 둘 다 있어야 «사용자가 말했다». 소음만·전사만으로는 안 선다.
  bool get confirmed => _voiced && _transcript;

  bool get voiced => _voiced;
  bool get transcript => _transcript;

  /// 지금까지 가장 길었던 연속 유성 프레임 수 — 임계 조정의 근거(diag).
  int get longestRun => _longestRun;

  /// 새 대기 구간·전환 뒤에 비운다.
  void reset() {
    _voiced = false;
    _transcript = false;
    _run = 0;
    _longestRun = 0;
  }
}

/// 소켓이 아직 안 열린 사이의 마이크 PCM 을 담아 두는 프리버퍼(F3).
///
/// 조각 전환 중 재생이 끝나 마이크가 열렸는데 새 소켓의 `call_started` 가 아직이면,
/// 프레임을 버리지 않고 여기 쌓았다가 열린 뒤 **순서대로** 흘려보낸다 — 마이크 열림 뒤
/// 첫 발화 유실 0(수용 기준). 상한을 넘으면 **오래된 것부터** 버린다: 5초 넘게 쌓였다면
/// 그 앞부분은 이미 대화 맥락에서 멀고, 최근 것을 살려야 첫 문장의 끝이 남는다.
class MicPrebuffer {
  /// [maxBytes] 기본 5초 — 16kHz · 16bit · mono = 32,000 B/s.
  MicPrebuffer({this.maxBytes = 5 * 32000});

  /// 상한(바이트). 넘으면 오래된 프레임부터 버린다.
  final int maxBytes;

  final Queue<Uint8List> _frames = Queue<Uint8List>();
  int _bytes = 0;
  int _dropped = 0;

  /// 쌓인 바이트.
  int get bytes => _bytes;

  /// 쌓인 프레임 수.
  int get length => _frames.length;

  /// 상한 때문에 버린 프레임 수(누적). 로그·시험용.
  int get droppedFrames => _dropped;

  bool get isEmpty => _frames.isEmpty;

  /// 프레임을 넣는다. 상한을 넘으면 앞에서부터 버린다.
  void push(Uint8List frame) {
    _frames.addLast(frame);
    _bytes += frame.length;
    while (_bytes > maxBytes && _frames.length > 1) {
      _bytes -= _frames.removeFirst().length;
      _dropped++;
    }
  }

  /// 전부 꺼낸다(순서 유지). 버퍼는 빈다.
  List<Uint8List> drain() {
    final out = List<Uint8List>.from(_frames, growable: false);
    _frames.clear();
    _bytes = 0;
    return out;
  }

  /// 버린다(전환 실패·통화 종료).
  void clear() {
    _frames.clear();
    _bytes = 0;
  }

  /// flush 할 프레임 — 소켓이 열려 있으면 전부(순서 유지), 아니면 버리고 빈 목록.
  ///
  /// ⛔ **게이트 입력이 없다 — 일부러다.** 버퍼에 든 프레임은 «게이트 열린 채 잡힌 것»
  ///   이다(컨트롤러가 잡을 때 [_micGated] 를 봤다). flush 시점의 게이트로 다시 거르면
  ///   비버가 막 말을 시작한 순간 사용자의 첫 문장이 통째로 사라진다(codex 리뷰
  ///   2026-09-14). 게이트는 잡을 때만 본다.
  List<Uint8List> takeForFlush({required bool socketOpen}) {
    if (!socketOpen) {
      clear();
      return const [];
    }
    return drain();
  }
}
