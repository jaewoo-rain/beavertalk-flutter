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
  const listPrice = '₩4,900';
  const salePrice = '₩2,450';

  Widget host(
    AvatarDetailState state, {
    String? price,
    String? discountPrice,
    int? discountPercent,
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
        onConfirm: () {},
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
}
