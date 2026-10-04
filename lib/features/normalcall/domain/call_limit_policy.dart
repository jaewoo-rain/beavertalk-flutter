/// 통화 상한 정책 — **단일 세션**. 한 소켓으로 플랜 상한까지 가고 끝낸다.
///
/// ## 왜 이 파일이 작아졌나
///
/// 2026-10-04 사장님 지시: 「클라틱을 왜 보내? 클라는 자기가 직접 시간 재고 시간 지나면
/// 종료하면 되잖아.」 + 「제미나이 신경쓰지말라고… 아예 지피티로 갈아탄다 생각하라고」
///
/// 그래서 **조각 분할을 코드에서 지웠다**(이 파일의 전신 `seamless_fragment.dart`).
/// 지운 것: 5분 조각 경계 · `seamless` 전환 · 조각 재연결 · `fragment_end`/`fragment_saved`
/// 계약 · `silent_resume` · 마이크 프리버퍼 · 서버 `remaining_s`/`max_fragments` 수신.
/// 분기로 남기지 않았다 — 되돌릴 일이 생기면 git 이 되돌린다(`2de35522` 이전).
///
/// ⛔ **되살리기 전에 알아야 할 것**: 조각 분할은 정책이 아니라 **Gemini 연결 수명(~10분)**
///   때문이었다. 인프라는 이유가 아니다 — Cloud Run 배포는 `--timeout=3600` 이다
///   (서버 `scripts/deploy_prod.sh:57` · `deploy_demo.sh:57`). OpenAI Realtime 은 세션
///   60분이라 15분을 한 소켓으로 버틴다.
///
/// ## 남은 것
///
/// 상한 판정([callLimitAction])과 「사용자가 정말 말했나」([UserSpeechEvidence]) 둘이다.
/// 컨트롤러가 소켓·재생·마이크를 다루고 **판정만** 여기 둬서 소켓 없이 시험한다
/// (`buildStartFrame` 을 밖으로 뺀 것과 같은 이유).
library;

import 'entities/call_allowance.dart';

/// 상한에 닿았을 때 무엇을 할지.
///
/// ⭐ 전신 `FragmentBoundaryAction` 의 네 갈래에서 **둘이 빠졌다**: `seamless`(다음 조각
///   으로 갈아타기)는 조각이 없어져 사라지고, `finalClose` 는 유일한 종료 갈래가 되어
///   「마지막」이라는 수식이 뜻을 잃었다 → [close]. 상한은 통화마다 **한 번만** 닿는다.
enum CallLimitAction {
  /// 아직 상한 전.
  none,

  /// 기존 시트 — **무료 전용**. 1구간이라 「이어하기」가 아니라 **구독 유도**다
  /// (`SubscriptionOverlay.freeCallEnded`). 픽셀·카피 종전과 동일.
  sheet,

  /// 유료 — 다음 «사용자 발화 → 비버 응답 turn_end» 에 응답까지 하고 끝낸다.
  /// 상한 순간에 바로 끊으면 비버가 말하던 문장이 잘린다.
  close,
}

/// 상한 판정. 매초 틱마다 부른다.
///
/// 상한은 [CallAllowance.limitFor] **한 곳**에서만 온다 — 서버에 묻지 않는다.
/// 유료 15분 · 무료 5분, 둘 다 **한 세션**이고 중간 재연결이 없다.
CallLimitAction callLimitAction({
  required int elapsedSec,
  required bool paidAccess,
}) {
  if (elapsedSec < CallAllowance.limitFor(paidAccess: paidAccess).inSeconds) {
    return CallLimitAction.none;
  }
  return paidAccess ? CallLimitAction.close : CallLimitAction.sheet;
}

/// «상한 뒤 사용자가 **정말** 말했나» — 종료 트리거의 증거 두 가지를 모은다.
///
/// 라이브에는 `user_turn_end` 프레임이 없다(양쪽 다 안 보낸다). 그래서 로컬 VAD 로
/// 봤는데, 그것만으로는 **주변 소음**이 표시를 세우고 서버 무음 넛지의 `turn_end` 에서
/// 종료가 새어 나간다. 서버가 라이브에서 학습자 전사를 `input_transcript{text}` 로
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

  /// 새 대기 구간·통화 종료 뒤에 비운다.
  void reset() {
    _voiced = false;
    _transcript = false;
    _run = 0;
    _longestRun = 0;
  }
}
