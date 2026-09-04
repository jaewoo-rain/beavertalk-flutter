import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/button.dart';
import '../../components/icons/app_icons.dart';
import '../../components/molecules/card_task.dart';
import '../../components/molecules/pronunciation_result.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/classroom/domain/entities/classroom_assignment.dart';
import '../../features/classroom/presentation/assignment_attempt_provider.dart';
import '../../features/classroom/presentation/classroom_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../home/learning_args.dart';
import 'widgets/assignment_badge.dart';

/// A7 숙제 상세 — Figma `screen/hw_detail`(`5685:6129`).
///
/// 과제가 요구하는 활동을 카드로 늘어놓는다. 순서는 서버가 준 `activities` 순서
/// 그대로다 — 앱이 다시 정렬하면 선생님이 낸 순서와 어긋난다.
///
/// 발음은 문장 목록을 받아 `/learning/intro` 를 **과제 모드**로 연다. 끝나면
/// 그 화면이 문장 수를 제출하고 여기로 돌아온다.
class AssignmentDetailScreen extends ConsumerStatefulWidget {
  /// 화면을 만든다.
  const AssignmentDetailScreen({super.key, this.assignment});

  /// 목록이 넘긴 과제. null 이면 라우트 인자에서 읽는다.
  final ClassroomAssignment? assignment;

  @override
  ConsumerState<AssignmentDetailScreen> createState() =>
      _AssignmentDetailScreenState();
}

