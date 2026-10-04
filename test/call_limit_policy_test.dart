// 통화 상한 — **단일 세션**. 클라가 직접 재고 상한에서 끝낸다.
//
//   ① 유료 15분 — 900초 전에는 경계가 **한 번도** 안 잡힌다 → 900초에 close
//   ② 무료 5분  — 300초에 종전 구독 유도 시트(픽셀·카피 불변)
//   ③ 숫자의 출처 — 상한은 CallAllowance 한 곳에서만 온다
//   ④ start 프레임 — `silent_resume` 은 **없다**(조각 재개가 없어졌다)
//   ⑤ 사용자 발화 증거 — 소음만·전사만으로는 끝내지 않는다
//
// ⛔ **폐기한 시험들**(2026-10-04, 전신 `seamless_fragment_test.dart`):
//   조각 전환 타이밍 ① · 재개 start 프레임 ② · 마이크 프리버퍼 ③(6건) · 마지막 조각
//   판정 ④ · `fragment_saved` 대기 ⑦(5건) · 마이크 프레임 목적지 ⑧(3건) ·
//   `remaining_s` 경계 ⑨(4건) · 단일 세션 스위치 ⑩(7건).
//   지킬 대상이 **코드에서 사라졌다** — 조각 분할을 지웠다(사장님: 「아예 지피티로
//   갈아탄다 생각하라고」). 되살릴 일이 생기면 git 이 되돌린다(`2de35522` 이전).
//   ⚠ 그중 ⑨ 는 **서버에 없던 계약**이었다: `fragment_end`/`fragment_saved` 는 서버
//     `*.py` 전수 grep 0건이라, 전신은 매 조각 5초 타임아웃을 태우고 폴백으로 갔다.
//
// 정책은 lib/features/normalcall/domain/call_limit_policy.dart 의 순수 코드다 —
// buildStartFrame 을 밖으로 뺀 것과 같은 이유로 소켓 없이 시험한다.

import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/normalcall/domain/call_limit_policy.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_allowance.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_controller.dart';

CallLimitAction _at(int elapsedSec, {bool paid = true}) =>
    callLimitAction(elapsedSec: elapsedSec, paidAccess: paid);

