import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/plans/paywall.dart';
import 'package:beavertalk/features/subscription/domain/entities/subscription_state.dart';
import 'package:beavertalk/screens/plans/plans_compare.dart';
import 'package:beavertalk/screens/plans/purchase_flow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

/// Premium 혜택 줄은 듀오톤 아이콘 4종을 단다(Figma `Paywall/Benefit` `6198:1999`) —
/// 플랜 비교 · 페이월 · 구매 완료 세 곳. Free 카드는 점 불릿 그대로다.
void main() {
  Future<void> pump(WidgetTester t, Widget screen) async {
    await t.binding.setSurfaceSize(const Size(375, 1800));
    addTearDown(() => t.binding.setSurfaceSize(null));
    await t.pumpWidget(ProviderScope(
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: screen,
      ),
    ));
    await t.pump();
  }

  bool isDuo(Widget w, String name) =>
      w is SvgPicture &&
      (w.bytesLoader as SvgAssetLoader).assetName == 'assets/icons/$name.svg';

  for (final (label, screen) in [
    ('plans compare', const PlansCompareScreen()),
    ('paywall', const PaywallScreen(variant: PaywallVariant.max)),
    ('purchase success',
        const PurchaseSuccessScreen(tier: SubscriptionTier.max)),
  ]) {
    testWidgets('$label: Premium bullets carry the four duotone icons',
        (t) async {
      await pump(t, screen);
      for (final name in ['duo-video', 'duo-chart', 'duo-target', 'duo-bubble']) {
        expect(find.byWidgetPredicate((w) => isDuo(w, name)), findsOneWidget,
            reason: name);
      }
      expect(find.text('Up to 3 video calls a day, 15 minutes each'),
          findsWidgets);
    });
  }
}
