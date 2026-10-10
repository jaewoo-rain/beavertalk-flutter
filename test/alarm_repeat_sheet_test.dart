import 'package:beavertalk/components/molecules/row_alarm.dart';
import 'package:beavertalk/components/organisms/bottom_sheet_alarm_add.dart';
import 'package:beavertalk/components/organisms/bottom_sheet_alarm_settings.dart' show AlarmPartner;
import 'package:beavertalk/components/atoms/skeleton.dart';
import 'package:beavertalk/features/alarm/domain/entities/alarm.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/alarm/alarm_days.dart';
import 'package:beavertalk/screens/alarm/alarm_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// 알람 「반복 선택」 하위 화면(09-24 사용자 확정 · Figma `6180:4764`) · 로딩 스켈레톤(`3489:4550`).
void main() {
  Widget host(Widget child) => MaterialApp(
        locale: const Locale('ko'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: Align(alignment: Alignment.bottomCenter, child: child)),
      );

  Future<List<(int, bool)>> pumpSheet(WidgetTester tester) async {
    final toggles = <(int, bool)>[];
    tester.view.physicalSize = const Size(375, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    var days = [false, true, false, true, false, true, false];
    await tester.pumpWidget(host(StatefulBuilder(
      builder: (ctx, setState) => BottomSheetAlarmAdd(
        title: '알람 추가',
        cancelText: '취소',
        saveText: '저장',
        repeatLabel: '반복',
        partnerLabel: '통화 상대',
        hour24: 8,
        minute: 0,
        onTimeChanged: (_, _) {},
        days: days,
        dayNames: AlarmDays.fullNames('ko'),
        repeatDoneText: '완료',
        repeatBackLabel: '뒤로',
        daysSummary: '월 · 수 · 금',
        onDayToggled: (i, on) {
          toggles.add((i, on));
          setState(() => days = [...days]..[i] = on);
        },
        partners: const [AlarmPartner(id: '1', name: 'Baba')],
        partner: '1',
        onPartnerChanged: (_) {},
        onSave: () {},
        onCancel: () {},
        callMode: AlarmCallMode.learn,
        onCallModeChanged: (_) {},
        learnModeTitle: '학습',
        learnModeSubtitle: '커리큘럼 표현 연습',
        chatModeTitle: '자유 대화',
        chatModeSubtitle: '주제 없이 대화',
      ),
    )));
    await tester.pumpAndSettle();
    return toggles;
  }

  testWidgets('「반복」 을 누르면 시트 안에서 요일 이름 화면이 열린다(일요일부터)', (tester) async {
    await pumpSheet(tester);
    await tester.tap(find.text('반복'));
    await tester.pumpAndSettle();
    expect(find.text('일요일'), findsOneWidget);
    expect(find.text('토요일'), findsOneWidget);
    expect(find.text('완료'), findsOneWidget);
    expect(find.text('저장'), findsNothing, reason: '본문은 밀려 나갔다');
    final sun = tester.getTopLeft(find.text('일요일')).dy;
    final mon = tester.getTopLeft(find.text('월요일')).dy;
    expect(sun, lessThan(mon), reason: '일요일이 맨 위');
  });

  testWidgets('요일 줄을 누르면 켜고 끈다 — 데이터 인덱스 0=일', (tester) async {
    final toggles = await pumpSheet(tester);
    await tester.tap(find.text('반복'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('일요일'));
    await tester.tap(find.text('월요일'));
    await tester.pump();
    expect(toggles, [(0, true), (1, false)]);
  });

  testWidgets('「완료」 · 「<」 는 시트 본문으로 되돌아간다(시트는 닫히지 않는다)', (tester) async {
    await pumpSheet(tester);
    await tester.tap(find.text('반복'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('완료'));
    await tester.pumpAndSettle();
    expect(find.text('저장'), findsOneWidget);
    expect(find.text('일요일'), findsNothing);

    await tester.tap(find.text('반복'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('뒤로'));
    await tester.pumpAndSettle();
    expect(find.text('저장'), findsOneWidget);
  });

  testWidgets('로딩 줄은 실제 알람 줄과 높이가 같다', (tester) async {
    await tester.pumpWidget(host(const SkeletonShimmer(child: RowAlarmLoading())));
    final loading = tester.getSize(find.byType(RowAlarmLoading)).height;
    await tester.pumpWidget(host(const RowAlarm(
      partner: 'Baba',
      time: '8:00',
      summary: '평일',
      mode: RowAlarmMode.study,
      active: true,
    )));
    final real = tester.getSize(find.byType(RowAlarm)).height;
    expect(loading, real);
  });

  // 09-26 사장님 확정 시안 C — Figma `Row/Alarm` `6179:4634`(mode=study|free-talk).
  group('통화 방식 원판', () {
    Future<void> pumpRow(WidgetTester tester,
        {required RowAlarmMode mode, required bool active}) async {
      await tester.pumpWidget(host(RowAlarm(
        partner: 'Baba',
        time: '8:00',
        summary: '평일',
        mode: mode,
        active: active,
      )));
    }

    // 토글 손잡이(24 원)와 가르려고 40 원만 찾는다.
    Finder disc() => find.descendant(
          of: find.byType(RowAlarm),
          matching: find.byWidgetPredicate((w) =>
              w is Container &&
              w.decoration is BoxDecoration &&
              (w.decoration! as BoxDecoration).shape == BoxShape.circle &&
              w.constraints?.maxWidth == 40),
        );

    testWidgets('40 원판이 글자 앞 12 에 세로 가운데로 선다', (tester) async {
      await pumpRow(tester, mode: RowAlarmMode.study, active: true);
      final d = tester.getRect(disc());
      expect(d.size, const Size(40, 40));
      final text = tester.getRect(find.text('8:00'));
      expect(text.left - d.right, 12);
      final row = tester.getRect(find.byType(RowAlarm));
      expect(d.center.dy, closeTo(row.center.dy, 0.5));
    });

    testWidgets('방식마다 읽어 주는 이름이 다르고 요약에는 방식 글자가 없다', (tester) async {
      // 원판에 단 이름 — 줄의 탭 영역이 자식 이름을 한 덩이로 합치므로 위젯 설정으로 본다.
      Finder labelled(String label) => find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.label == label);
      await pumpRow(tester, mode: RowAlarmMode.study, active: true);
      expect(labelled('학습'), findsOneWidget);
      expect(find.text('평일'), findsOneWidget);
      expect(find.textContaining('학습'), findsNothing);
      await pumpRow(tester, mode: RowAlarmMode.freeTalk, active: true);
      expect(labelled('학습'), findsNothing);
      expect(labelled('자유 대화'), findsOneWidget);
    });

    testWidgets('꺼진 알람은 원판이 0.4 로 흐려진다', (tester) async {
      Opacity discOpacity() => tester.widget<Opacity>(
          find.ancestor(of: disc(), matching: find.byType(Opacity)).first);
      await pumpRow(tester, mode: RowAlarmMode.freeTalk, active: true);
      expect(discOpacity().opacity, 1);
      await pumpRow(tester, mode: RowAlarmMode.freeTalk, active: false);
      expect(discOpacity().opacity, 0.4);
    });

    testWidgets('로딩 줄도 같은 자리에 40 원을 둔다', (tester) async {
      await tester.pumpWidget(host(const SkeletonShimmer(child: RowAlarmLoading())));
      final circle = tester.getRect(find.byType(Skeleton).first);
      expect(circle.size, const Size(40, 40));
    });
  });
}
