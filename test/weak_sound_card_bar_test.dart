import 'package:beavertalk/features/weak_sound/domain/entities/weak_sound_item.dart';
import 'package:beavertalk/features/weak_sound/presentation/widgets/weak_sound_card.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// 취약 발음 카드 막대 W2 「구간 단색」(09-24 사장님 확정 · Figma `WeakSound/Card` `6040:1496`).
void main() {
  // 테마 확장이 없으면 `context.c` 는 Dark 토큰이다.
  const c = AppColorTokens.dark;

  Future<void> pump(WidgetTester tester, int? score) async {
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('ko'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 335,
            child: WeakSoundCard(
              item: WeakSoundItem(
                soundKey: 'eo',
                label: 'ㅓ',
                cardDesc: '입을 크게',
                type: 'vowel',
                score: score,
              ),
            ),
          ),
        ),
      ),
    ));
    await tester.pump();
  }

  /// 막대 칸(Stack) 안의 둥근 상자들 — [0] 바탕, [1] 채움(있으면).
  List<Container> bars(WidgetTester tester) => tester
      .widgetList<Container>(find.byWidgetPredicate((w) =>
          w is Container &&
          w.decoration is BoxDecoration &&
          (w.decoration! as BoxDecoration).borderRadius == BorderRadius.circular(4)))
      .toList();

  testWidgets('72점 — 바탕 Score/4 16% · 채움 Score/4 · 두께 8 · 길이 = 폭 × 0.72', (tester) async {
    await pump(tester, 72);
    final b = bars(tester);
    expect(b, hasLength(2));
    expect((b[0].decoration! as BoxDecoration).color, c.score4.withValues(alpha: 0.16));
    expect((b[1].decoration! as BoxDecoration).color, c.score4);
    final track = tester.getSize(find.byWidget(b[0]));
    final fill = tester.getSize(find.byWidget(b[1]));
    expect(track.height, 8);
    expect(fill.width, closeTo(track.width * 0.72, 0.5));
  });

  testWidgets('점수 글자 · 「점」 = 구간 글자색(41 → Score/3 Text)', (tester) async {
    await pump(tester, 41);
    expect(tester.widget<Text>(find.text('41')).style!.color, c.score3Text);
    expect(tester.widget<Text>(find.text('점')).style!.color, c.score3Text);
  });

  testWidgets('목표 눈금은 폭의 80% · 2×12', (tester) async {
    await pump(tester, 50);
    final track = tester.getRect(find.byWidget(bars(tester)[0]));
    final tick = find.byWidgetPredicate((w) =>
        w is Container && w.constraints?.maxWidth == 2 && w.constraints?.maxHeight == 12);
    final r = tester.getRect(tick);
    expect(r.center.dx, closeTo(track.left + track.width * 0.8, 0.5));
    expect(r.center.dy, closeTo(track.center.dy, 0.5), reason: '막대와 세로 가운데');
  });

  testWidgets('측정 전 — 바탕 Fill/Alternative · 채움 없음 · 「측정 전」', (tester) async {
    await pump(tester, null);
    final b = bars(tester);
    expect(b, hasLength(1));
    expect((b[0].decoration! as BoxDecoration).color, c.fillAlternative);
    expect(find.text('측정 전'), findsOneWidget);
  });
}
