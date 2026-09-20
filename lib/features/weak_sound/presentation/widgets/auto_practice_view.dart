import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../components/atoms/button.dart';
import '../../../review/presentation/review_providers.dart';
import '../../../../theme/app_color_tokens.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../domain/auto_practice.dart';
import '../auto_practice_controller.dart';

/// 단어·문장 단계의 공통 본문 — 자동 재생/따라 말하기를 그린다.
///
/// 마이크도 점수도 없다. 사용자는 화면만 보고 입으로 따라 한다.
/// 두 단계가 같은 위젯을 쓰는 이유는 **동작이 같기 때문**이다 — 다른 것은 항목이
/// 단어냐 문장 조각이냐뿐이다.
class AutoPracticeView extends ConsumerStatefulWidget {
  const AutoPracticeView({
    super.key,
    required this.items,
    required this.pronunciations,
    required this.captions,
    required this.onDone,
    this.header,
    this.doneLabel = '다음',
  });

  /// 읽어 줄 텍스트들(단어 4개, 또는 문장 조각들).
  final List<String> items;

  /// 항목별 `[발음]` 줄 — 규칙 항목에만 있다. 없으면 빈 리스트.
  final List<String?> pronunciations;

  /// 항목별 보조 설명(뜻·번역). 없으면 빈 리스트.
  final List<String?> captions;

  /// 항목 위에 **항상** 띄울 머리말. 문장 단계가 「이번 문장」 전문과 번역을 여기 둔다.
  ///
  /// 조각에는 조각별 번역이 없다(소스에 문장 하나의 번역뿐). 조각마다 문장 전체 번역을
  /// 붙이면 「주스를 조금 줘」에 «저녁에» 가 든 번역이 달려 **틀린 정보**가 되고, 마지막
  /// 조각에만 붙이면 번역이 있다 없다 한다(2026-09-21 사용자 지적). 그래서 번역은 조각이
  /// 아니라 **문장에 붙인다** — 위에 고정해 두고 아래에서 조각을 따라 한다.
  final Widget? header;

  /// 전부 끝났을 때 누를 버튼의 동작.
  final VoidCallback onDone;

  final String doneLabel;

  @override
  ConsumerState<AutoPracticeView> createState() => _AutoPracticeViewState();
}

class _AutoPracticeViewState extends ConsumerState<AutoPracticeView>
    with WidgetsBindingObserver {
  late final AutoPracticeController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = AutoPracticeController(
      items: widget.items,
      repository: ref.read(reviewRepositoryProvider),
      cache: ref.read(speechCacheProvider),
    )..addListener(_onChange);
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.start());
  }

  void _onChange() => setState(() {});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 앱이 뒤로 가면 멈춘다. 안 멈추면 주머니 속에서 단어가 혼자 넘어가 있다.
    if (state == AppLifecycleState.resumed) {
      _controller.resume();
    } else {
      _controller.pause();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.removeListener(_onChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final s = _controller.state;
    final i = s.index;
    final done = s.phase == AutoPracticePhase.done;
    // 주 동작은 **화면 아래**에 붙인다. 가운데 떠 있으면 다음으로 갈 수 있는지
    // 한눈에 안 보이고, 아래 절반이 통째로 빈다(실기기 확인 2026-09-21).
    // 그래서 이 위젯은 남은 높이를 다 받고 Spacer 로 아래를 민다
    // (LearnScaffold 는 scrollable: false 로 부른다).
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.header != null) ...[
          widget.header!,
          const SizedBox(height: AppSpacing.s16),
        ],
        _Counter(state: s),
        const SizedBox(height: AppSpacing.s20),
        _Card(
          text: _controller.currentItem,
          pronunciation: _at(widget.pronunciations, i),
          caption: _at(widget.captions, i),
          phase: s.phase,
        ),
        const SizedBox(height: AppSpacing.s20),
        _Hint(phase: s.phase, muted: _controller.muted),
        const Spacer(),
        // 「점수 없음」을 화면에 적어 둔다. 사용자가 점수를 기다리며 서 있지 않게.
        Text(
          '이 단계는 점수가 없어요. 편하게 따라 말해 보세요.',
          textAlign: TextAlign.center,
          style: AppType.label2.r.copyWith(color: c.labelAssistive),
        ),
        const SizedBox(height: AppSpacing.s12),
        // 끝나기 전에도 자리를 지킨다 — 버튼이 불쑥 생기면 그 순간 레이아웃이 튄다.
        Opacity(
          opacity: done ? 1 : 0,
          child: IgnorePointer(
            ignoring: !done,
            child: Button(
              type: BtnType.primaryFill,
              size: BtnSize.s60,
              text: widget.doneLabel,
              onPressed: widget.onDone,
            ),
          ),
        ),
      ],
    );
  }

  static String? _at(List<String?> list, int i) =>
      i >= 0 && i < list.length ? list[i] : null;
}

/// 「2 / 4」.
class _Counter extends StatelessWidget {
  const _Counter({required this.state});

  final AutoPracticeState state;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${state.displayIndex}',
          style: AppType.label1.b.copyWith(color: c.primaryForeground),
        ),
        Text(
          ' / ${state.total}',
          style: AppType.label1.m.copyWith(color: c.labelAssistive),
        ),
      ],
    );
  }
}

/// 지금 항목을 크게 보여주는 카드.
class _Card extends StatelessWidget {
  const _Card({
    required this.text,
    required this.pronunciation,
    required this.caption,
    required this.phase,
  });

  final String text;
  final String? pronunciation;
  final String? caption;
  final AutoPracticePhase phase;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final speaking = phase == AutoPracticePhase.playing;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s20,
        vertical: AppSpacing.s28,
      ),
      decoration: BoxDecoration(
        color: c.backgroundNormalNormal,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          // 재생 중에만 테두리가 켜진다 — 「지금 듣는 시간」이라는 유일한 신호다.
          color: speaking ? c.primaryNormal : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: AppType.title3.b.copyWith(color: c.labelStrong),
          ),
          if (pronunciation != null && pronunciation!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s8),
            Text(
              '[$pronunciation]',
              textAlign: TextAlign.center,
              style: AppType.body1.b.copyWith(color: c.primaryForeground),
            ),
          ],
          if (caption != null && caption!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s8),
            Text(
              caption!,
              textAlign: TextAlign.center,
              style: AppType.body2.r.copyWith(color: c.labelNormal),
            ),
          ],
        ],
      ),
    );
  }
}

/// 지금 무엇을 해야 하는지 한 줄.
class _Hint extends StatelessWidget {
  const _Hint({required this.phase, required this.muted});

  final AutoPracticePhase phase;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final (text, strong) = switch (phase) {
      AutoPracticePhase.playing => ('잘 들어 보세요', false),
      AutoPracticePhase.repeating => ('지금 따라 말해 보세요', true),
      AutoPracticePhase.done => ('연습을 마쳤어요', false),
      AutoPracticePhase.idle => ('잠시 멈췄어요', false),
    };
    return Column(
      children: [
        Text(
          text,
          textAlign: TextAlign.center,
          style: AppType.headline2.b.copyWith(
            color: strong ? c.primaryForeground : c.labelNormal,
          ),
        ),
        if (muted) ...[
          const SizedBox(height: AppSpacing.s8),
          Text(
            '소리를 불러오지 못했어요. 글자를 보고 따라 말해 보세요.',
            textAlign: TextAlign.center,
            style: AppType.label2.r.copyWith(color: c.statusCautionary),
          ),
        ],
      ],
    );
  }
}
