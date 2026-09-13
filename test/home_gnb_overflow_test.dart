// 홈 학습 현황 블록의 **레이아웃 안정성** — 무엇이 들어와도 넘치지 않아야 한다.
//
// 이 블록은 서버 문자열 3종(단원 코드·주제·학습 종류)을 한 줄씩 받는데, 길이를
// 앱이 통제하지 못한다. 게다가 높이가 92로 고정돼 있어 **글자 배율**을 키우면
// 세로로도 넘친다. 두 축을 다 건다.
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/components/atoms/badge.dart';
import 'package:beavertalk/components/organisms/home_gnb.dart';
import 'package:beavertalk/l10n/app_localizations.dart';

/// 넘침은 예외가 아니라 `FlutterError.onError` 로 보고된다 — 잡아서 모은다.
Future<List<String>> _overflows(
  WidgetTester tester,
  Widget child, {
  required Size size,
  double textScale = 1.0,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final captured = <String>[];
  final prev = FlutterError.onError;
  FlutterError.onError = (details) {
    final s = details.toString();
    if (s.contains('overflowed')) {
      captured.add(s
          .split('\n')
          .firstWhere((l) => l.contains('overflowed'),
              orElse: () => s.split('\n').first)
          .trim());
    }
  };
  try {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
          child: Scaffold(body: Center(child: child)),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 32));
  } finally {
    FlutterError.onError = prev;
  }
  tester.takeException();
  return captured;
}

/// 좁은 폰(iPhone SE 급). 가로 넘침이 여기서 드러난다.
const _narrow = Size(320, 640);

void main() {
  group('HomeGnb 레이아웃 안정성', () {
    testWidgets('기본 — 320 폭에서 넘치지 않는다', (tester) async {
      expect(
        await _overflows(tester,
            const HomeGnb(course: _normal), size: _narrow),
        isEmpty,
      );
    });

    testWidgets('🔴 단원 코드가 길어도 넘치지 않는다', (tester) async {
      // `badgeCode` 는 칸이 셋이 아니면 **서버 코드를 그대로** 쓴다. 서버가
      // 코드 모양을 바꾸면 배지가 그만큼 길어지는데, 배지는 고정폭이 아니라
      // 내용만큼 자라므로 오른쪽 라벨을 밀어낸다.
      expect(
        await _overflows(tester,
            const HomeGnb(course: _longCode), size: _narrow),
        isEmpty,
      );
    });

    testWidgets('🔴 글자 배율 1.3 에서 세로로 넘치지 않는다', (tester) async {
      // 높이가 92 로 **고정**돼 있고 내용이 정확히 76(+패딩 16)이라 여유가 0이다.
      // 사용자가 시스템 글자 크기를 키우면 그대로 넘친다.
      expect(
        await _overflows(tester, const HomeGnb(course: _normal),
            size: _narrow, textScale: 1.3),
        isEmpty,
      );
    });

    testWidgets('🔴 글자 배율 2.0 에서도 넘치지 않는다', (tester) async {
      expect(
        await _overflows(tester, const HomeGnb(course: _normal),
            size: _narrow, textScale: 2.0),
        isEmpty,
      );
    });

    testWidgets('레벨 미정 — 배율 1.5 에서 넘치지 않는다', (tester) async {
      expect(
        await _overflows(tester, const HomeGnb(course: _noLevel),
            size: _narrow, textScale: 1.5),
        isEmpty,
      );
    });

    testWidgets('아주 긴 주제도 넘치지 않는다 — 두 줄로 흐른다', (tester) async {
      expect(
        await _overflows(tester,
            const HomeGnb(course: _longTopic), size: _narrow),
        isEmpty,
      );
    });

    testWidgets('긴 코드 + 배율 2.0 — 1행이 두 줄로 흘러도 넘치지 않는다',
        (tester) async {
      // 배지는 hug 라 줄어들지 않는다. 한 줄에 못 들어가면 학습 종류 라벨이
      // 다음 줄로 흘러야 한다 — 자르는 게 아니라.
      expect(
        await _overflows(tester, const HomeGnb(course: _longCode),
            size: _narrow, textScale: 2.0),
        isEmpty,
      );
    });

    testWidgets('배지는 hug 다 — 짧은 코드가 잘리지 않는다', (tester) async {
      // 🔴 `Flexible` 로 줄이면 `A1-1` 같은 짧은 코드에도 줄임표가 붙을 수 있다.
      await _overflows(tester, const HomeGnb(course: _normal), size: _narrow);
      expect(find.text('A1-1'), findsOneWidget);
    });

    testWidgets('🔴 배지가 화면 폭을 가로지르지 않는다 — hug 여야 한다',
        (tester) async {
      // `Badge` 는 `Container(alignment:)` 를 썼는데, 그 인자는 자식을 `Align`
      // 으로 감싸고 `Align` 은 **폭 제약이 있으면 최대치까지 늘어난다.**
      // `Row(mainAxisSize: min)` 안에서는 가로 제약이 없어 hug 처럼 보였지만,
      // `Wrap` 으로 바꾸자 알약이 화면을 가로질렀다(실기기 2026-09-13).
      await _overflows(tester, const HomeGnb(course: _normal), size: _narrow);

      final badge = tester.getSize(find.byType(Badge));
      // 320 폭 − 좌우 패딩 32×2 = 256 이 이 줄에 주어진 폭이다. `A1-1` 은
      // 그 근처도 못 간다 — 늘어났다면 256 에 붙는다.
      expect(badge.width, lessThan(120),
          reason: '배지가 내용만큼이 아니라 주어진 폭을 다 먹었다');
      expect(badge.height, 26);
    });

    testWidgets('스켈레톤 — 배율 1.5 에서 넘치지 않는다', (tester) async {
      expect(
        await _overflows(tester, const HomeGnbSkeleton(),
            size: _narrow, textScale: 1.5),
        isEmpty,
      );
    });
  });
}

const _normal = HomeCourse(
  kind: HomeCourseKind.expression,
  unitCode: 'A1-1',
  topic: '처음 만난 반 친구와 이름과 나라 말하기',
  expressionsLeft: 14,
);

/// 서버가 코드 모양을 바꿔 `badgeCode` 가 원문을 그대로 내보내는 경우.
const _longCode = HomeCourse(
  kind: HomeCourseKind.expression,
  unitCode: 'A1-T01-1-EXTRA',
  topic: '처음 만난 반 친구와 이름과 나라 말하기',
  expressionsLeft: 14,
);

const _noLevel = HomeCourse(kind: HomeCourseKind.noLevel);

/// 서버 주제는 길이를 앱이 통제하지 못한다 — 한 줄에 안 들어가는 경우.
const _longTopic = HomeCourse(
  kind: HomeCourseKind.expression,
  unitCode: 'A1-1',
  topic: '처음 만난 반 친구와 이름과 나라를 말하고 서로의 취미와 좋아하는 음식까지 묻고 답하기',
  expressionsLeft: 14,
);
