import 'package:beavertalk/components/molecules/card_line.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// 결제 행 보조줄 「날짜 · 결제수단」(PM-DEC-065 · 09-27 결제 내역 게이트 등록에서 드러남).
///
/// - 결제수단은 서버 문구라 그 안에 「·」 가 있을 수 있다 — 조각으로 쪼개지 않는다.
/// - 한 줄에 안 들어가면 넘치지 않고 결제수단이 다음 줄로 내려간다.
Future<void> _pump(WidgetTester tester, double width, CardLine line) async {
  tester.view.physicalSize = Size(width, 400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: Align(alignment: Alignment.topLeft, child: line)),
  ));
}

CardLine _line(List<String> meta) => CardLine(
      type: CardLineType.payment,
      label: 'Subscription',
      metaSegments: meta,
      value: r'$23.99',
      status: 'Completed',
    );

void main() {
  testWidgets('결제수단 안의 「·」 는 글자로 남는다(쪼개지지 않음)', (tester) async {
    await _pump(tester, 1200, _line(['Sep 1', 'Google Play · Visa •••• 4242']));
    expect(find.text('Google Play · Visa •••• 4242'), findsOneWidget);
    expect(find.text('Google Play'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('자리가 있으면 한 줄 — 날짜와 결제수단이 같은 높이', (tester) async {
    await _pump(tester, 1200, _line(['Sep 1', 'Visa •••• 4242']));
    final date = tester.getTopLeft(find.text('Sep 1'));
    final card = tester.getTopLeft(find.text('Visa •••• 4242'));
    expect(card.dy, date.dy);
    expect(card.dx, greaterThan(date.dx));
  });

  testWidgets('좁으면 넘치지 않고 결제수단이 다음 줄로', (tester) async {
    await _pump(
      tester,
      320,
      _line(['Sep 1', 'Mastercard Platinum Business •••• 9876']),
    );
    expect(tester.takeException(), isNull, reason: '넘침(RenderFlex overflow) 없음');
    final date = tester.getTopLeft(find.text('Sep 1'));
    final card = tester.getTopLeft(find.text('Mastercard Platinum Business •••• 9876'));
    expect(card.dy, greaterThan(date.dy), reason: '다음 줄');
    expect(card.dx, date.dx, reason: '같은 시작선');
  });

  testWidgets('옛 문자열 meta 도 그대로 동작(고정 문구용)', (tester) async {
    await _pump(
      tester,
      1200,
      const CardLine(
        type: CardLineType.payment,
        label: 'Subscription',
        meta: 'Sep 1·Visa •••• 4242',
        value: r'$23.99',
        status: 'Completed',
      ),
    );
    expect(find.text('Sep 1'), findsOneWidget);
    expect(find.text('Visa •••• 4242'), findsOneWidget);
  });
}
