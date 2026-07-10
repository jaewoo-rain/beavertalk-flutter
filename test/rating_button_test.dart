import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/components/icons/app_icons.dart';
import 'package:beavertalk/components/molecules/rating_button.dart';

void main() {
  testWidgets('RatingButton renders with an AppIcons builder without throwing',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RatingButton(
            icon: AppIcons.thumbsUp,
            label: '좋아요',
            selected: true,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.byType(RatingButton), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
