// 표현학습 힌트 말풍선([TooltipBubble])의 다국어 넘침 감사 — 2026-09-15 사장님 요청
// 「다국어로 했을 때 overflow 위험 → 줄바꿈 등 대응 방안 수립·코드 반영」.
//
// i18n_overflow_test 는 통화 화면을 띄우지 않는다(타이머·소켓 — 그 파일 머리말).
// 그래서 말풍선만 **통화 화면과 같은 자리 규칙**으로 띄워 30개 언어를 전수 검사한다.
//
// 대응 방안(Figma 동작 규격 카드 「다국어·넘침」과 같은 내용):
// 1. 폭 상한 = min(335, 화면폭 − 말풍선 시작 − 20) — 좁은 폰에서 화면 밖으로 안 나간다.
// 2. 줄바꿈 허용 · 최대 [TooltipBubble.maxLines] 줄 · 넘치면 말줄임(최후 방어).
// 3. 폭은 가장 긴 줄에 맞춘다(longestLine) · 높이는 위로 자란다.
// 4. 시스템 글자 배율은 막지 않는다 — 배율 2.0 도 넘침 없이 화면 안에 있어야 한다.
//
// ⚠ 테스트 기본 글꼴은 모든 글리프를 정사각형(폭 = 글자 크기)으로 그려 실제보다 넓다.
//   Pretendard 를 실제로 올려 라틴·한글 폭을 현실에 맞춘다. Pretendard 에 없는 문자
//   (태국·미얀마·데바나가리 등)는 여전히 정사각형이라 **더 가혹한** 쪽으로 잰다.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/components/molecules/tooltip_bubble.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/theme/app_typography.dart';

/// 통화 화면 폰 폭에서의 말풍선 시작(버튼 x32 − 12). 화면폭 600 미만이면 늘 이 값이다.
const double _start = 20;

Future<void> _loadPretendard() async {
  final loader = FontLoader(kFontFamily);
  for (final weight in const ['Regular', 'Medium', 'SemiBold', 'Bold']) {
    loader.addFont(rootBundle.load('assets/fonts/Pretendard-$weight.otf'));
  }
  await loader.load();
}

Widget _harness(Locale locale, double width, double scale) => MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(scale)),
          child: Scaffold(
            body: Stack(
              children: [
                PositionedDirectional(
                  start: _start,
                  bottom: 120,
                  child: TooltipBubble(
                    message: AppLocalizations.of(context).callHintLockedTitle,
                    maxWidth: TooltipBubble.maxWidthFor(
                      available: width,
                      start: _start,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

RenderParagraph _paragraph(WidgetTester tester) =>
    tester.renderObject<RenderParagraph>(
      find.descendant(
        of: find.byType(TooltipBubble),
        matching: find.byType(RichText),
      ),
    );

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await _loadPretendard();
  });

  test('폭 상한 — 폰 375 는 정본 335, 320 은 화면 안쪽 280', () {
    expect(TooltipBubble.maxWidthFor(available: 375, start: _start), 335);
    expect(TooltipBubble.maxWidthFor(available: 320, start: _start), 280);
  });

  for (final width in const [320.0, 375.0]) {
    for (final scale in const [1.0, 2.0]) {
      testWidgets(
          '30개 언어 @ ${width.toInt()}dp · 글자 배율 $scale — 넘침 없음 · 화면 안'
          '${scale == 1.0 ? ' · 말줄임 없음' : ''}', (tester) async {
        tester.view.physicalSize = Size(width, 640);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        final failures = <String>[];
        for (final locale in AppLocalizations.supportedLocales) {
          final tag = locale.toLanguageTag();
          final errors = <FlutterErrorDetails>[];
          final prev = FlutterError.onError;
          FlutterError.onError = errors.add;
          try {
            await tester.pumpWidget(_harness(locale, width, scale));
            await tester.pump();
          } finally {
            FlutterError.onError = prev;
          }

          if (errors.isNotEmpty) {
            failures.add(
              '$tag: ${errors.first.exceptionAsString().split('\n').first}',
            );
          }
          final rect = tester.getRect(find.byType(TooltipBubble));
          if (rect.left < 0 || rect.right > width) {
            failures.add('$tag: 화면 밖 $rect');
          }
          // 배율 1.0 에서는 말줄임조차 없어야 한다 — 문구가 잘리면 안내가 안 된다.
          // 배율 2.0 은 접근성 극단이라 말줄임까지는 허용하고 넘침만 막는다.
          if (scale == 1.0 && _paragraph(tester).didExceedMaxLines) {
            failures.add('$tag: ${TooltipBubble.maxLines}줄 초과(말줄임 발생)');
          }
        }
        expect(failures, isEmpty, reason: failures.join('\n'));
      });
    }
  }

  testWidgets('320dp — 가장 긴 문구(fr)는 한 줄로 밀지 않고 줄바꿈된다', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_harness(const Locale('fr'), 320, 1.0));
    await tester.pump();

    final p = _paragraph(tester);
    expect(p.size.height, greaterThan(AppType.caption2.height * 1.5),
        reason: '두 줄 이상이어야 한다');
    expect(p.didExceedMaxLines, isFalse);
  });

  testWidgets('RTL(ar) — 말풍선이 오른쪽 기준으로 붙는다', (tester) async {
    tester.view.physicalSize = const Size(375, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_harness(const Locale('ar'), 375, 1.0));
    await tester.pump();

    final rect = tester.getRect(find.byType(TooltipBubble));
    expect(rect.right, moreOrLessEquals(375 - _start),
        reason: 'start 가 오른쪽에서 재진다');
  });
}
