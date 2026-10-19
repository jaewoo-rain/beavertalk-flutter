import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/components/chrome/bottom_cta_bar.dart';

void main() {
  const childKey = Key('bottom-cta-child');

  Widget host({required EdgeInsets viewPadding}) {
    return MediaQuery(
      // No OS bottom inset (web/desktop case): viewPadding.bottom == 0.
      data: MediaQueryData(viewPadding: viewPadding, padding: viewPadding),
      child: const Directionality(
        textDirection: TextDirection.ltr,
        child: BottomCtaBar(
          child: SizedBox(key: childKey, height: 48, width: 100),
        ),
      ),
    );
  }

  testWidgets('BottomCtaBar builds and renders its child', (tester) async {
    await tester.pumpWidget(host(viewPadding: EdgeInsets.zero));

    expect(find.byType(BottomCtaBar), findsOneWidget);
    expect(find.byKey(childKey), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'applies a 34 bottom gap when there is no OS inset '
      '(viewPadding.bottom == 0)', (tester) async {
    await tester.pumpWidget(host(viewPadding: EdgeInsets.zero));

    final barBottom = tester.getBottomLeft(find.byType(BottomCtaBar)).dy;
    final childBottom = tester.getBottomLeft(find.byKey(childKey)).dy;

    // max(34, inset + 12) with inset 0 → 34 (PM-DEC-807).
    expect(barBottom - childBottom, closeTo(34, 0.5));
  });

  testWidgets('honours a larger OS bottom inset when present', (tester) async {
    const osInset = 34.0;
    await tester
        .pumpWidget(host(viewPadding: const EdgeInsets.only(bottom: osInset)));

    final barBottom = tester.getBottomLeft(find.byType(BottomCtaBar)).dy;
    final childBottom = tester.getBottomLeft(find.byKey(childKey)).dy;

    // max(34, OS inset 34 + 12) → 46 (PM-DEC-807).
    expect(barBottom - childBottom, closeTo(osInset + 12, 0.5));
  });
}
