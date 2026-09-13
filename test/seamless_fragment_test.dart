// 끊김 없는 5분 조각 전환(Pro·Max) — 계획 §3 F6 «시험 5면».
//
//   ① 전환 타이밍  — 5:00 에 시트가 아니라 «대기»; 경계는 (segmentsUsed+1)×5분
//   ② 재생 유지    — 소켓만 닫는 start 프레임 규약(silent_resume + continues_call_id).
//                    ⚠ 재생 큐가 실제로 살아남는 것(F2)은 컨트롤러 _closeSocketOnly 가
//                    _teardown 을 안 타는 코드 경로로 보장한다 — 소켓·오디오 없이는 자동
//                    시험이 안 되어 여기서는 **프레임 규약**만 잠근다. 실기기 QA 항목.
//   ③ 프리버퍼 flush — 순서 유지 · 5초 상한에서 오래된 것부터 버림 · drain 뒤 빔
//   ④ 마지막 조각  — 로컬 카운트 / 서버 fragment_index 기준 «재연결 없음»
//   ⑤ Free 시트    — Free 는 종전 «이어하기» 시트(픽셀·프레임 불변: 그 코드는 안 건드렸다)
//
// 정책·버퍼는 lib/features/normalcall/domain/seamless_fragment.dart 의 순수 코드다 —
// buildStartFrame 을 밖으로 뺀 것과 같은 이유로 소켓 없이 시험한다.

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/normalcall/domain/entities/call_course.dart';
import 'package:beavertalk/features/normalcall/domain/seamless_fragment.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_controller.dart';

FragmentBoundaryAction _at(
  int elapsedSec, {
  int segmentsUsed = 0,
  bool paid = true,
  CallCourse? course = CallCourse.expression,
  int maxFragments = 3,
}) =>
    fragmentBoundaryAction(
      elapsedSec: elapsedSec,
      segmentsUsed: segmentsUsed,
      paidAccess: paid,
      seamlessEligible: seamlessEligibleCourse(course),
      maxFragments: maxFragments,
    );

Uint8List _frame(int n, {int len = 640}) => Uint8List(len)..fillRange(0, len, n);

