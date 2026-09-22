import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;

import '../../app/adaptive.dart';
import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/atoms/skeleton.dart';
import '../../components/icons/app_icons.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/normalcall/domain/entities/call_result.dart';
import '../../features/normalcall/domain/entities/call_streak.dart';
import '../../features/normalcall/presentation/streak_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../system/network_error.dart';
import '../../core/format/dates.dart';

/// 학습 달력 — Figma `screen/streak_calendar` (`6183:4527`) · 로딩 `6245:42308`.
///
/// 홈 불꽃 칩을 누르면 온다.
/// ```
/// [ 🔥 12 일 연속 ]                 ← 히어로(Accent/Streak-Surface)
/// [통화 시간 130분 | 통화 9회]        ← 지표 — 이번 달
/// [ 2026년 9월 · 얼굴 달력 ]          ← 통화한 날은 그날 상대의 얼굴 · 연속 구간은 띠
/// [ 9월 18일 · 강아지 산책… › ]       ← 고른 날의 통화 → 그 통화의 분석
/// ```
///
/// ⚠ Figma 의 지표 「배운 표현」·「말한 단어」 는 **아직 그리지 않는다** — 서버 집계가 없다
///   (남은판단 S3). 지어낸 숫자를 그리느니 가진 값(통화 시간·통화 수)만 그린다.
///
/// 요일 머리와 한 주의 시작 요일은 **로케일을 따른다**(`MaterialLocalizations` 의
/// `narrowWeekdays` · `firstDayOfWeekIndex`). 달력 머리는 열이 고정이라 한 글자여도
/// 위치로 구분된다(알람 요일 칩과 다른 점 — 그쪽은 칩이 흘러서 위치가 없다).
class StreakCalendarScreen extends ConsumerStatefulWidget {
  /// Creates the learning calendar.
  const StreakCalendarScreen({super.key});

  @override
  ConsumerState<StreakCalendarScreen> createState() =>
      _StreakCalendarScreenState();
}

