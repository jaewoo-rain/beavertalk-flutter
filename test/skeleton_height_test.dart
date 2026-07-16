import 'package:beavertalk/components/atoms/skeleton.dart';
import 'package:beavertalk/components/molecules/card_alarm.dart';
import 'package:beavertalk/components/molecules/card_alarm_loading.dart';
import 'package:beavertalk/components/molecules/card_bookmark.dart';
import 'package:beavertalk/components/molecules/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A skeleton exists to reserve the space its real card will take. If the two
/// disagree the content jumps on load — the exact thing the skeleton is there to
/// prevent — and nothing else in the build would notice: both widgets render
/// fine on their own, and the drift only shows for the few hundred ms a response
/// is in flight, which is too short to catch by hand on a device.
///
/// These pin each skeleton to its card. They caught real drift once already:
/// `Card-Bookmark` was restyled (14px sentence over a 12px translation, gap 8)
/// from 136 to 116 while `CardLoading` still reserved the old height.
void main() {
  /// Renders [child] at the cards' real 335 width and returns its height.
  Future<double> heightOf(WidgetTester tester, Widget child) async {
    final key = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SkeletonShimmer(
            child: Center(
              child: SizedBox(
                width: 335,
                child: KeyedSubtree(key: key, child: child),
              ),
            ),
          ),
        ),
      ),
    );
    return tester.getSize(find.byKey(key)).height;
  }

  testWidgets('CardLoading reserves exactly CardBookmark\'s height',
      (tester) async {
    // Short strings so neither line wraps — a wrapped sentence is taller by
    // definition and would test the text, not the box. `actionText` matters:
    // it is what puts the 36-high 연습하기 button in the footer row, and both
    // frames that instance this card have it.
    final real = await heightOf(
      tester,
      const CardBookmark(
        korean: '안녕',
        native: 'Hi',
        bookmarked: false,
        actionText: '연습하기',
      ),
    );
    final skeleton = await heightOf(tester, const CardLoading());

    expect(skeleton, real);
    // The measured value from `screen/analysis` (3583:34466), pinned so a
    // restyle of either card has to come here and say so.
    expect(real, 116);
  });

  testWidgets('CardAlarmLoading reserves exactly CardAlarm\'s height',
      (tester) async {
    final real = await heightOf(
      tester,
      CardAlarm(
        state: CardAlarmState.active,
        time: 'AM 8:00',
        days: List.filled(7, true),
        userName: 'Baba',
      ),
    );
    final skeleton = await heightOf(tester, const CardAlarmLoading());

    expect(skeleton, real);
  });
}