void main() {
  group('① 전환 타이밍 — 5:00 에 시트가 아니라 대기', () {
    test('경계 전에는 아무것도 안 한다', () {
      expect(_at(0), FragmentBoundaryAction.none);
      expect(_at(299), FragmentBoundaryAction.none);
    });

    test('Pro·Max 표현학습 5:00 → seamless (시트 없음, 타이머 누적)', () {
      expect(_at(300), FragmentBoundaryAction.seamless);
      expect(_at(301), FragmentBoundaryAction.seamless, reason: '지난 뒤에도 같은 판정');
    });

    test('프리토킹도 같다', () {
      expect(_at(300, course: CallCourse.freetalk), FragmentBoundaryAction.seamless);
    });

    test('⭐ 경계는 (segmentsUsed+1)×5분 — 조각2 는 10:00, 조각3 은 15:00', () {
      expect(_at(300, segmentsUsed: 1), FragmentBoundaryAction.none,
          reason: '조각2 진행 중 5:00 은 경계가 아니다(누적 시계)');
      expect(_at(600, segmentsUsed: 1), FragmentBoundaryAction.seamless);
      expect(_at(900, segmentsUsed: 2), FragmentBoundaryAction.finalClose);
    });

    test('일반 통화(course null)·레벨테스트는 아직 종전 시트 — 다음 단계', () {
      expect(_at(300, course: null), FragmentBoundaryAction.sheet);
      expect(seamlessEligibleCourse(null), isFalse);
      expect(seamlessEligibleCourse(CallCourse.auto), isFalse,
          reason: 'auto 는 요청이지 코스가 아니다 — call_started.course 로 풀린 뒤 판정');
    });
  });

  group('② 재개 start 프레임 — 소켓만 갈아 끼우는 규약(F4)', () {
    Map<String, dynamic> frame({bool silent = false, String? continues}) =>
        buildStartFrame(
          aec: const {'mode': 'unknown'},
          sampleRate: 16000,
          numChannels: 1,
          continuesCallId: continues,
          callType: 'expression',
          silentResume: silent,
        );

    test('silent_resume:true + continues_call_id + 같은 코스가 실린다', () {
      final f = frame(silent: true, continues: '1567');
      expect(f['silent_resume'], isTrue);
      expect(f['continues_call_id'], '1567');
      expect(f['call_type'], 'expression', reason: '코스는 조각을 넘어 같아야 한다');
    });

    test('⭐ 기본은 키 자체가 없다 — 첫 조각·시트 경유 이어하기는 종전 프레임 그대로', () {
      expect(frame().containsKey('silent_resume'), isFalse);
      expect(frame(continues: '1567').containsKey('silent_resume'), isFalse,
          reason: '시트의 «Keep talking» 은 비버가 «이어서» 로 먼저 말하는 옛 재개다');
    });
  });

  group('③ 마이크 프리버퍼 — 첫 발화 유실 0', () {
    test('넣은 순서대로 나온다, drain 뒤엔 빈다', () {
      final b = MicPrebuffer();
      b.push(_frame(1));
      b.push(_frame(2));
      b.push(_frame(3));
      expect(b.length, 3);
      expect(b.bytes, 640 * 3);

      final out = b.drain();
      expect(out.map((f) => f[0]).toList(), [1, 2, 3]);
      expect(b.isEmpty, isTrue);
      expect(b.bytes, 0);
    });

    test('5초 상한 — 넘으면 오래된 것부터 버리고 최근 것을 살린다', () {
      // 상한을 작게: 프레임 3개(640B)까지만.
      final b = MicPrebuffer(maxBytes: 640 * 3);
      for (var i = 1; i <= 5; i++) {
        b.push(_frame(i));
      }
      expect(b.length, 3);
      expect(b.droppedFrames, 2, reason: '1·2 를 버렸다');
      expect(b.drain().map((f) => f[0]).toList(), [3, 4, 5],
          reason: '첫 문장의 끝(최근)이 남아야 서버가 알아듣는다');
    });

    test('기본 상한은 5초(16kHz·16bit·mono = 160,000B)', () {
      expect(MicPrebuffer().maxBytes, 5 * 32000);
    });

    test('프레임 하나가 상한보다 커도 그 하나는 남긴다 — 통째로 비우지 않는다', () {
      final b = MicPrebuffer(maxBytes: 100);
      b.push(_frame(9, len: 640));
      expect(b.length, 1);
    });

    test('clear 는 버린다(전환 실패·종료)', () {
      final b = MicPrebuffer()..push(_frame(1));
      b.clear();
      expect(b.isEmpty, isTrue);
    });
  });

  group('④ 마지막 조각 — 응답까지 하고 종료, 재연결 없음', () {
    test('로컬 카운트: Pro·Max 3조각이면 15:00 이 finalClose', () {
      expect(_at(900, segmentsUsed: 2), FragmentBoundaryAction.finalClose);
      expect(_at(600, segmentsUsed: 1), FragmentBoundaryAction.seamless,
          reason: '10:00 은 아직 재연결한다');
    });

    test('서버 값이 있으면 그것이 정본 — fragment_index >= max_fragments', () {
      expect(
        isFinalFragment(serverFragmentIndex: 3, serverMaxFragments: 3, segmentsUsed: 0, maxFragmentsLocal: 3),
        isTrue,
        reason: '로컬 카운트가 어긋나도 서버가 «3/3» 이면 마지막이다',
      );
      expect(
        isFinalFragment(serverFragmentIndex: 2, serverMaxFragments: 3, segmentsUsed: 2, maxFragmentsLocal: 3),
        isFalse,
      );
    });

    test('서버 값이 없으면 로컬 카운트', () {
      expect(
        isFinalFragment(serverFragmentIndex: null, serverMaxFragments: null, segmentsUsed: 2, maxFragmentsLocal: 3),
        isTrue,
      );
      expect(
        isFinalFragment(serverFragmentIndex: null, serverMaxFragments: null, segmentsUsed: 1, maxFragmentsLocal: 3),
        isFalse,
      );
    });
  });

  group('⑥ 사용자 발화 증거 — 소음만·전사만으로는 전환하지 않는다', () {
    // 라이브엔 user_turn_end 가 없다(양쪽 다 안 보낸다). 로컬 VAD 만 쓰면 주변 소음이
    // 표시를 세우고 서버 무음 넛지의 turn_end 에서 전환이 샌다. 그래서 «VAD 유성 AND
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

    test('reset 뒤엔 둘 다 다시 모아야 한다 — 다음 대기 구간', () {
      final e = UserSpeechEvidence()
        ..onVoiced()
        ..onTranscript('네')
        ..reset();
      expect(e.confirmed, isFalse);
      e.onTranscript('네');
      expect(e.confirmed, isFalse, reason: '옛 유성이 남아 있으면 안 된다');
    });
  });

  group('⑤ Free — 종전 «이어하기» 시트 그대로', () {
    test('Free 5:00 → sheet (seamless 아님)', () {
      expect(_at(300, paid: false), FragmentBoundaryAction.sheet);
      expect(_at(300, paid: false, course: CallCourse.freetalk), FragmentBoundaryAction.sheet);
    });

    test('Free 는 조각이 1개 — max 1 이어도 sheet 가 먼저다(finalClose 로 안 간다)', () {
      // Free 의 5:00 은 «구독 유도 시트» 지 «조용히 끝내기» 가 아니다.
      expect(_at(300, paid: false, maxFragments: 1), FragmentBoundaryAction.sheet);
    });
  });
}
