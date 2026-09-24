import 'package:beavertalk/features/weak_sound/domain/entities/sound_lesson.dart';
import 'package:beavertalk/features/weak_sound/domain/entities/sound_result.dart';
import 'package:beavertalk/features/weak_sound/presentation/weak_sound_providers.dart';
import 'package:beavertalk/l10n/app_localizations.dart';
import 'package:beavertalk/screens/weak_sound/learn_result.dart';
import 'package:beavertalk/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 발음 학습 결과 — E5(하락) · E8(첫 측정)은 반원 게이지 새 구성(09-24 사장님 「이걸로 가자」),
/// 17(오름)은 B-1 그대로.
const _lesson = SoundLesson(
  soundKey: 'rieul_coda',
  label: '받침 ㄹ',
  type: 'coda',
  cardDesc: '혀끝을 윗잇몸에 대요',
  howTo: [],
  words: [SoundWord(text: '말'), SoundWord(text: '길'), SoundWord(text: '물'), SoundWord(text: '술')],
  sentence: SoundSentence(text: '물을 마셔요.', chunks: ['마셔요.', '물을 마셔요.']),
  test: SoundSentence(text: '길이 멀어요.'),
);

SoundResult _result({int? before, required int after}) => SoundResult(
      soundKey: 'rieul_coda',
      label: '받침 ㄹ',
      after: after,
      before: before,
      delta: before == null ? null : after - before,
      bestScore: after,
      attempts: 1,
      text: '길이 멀어요.',
    );

void main() {
  const c = AppColorTokens.dark;

  Future<void> pump(WidgetTester tester, SoundResult r, {Size size = const Size(360, 780)}) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(
      overrides: [soundLessonProvider.overrideWith((ref, key) async => _lesson)],
      child: MaterialApp(
        locale: const Locale('ko'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: LearnResultScreen(soundKey: 'rieul_coda', result: r),
      ),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('E5 하락 — 게이지 58 · 「점」 Score/3 Text · 알약·막대·목표·조음 카드 없음', (tester) async {
    await pump(tester, _result(before: 70, after: 58));
    expect(tester.takeException(), isNull);
    expect(tester.widget<Text>(find.text('58')).style!.color, c.score3Text);
    expect(tester.widget<Text>(find.text('점')).style!.color, c.score3Text);
    expect(tester.widget<Text>(find.text('58')).style!.fontSize, 40);
    expect(find.text('-12'), findsNothing, reason: '변화 알약 없음');
    expect(find.text('학습 전 70점'), findsNothing, reason: '학습 전→후 막대 없음');
    expect(find.text('목표 80점'), findsNothing);
    expect(find.text('받침 ㄹ 소리'), findsNothing, reason: '조음 카드 없음');
    expect(find.text('학습을 마쳤어요'), findsOneWidget);
    expect(find.text('최종 평가'), findsOneWidget, reason: '한 일 3줄은 그대로');
  });

  testWidgets('E8 첫 측정 — 게이지 72 · Score/4 Text', (tester) async {
    await pump(tester, _result(after: 72));
    expect(tester.widget<Text>(find.text('72')).style!.color, c.score4Text);
    expect(find.text('첫 측정이에요'), findsNothing, reason: 'B-1 막대 라벨이 없다');
  });

  testWidgets('17 오름 — B-1 그대로(+14 알약 · 학습 전 막대)', (tester) async {
    await pump(tester, _result(before: 70, after: 84));
    expect(find.text('+14'), findsOneWidget);
    expect(find.text('학습 전 70점'), findsOneWidget);
    expect(find.text('목표 80점'), findsOneWidget);
  });

  testWidgets('17 오름 — 숫자 · 「점」 · 막대 채움이 점수 구간색(09-24 사장님)', (tester) async {
    await pump(tester, _result(before: 30, after: 44));
    expect(tester.widget<Text>(find.text('44')).style!.color, c.score3Text);
    expect(tester.widget<Text>(find.text('점')).style!.color, c.score3Text);
    final fill = find.byWidgetPredicate((w) =>
        w is Container &&
        w.decoration is BoxDecoration &&
        (w.decoration! as BoxDecoration).color == c.score3);
    expect(fill, findsOneWidget, reason: '막대 채움 Score/3(옛 primaryNormal 아님)');
  });

  testWidgets('E5 — 320×568 에서도 넘치지 않는다(모자라면 스크롤)', (tester) async {
    await pump(tester, _result(before: 70, after: 58), size: const Size(320, 568));
    expect(tester.takeException(), isNull);
  });
}
