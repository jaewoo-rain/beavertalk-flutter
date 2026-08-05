import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/components/chrome/bottom_cta_bar.dart';
import 'package:beavertalk/theme/app_spacing.dart';

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
      'applies a bottom inset >= 24 when there is no OS inset '
      '(viewPadding.bottom == 0)', (tester) async {
    await tester.pumpWidget(host(viewPadding: EdgeInsets.zero));

    final barBottom = tester.getBottomLeft(find.byType(BottomCtaBar)).dy;
    final childBottom = tester.getBottomLeft(find.byKey(childKey)).dy;

    // The gap between the child's bottom and the bar's bottom edge is the
    // SafeArea minimum floor of 24px (SafeArea has no top/horizontal padding
    // here, and BottomCtaBar's own Padding adds 0 at the bottom).
    expect(barBottom - childBottom, greaterThanOrEqualTo(AppSpacing.s24));
    expect(barBottom - childBottom, closeTo(AppSpacing.s24, 0.5));
  });

  testWidgets('honours a larger OS bottom inset when present', (tester) async {
    const osInset = 34.0;
    await tester
        .pumpWidget(host(viewPadding: const EdgeInsets.only(bottom: osInset)));

    final barBottom = tester.getBottomLeft(find.byType(BottomCtaBar)).dy;
    final childBottom = tester.getBottomLeft(find.byKey(childKey)).dy;

    // SafeArea uses the larger of (minimum 24, OS inset 34) → 34.
    expect(barBottom - childBottom, closeTo(osInset, 0.5));
  });
}