void main() {
  group('① 유료 15분 — 한 세션으로 끝까지', () {
    test('⭐ 900초 전에는 경계가 **한 번도** 안 잡힌다', () {
      // 전신이 조각을 끊던 지점(5분·6분·10분)을 전부 짚는다.
      for (final t in [0, 1, 299, 300, 301, 359, 360, 361, 599, 600, 601, 899]) {
        expect(_at(t), CallLimitAction.none, reason: '${t}s 에서 끊기면 안 된다');
      }
    });

    test('⭐ 900초 → close (응답까지 하고 종료, 재연결 없음)', () {
      expect(_at(900), CallLimitAction.close);
      expect(_at(901), CallLimitAction.close, reason: '한 틱 늦게 들어와도 같다');
      expect(_at(1200), CallLimitAction.close);
    });

    test('⛔ 유료는 시트로 가지 않는다 — 누를 수 있는 버튼이 없다', () {
      expect(_at(900), isNot(CallLimitAction.sheet));
    });
  });

  group('② 무료 5분 — 종전 구독 유도 시트 그대로', () {
    test('300초 전 none, 300초에 시트', () {
      expect(_at(299, paid: false), CallLimitAction.none);
      expect(_at(300, paid: false), CallLimitAction.sheet);
      expect(_at(301, paid: false), CallLimitAction.sheet);
    });

    test('⛔ 무료는 close 로 조용히 끝내지 않는다 — 전환 의도가 가장 높은 지점이다', () {
      // 그 시트는 「이어하기」가 아니라 SubscriptionOverlay.freeCallEnded 다.
      expect(_at(900, paid: false), CallLimitAction.sheet);
    });
  });

  group('③ 상한의 출처 — CallAllowance 한 곳', () {
    test('⛔ 숫자를 정책 밖에 쓰지 않았다', () {
      final paidLimit = CallAllowance.limitFor(paidAccess: true).inSeconds;
      final freeLimit = CallAllowance.limitFor(paidAccess: false).inSeconds;
      expect(_at(paidLimit - 1), CallLimitAction.none);
      expect(_at(paidLimit), CallLimitAction.close);
      expect(_at(freeLimit - 1, paid: false), CallLimitAction.none);
      expect(_at(freeLimit, paid: false), CallLimitAction.sheet);
    });

    test('유료 15분 · 무료 5분', () {
      expect(CallAllowance.limitFor(paidAccess: true), const Duration(minutes: 15));
      expect(CallAllowance.limitFor(paidAccess: false), const Duration(minutes: 5));
    });

    test('⛔ 무료는 연장이 없다 — 그래서 그 시트가 구독 유도다', () {
      expect(CallAllowance.canExtend(segmentsUsed: 1, paidAccess: false), isFalse);
    });
  });

  group('④ start 프레임 — 조각 재개 키가 사라졌다', () {
    test('⛔ `silent_resume` 은 어떤 프레임에도 없다', () {
      // 조각 재연결이 없어졌다 — 비버가 먼저 말하지 않게 하는 재개는 더 안 쓴다.
      // 시트 경유 «Keep talking» 은 종전대로 서버가 «이어서» 로 먼저 말한다.
      for (final continues in [null, '1567']) {
        final f = buildStartFrame(
          aec: const {'mode': 'unknown'},
          sampleRate: 16000,
          numChannels: 1,
          continuesCallId: continues,
          callType: 'expression',
        );
        expect(f.containsKey('silent_resume'), isFalse);
        expect(f['continues_call_id'], continues);
        expect(f['call_type'], 'expression');
      }
    });
  });

  group('⑤ 사용자 발화 증거 — 소음만·전사만으로는 끝내지 않는다', () {
    // 라이브엔 user_turn_end 가 없다(양쪽 다 안 보낸다). 로컬 VAD 만 쓰면 주변 소음이
    // 표시를 세우고 서버 무음 넛지의 turn_end 에서 종료가 샌다. 그래서 «VAD 유성 AND
    // 비어 있지 않은 input_transcript» 를 turn_end 시점에 읽는다.
    test('소음만(VAD 유성, 전사 없음) → 안 선다', () {
      final e = UserSpeechEvidence()..onVoiced();
      expect(e.confirmed, isFalse, reason: '무음 넛지 turn_end 로 새면 안 된다');
    });

    test('전사만(VAD 유성 없음) → 안 선다', () {
      final e = UserSpeechEvidence()..onTranscript('안녕하세요');
      expect(e.confirmed, isFalse);
    });

    test('둘 다 → 선다. 순서는 무관(3.1 은 전사가 turn_end 직전에 올 수 있다)', () {
      final a = UserSpeechEvidence()
        ..onVoiced()
        ..onTranscript('안녕하세요');
      expect(a.confirmed, isTrue);
      final b = UserSpeechEvidence()
        ..onTranscript('안녕하세요')
        ..onVoiced();
      expect(b.confirmed, isTrue, reason: '전사가 먼저 와도 같다');
    });

    test('공백뿐인 전사·null 은 전사로 안 친다', () {
      final e = UserSpeechEvidence()
        ..onVoiced()
        ..onTranscript('   ')
        ..onTranscript(null);
      expect(e.confirmed, isFalse);
    });

    test('⛔ gated 프레임(비버 발화 중)은 표시를 세우지 않고 연속도 끊는다', () {
      final e = UserSpeechEvidence(minVoicedRun: 2);
      e.onFrame(loud: true, gated: true);
      e.onFrame(loud: true, gated: true);
      e.onFrame(loud: true, gated: true);
      expect(e.voiced, isFalse, reason: '비버 목소리 되먹임·끼어들기는 사용자 발화가 아니다');
      // 게이트가 열린 뒤 한 프레임만 크면 아직 아니다 — 앞의 gated 연속은 안 세어졌다.
      e.onFrame(loud: true, gated: false);
      expect(e.voiced, isFalse);
    });

    test('한 프레임짜리 기침·문소리는 안 세운다 — 연속 2프레임부터', () {
      final e = UserSpeechEvidence(minVoicedRun: 2);
      expect(e.onFrame(loud: true, gated: false), isFalse);
      e.onFrame(loud: false, gated: false); // 끊김
      expect(e.onFrame(loud: true, gated: false), isFalse);
      expect(e.voiced, isFalse, reason: '큰 소리가 두 번이어도 연속이 아니면 아니다');

      expect(e.onFrame(loud: true, gated: false), isTrue, reason: '연속 2프레임 — 처음 섰다');
      expect(e.voiced, isTrue);
      expect(e.onFrame(loud: true, gated: false), isFalse,
          reason: '두 번째부터는 false(계측용 1회)');
      expect(e.longestRun, 3, reason: '임계 조정 근거');
    });

    test('reset 뒤엔 둘 다 다시 모아야 한다', () {
      final e = UserSpeechEvidence()
        ..onVoiced()
        ..onTranscript('네')
        ..reset();
      expect(e.confirmed, isFalse);
      e.onTranscript('네');
      expect(e.confirmed, isFalse, reason: '옛 유성이 남아 있으면 안 된다');
    });
  });
}
