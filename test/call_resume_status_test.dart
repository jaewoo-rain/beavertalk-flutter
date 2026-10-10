// 이어가기 판정을 **서버에 묻는다** — `GET /calls/{id}/resume-status`.
//
// 2026-08-24, 하루를 이 구멍에서 썼다:
//
//   앱  : 「나는 Pro 다」 → 「Keep going?」 을 띄우고 이어가기를 요청
//   서버: 「너는 Free 다」 → 조각 상한 소진 → **조용히** 새 통화로 떨어뜨림
//   화면: 멀쩡히 이어진 것처럼 보이고, 비버만 앞 대화를 잊는다
//
// 에러가 안 난다(백엔드가 일부러 그렇게 설계했다 — "거절이 아닙니다"). 그래서
// 물어보는 쪽이 유일하게 정직한 길이다.
//
// 이 파일은 **판정 규칙**을 잠근다. 「서버가 답하면 서버가 이긴다 / 못 답하면
// 로컬로 내려간다 / 없는 값을 낙관하지 않는다」.
//
// 플랜: docs/2026-08-24_0611_resume-status-integration-plan.md

import 'package:beavertalk/features/normalcall/domain/entities/call_allowance.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_resume_status.dart';
import 'package:flutter_test/flutter_test.dart';

/// 컨트롤러가 쓰는 판정식과 **같은 모양**이다:
///   `resume?.canResume ?? CallAllowance.canExtend(...)`
bool decide({
  required CallResumeStatus? resume,
  required int segmentsUsed,
  required bool paidAccess,
}) =>
    resume?.canResume ??
    CallAllowance.canExtend(segmentsUsed: segmentsUsed, paidAccess: paidAccess);

void main() {
  group('서버가 답하면 서버가 이긴다', () {
    test('앱은 유료라 믿어도 서버가 안 된다면 안 된다', () {
      // ⛔ 오늘의 그 버그다. 로컬만 보면 「유료 3구간 중 1개 썼으니 가능」이지만
      //    서버는 그 회원을 Free 로 보고 상한 1개를 이미 다 썼다고 한다.
      const server = CallResumeStatus(
        ready: true,
        canResume: false,
        fragmentCount: 1,
        maxFragments: 1,
        analyzing: false,
      );
      expect(
        decide(resume: server, segmentsUsed: 1, paidAccess: true),
        isFalse,
        reason: '서버가 거절하면 「Keep going?」 을 띄우면 안 된다',
      );
      // 로컬만 봤다면 정반대로 답했다는 것을 같이 잠근다.
      expect(
        CallAllowance.canExtend(segmentsUsed: 1, paidAccess: true),
        isTrue,
      );
    });

    test('앱은 무료라 믿어도 서버가 된다면 된다', () {
      // 반대 방향도 서버가 이긴다 — 구독이 서버에만 반영된 경우.
      const server = CallResumeStatus(
        ready: true,
        canResume: true,
        fragmentCount: 1,
        maxFragments: 3,
        analyzing: false,
      );
      expect(
        decide(resume: server, segmentsUsed: 1, paidAccess: false),
        isTrue,
      );
      expect(
        CallAllowance.canExtend(segmentsUsed: 1, paidAccess: false),
        isFalse,
      );
    });
  });

  group('서버가 못 답하면 로컬로 내려간다', () {
    test('null 이면 통화를 막지 않고 로컬 계산을 쓴다', () {
      // 구버전 서버·네트워크 실패·404 가 전부 null 로 온다. 이때 이어가기를 막으면
      // **서버가 잠깐 흔들렸다고 유료 회원의 통화가 끊긴다.**
      expect(decide(resume: null, segmentsUsed: 1, paidAccess: true), isTrue);
      expect(decide(resume: null, segmentsUsed: 3, paidAccess: true), isFalse);
      expect(decide(resume: null, segmentsUsed: 1, paidAccess: false), isFalse);
    });
  });

  group('JSON 파싱 — 빠진 값은 보수적으로', () {
    test('서버 응답을 그대로 읽는다', () {
      final s = CallResumeStatus.fromJson(const {
        'ready': true,
        'can_resume': true,
        'fragment_count': 1,
        'max_fragments': 3,
        'analyzing': false,
      });
      expect(s.ready, isTrue);
      expect(s.canResume, isTrue);
      expect(s.fragmentCount, 1);
      expect(s.maxFragments, 3);
      expect(s.analyzing, isFalse);
    });

    test('필드가 빠지면 **막는 쪽**으로 채운다', () {
      // ⛔ 없는 값을 낙관하면 오늘의 버그가 되돌아온다 — 서버가 안 준 걸
      //    「된다」로 읽고 이어가기를 권하게 된다.
      final s = CallResumeStatus.fromJson(const {});
      expect(s.canResume, isFalse);
      expect(s.ready, isFalse);
      expect(s.fragmentCount, 0);
      expect(s.maxFragments, 0);
    });

    test('숫자가 double 로 와도 읽는다', () {
      // JSON 은 1 과 1.0 을 구분하지 않는다. int 캐스팅으로 짜면 여기서 터진다.
      final s = CallResumeStatus.fromJson(const {
        'fragment_count': 2.0,
        'max_fragments': 3.0,
      });
      expect(s.fragmentCount, 2);
      expect(s.maxFragments, 3);
    });
  });

  group('상한 도달을 서버 숫자로도 확인한다', () {
    test('조각을 다 쓰면 can_resume 이 false 로 온다', () {
      const s = CallResumeStatus(
        ready: true,
        canResume: false,
        fragmentCount: 3,
        maxFragments: 3,
        analyzing: false,
      );
      expect(s.fragmentCount >= s.maxFragments, isTrue);
      expect(decide(resume: s, segmentsUsed: 3, paidAccess: true), isFalse);
    });
  });
}
