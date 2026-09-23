// `start` 프레임 — 서버가 통화를 어떻게 열지 정하는 필드들.
//
// 이 프레임의 결함은 지금까지 전부 **"필드가 조용히 빠졌다"** 였다. 서버는 못 받은
// 필드를 에러로 알리지 않고 폴백하므로, 화면상 통화는 멀쩡히 이어지고 증상만 엉뚱한
// 데서 튀어나온다 — 그래서 실기기로도 안 보였다:
//
//   - `continues_call_id` 미전송 → 비버가 앞 구간을 잊는다 (2026-08-24)
//   - `inbound_call_id` 미전송   → 이어간 순간 **상대가 바뀐다** (2026-08-31)
//   - `assignment_id` 미전송     → 2구간부터 **숙제 통화가 아니게 된다** (2026-09-06)
//
// `call_type` 도 같은 자리에 앉는다(2026-09-10). 다만 이쪽은 반대 방향의 위험도 있다 —
// **안 보내야 할 때 보내면** 서버의 자동 라우팅(D11)을 덮어쓰고, 값이 틀리면 pydantic
// Literal 검증에서 422 가 나 **통화가 아예 안 열린다**. 그래서 양쪽을 다 잠근다.
//
// 플랜: docs/2026-08-31_0516_carry-inbound-call-id-across-segments-plan.md

import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/features/normalcall/domain/entities/call_course.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_controller.dart';

/// 실제 호출부와 같은 규격(`_micSampleRate` / `_micNumChannels`).
Map<String, dynamic> _frame({
  String? inboundCallId,
  String? continuesCallId,
  int? assignmentId,
  String? callType,
  bool forceCourse = false,
  String? planOverride,
}) =>
    buildStartFrame(
      aec: const {'mode': 'unknown'},
      sampleRate: 16000,
      numChannels: 1,
      inboundCallId: inboundCallId,
      continuesCallId: continuesCallId,
      assignmentId: assignmentId,
      callType: callType,
      forceCourse: forceCourse,
      planOverride: planOverride,
    );

