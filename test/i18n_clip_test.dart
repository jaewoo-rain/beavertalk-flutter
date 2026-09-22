// 잘림 전수 감사 — 앱의 모든 화면에서 **잘리면 안 되는 글자가 잘리는지** 본다.
//
// `i18n_overflow_test` 와 같은 화면 목록(`support/i18n_screens.dart`)을 쓰되
// 보는 것이 정반대다:
//
//   넘침(overflow) = 상자 밖으로 나간다 → 안 보인다 → Flutter 가 예외를 던진다
//   잘림(clip)     = 상자 안에 갇힌다   → **틀린 내용이 보인다** → 아무도 안 알려준다
//
// 뒤가 더 나쁘고, 뒤는 기존 시험 어느 쪽도 못 잡았다. 잘림은 두 경로로 생긴다:
//
//   (가) 상자가 낮다 — `SizedBox(height: 56)` 안에서 두 줄이 되면 둘째 줄이
//        그냥 사라진다. `maxLines`·`overflow` 는 멀쩡하고 예외도 안 난다.
//   (나) `maxLines: 1` + ellipsis — 설정 자체는 의도지만, 그 자리에 **수치나
//        식별자**가 오면 잘린 값이 거짓이 된다(「1.790.0…」·「초…」).
//
// 판정 기준은 [_mustNotTruncate] 하나다 — 산문은 뜻이 줄 뿐이라 대상이 아니고,
// 수치(금액·점수·비율·날짜)와 짧은 식별자(이름·라벨)만 본다.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/main.dart' show kMaxTextScale;

import 'support/i18n_screens.dart';

/// 이 문자열이 잘리면 **사실이 틀어지는가**.
///
/// 수치와 식별자가 대상이다. 산문은 아니다 — 뜻이 줄어들 뿐 거짓이 되지 않는다.
bool _mustNotTruncate(String s) {
  final t = s.trim();
  if (t.isEmpty) return false;
  // 숫자가 들어간 짧은 문자열 = 수치로 본다(「97 점」·「0 of 1」·날짜·금액).
  if (RegExp(r'[0-9]').hasMatch(t) && t.length <= 40) return true;
  // 짧은 이름·라벨(어절 3개 이하)도 식별자로 본다.
  if (t.length <= 24 && t.split(RegExp(r'\s+')).length <= 3) return true;
  return false;
}

/// 이 텍스트를 담고 있는 **우리 위젯**의 이름을 위에서부터 몇 개 집는다.
///
/// Flutter 기본 위젯(Padding·Row·…)은 어디에나 있어 단서가 못 된다. 앱 코드에서
/// 온 위젯만 추려야 「어느 파일을 고쳐야 하나」에 바로 답이 된다.
String _where(Element el) {
  final names = <String>[];
  el.visitAncestorElements((a) {
    final n = a.widget.runtimeType.toString();
    if (n.startsWith('_') ||
        const {
          'Padding', 'Row', 'Column', 'Center', 'Flexible', 'Expanded',
          'SizedBox', 'Container', 'DecoratedBox', 'Align', 'Stack',
          'ConstrainedBox', 'DefaultTextStyle', 'MediaQuery', 'Semantics',
          'RepaintBoundary', 'Directionality', 'Builder', 'InkWell',
          'GestureDetector', 'Material', 'AnimatedContainer', 'ClipRRect',
          'Positioned', 'Wrap', 'IntrinsicHeight', 'LayoutBuilder', 'Opacity',
          'Listener', 'RawGestureDetector', 'DefaultSelectionStyle',
          'IgnorePointer', 'FadeTransition', 'AnimatedOpacity',
          'IndexedSemantics', 'SafeArea', 'AnimatedDefaultTextStyle',
          'ExcludeSemantics', 'MergeSemantics', 'Offstage', 'Visibility',
          'SliverPadding', 'KeyedSubtree', 'AnimatedBuilder', 'ValueListenableBuilder',
          'Transform', 'FractionalTranslation', 'ClipPath', 'CustomPaint',
          'Theme', 'IconTheme', 'TextFieldTapRegion', 'TapRegion', 'Actions',
          'Shortcuts', 'Focus', 'FocusScope', 'MouseRegion', 'Scrollable',
          'Viewport', 'SliverList', 'SliverToBoxAdapter', 'PrimaryScrollController',
          'NotificationListener<KeepAliveNotification>', 'NotificationListener<ScrollNotification>',
                }.contains(n)) {
      return true;
    }
    names.add(n);
    return names.length < 3;
  });
  return names.join('<');
}

