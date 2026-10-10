import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beavertalk/components/atoms/icon_button.dart';
import 'package:beavertalk/components/atoms/select_box.dart';
import 'package:beavertalk/components/icons/app_icons.dart';
import 'package:beavertalk/components/molecules/country_select.dart';
import 'package:beavertalk/components/molecules/rating_button.dart';
import 'package:beavertalk/components/molecules/select_card.dart';

/// 선택 상태가 바뀔 때 **상자 크기가 달라지면 안 된다**.
///
/// 이 결함은 눈으로 못 잡는다 — `selected ? Border.all(width: 1) : null` 처럼
/// 테두리를 통째로 없앴다 켜면 두께가 0↔1 로 오가고, 그만큼 안쪽 내용이 1px 씩
/// 밀린다. 목록에서 항목을 옮겨 고르면 글자가 미세하게 떨리는 그 현상이다.
/// 색만 투명으로 섞으면 사라지므로, 여기서 그 규칙을 못 박는다.
void main() {
  Widget host(Widget child) =>
      MaterialApp(home: Scaffold(body: Center(child: SizedBox(width: 320, child: child))));

  /// [build] 로 켠 상태와 끈 상태를 각각 그려 크기를 비교한다.
  Future<void> expectStableSize(
    WidgetTester tester,
    Type type,
    Widget Function(bool on) build,
  ) async {
    await tester.pumpWidget(host(build(false)));
    final Size off = tester.getSize(find.byType(type));

    await tester.pumpWidget(host(build(true)));
    // 전환 한가운데와 정착 후 둘 다 잰다.
    await tester.pump(const Duration(milliseconds: 90));
    expect(tester.getSize(find.byType(type)), off, reason: '$type 전환 중');
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.getSize(find.byType(type)), off, reason: '$type 정착 후');
  }

  testWidgets('CountrySelect 는 선택해도 크기가 그대로다', (tester) async {
    await expectStableSize(
      tester,
      CountrySelect,
      (on) => CountrySelect(
        flag: const SizedBox(width: 24, height: 24),
        name: 'Korea',
        selected: on,
        onSelect: () {},
      ),
    );
  });

  testWidgets('SelectCard 는 체크해도 크기가 그대로다', (tester) async {
    await expectStableSize(
      tester,
      SelectCard,
      (on) => SelectCard(
        icon: const SizedBox(width: 24, height: 24),
        title: '여행',
        description: '여행에서 쓸 한국어',
        checked: on,
        onChanged: (_) {},
      ),
    );
  });

  testWidgets('AppIconButton 은 선택해도 크기가 그대로다', (tester) async {
    await expectStableSize(
      tester,
      AppIconButton,
      (on) => Center(
        child: AppIconButton(label: 'Mo', selected: on, onChanged: (_) {}),
      ),
    );
  });

  testWidgets('SelectBox 는 선택해도 크기가 그대로다', (tester) async {
    await expectStableSize(
      tester,
      SelectBox,
      (on) => Center(
        child: SelectBox(label: '월', selected: on, onChanged: (_) {}),
      ),
    );
  });

  testWidgets('RatingButton 은 선택해도 크기가 그대로다', (tester) async {
    await expectStableSize(
      tester,
      RatingButton,
      (on) => Center(
        child: RatingButton(
          icon: AppIcons.thumbsUp,
          label: '좋아요',
          selected: on,
          onTap: () {},
        ),
      ),
    );
  });
}
