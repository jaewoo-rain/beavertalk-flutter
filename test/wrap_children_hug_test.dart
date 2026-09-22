// Wrap 자식이 **글자 폭으로 줄어드는지** 잰다 — 넘침이 아니라 원인을 본다.
//
// 2026-09-22 실기기 1보: 알람 요일 칩이 `Container(alignment:)` 때문에 한 줄을 다 먹어
// 일곱 개가 세로로 쌓였다. 넘침 시험은 화면이 짧을 때만 그걸 잡는다(긴 기기·세로 제약이
// 풀린 하네스에서는 그냥 길어질 뿐이다). 그래서 증상 대신 원인 — 「Wrap 의 자식이 전부
// Wrap 전폭」 — 을 직접 잰다. 앞으로 누가 Wrap 안에 같은 패턴을 써도 여기서 걸린다.
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/l10n/app_localizations.dart';

import 'support/i18n_screens.dart';

void main() {
  final screens = i18nScreens();
  // 약칭이 가장 짧은 축(ko)·긴 축(ne·de) — 칩이 짧을수록 전폭 먹기가 도드라진다.
  const locales = [Locale('en'), Locale('ko'), Locale('ne'), Locale('de')];

  testWidgets('Wrap 안의 자식이 한 줄 전폭을 먹지 않는다', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final bad = <String>[];
    for (final locale in locales) {
      for (final entry in screens.entries) {
        try {
          await tester.pumpWidget(ProviderScope(
            child: MaterialApp(
              locale: locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: entry.value(),
            ),
          ));
          await tester.pump(const Duration(milliseconds: 32));
        } catch (_) {
          // 하네스에서 못 그리는 화면(프로바이더·라우트 인자) — 이 시험의 관심 밖.
        }
        tester.takeException();
        final root = tester.binding.rootElement?.renderObject;
        if (root == null) continue;
        void visit(RenderObject o) {
          if (o is RenderWrap && o.hasSize) {
            final kids = <RenderBox>[];
            o.visitChildren((k) {
              if (k is RenderBox && k.hasSize) kids.add(k);
            });
            // 자식이 셋 이상인데 **모두** Wrap 폭과 같다 = 한 줄에 하나씩 쌓였다.
            if (kids.length >= 3 &&
                o.size.width > 0 &&
                kids.every((k) => k.size.width >= o.size.width - 0.5)) {
              bad.add('$locale · ${entry.key}: ${kids.length}개 자식이 모두 '
                  '${o.size.width.toStringAsFixed(0)}px(전폭)');
            }
          }
          o.visitChildren(visit);
        }

        visit(root);
      }
    }
    expect(bad, isEmpty, reason: bad.join('\n'));
  });
}
