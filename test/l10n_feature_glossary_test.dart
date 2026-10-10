import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// 기능명 용어집 앱 적용분(PM-DEC-082 · 083 · 09-27 · 43 하네스 기능명 용어집 제안서).
///
/// AI 작성 제안 기준이다 — 원어민 검수 전. 뜻이 바뀐 번역이 다시 들어오지 않게만 잠근다.
void main() {
  Future<AppLocalizations> l(Locale locale) =>
      AppLocalizations.delegate.load(locale);

  test('숙제 활동 「발음」 — 30개 언어 모두 그 언어의 「발음」 과 같은 단어(말하기 아님)', () async {
    // 이 활동은 출제 문장을 따라 읽고 발음을 채점한다(B2B enrollment · assess_pronunciation).
    // 29개 언어가 「Speaking」 류로 옮겨져 자유 말하기처럼 읽혔다.
    for (final locale in AppLocalizations.supportedLocales) {
      final t = await l(locale);
      expect(t.hwActivitySpeaking, t.pronunciation, reason: locale.toLanguageTag());
    }
  });

  test('발음 교정 표기 — ja 「添削」(글 첨삭) 금지 · fil 「koreksyon」 대신 승인어 「Pagtatama」', () async {
    expect((await l(const Locale('ja'))).bulletProCorrections, isNot(contains('添削')));
    expect((await l(const Locale('fil'))).bulletProCorrections, startsWith('Pagtatama'));
  });

  test('표현 학습 홈 라벨 · 억양 분석 표기', () async {
    expect((await l(const Locale('en'))).homeCourseExpression, 'Expressions');
    expect((await l(const Locale('ko'))).homeCourseExpression, '표현 학습');
    expect((await l(const Locale('fil'))).accentAnalysis, isNot(contains('punto')));
  });
}
