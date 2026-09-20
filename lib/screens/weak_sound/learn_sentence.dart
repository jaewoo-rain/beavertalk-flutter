import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/routes.dart';
import '../../features/weak_sound/presentation/sound_key_arg.dart';
import '../../features/weak_sound/presentation/widgets/auto_practice_view.dart';
import '../../features/weak_sound/presentation/widgets/learn_scaffold.dart';

/// 3단계 · 문장 연습 — Figma `09~13 · learn/3_sentence`, 규칙은 R3.
///
/// 문장을 **끝에서부터 쌓아 올린다**(backchaining). 조각은 서버가 만들어 두었고
/// (`sentence.chunks`), 조각마다 목표 소리가 들어 있다. 마지막 조각이 문장 전체다.
///
/// 끝에서부터 쌓는 이유는 한국어의 문장 끝이 가장 어렵고 가장 자주 흐려지기 때문이다.
/// 앞에서부터 늘리면 매번 어려운 끝을 새로 만나지만, 뒤에서부터면 이미 해 본 끝에
/// 앞을 붙이는 셈이 된다.
class LearnSentenceScreen extends ConsumerWidget {
  const LearnSentenceScreen({super.key, this.soundKey});

  final String? soundKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = resolveSoundKey(context, soundKey);
    if (key == null) return const MissingSoundKey();
    return LearnScaffold(
      soundKey: key,
      step: 3,
      builder: (context, lesson) {
        // 조각이 없으면 문장 하나를 통째로 연습한다 — 빈 화면을 보이지 않는다.
        final chunks = lesson.sentence.chunks.isEmpty
            ? [lesson.sentence.text]
            : lesson.sentence.chunks;
        return AutoPracticeView(
          items: chunks,
          pronunciations: [
            // 발음 표기는 문장 전체 기준이라 **마지막 조각에만** 붙인다. 부분 조각에
            // 전체 발음을 달면 글자와 소리가 어긋나 보인다.
            for (var i = 0; i < chunks.length; i++)
              i == chunks.length - 1 ? lesson.sentence.pronunciation : null,
          ],
          captions: [
            for (var i = 0; i < chunks.length; i++)
              i == chunks.length - 1 ? lesson.sentence.translationEn : null,
          ],
          doneLabel: '평가 시작하기',
          onDone: () => Navigator.of(context).pushNamed(
            Routes.weakSoundTest,
            arguments: key,
          ),
        );
      },
    );
  }
}
