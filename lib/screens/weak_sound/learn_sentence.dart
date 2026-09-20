import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/routes.dart';
import '../../features/weak_sound/domain/entities/sound_lesson.dart';
import '../../features/weak_sound/presentation/sound_key_arg.dart';
import '../../features/weak_sound/presentation/widgets/auto_practice_view.dart';
import '../../features/weak_sound/presentation/widgets/learn_scaffold.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// 3단계 · 문장 연습 — Figma `09~13 · learn/3_sentence`, 규칙은 R3.
///
/// 문장을 **끝에서부터 쌓아 올린다**(backchaining). 조각은 서버가 만들어 두었고
/// (`sentence.chunks`), 조각마다 목표 소리가 들어 있다. 마지막 조각이 문장 전체다.
///
/// 끝에서부터 쌓는 이유는 한국어의 문장 끝이 가장 어렵고 가장 자주 흐려지기 때문이다.
/// 앞에서부터 늘리면 매번 어려운 끝을 새로 만나지만, 뒤에서부터면 이미 해 본 끝에
/// 앞을 붙이는 셈이 된다.
/// 「이번 문장」 — 조각을 따라 하는 동안 **항상 보이는** 전문과 번역.
///
/// 조각은 문장의 일부라 조각만 보면 무슨 말인지 모른다. 전문을 위에 두면 지금 따라 하는
/// 조각이 어디에 붙는지도 같이 보인다.
class _SentenceHeader extends StatelessWidget {
  const _SentenceHeader({required this.sentence});

  final SoundSentence sentence;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: c.backgroundElevatedAlternative,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('이번 문장',
              style: AppType.caption1.b.copyWith(color: c.primaryForeground)),
          const SizedBox(height: AppSpacing.s4),
          Text(sentence.text,
              style: AppType.body2.b.copyWith(color: c.labelStrong)),
          if (sentence.pronunciation != null) ...[
            const SizedBox(height: AppSpacing.s2),
            Text('[${sentence.pronunciation}]',
                style: AppType.label2.b.copyWith(color: c.primaryForeground)),
          ],
          if (sentence.translationEn != null) ...[
            const SizedBox(height: AppSpacing.s2),
            Text(sentence.translationEn!,
                style: AppType.label2.r.copyWith(color: c.labelNormal)),
          ],
        ],
      ),
    );
  }
}

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
      // 주 동작을 화면 아래에 붙이기 위해 스크롤을 쓰지 않는다(learn_scaffold 참조).
      scrollable: false,
      builder: (context, lesson) {
        // 조각이 없으면 문장 하나를 통째로 연습한다 — 빈 화면을 보이지 않는다.
        final chunks = lesson.sentence.chunks.isEmpty
            ? [lesson.sentence.text]
            : lesson.sentence.chunks;
        return AutoPracticeView(
          items: chunks,
          // 발음 표기·번역은 **문장 전체 기준**이라 조각에 붙이지 않는다.
          // 둘 다 위 머리말(_SentenceHeader)로 올렸다.
          pronunciations: const [],
          captions: const [],
          header: _SentenceHeader(sentence: lesson.sentence),
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