class _AssignmentDetailScreenState
    extends ConsumerState<AssignmentDetailScreen> {
  ClassroomAssignment? _assignment;

  /// 문장 목록을 받아오는 중이면 true — 두 번 누르는 것을 막는다.
  bool _loadingItems = false;

  /// 이 화면에서 워크북을 열었나. 서버 응답을 다시 받기 전까지 카드를 완료로
  /// 그리기 위한 값이다 — 목록으로 돌아가면 서버 값(`workbookOpenedAt`)이 이긴다.
  bool _workbookOpenedHere = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_assignment != null) return;
    final injected =
        widget.assignment ?? ModalRoute.of(context)?.settings.arguments;
    if (injected is ClassroomAssignment) {
      _assignment = injected;
      unawaited(_restoreAttempt(injected));
    }
  }

  /// 화면에 들어오자마자 서버 채점을 되살린다.
  ///
  /// 🔴 발음 카드의 게이지·발음/유창성/리듬은 **메모리의 집계**에서 나온다. 앱을
  ///    껐다 켜면 그 집계가 비어, 「38문장 중 37문장 통과 · 완료」 옆에서 `-%` 와
  ///    「아직 발음을 하지 않았어요」가 같이 뜬다(2026-09-04 실기기 실측).
  ///    되살리기는 지금까지 **버튼을 눌렀을 때만** 돌았다.
  ///
  /// ⛔ 서버가 채점을 하나도 안 가졌으면 부르지 않는다 — 아직 아무것도 안 한
  ///    학습자에게까지 네트워크를 태울 이유가 없다.
  /// 실패는 조용히 넘긴다. 되살리기는 화면의 **덤**이고, 버튼을 누르면 어차피
  /// 같은 호출이 다시 돈다.
  Future<void> _restoreAttempt(ClassroomAssignment a) async {
    if (a.speakingScored <= 0) return;
    if (ref.read(assignmentAttemptProvider.notifier).of(a.assignmentId) !=
        null) {
      return;
    }
    final locale = Localizations.localeOf(context).languageCode;
    try {
      final bundle = await ref
          .read(classroomRepositoryProvider)
          .assignmentItems(a.assignmentId, locale: locale);
      if (!mounted) return;
      ref
          .read(assignmentAttemptProvider.notifier)
          .restore(assignmentId: a.assignmentId, items: bundle.items);
    } catch (_) {
      // 조용히 넘긴다 — 카드가 예전처럼 `-` 를 그릴 뿐이다.
      //
      // 🔴 `on AppException` 으로 좁히지 마라. 이 호출은 **화면이 뜨자마자** 나가서
      //    사용자가 시킨 적이 없는데, 좁히면 dio·env 초기화 실패 같은 다른 예외가
      //    화면 밖으로 새어 나간다(위젯 검사 하네스가 그 경로에서 통째로 죽었다).
      //    되살리기는 덤이고, 실패해도 버튼을 누르면 같은 호출이 다시 돈다.
    }
  }

  /// 다 읽은 과제의 결과를 연다.
  ///
  /// 서버에서 문장 묶음을 다시 받아 진행을 되살린 **뒤에** 연다. 앱을 껐다 켜면
  /// 메모리의 집계가 비어 있어, 안 되살리면 결과 화면이 「-%」만 그린다.
  Future<void> _showSpeakingResult(ClassroomAssignment a) async {
    if (_loadingItems) return;
    setState(() => _loadingItems = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    try {
      final bundle = await ref
          .read(classroomRepositoryProvider)
          .assignmentItems(a.assignmentId, locale: locale);
      if (!mounted) return;
      setState(() => _loadingItems = false);
      ref
          .read(assignmentAttemptProvider.notifier)
          .restore(assignmentId: a.assignmentId, items: bundle.items);
      await navigator.pushNamed(
        Routes.learningCallMain,
        arguments: LearningArgs(
          sentences: const [],
          origin: LearningOrigin.assignment,
          assignmentId: a.assignmentId,
        ),
      );
    } on AppException catch (e) {
      if (!mounted) return;
      setState(() => _loadingItems = false);
      messenger
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(content: Text(e.fromServer ? e.message : l10n.hwJoinFailed)),
        );
    }
  }

  /// 발음 과제 시작 — 문장을 받아 학습 화면을 과제 모드로 연다.
  Future<void> _startSpeaking(ClassroomAssignment a) async {
    if (_loadingItems) return;
    setState(() => _loadingItems = true);
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    try {
      final bundle = await ref
          .read(classroomRepositoryProvider)
          .assignmentItems(a.assignmentId, locale: locale);
      if (!mounted) return;
      setState(() => _loadingItems = false);

      if (bundle.items.isEmpty) {
        messenger
          ..clearSnackBars()
          ..showSnackBar(SnackBar(content: Text(l10n.hwSpeakingUnavailable)));
        return;
      }

      // 서버에 남은 채점으로 진행 상황을 되살린다. 중간에 나갔던 학습자는
      // 여기서 이미 읽은 문장의 결과를 되찾는다.
      ref
          .read(assignmentAttemptProvider.notifier)
          .restore(assignmentId: a.assignmentId, items: bundle.items);

      // 이어서 읽을 자리 = **아직 채점 안 된 첫 문장.** 점수만 되살리고 커서를
      // 1번에 두면 학습자는 읽은 문장을 처음부터 다시 읽게 된다. 다 읽었으면
      // 0 번으로 — 복습은 처음부터 도는 편이 자연스럽다.
      final int resumeAt = bundle.items.indexWhere((i) => i.score == null);

      await navigator.pushNamed(
        Routes.learningIntro,
        arguments: LearningArgs(
          // 학습 화면은 `MockSentence` 로 말한다. 과제 문장의 id 는 **학습 항목
          // id** 다 — 문장 id 가 아니다. 그래서 북마크가 꺼진다(origin 주석).
          sentences: [
            for (final item in bundle.items)
              MockSentence(
                id: item.itemId,
                korean: item.readable,
                // 🔴 `meaning` 이 아니다. 그건 **표제어** 뜻이라 예문 밑에 쓰면
                //    「그 사람은 선생님이 아닙니다」 밑에 `person` 이 뜬다.
                native: item.readableMeaning ?? '',
                charScores: const [],
                // 아직 채점 전이라 점수가 없다. 0 은 「0점」이 아니라 미채점이며,
                // 화면은 녹음 단계에서 이 값을 그리지 않는다.
                overall: 0,
                pronunciation: 0,
                fluency: 0,
                rhythm: 0,
              ),
          ],
          index: resumeAt < 0 ? 0 : resumeAt,
          origin: LearningOrigin.assignment,
          assignmentId: a.assignmentId,
        ),
      );
      if (!mounted) return;
      setState(() {});
    } on AppException catch (e) {
      if (!mounted) return;
      setState(() => _loadingItems = false);
      messenger
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              e.fromServer ? e.message : l10n.hwSpeakingUnavailable,
            ),
          ),
        );
    }
  }

  /// 워크북 열기 — 앱 밖 브라우저로 넘긴다.
  Future<void> _openWorkbook(int assignmentId, String url) async {
    final uri = Uri.tryParse(url);
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    if (uri == null) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.hwWorkbookUnavailable)),
      );
      return;
    }
    // 앱 안에서 PDF 를 그리지 않는다 — 뷰어를 들이면 30 로케일 폰트가 따라온다.
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened || !mounted) return;

    // ⭐ 여는 데 성공했을 때만 수행으로 남긴다(2026-09-04 사용자 지시).
    //    ⚠ 「열었다」이지 「풀었다」가 아니다 — 그 뒤는 Google Drive 의 몫이라 모른다.
    //    🔴 실패해도 화면은 완료로 둔다. 학습자는 이미 열었고, 다시 누르게 하는 것보다
    //       교사 쪽 숫자가 늦는 편이 낫다(발음 제출과 같은 방침).
    setState(() => _workbookOpenedHere = true);
    try {
      await ref.read(classroomRepositoryProvider).openWorkbook(assignmentId);
      ref.invalidate(myAssignmentsProvider);
    } on AppException {
      // 조용히 넘긴다 — 다음에 다시 누르면 그때 남는다.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    final a = _assignment;
    if (a == null) {
      return AppScaffold(
        background: c.backgroundNormalNormal,
        body: const SizedBox.shrink(),
      );
    }

    return AppScaffold(
      background: c.backgroundNormalNormal,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gnb.main(
            title: l10n.hwChapterLabel(a.chapter.toString().padLeft(2, '0')),
            onBack: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s20,
                AppSpacing.s8,
                AppSpacing.s20,
                AppSpacing.s24,
              ),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        a.classroomName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppType.label1.r.copyWith(color: c.labelNeutral),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s8),
                    assignmentBadge(context, a),
                  ],
                ),
                if (a.isClosed) ...[
                  const SizedBox(height: AppSpacing.s12),
                  Text(
                    l10n.hwDetailClosed,
                    style: AppType.caption1.r.copyWith(
                      color: c.accentForegroundRed,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.s16),
                for (final act in a.activities)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                    child: _taskCard(context, a, act),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 지표 한 칸 — 채점 전이면 `-`. 0 을 쓰면 「0점」으로 읽힌다.
  static String _pct(int? value) => value == null ? '-' : '$value%';

  Widget _taskCard(
    BuildContext context,
    ClassroomAssignment a,
    AssignmentActivity act,
  ) {
    final l10n = AppLocalizations.of(context);
    final attempt = ref.watch(assignmentAttemptProvider)[a.assignmentId];
    final bool done =
        activityDone(a, act) ||
        (act == AssignmentActivity.workbook && _workbookOpenedHere);
    final Widget? badge = done ? assignmentBadgeDone(context) : null;

    switch (act) {
      case AssignmentActivity.speaking:
        // 평균은 이번에 연 시도에만 있다. 목록 응답은 문장 수만 주기 때문이다 —
        // 없는 점수를 지어내지 않고 게이지를 비활성으로 둔다.
        final int? average = attempt?.averageScore;
        // 진행 문장 수는 **서버 값도 쓴다.** 서버가 채점할 때마다 집계를
        // 갱신하므로(2026-09-04~), 앱을 다시 켜도 「3 / 38」이 남는다.
        final int? shownPassed = attempt?.passed ?? a.speakingPassed;
        final int? shownTotal = attempt?.total ?? a.speakingTotal;
        return CardTask(
          icon: AppIcons.soundWave,
          title: l10n.hwActivitySpeaking,
          badge: badge,
          description: (shownPassed == null || shownTotal == null)
              ? l10n.hwTaskSpeakingDesc
              : l10n.hwSpeakingProgress(shownPassed, shownTotal),
          result: PronunciationResult(
            score: (average ?? 0).toDouble(),
            state: average == null
                ? PronunciationState.inactive
                : PronunciationState.active,
            hint: average == null ? l10n.hwSpeakingNoScore : null,
            // 시안의 세 칸은 발음·유창성·리듬이다. 과제 맥락이라고 다른 축을
            // 끼워 넣으면 같은 컴포넌트가 화면마다 다른 뜻이 된다.
            metrics: [
              PronunciationMetric(
                label: l10n.pronunciation,
                value: _pct(attempt?.averagePronunciation),
              ),
              PronunciationMetric(
                label: l10n.fluency,
                value: _pct(attempt?.averageFluency),
              ),
              PronunciationMetric(
                label: l10n.rhythm,
                value: _pct(attempt?.averageRhythm),
              ),
            ],
          ),
          ctaLabel: done ? l10n.hwCtaResult : l10n.hwCtaStudy,
          ctaType: done ? BtnType.secondaryFill : BtnType.primaryFill,
          // 닫힌 과제는 제출을 받지 않는다. 읽게 해 놓고 마지막에 튕기지 않는다.
          // 🔴 다 읽은 과제는 **결과로 간다.** 예전에는 라벨만 「학습결과」로
          //    바뀌고 눌러도 녹음 화면이 다시 열렸다.
          ctaDisabled: (a.isClosed && !done) || _loadingItems,
          onCta: () => done ? _showSpeakingResult(a) : _startSpeaking(a),
        );

      case AssignmentActivity.conversation:
        return CardTask(
          icon: AppIcons.chat,
          title: l10n.hwActivityConversation,
          badge: badge,
          description: l10n.hwTaskConversationDesc,
          // 🔴 발음과 달리 라벨을 「학습결과」로 바꾸지 않는다. 회화에는 볼 결과가
          //    없다 — 과제 리포트(`assignmentReport`)는 **발음** 축이고, 통화 요약은
          //    과제가 아니라 통화 한 건에 붙는다. 라벨만 바꾸면 눌렀을 때 결과 대신
          //    통화가 또 걸린다(발음 카드가 예전에 그랬다). 끝난 것은 배지가 말한다.
          ctaLabel: l10n.hwCtaStudy,
          ctaType: done ? BtnType.secondaryFill : BtnType.primaryFill,
          ctaDisabled: a.isClosed,
          // 통화는 서버가 스스로 과제에 묶는다(`submission_service.link_call`).
          // 과제 id 는 통화 시작 메시지에 실려 목표 표현 주입에 쓰인다.
          onCta: () => Navigator.of(
            context,
          ).pushNamed(Routes.callLoading, arguments: a.assignmentId),
        );

      case AssignmentActivity.workbook:
        final url = a.workbookUrl;
        return CardTask(
          icon: AppIcons.book,
          title: l10n.hwActivityWorkbook,
          badge: badge,
          description: url == null
              ? l10n.hwWorkbookUnavailable
              : l10n.hwTaskWorkbookDesc,
          ctaLabel: l10n.hwCtaDownload,
          ctaType: BtnType.secondaryFill,
          ctaRightIcon: Builder(
            builder: (ctx) =>
                AppIcons.externalLink(size: 20, color: ctx.c.labelStrong),
          ),
          // 교사가 링크를 안 넣었으면 열 곳이 없다.
          ctaDisabled: url == null,
          onCta: url == null ? null : () => _openWorkbook(a.assignmentId, url),
        );
    }
  }
}
