import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/components/atoms/mic_button.dart';
import 'package:beavertalk/l10n/app_localizations.dart';

void main() {
  // MicButton reads `AppLocalizations.of(context)`, which null-checks unless the
  // host installs the l10n delegates (as `main.dart` does).
  Widget host(Widget child) => MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: Center(child: child)),
      );

  testWidgets('MicButton renders idle without a level (static)', (tester) async {
    var taps = 0;
    await tester.pumpWidget(host(
      MicButton(recording: false, onTap: () => taps++),
    ));

    expect(find.byType(MicButton), findsOneWidget);
    // No reactive halo/scale wrapper when level is null.
    expect(find.byType(AnimatedScale), findsNothing);

    await tester.tap(find.byType(MicButton));
    expect(taps, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('MicButton reacts to a level while recording', (tester) async {
    await tester.pumpWidget(host(
      MicButton(recording: true, level: 0.7, onTap: () {}),
    ));

    // The reactive pulse (scale + halo) is present when a level is supplied.
    expect(find.byType(AnimatedScale), findsOneWidget);
    expect(find.byType(AnimatedContainer), findsOneWidget);

    // Animating to a new level does not throw.
    await tester.pumpWidget(host(
      MicButton(recording: true, level: 0.1, onTap: () {}),
    ));
    await tester.pump(const Duration(milliseconds: 120));
    expect(tester.takeException(), isNull);
  });

  testWidgets('마이크가 정지 버튼으로 바뀌어도 자리가 안 움직인다', (tester) async {
    // 예전엔 녹음 중에만 헤일로 여백 40 을 레이아웃으로 예약해 위젯이 96→136
    // 으로 커졌다. CTA 바가 그만큼 높아지며 버튼이 위로 밀려, 누른 자리와 다른
    // 자리에 정지 버튼이 떴다. 화면은 정상으로 보여 눈으로 못 잡는 결함이라
    // 자로 잰다.
    await tester.pumpWidget(host(
      MicButton(recording: false, level: 0, onTap: () {}),
    ));
    final Rect idle = tester.getRect(find.byType(MicButton));

    await tester.pumpWidget(host(
      MicButton(recording: true, level: 0.9, onTap: () {}),
    ));
    await tester.pump(const Duration(milliseconds: 200));
    final Rect recording = tester.getRect(find.byType(MicButton));

    expect(recording, idle, reason: '버튼 상자가 상태에 따라 달라지면 안 된다');
    expect(idle.size, const Size(96, 96));
  });

  testWidgets('MicButton stays static when idle even if a level is passed',
      (tester) async {
    await tester.pumpWidget(host(
      MicButton(recording: false, level: 0.9, onTap: () {}),
    ));

    // Idle never pulses regardless of level.
    expect(find.byType(AnimatedScale), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
