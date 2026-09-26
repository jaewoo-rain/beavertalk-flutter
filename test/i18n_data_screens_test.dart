import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/i18n_data_screens.dart';

/// 데이터판 등록이 **정말 데이터를 그리는지** — 로딩 · 오류로 조용히 떨어지면 레이아웃 게이트가
/// 다시 빈 화면만 보게 된다(09-24 「음소 단위 · N회 시도」 가 그렇게 빠져나갔다).
///
/// 화면마다 가짜 데이터에서만 나오는 글자 하나를 찾는다. 새 데이터판을 등록하면 여기에도 적는다.
void main() {
  const markers = <String, String>{
    'WeakSoundsData': 'Start with 받침 ㄹ',
    // 요약에서 방식 글자를 뺐다(09-26 시안 C — 방식은 줄 앞 원판).
    'AlarmListData': 'Mon · Wed · Fri',
    'AlarmAddData': 'Add alarm',
    'AlarmEditData': 'Edit alarm',
    'CallFinishData': 'Call ended 12:37',
    'MyPageLevel': 'United Kingdom of Great Britain',
    'MyPageNoLevel': 'United Kingdom of Great Britain',
    'MyPageSettingsPremium': 'bt.qa.international.student.0924@example-university.ac.kr',
    'MyPageSettingsFree': 'bt.qa.international.student.0924@example-university.ac.kr',
    'EditNicknameData': '20/12',
    'OnboardingReasonSelected': 'Why are you learning a language?',
    'RecordListData': 'Ordering food at a restaurant',
    'HwJoinConsentChecked': 'What your teacher sees',
    'HwJoinDoneData': 'Maximilian-Alexander',
    'HwAssignmentListData': 'Not submitted, 2d late',
  };

  test('데이터판마다 표식이 있다', () {
    expect(i18nDataScreens().keys.toSet(), markers.keys.toSet());
  });

  for (final e in i18nDataScreens().entries) {
    testWidgets('${e.key} — 데이터가 찬 상태로 그려진다', (tester) async {
      tester.view.physicalSize = const Size(360, 780);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(ProviderScope(
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: e.value(),
        ),
      ));
      // 게이트와 같은 한 번 — 32ms 안에 데이터가 들어와야 게이트도 본다.
      await tester.pump(const Duration(milliseconds: 32));
      tester.takeException();
      expect(find.textContaining(markers[e.key]!, findRichText: true), findsWidgets);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}
