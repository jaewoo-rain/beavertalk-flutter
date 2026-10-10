import 'dart:async';

import 'package:beavertalk/components/organisms/gnb.dart';
import 'package:beavertalk/features/normalcall/domain/entities/call_result.dart';
import 'package:beavertalk/features/normalcall/presentation/streak_provider.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/home/streak_calendar.dart';
import 'package:beavertalk/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 학습 달력 로딩 — GNB 가 주황 히어로 면 위에 투명하게 얹혀야 한다(실제 화면과 같이).
///
/// 09-26 사용자 「Learning Calendar 로딩 스켈레톤에서 GNB 색상도 주황색으로 해줘」 — 로딩
/// 화면만 GNB 기본 배경(회색)이라 주황 히어로 위에 회색 띠가 얹혔다.
void main() {
  testWidgets('로딩 중 GNB 배경은 투명 · 주황 면 위', (tester) async {
    final never = Completer<List<CallSummary>>();
    await tester.pumpWidget(ProviderScope(
      overrides: [callHistoryProvider.overrideWith((ref) => never.future)],
      child: MaterialApp(
        theme: ThemeData(extensions: const [AppColorTokens.light]),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const StreakCalendarScreen(),
      ),
    ));
    await tester.pump();

    final gnb = tester.widget<Gnb>(find.byType(Gnb));
    expect(gnb.background, Colors.transparent, reason: 'GNB 만 회색으로 칠해진다');
    final hero = tester.widget<ColoredBox>(
        find.ancestor(of: find.byType(Gnb), matching: find.byType(ColoredBox)).first);
    expect(hero.color, AppColorTokens.light.accentStreakSurface);
  });
}
