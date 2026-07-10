import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/components/atoms/mic_button.dart';

void main() {
  Widget host(Widget child) => MaterialApp(home: Scaffold(body: Center(child: child)));

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