class _StreakCalendarScreenState extends ConsumerState<StreakCalendarScreen> {
  /// 고른 날(현지 날짜). null 이면 이번 달에서 통화한 가장 최근 날.
  DateTime? _selected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final history = ref.watch(callHistoryProvider);
    return AppScaffold(
      background: context.c.backgroundNormalNormal,
      body: history.when(
        loading: () => _Loading(title: l10n.streakCalendarTitle),
        error: (e, _) => Column(
          children: [
            Gnb.main(
                title: l10n.streakCalendarTitle,
                onBack: () => Navigator.pop(context)),
            Expanded(
              child: NetworkErrorView(
                message: e is AppException && e.fromServer ? e.message : null,
                onRetry: () => ref.invalidate(callHistoryProvider),
              ),
            ),
          ],
        ),
        data: (calls) => _content(context, calls),
      ),
    );
  }

  Widget _content(BuildContext context, List<CallSummary> calls) {
    final l10n = AppLocalizations.of(context);
    final c = context.c;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final byDay = callsByDay(calls);
    final streak = CallStreak.fromDates(
        calls.map((x) => x.callDate).whereType<DateTime>(), now);
    final month = [
      for (final e in byDay.entries)
        if (e.key.year == today.year && e.key.month == today.month) ...e.value,
    ];
    final minutes =
        month.fold<int>(0, (s, x) => s + (x.totalTime ?? 0)) ~/ 60;
    final selected = _selected ??
        (byDay.keys
                .where((d) => d.year == today.year && d.month == today.month)
                .fold<DateTime?>(
                    null, (a, b) => a == null || b.isAfter(a) ? b : a) ??
            today);
    final dayCalls = byDay[selected] ?? const <CallSummary>[];

    return Column(
      children: [
        // ── 히어로 ─────────────────────────────────────────────────────
        ColoredBox(
          color: c.accentStreakSurface,
          child: Column(
            children: [
              Gnb.main(
                  title: l10n.streakCalendarTitle,
                  onBack: () => Navigator.pop(context)),
              ContentColumn(
                gutter: 24,
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  children: [
                    AppIcons.flameFill(
                      size: 36,
                      color: streak.state == StreakState.broken
                          ? c.labelAssistive
                          : c.accentStreak,
                    ),
                    const SizedBox(width: 10),
                    // 숫자(Title 1) + 단위(Headline 1). 단위는 언어마다 길이가 크게 달라
                    // (ko 「일 연속」 · de 「Tage in Folge」) Wrap 으로 둔다 — 자르지 않는다.
                    Expanded(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.end,
                        spacing: 2,
                        children: [
                          Text(
                            '${streak.days}',
                            style: AppType.title1.b.copyWith(
                              color: c.labelStrong,
                              fontFeatures: const [
                                FontFeature.tabularFigures()
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              l10n.streakDaysUnit(streak.days),
                              style: AppType.headline1.b
                                  .copyWith(color: c.labelStrong),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: ContentColumn(
              padding: const EdgeInsets.only(top: 12, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ⚠ 정본은 3칸(배운 표현 · 말한 단어 · 통화 시간)이다. 앞 두 칸은 서버 집계가
                  //   없어 **일부러 뺐다**(0 으로 그리면 「안 했다」로 읽힌다 · 남은판단 S3).
                  //   집계가 생기면 칸을 되살리고, 칸이 셋 이상이면 Wrap/2×2 로 바꾼다.
                  _card(
                    context,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: _Metric(
                              value: l10n.streakMinutes(minutes),
                              label: l10n.streakMetricCallTime,
                            ),
                          ),
                          VerticalDivider(
                              width: 1, thickness: 1, color: c.lineAlternative),
                          Expanded(
                            child: _Metric(
                              value: l10n.streakCallCount(month.length),
                              label: l10n.streakMetricCalls,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _card(
                    context,
                    padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
                    child: _MonthGrid(
                      month: DateTime(today.year, today.month),
                      today: today,
                      byDay: byDay,
                      streak: streak,
                      selected: selected,
                      onSelect: (d) => setState(() => _selected = d),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _card(
                    context,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: dayCalls.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              l10n.streakNoCallsThatDay,
                              textAlign: TextAlign.center,
                              style: AppType.label1.r
                                  .copyWith(color: c.labelAlternative),
                            ),
                          )
                        : Column(
                            children: [
                              for (var i = 0; i < dayCalls.length; i++)
                                _CallRow(
                                  call: dayCalls[i],
                                  last: i == dayCalls.length - 1,
                                ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _card(BuildContext context,
          {required Widget child, required EdgeInsets padding}) =>
      Container(
        padding: padding,
        decoration: BoxDecoration(
          color: context.c.backgroundElevatedAlternative,
          borderRadius: BorderRadius.circular(12),
        ),
        child: child,
      );
}

/// 통화를 **현지 날짜**별로 묶는다(최신순 유지).
Map<DateTime, List<CallSummary>> callsByDay(List<CallSummary> calls) {
  final out = <DateTime, List<CallSummary>>{};
  for (final c in calls) {
    final d = c.callDate?.toLocal();
    if (d == null) continue;
    out.putIfAbsent(DateTime(d.year, d.month, d.day), () => []).add(c);
  }
  return out;
}

/// [month] 의 달력 칸 — 주 단위, 앞뒤 빈 칸은 null.
/// [firstDayOfWeekIndex] 는 `MaterialLocalizations` 의 값(0 = 일요일).
List<List<DateTime?>> monthWeeks(DateTime month, int firstDayOfWeekIndex) {
  final first = DateTime(month.year, month.month);
  final days = DateTime(month.year, month.month + 1, 0).day;
  // DateTime.weekday: 월=1 … 일=7 → 일=0 … 토=6.
  final lead = (first.weekday % 7 - firstDayOfWeekIndex + 7) % 7;
  final cells = <DateTime?>[
    for (var i = 0; i < lead; i++) null,
    for (var d = 1; d <= days; d++) DateTime(month.year, month.month, d),
  ];
  while (cells.length % 7 != 0) {
    cells.add(null);
  }
  return [
    for (var i = 0; i < cells.length; i += 7) cells.sublist(i, i + 7),
  ];
}

class _Metric extends StatelessWidget {
  const _Metric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 수치 — 자르지 않는다. 좁으면 줄을 바꾼다.
          Text(value,
              style: AppType.heading1.b.copyWith(
                color: c.labelStrong,
                fontFeatures: const [FontFeature.tabularFigures()],
              )),
          Text(label,
              style: AppType.caption1.r.copyWith(color: c.labelAlternative)),
        ],
      ),
    );
  }
}

/// 얼굴 달력 — `Cell-Day` 46×40: 통화한 날 = 그날 상대의 얼굴(28, 불꽃색 테두리),
/// 아닌 날 = 숫자, 미래 = 흐린 숫자. 연속 구간은 `Accent/Streak-Surface` 띠.
class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.month,
    required this.today,
    required this.byDay,
    required this.streak,
    required this.selected,
    required this.onSelect,
  });

  final DateTime month;
  final DateTime today;
  final Map<DateTime, List<CallSummary>> byDay;
  final CallStreak streak;
  final DateTime selected;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final ml = MaterialLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final first = ml.firstDayOfWeekIndex;
    final heads = [for (var i = 0; i < 7; i++) ml.narrowWeekdays[(first + i) % 7]];
    // 연속 구간 — 오늘(done) 또는 어제(pending)부터 거꾸로 [streak.days] 일.
    final end = streak.state == StreakState.done
        ? today
        : DateTime(today.year, today.month, today.day - 1);
    bool inBand(DateTime d) =>
        streak.days > 0 &&
        !d.isAfter(end) &&
        d.isAfter(DateTime(end.year, end.month, end.day - streak.days));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(asciiDigits(intl.DateFormat.yMMMM(locale).format(month)),
              style: AppType.label1.b.copyWith(color: c.labelStrong)),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            for (final h in heads)
              Expanded(
                child: Text(h,
                    textAlign: TextAlign.center,
                    style: AppType.caption1.r
                        .copyWith(color: c.labelAlternative)),
              ),
          ],
        ),
        const SizedBox(height: 4),
        for (final week in monthWeeks(month, first))
          Row(
            children: [
              for (final d in week)
                Expanded(
                  child: d == null
                      ? const SizedBox(height: 40)
                      : _cell(context, d, inBand(d)),
                ),
            ],
          ),
      ],
    );
  }

  Widget _cell(BuildContext context, DateTime d, bool band) {
    final c = context.c;
    final calls = byDay[d];
    final future = d.isAfter(today);
    final isSelected = d == selected;
    final url = calls?.first.character.imageUrl;
    Widget inner;
    if (calls != null && calls.isNotEmpty) {
      inner = Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: c.accentStreak),
          image: DecorationImage(
            image: (url != null && url.isNotEmpty)
                ? NetworkImage(url) as ImageProvider
                : placeholderAvatar,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      inner = Text(
        '${d.day}',
        style: (future ? AppType.label1.r : AppType.label1.m).copyWith(
          color: future ? c.labelAssistive : c.labelStrong,
        ),
      );
    }
    return Semantics(
      button: !future,
      selected: isSelected,
      label: MaterialLocalizations.of(context).formatFullDate(d),
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: future ? null : () => onSelect(d),
        child: Container(
          constraints: const BoxConstraints(minHeight: 40),
          color: band ? c.accentStreakSurface : null,
          alignment: Alignment.center,
          child: Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: isSelected
                ? BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: c.labelStrong),
                  )
                : null,
            child: inner,
          ),
        ),
      ),
    );
  }
}

/// `Row-Call` — 얼굴 36 · 날짜(Caption 1) · 제목(Body 2 Bold) · 셰브런 → 그 통화의 분석.
class _CallRow extends StatelessWidget {
  const _CallRow({required this.call, required this.last});

  final CallSummary call;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final url = call.character.imageUrl;
    final date = call.callDate?.toLocal();
    final title = (call.summary ?? '').trim();
    return InkWell(
      onTap: () => Navigator.pushNamed(context, Routes.analysisLoading,
          arguments: call.callId),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: last
              ? null
              : Border(bottom: BorderSide(color: c.lineAlternative)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: c.backgroundNormalAlternative,
              backgroundImage: (url != null && url.isNotEmpty)
                  ? NetworkImage(url) as ImageProvider
                  : placeholderAvatar,
            ),
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (date != null)
                    Text(asciiDigits(intl.DateFormat.MMMd(locale).format(date)),
                        style: AppType.caption1.r
                            .copyWith(color: c.labelNormal)),
                  // 제목은 요약 산문이라 두 줄까지 쓰고 넘치면 줄인다(식별자 아님).
                  Text(
                    title.isEmpty ? l10n.analysisResult : title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppType.body2.b.copyWith(color: c.labelStrong),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.s12),
            AppIcons.chevronRight(size: 20, color: c.labelAssistive),
          ],
        ),
      ),
    );
  }
}

/// `screen/streak_calendar_loading` (`6245:42308`) — 같은 배치를 막대로 든다.
class _Loading extends StatelessWidget {
  const _Loading({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Column(
      children: [
        ColoredBox(
          color: c.accentStreakSurface,
          child: Column(
            children: [
              Gnb.main(title: title, onBack: () => Navigator.maybePop(context)),
              const ContentColumn(
                gutter: 24,
                padding: EdgeInsets.only(bottom: 20),
                child: SkeletonShimmer(
                  child: Row(
                    children: [
                      Skeleton.circle(size: 36),
                      SizedBox(width: 10),
                      Skeleton.bar(width: 120, height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const Expanded(
          child: SkeletonShimmer(
            child: ContentColumn(
              padding: EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Skeleton.box(width: double.infinity, height: 68),
                  SizedBox(height: 10),
                  Skeleton.box(width: double.infinity, height: 280),
                  SizedBox(height: 10),
                  Skeleton.box(width: double.infinity, height: 64),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