void main() {
  group('buildStartFrame — 항상 나가는 것', () {
    test('타입과 마이크 규격은 빠지지 않는다', () {
      final f = _frame();

      expect(f['type'], 'start');
      expect(f['aec'], const {'mode': 'unknown'});
      // ⛔ 예전엔 안 보냈고 서버가 기본값 16000 을 가정했다 — 우리 레코더와
      //    우연히 맞았을 뿐이다. 빠지면 조용히 이상한 목소리가 된다.
      expect(f['sample_rate'], 16000);
      expect(f['num_channels'], 1);
    });
  });

  group('inbound_call_id — 통화 상대를 정하는 값', () {
    test('수신통화면 실린다', () {
      final f = _frame(inboundCallId: 'uuid-alarm-1');

      expect(f['inbound_call_id'], 'uuid-alarm-1');
    });

    test('⭐ 이어가는 구간에도 실린다 — 빠지면 상대가 바뀐다', () {
      // 사장님 실기기(2026-08-31): 알람 캐릭터 BABA 와 5분 통화 → 「Keep talking」
      // → BIBI 로 바뀌었다. 서버 `resolve_call_character` 는 이 값으로만 알람을
      // 되짚는다 — `continues_call_id` 로는 캐릭터를 못 고른다. 그래서 이어가는
      // 구간이 이 필드 없이 열리면 member.character_id(대표 캐릭터)로 떨어진다.
      final f = _frame(
        inboundCallId: 'uuid-alarm-1',
        continuesCallId: '1182',
      );

      expect(f['inbound_call_id'], 'uuid-alarm-1',
          reason: '이어가도 같은 알람의 통화다');
      expect(f['continues_call_id'], '1182');
    });

    test('홈에서 건 전화는 필드 자체가 안 나간다', () {
      // ⚠ `null` 이 실리는 것과 **필드가 없는 것**은 다르다. 서버는 값의 유무로
      //    수신통화 여부를 가른다.
      final f = _frame();

      expect(f.containsKey('inbound_call_id'), isFalse);
    });
  });

  group('continues_call_id — 앞 구간의 기억', () {
    test('이어가는 구간에 실린다', () {
      final f = _frame(continuesCallId: '1182');

      expect(f['continues_call_id'], '1182');
    });

    test('첫 구간에는 필드 자체가 안 나간다', () {
      final f = _frame();

      expect(f.containsKey('continues_call_id'), isFalse);
    });
  });

  group('assignment_id — 숙제 통화라는 표식', () {
    // ⛔ 서버가 이 값 하나로 **넷**을 바꾼다: 통화 언어를 ko 로 고정
    //   (`call_session.py:438`) · 통화 길이를 5분 고정(`:1670`, 플랜·env·클라
    //   override 를 전부 무시) · 과제 목표 표현 주입(`:1291`) · 과제 귀속.
    //   빠지면 그 넷이 **한꺼번에** 평소 통화로 되돌아가는데 에러는 안 난다.
    test('과제에서 시작한 통화에 실린다', () {
      final f = _frame(assignmentId: 77);

      expect(f['assignment_id'], 77);
    });

    test('평소 통화에는 필드 자체가 안 나간다', () {
      final f = _frame();

      expect(f.containsKey('assignment_id'), isFalse);
    });

    test('⭐ 이어가는 구간에도 같이 실린다 — 여기가 실제로 빠졌던 자리다', () {
      // 2구간을 흉내낸다: 앞 구간을 이어가면서 과제도 그대로 들고 간다.
      // ⚠ 서버는 `continues_call_id` 로 과제를 **못 되짚는다** — `call` 테이블에
      //   `assignment_id` 컬럼이 없다. 클라가 매 조각 다시 싣는 것 말고 방법이 없다.
      final f = _frame(continuesCallId: '1182', assignmentId: 77);

      expect(f['continues_call_id'], '1182');
      expect(f['assignment_id'], 77,
          reason: '이어가는 구간에서 과제가 빠지면 숙제 통화가 평소 통화로 되돌아간다');
    });
  });

  group('call_type — 무엇을 하는 통화인가', () {
    // ⭐ **필드가 없는 것**이 기본 동작이다. 서버는 값이 없으면 스스로 판단한다
    //   (D11 자동 라우팅: `member.korean_level` 미확정이면 레벨테스트).
    //   빈 문자열이나 `'normal'` 을 보내면 그 판단을 **덮어쓴다.**
    test('⭐ 안 주면 필드 자체가 안 나간다 — 기존 통화 동작 보존의 핵심', () {
      final f = _frame();

      expect(f.containsKey('call_type'), isFalse,
          reason: '값이 실리면 서버의 자동 라우팅을 덮어쓴다');
    });

    test('표현학습이면 expression 이 실린다', () {
      final f = _frame(callType: CallCourse.expression.wireValue);

      expect(f['call_type'], 'expression');
    });

    test('프리토킹이면 freetalk 이 실린다', () {
      final f = _frame(callType: CallCourse.freetalk.wireValue);

      expect(f['call_type'], 'freetalk');
    });

    test('⛔ 와이어 값은 서버 Literal 과 **글자 그대로** 같아야 한다', () {
      // `protocol.py:115`(서버 origin/dev 50d03df) —
      //   Literal["normal","level_test","expression","freetalk","auto","chat"].
      // pydantic Literal 이라 오타 하나면 **422 로 통화가 아예 안 열린다.**
      // enum 이름을 바꾸면 여기서 걸린다.
      // `chat` 은 홈 대화 모드(09-23, 옛 `normal` 대체 — 신서버에서 normal 은 죽은 값).
      expect(CallCourse.values.map((c) => c.wireValue).toList(),
          ['expression', 'freetalk', 'chat', 'auto']);
    });

    test('자동이면 auto 가 실린다 — 서버가 진도로 코스를 정한다', () {
      final f = _frame(callType: CallCourse.auto.wireValue);

      expect(f['call_type'], 'auto');
    });
  });

  group('force_course — QA 잠금 우회(개발자 도구 프리토킹 버튼만)', () {
    // 서버 계약: ClientStart.force_course: bool = False. admin 만 COURSE_LOCKED 우회.
    test('⭐ 기본은 키 자체가 없다 — 자동·표현학습·제품 진입점 전부', () {
      expect(_frame().containsKey('force_course'), isFalse);
      expect(_frame(callType: 'expression').containsKey('force_course'), isFalse);
      expect(_frame(callType: 'auto').containsKey('force_course'), isFalse);
    });

    test('켜면 true 가 실린다', () {
      final f = _frame(callType: 'freetalk', forceCourse: true);

      expect(f['force_course'], isTrue);
      expect(f['call_type'], 'freetalk');
    });

    test('이어가는 구간에도 같이 실린다 — 필드 규율', () {
      final f = _frame(continuesCallId: '1182', callType: 'freetalk', forceCourse: true);

      expect(f['force_course'], isTrue);
    });
  });

  group('plan_override — QA 플랜 강제(개발자 도구 «플랜 × 코스» 6칸)', () {
    // 서버 계약: ClientStart.plan_override Literal["free","pro","max"] | None.
    // admin 만 유효, user 는 무시. 배포 전엔 extra=ignore 로 조용히 버려진다.
    test('⭐ 기본은 키 자체가 없다 — 홈·표현학습·프리토킹·일반 전부', () {
      expect(_frame().containsKey('plan_override'), isFalse);
      expect(_frame(callType: 'auto').containsKey('plan_override'), isFalse);
      expect(_frame(callType: 'freetalk', forceCourse: true).containsKey('plan_override'),
          isFalse);
    });

    test('6칸은 플랜 + **명시 코스**를 같이 싣는다 — auto 가 아니다', () {
      // 2026-09-19 로 바뀐 것: 옛 두 버튼은 auto 를 보냈고, 지금 6칸은 코스를 명시한다.
      // 서버가 코스를 고르면 «플랜별로 그 코스를 본다» 는 QA 목적이 사라진다.
      final premiumExpr = _frame(
        callType: CallCourse.expression.wireValue,
        planOverride: PlanOverride.premium.wireValue,
      );
      expect(premiumExpr['call_type'], 'expression');
      expect(premiumExpr['plan_override'], 'premium');
      expect(premiumExpr.containsKey('force_course'), isFalse);

      final freeTalk = _frame(
        callType: CallCourse.freetalk.wireValue,
        planOverride: PlanOverride.free.wireValue,
        forceCourse: true,
      );
      expect(freeTalk['call_type'], 'freetalk');
      expect(freeTalk['plan_override'], 'free');
      expect(freeTalk['force_course'], isTrue, reason: '프리토킹은 잠금을 우회한다');

    });

    // 서버 `premium` 브랜치(09-23) Literal["free","premium"]. 옛 pro·max 를 보내면 신서버가
    // start 프레임을 검증에서 버려 통화가 안 열린다.
    test('⛔ 와이어 값은 서버 Literal 과 글자 그대로', () {
      expect(PlanOverride.values.map((p) => p.wireValue).toList(), ['free', 'premium']);
    });

    test('이어가는 구간에도 같이 실린다 — 안 그러면 2구간부터 구독 플랜 엔진으로 돌아간다', () {
      final f = _frame(
        continuesCallId: '1182',
        callType: 'auto',
        planOverride: PlanOverride.premium.wireValue,
      );

      expect(f['continues_call_id'], '1182');
      expect(f['plan_override'], 'premium');
    });

    test('⭐ 이어가는 구간에도 같이 실린다 — assignment_id 가 정확히 여기서 샜다', () {
      // 2구간을 흉내낸다. 컨트롤러는 이 값을 지역 인자가 아니라 **필드**로 들고
      // 있어야 여기까지 온다 — 인자로 두면 재연결이 안 넘겨 null 이 된다.
      final f = _frame(
        continuesCallId: '1182',
        callType: CallCourse.expression.wireValue,
      );

      expect(f['continues_call_id'], '1182');
      expect(f['call_type'], 'expression',
          reason: '빠지면 2구간부터 표현학습이 평소 통화로 되돌아간다');
    });
  });

  // 서버 `premium` 브랜치(09-23) §3 — 「오늘」의 경계. daily-status·calendar 와 같은 값.
  group('buildStartFrame — 시간대', () {
    test('tz(IANA)·tz_offset_min 이 있으면 둘 다 실린다', () {
      final f = buildStartFrame(
        aec: const {'mode': 'unknown'},
        sampleRate: 16000,
        numChannels: 1,
        tz: 'Asia/Seoul',
        tzOffsetMin: 540,
      );
      expect(f['tz'], 'Asia/Seoul');
      expect(f['tz_offset_min'], 540);
    });

    test('IANA 를 모르면 tz 키 자체가 빠지고 offset 만 간다', () {
      final f = buildStartFrame(
        aec: const {'mode': 'unknown'},
        sampleRate: 16000,
        numChannels: 1,
        tzOffsetMin: -300,
      );
      expect(f.containsKey('tz'), isFalse, reason: '빈 문자열로 채우면 서버가 잘못된 이름으로 본다');
      expect(f['tz_offset_min'], -300);
    });
  });
}
