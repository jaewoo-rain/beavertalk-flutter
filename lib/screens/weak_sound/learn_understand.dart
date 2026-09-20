import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../features/pronunciation/domain/phoneme_diagram.dart';
import '../../features/weak_sound/domain/entities/sound_lesson.dart';
import '../../features/weak_sound/presentation/sound_key_arg.dart';
import '../../features/weak_sound/presentation/widgets/learn_scaffold.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// 1단계 · 소리 이해 — Figma `03 · learn/1_understand` (`6024:9569`), 규칙은 R1.
///
/// 소리 항목은 **조음 도해**를, 규칙 항목은 **「글자 → 소리」 변환 도식**을 보여준다.
/// 둘 다 보여줄 것이 없으면 그 칸을 통째로 뺀다 — 빈 상자를 남기지 않는다.
class LearnUnderstandScreen extends ConsumerWidget {
  const LearnUnderstandScreen({super.key, this.soundKey});

  /// 생성자 주입(테스트·갤러리). 비면 라우트 인자에서 읽는다.
  final String? soundKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = resolveSoundKey(context, soundKey);
    if (key == null) return const MissingSoundKey();
    return LearnScaffold(
      soundKey: key,
      step: 1,
      builder: (context, lesson) => _Body(lesson: lesson),
      footer: (context, lesson) => Button(
        type: BtnType.primaryFill,
        size: BtnSize.s60,
        text: '단어 연습하기',
        onPressed: () => Navigator.of(context).pushNamed(
          Routes.weakSoundWords,
          arguments: key,
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.lesson});

  final SoundLesson lesson;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Hero(lesson: lesson),
        const SizedBox(height: AppSpacing.s24),
        if (lesson.isRule)
          _RuleFormula(lesson: lesson)
        else
          _Diagram(lesson: lesson),
        const SizedBox(height: AppSpacing.s24),
        Text('소리 내는 법',
            style: AppType.headline2.b.copyWith(color: c.labelStrong)),
        const SizedBox(height: 10),
        for (var i = 0; i < lesson.howTo.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.s8),
          _HowRow(index: i + 1, text: lesson.howTo[i]),
        ],
      ],
    );
  }
}

/// 큰 타일 + 이름 + 한 줄 설명.
class _Hero extends StatelessWidget {
  const _Hero({required this.lesson});

  final SoundLesson lesson;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final glyph = lesson.isRule
        ? (lesson.symbol ?? lesson.label)
        : (lesson.repSyllable ?? lesson.jamoTarget?.jamo ?? '');
    return Row(
      children: [
        Container(
          width: 72,
          height: 72,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: c.primaryNormal10,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Text(
            glyph,
            style: (lesson.isRule ? AppType.headline1 : AppType.title1)
                .b
                .copyWith(color: c.primaryForeground),
          ),
        ),
        const SizedBox(width: AppSpacing.s16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(lesson.label,
                  style: AppType.heading2.b.copyWith(color: c.labelStrong)),
              const SizedBox(height: AppSpacing.s4),
              Text(lesson.cardDesc,
                  style: AppType.body2.r.copyWith(color: c.labelNormal)),
            ],
          ),
        ),
      ],
    );
  }
}

/// 조음 도해 카드 — 소리 항목 전용.
///
/// 도해 자산은 **앱이 직접 고른다**(`diagramForJamo`). 서버가 주는 `diagram` 문자열을
/// 쓰지 않는 이유는 자산 이름을 레포 둘에 걸쳐 맞추는 결합을 만들지 않기 위해서다.
/// 세트에 없는 자모면 카드를 통째로 생략한다.
class _Diagram extends StatelessWidget {
  const _Diagram({required this.lesson});

  final SoundLesson lesson;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final target = lesson.jamoTarget;
    if (target == null) return const SizedBox.shrink();
    final diagram = diagramForJamo(target.jamo, isCoda: target.isCoda);
    if (diagram == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: c.backgroundNormalNormal,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          // 도해는 그림 자체가 다크 카드라 라운드만 준다(조음 시트와 같은 규칙).
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.s12),
            child: Image.asset(diagram.asset, width: 200, fit: BoxFit.contain),
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            '목표 · ${lesson.cardDesc}',
            textAlign: TextAlign.center,
            style: AppType.label1.b.copyWith(color: c.primaryForeground),
          ),
        ],
      ),
    );
  }
}

/// 「글자 → 소리」 변환 도식 — 규칙 항목 전용(Figma R1).
///
/// 규칙은 혀 모양으로 설명되지 않는다. 한국어가 **글자와 소리가 어긋나는 자리**를
/// 보여주는 것이 설명이다.
class _RuleFormula extends StatelessWidget {
  const _RuleFormula({required this.lesson});

  final SoundLesson lesson;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    if (lesson.formula.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s20),
      decoration: BoxDecoration(
        color: c.backgroundNormalNormal,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          for (var i = 0; i < lesson.formula.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.s16),
            _FormulaRow(row: lesson.formula[i]),
          ],
        ],
      ),
    );
  }
}

class _FormulaRow extends StatelessWidget {
  const _FormulaRow({required this.row});

  final SoundFormula row;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            row.spelling,
            textAlign: TextAlign.end,
            style: AppType.heading2.b.copyWith(color: c.labelStrong),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
          child: Icon(Icons.arrow_forward, size: 20, color: c.labelAssistive),
        ),
        Flexible(
          child: Text(
            '[${row.pronunciation}]',
            style: AppType.heading2.b.copyWith(color: c.primaryForeground),
          ),
        ),
      ],
    );
  }
}

/// 번호 붙은 설명 한 줄.
class _HowRow extends StatelessWidget {
  const _HowRow({required this.index, required this.text});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: c.primaryNormal10,
            shape: BoxShape.circle,
          ),
          child: Text('$index',
              style: AppType.caption2.b.copyWith(color: c.primaryForeground)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text,
              style: AppType.body2.r.copyWith(color: c.labelNormal)),
        ),
      ],
    );
  }
}