void main() {
  // 길이가 가장 사나운 로케일만 돈다. 30개를 전부 돌리면 20분 넘게 걸리고 새로
  // 걸리는 것이 없다 — 길이 순위가 이 안에 다 들어 있다. 데바나가리(ne·hi)는
  // **줄 높이**가 높아 (가) 경로를 여는 문자라 반드시 포함한다.
  const locales = [
    Locale('ne'), Locale('hi'), Locale('km'), Locale('fil'),
    Locale('de'), Locale('hu'), Locale('ur'), Locale('ko'),
  ];

  // 좁은 폰 + 글꼴 배율 상한. 둘을 같이 걸어야 최악이 나온다.
  //
  // 폭은 `--dart-define=CLIP_W=<dp>` 로 바꿔 잰다. 320 은 감사용 최악값(iPhone SE
  // 급)이고 검수 기기(SM G950N)는 **360** 이다(`1080px ÷ density 480`).
  // **둘은 다른 질문이다** — 320 에서만 나는 잘림은 「가장 좁은 기기에서 이렇게
  // 된다」이고, 360 에서도 나면 「지금 그 폰에서 이렇게 보인다」이다.
  //
  // ⛔ 411 로 돌리지 마라. 2026-09-22 에 한동안 그렇게 재고 「실기기 기준」이라고
  //   보고했는데, 실제 기기보다 **넓어서 더 관대한** 조건이었다.
  const clipWidth = int.fromEnvironment('CLIP_W', defaultValue: 320);
  // 한줄잘림(나)까지 볼지. 감사할 때만 켠다 — 위 (나) 주석 참조.
  const checkOneLine = bool.fromEnvironment('CLIP_ONELINE');
  final narrow = Size(clipWidth.toDouble(), 640);

  testWidgets('잘리면 안 되는 글자가 잘리지 않는다 (전 화면 × 상한 배율)',
      (tester) async {
    tester.view.physicalSize = narrow;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final screens = i18nScreens();
    final bad = <String>[];

    for (final locale in locales) {
      for (final entry in screens.entries) {
        try {
          await tester.pumpWidget(
            ProviderScope(
              child: MaterialApp(
                locale: locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: MediaQuery(
                  data: MediaQueryData(
                    size: narrow,
                    textScaler: const TextScaler.linear(kMaxTextScale),
                  ),
                  child: entry.value(),
                ),
              ),
            ),
          );
          await tester.pump(const Duration(milliseconds: 32));
        } catch (_) {
          // 라우트 인자·프로바이더 부재로 못 그리는 화면은 넘어간다
          // (넘침 시험과 같은 정책).
        }
        tester.takeException();

        for (final el in tester.elementList(find.byType(Text))) {
          final t = el.widget as Text;
          final s = t.data;
          if (s == null || !_mustNotTruncate(s)) continue;
          final ro = el.renderObject;
          // ⛔ 여기서 `TextPainter` 를 새로 만들어 재지 마라. 위젯 시험의 기본
          //   폰트는 실제 앱 폰트와 자폭이 달라, 같은 글자가 한 줄인지 두 줄인지
          //   **렌더와 다르게 나온다**. 2026-09-22 첫 판이 그래서 `SelectCard` ·
          //   `InputDecorator` 를 결함으로 잘못 세웠다(24+15건 전부 오탐).
          //   판정은 그린 놈에게 물어본다.
          if (ro is! RenderParagraph || !ro.hasSize || ro.size.isEmpty) continue;

          // (나) 한 줄로 못 담는데 한 줄로 자르기로 돼 있다 — 렌더의 자기 판정.
          //
          // ★★ **이 결과는 「결함」이 아니라 「확인 대상」이다.**
          //
          //   위젯 시험이 쓰는 기본 폰트는 실제 앱 폰트가 아니다. 글리프 하나를
          //   대략 정사각형으로 잡기 때문에, **결합 문자가 많은 문자(데바나가리 ·
          //   크메르 · 버마)의 폭을 크게 부풀린다.** `RenderParagraph` 에게 물어도
          //   그 렌더가 이미 틀린 폰트로 잰 것이라 답이 같이 틀린다.
          //
          //   실측 반례(2026-09-22) — `ne` 「अवतार परिवर्तन गर्नुहोस्」 가
          //   320dp·배율 1.1 에서 `didExceedMaxLines` 로 잡혔다. 같은 조건을
          //   실기기에 만들어(`adb shell wm density 540`) 확인하니 **한 줄이고
          //   폭의 53% 만 썼다.** 두 줄 근처도 아니었다.
          //
          //   그래서 여기서 나온 한줄잘림은 **실기기로 확인한 뒤** 고친다. 숫자만
          //   보고 번역을 줄이거나 레이아웃을 바꾸면 없는 문제를 고치게 된다.
          //   반대로 (가) 상자잘림은 폰트보다 **구조**(고정 높이) 문제라 그대로
          //   믿어도 된다 — 실기기에서 먼저 발견하고 이 시험이 재현한 건들이다.
          //
          // ⚠ 이 검사는 **기본으로 꺼져 있다**(`--dart-define=CLIP_ONELINE=true`).
          //   2026-09-22 전수감사에서 195건이 나왔고 사장님 결정으로 버튼·식별자를
          //   두 줄로 열었다. ⚠ 그 195 는 **위 폰트 문제로 부풀려진 숫자**다 —
          //   실제로 몇 건이 기기에서 잘렸는지는 확인하지 않았다. 두 줄 허용은
          //   글자가 한 줄에 들어가면 아무 변화가 없어 해롭지 않지만, 그 숫자를
          //   사실로 인용하지는 마라.
          //   남은 것은 입력 힌트다(힌트는 잘려도 뜻이 줄 뿐 — 사장님 결정).
          //   결정 전에 시험을 빨갛게 두면 다른 결함을 가린다.
          if (checkOneLine && t.maxLines == 1 && ro.didExceedMaxLines) {
            bad.add('${locale.languageCode} · ${entry.key} · 한줄잘림: "$s"'
                ' @${_where(el)}');
            continue;
          }
          // (가) 상자가 낮아 글자가 그 안에 갇혔다. 필요 높이도 렌더에게 묻는다
          //     — 같은 폰트·같은 줄바꿈 규칙으로 계산된 값이다.
          final need = ro.getMaxIntrinsicHeight(ro.size.width);
          if (need > ro.size.height + 1) {
            bad.add(
              '${locale.languageCode} · ${entry.key} · 상자잘림: "$s" '
              '(필요 ${need.toStringAsFixed(1)} / '
              '상자 ${ro.size.height.toStringAsFixed(1)}) @${_where(el)}',
            );
          }
        }

        await tester.pumpWidget(const SizedBox.shrink());
      }
    }

    // 전체 목록은 **파일로** 낸다. 콘솔은 긴 줄을 접어 버려서 자리·소유 위젯이
    // 잘린 채로 남는다(2026-09-22: 247건 중 44건만 파싱됐다).
    if (bad.isNotEmpty) {
      final report = File('build/i18n_clip_report.txt');
      report.parent.createSync(recursive: true);
      report.writeAsStringSync(
        '# 잘림 감사 — 폭 ${clipWidth}dp · 배율 $kMaxTextScale\n'
        '# 사례 ${bad.length}건\n\n'
        '${bad.join('\n')}\n',
      );
      final bySite = <String, int>{};
      for (final b in bad) {
        final k = b.substring(b.indexOf(' · ') + 3);
        bySite[k] = (bySite[k] ?? 0) + 1;
      }
      fail(
        '잘리면 안 되는 글자가 잘린다 — 자리 ${bySite.length}곳 / 사례 ${bad.length}건.\n'
        '잘린 값은 빈 값보다 나쁘다. 사용자가 그것을 사실로 읽는다.\n'
        '전체 목록: build/i18n_clip_report.txt',
      );
    }
  });
}
