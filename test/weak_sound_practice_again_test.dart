import 'dart:typed_data';

import 'package:beavertalk/components/atoms/button.dart';
import 'package:beavertalk/features/review/domain/repositories/review_repository.dart';
import 'package:beavertalk/features/review/presentation/review_providers.dart';
import 'package:beavertalk/features/weak_sound/domain/entities/sound_lesson.dart';
import 'package:beavertalk/features/weak_sound/presentation/weak_sound_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/weak_sound/learn_sentence.dart';
import 'package:beavertalk/screens/weak_sound/learn_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 발음 학습 08 · 13 끝 화면 — Figma 「한 번 더 하기」(secondary_elevated) 위 · 주 버튼 아래(09-24
/// 사장님 「Figma 대로 해」). 누르면 같은 연습을 첫 항목부터 다시 한다.
class _SilentRepo implements ReviewRepository {
  @override
  Future<Uint8List?> speech(String text, {String? engine}) async => null;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

const _lesson = SoundLesson(
  soundKey: 'eo',
  label: 'ㅓ',
  type: 'vowel',
  cardDesc: '',
  howTo: [],
  words: [
    SoundWord(text: '어머니'),
    SoundWord(text: '거기'),
    SoundWord(text: '서울'),
    SoundWord(text: '너무'),
  ],
  sentence: SoundSentence(text: '어머니가 서울에 가요.', chunks: ['가요.', '서울에 가요.', '어머니가 서울에 가요.']),
  test: SoundSentence(text: '거기 너무 멀어요.'),
);

void main() {
  Future<void> pump(WidgetTester tester, Widget screen, {String locale = 'ko'}) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(
      overrides: [
        soundLessonProvider.overrideWith((ref, key) async => _lesson),
        reviewRepositoryProvider.overrideWithValue(_SilentRepo()),
      ],
      child: MaterialApp(
        locale: Locale(locale),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: screen,
      ),
    ));
    await tester.pump();
  }

  /// 소리 없이(합성 실패) 글자 수 어림으로 진행한다 — 끝날 때까지 시간을 민다.
  Future<void> runToEnd(WidgetTester tester) async {
    for (var i = 0; i < 60; i++) {
      await tester.pump(const Duration(seconds: 1));
    }
  }

  Finder button(String text) => find.widgetWithText(Button, text);

  testWidgets('08 단어 — 끝나면 「한 번 더 하기」 위 · 「문장 연습하기」 아래', (tester) async {
    await pump(tester, const LearnWordsScreen(soundKey: 'eo'));
    await runToEnd(tester);
    expect(tester.takeException(), isNull, reason: '320×640 에서 넘치지 않는다');
    final again = tester.getRect(button('한 번 더 하기'));
    final next = tester.getRect(button('문장 연습하기'));
    expect(again.bottom, lessThanOrEqualTo(next.top));
    expect(next.top - again.bottom, 12);
    expect(tester.widget<Button>(button('한 번 더 하기')).type, BtnType.secondaryElevated);
    expect(tester.widget<Button>(button('문장 연습하기')).type, BtnType.primaryFill);
  });

  testWidgets('「한 번 더 하기」는 첫 단어부터 다시 — 버튼은 다시 끝날 때까지 누를 수 없다', (tester) async {
    await pump(tester, const LearnWordsScreen(soundKey: 'eo'));
    await runToEnd(tester);
    expect(find.text('너무'), findsOneWidget, reason: '끝 = 마지막 단어');
    await tester.tap(button('한 번 더 하기'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('어머니'), findsOneWidget, reason: '첫 단어로 돌아갔다');
    expect(find.text('1'), findsOneWidget, reason: '「1 / 4」');
    final ignoring = tester.widget<IgnorePointer>(find.ancestor(
        of: button('한 번 더 하기'), matching: find.byType(IgnorePointer)).first);
    expect(ignoring.ignoring, isTrue, reason: '진행 중에는 숨겨 둔 자리만 지킨다');
    await runToEnd(tester);
  });

  testWidgets('13 문장 — 「한 번 더 하기」 위 · 「최종 평가 하기」 아래 · de 도 넘치지 않는다', (tester) async {
    for (final loc in ['ko', 'de']) {
      await pump(tester, const LearnSentenceScreen(soundKey: 'eo'), locale: loc);
      await runToEnd(tester);
      expect(tester.takeException(), isNull, reason: '$loc 320×640');
    }
    await pump(tester, const LearnSentenceScreen(soundKey: 'eo'));
    await runToEnd(tester);
    expect(button('최종 평가 하기'), findsOneWidget);
    expect(tester.getRect(button('한 번 더 하기')).top,
        lessThan(tester.getRect(button('최종 평가 하기')).top));
  });
}
