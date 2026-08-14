import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/mypage/avatar_detail.dart';

/// `AvatarDetailScreen` — the full-page replacement for the retired
/// `BottomSheetAvatar` modal (Figma `Avatar-Detail` `4024:1090`).
///
/// Guards the per-state contract that used to live in the sheet: which badge
/// wording shows, which footer buttons show, and that the price row appears for
/// unowned states only. That last one is the easiest to regress — the sheet
/// rendered a price for every state, and the new design drops it once owned.
void main() {
  const listPrice = r'$10';
  const salePrice = r'$5';

  Widget host(
    AvatarDetailState state, {
    String? price,
    String? discountPrice,
    int? discountPercent,
    VoidCallback? onConfirm,
    VoidCallback? onPurchase,
  }) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: AvatarDetailScreen(
        state: state,
        name: 'Baba',
        tags: const ['Savage', 'Blunt', 'Tsundere'],
        summary: 'A sharp-tongued master.',
        description: 'Baba, a beaver famous for his flawless dams.',
        price: price,
        discountPrice: discountPrice,
        discountPercent: discountPercent,
        onConfirm: onConfirm ?? () {},
        onPurchase: onPurchase ?? () {},
        onClose: () {},
        onPlaySample: () {},
        onShare: () {},
      ),
    );
  }

  testWidgets('owned-unused: Owned badge + single Use This, no price',
      (tester) async {
    await tester.pumpWidget(host(AvatarDetailState.ownedUnused));
    await tester.pump();

    expect(find.text('Owned'), findsOneWidget);
    expect(find.text('Use This'), findsOneWidget);
    expect(find.text('Close'), findsNothing);
    expect(find.text('Buy'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('owned-used: Owned badge + single Close', (tester) async {
    await tester.pumpWidget(host(AvatarDetailState.ownedUsed));
    await tester.pump();

    expect(find.text('Owned'), findsOneWidget);
    expect(find.text('Close'), findsOneWidget);
    expect(find.text('Use This'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('unowned-normal: purchase badge, price, Close + Buy',
      (tester) async {
    await tester.pumpWidget(
      host(AvatarDetailState.unownedNormal, price: listPrice),
    );
    await tester.pump();

    expect(find.text('Available to purchase'), findsOneWidget);
    expect(find.text(listPrice), findsOneWidget);
    expect(find.text('Close'), findsOneWidget);
    expect(find.text('Buy'), findsOneWidget);
    expect(find.text('Use This'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('unowned-discount: -N% marker, struck list price + sale price',
      (tester) async {
    await tester.pumpWidget(
      host(
        AvatarDetailState.unownedDiscount,
        price: listPrice,
        discountPrice: salePrice,
        discountPercent: 50,
      ),
    );
    await tester.pump();

    expect(find.text('-50%'), findsOneWidget);
    expect(find.text(salePrice), findsOneWidget);

    // The original price must read as superseded, not as the amount charged.
    final struck = tester.widget<Text>(find.text(listPrice));
    expect(struck.style?.decoration, TextDecoration.lineThrough);
    expect(tester.takeException(), isNull);
  });

  testWidgets('unowned-discount omits the -N% marker when no rate is given',
      (tester) async {
    // The rate cannot be derived from pre-formatted price strings, so a missing
    // rate must render nothing rather than a guessed "-50%".
    await tester.pumpWidget(
      host(
        AvatarDetailState.unownedDiscount,
        price: listPrice,
        discountPrice: salePrice,
      ),
    );
    await tester.pump();

    expect(find.textContaining('%'), findsNothing);
    expect(find.text(salePrice), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the single-button footer fills the gutter width', (tester) async {
    // On device a bare Button hugged its label and floated centred (~260px)
    // because BottomCtaBar passes a loose constraint. The footer must span the
    // 20px gutters like Figma's 335-wide CTA.
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(host(AvatarDetailState.ownedUnused));
    await tester.pump();

    final button = tester.getSize(
      find
          .ancestor(
            of: find.text('Use This'),
            matching: find.byType(InkWell),
          )
          .first,
    );
    // 375 - 20 - 20 = 335.
    expect(button.width, closeTo(335, 1));
  });

  testWidgets('owned states drop the price row even when a price is passed',
      (tester) async {
    for (final state in [
      AvatarDetailState.ownedUnused,
      AvatarDetailState.ownedUsed,
    ]) {
      await tester.pumpWidget(
        host(state, price: listPrice, discountPrice: salePrice),
      );
      await tester.pump();

      expect(find.text(listPrice), findsNothing, reason: '$state shows a price');
      expect(find.text(salePrice), findsNothing, reason: '$state shows a price');
    }
    expect(tester.takeException(), isNull);
  });

  // ── 구독으로 열린 상태 (is_unlocked=true, is_owned=false) ─────────────────
  //
  // Max 회원의 미구매 캐릭터. 서버가 소유와 접근을 나눠 보내면서 생긴 상태이고,
  // 원래 버그가 정확히 여기였다 — 앱이 `is_owned` 만 보고 잠가 버렸다.
  //
  // 이 상태의 계약은 세 줄이다: 선택 가능 / "Owned" 배지 금지 / 구매 CTA 유지.
  // 셋 중 하나라도 깨지면 사용자에게 거짓말이 된다.
  group('subscription-unlocked', () {
    testWidgets('never claims ownership — Max badge, not "Owned"',
        (tester) async {
      for (final state in [
        AvatarDetailState.subscriptionUnused,
        AvatarDetailState.subscriptionUsed,
      ]) {
        await tester.pumpWidget(host(state, price: listPrice));
        await tester.pump();

        expect(find.text('Available with Max'), findsOneWidget,
            reason: '$state is missing the Max badge');
        // ⛔ 이게 뜨면 산 것으로 오해시킨 뒤 해지 때 뺏는 꼴이 된다.
        expect(find.text('Owned'), findsNothing,
            reason: '$state claims ownership');
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('keeps the price row and the Buy CTA alive', (tester) async {
      // 소유 상태와 갈리는 지점: Max 회원도 해지 후를 대비해 영구 구매를 할 수
      // 있어야 하고, 서버가 그 흐름을 막지 않는다.
      for (final state in [
        AvatarDetailState.subscriptionUnused,
        AvatarDetailState.subscriptionUsed,
      ]) {
        await tester.pumpWidget(host(state, price: listPrice));
        await tester.pump();

        expect(find.text(listPrice), findsOneWidget,
            reason: '$state dropped the price row');
        expect(find.text('Buy'), findsOneWidget,
            reason: '$state dropped the purchase CTA');
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('unused: Use This is the primary action', (tester) async {
      var used = 0;
      var bought = 0;
      await tester.pumpWidget(host(
        AvatarDetailState.subscriptionUnused,
        price: listPrice,
        onConfirm: () => used++,
        onPurchase: () => bought++,
      ));
      await tester.pump();

      // 원래 버그의 반대편 — 선택할 수 있어야 한다.
      expect(find.text('Use This'), findsOneWidget);
      await tester.tap(find.text('Use This'));
      expect((used, bought), (1, 0));

      await tester.tap(find.text('Buy'));
      expect((used, bought), (1, 1));
    });

    testWidgets('used: Close replaces Use This, Buy stays', (tester) async {
      var bought = 0;
      await tester.pumpWidget(host(
        AvatarDetailState.subscriptionUsed,
        price: listPrice,
        onPurchase: () => bought++,
      ));
      await tester.pump();

      // 이미 쓰는 중이라 "사용하기"는 할 일이 없다.
      expect(find.text('Use This'), findsNothing);
      expect(find.text('Close'), findsOneWidget);

      await tester.tap(find.text('Buy'));
      expect(bought, 1);
    });

    testWidgets('renders a sale the same way the unowned state does',
        (tester) async {
      // 할인은 소유 축과 직교한다 — 구독으로 열린 캐릭터도 할인 중일 수 있다.
      // enum 을 두 배로 늘리는 대신 할인가 유무로 판단하므로, 그 경로를 못박는다.
      await tester.pumpWidget(host(
        AvatarDetailState.subscriptionUnused,
        price: listPrice,
        discountPrice: salePrice,
        discountPercent: 50,
      ));
      await tester.pump();

      expect(find.text('-50%'), findsOneWidget);
      expect(find.text(salePrice), findsOneWidget);
      final struck = tester.widget<Text>(find.text(listPrice));
      expect(struck.style?.decoration, TextDecoration.lineThrough);
      expect(tester.takeException(), isNull);
    });
  });
}
