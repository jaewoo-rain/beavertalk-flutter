import 'package:beavertalk/components/organisms/dialog_share_profile.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// 억양 공유 대화상자 — 「Share」 버튼은 **카드 안** 맨 아래.
///
/// QA F020(09-26): 버튼이 카드 밖 딤 위에 떠, 반투명 Fill/Strong 면이 딤에 묻혀 버튼으로
/// 안 보였다. 정본 `Dialog/ShareProfile` state=share(`4080:8649`) — 카드 `4080:8650` 한 장이
/// 캡처 영역과 버튼을 함께 감싼다(폭 335 · 패딩 좌우 20 · 아래 24 · 버튼 높이 60).
void main() {
  testWidgets('버튼이 카드 안 — 좌우 20 · 아래 24 · 높이 60 · 캡처 밖', (tester) async {
    tester.view.physicalSize = const Size(375, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(
        body: Center(
          child: DialogShareProfile(
            avatar: SizedBox(width: 80, height: 80),
            caption: 'Your Korean accent sounds',
            title: 'Japan',
            stats: [ProfileStat(label: 'Japan', value: 70, active: true)],
          ),
        ),
      ),
    ));
    await tester.pump();

    final card = tester.getRect(find.byType(DialogShareProfile));
    final button = tester.getRect(find
        .ancestor(of: find.text('Share'), matching: find.byType(InkWell))
        .first);
    expect(card.width, 335);
    expect(button.left - card.left, 20);
    expect(card.right - button.right, 20);
    expect(card.bottom - button.bottom, 24);
    expect(button.height, 60);

    // 캡처 영역(RepaintBoundary)에 버튼이 들어가면 공유 이미지에 버튼이 찍힌다.
    final capture = find
        .descendant(
          of: find.byType(DialogShareProfile),
          matching: find.byType(RepaintBoundary),
        )
        .first;
    expect(
      find.descendant(of: capture, matching: find.text('Share')),
      findsNothing,
    );
    expect(
      find.descendant(of: capture, matching: find.text('BeaverTalk')),
      findsOneWidget,
    );
  });
}
