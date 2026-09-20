import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/routes.dart';
import '../../features/weak_sound/presentation/sound_key_arg.dart';
import '../../features/weak_sound/presentation/widgets/auto_practice_view.dart';
import '../../features/weak_sound/presentation/widgets/learn_scaffold.dart';

/// 2단계 · 단어 연습 — Figma `04~08 · learn/2_words`, 규칙은 R2.
///
/// 단어 4개를 자동으로 재생하고 따라 말할 틈을 준다. **마이크도 점수도 없다.**
/// 푸터 버튼을 두지 않는다 — 끝나면 본문 안에서 「문장 연습하기」가 나타난다. 끝나지도
/// 않았는데 아래에 다음 버튼이 떠 있으면 건너뛰라는 신호로 읽힌다.
class LearnWordsScreen extends ConsumerWidget {
  const LearnWordsScreen({super.key, this.soundKey});

  final String? soundKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = resolveSoundKey(context, soundKey);
    if (key == null) return const MissingSoundKey();
    return LearnScaffold(
      soundKey: key,
      step: 2,
      // 주 동작을 화면 아래에 붙이기 위해 스크롤을 쓰지 않는다(learn_scaffold 참조).
      scrollable: false,
      builder: (context, lesson) => AutoPracticeView(
        items: [for (final w in lesson.words) w.text],
        pronunciations: [for (final w in lesson.words) w.pronunciation],
        captions: [for (final w in lesson.words) w.meaningEn],
        doneLabel: '문장 연습하기',
        onDone: () => Navigator.of(context).pushNamed(
          Routes.weakSoundSentence,
          arguments: key,
        ),
      ),
    );
  }
}
