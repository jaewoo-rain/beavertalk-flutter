import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/adaptive.dart';
import '../../app/app_scaffold.dart';
import '../../components/atoms/skeleton.dart';
import '../../components/icons/app_icons.dart';
import '../../components/molecules/row_alarm.dart';
import '../../components/molecules/empty_state.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/alarm/domain/entities/alarm.dart';
import '../../features/alarm/presentation/providers/alarm_list_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_typography.dart';
import '../system/network_error.dart';
import 'alarm_add.dart';
import 'alarm_days.dart';
import 'alarm_models.dart';

/// Alarm list — Figma `screen/etc_alarm` (`6179:28961`, 09-22 개편). A grouped
/// list of [RowAlarm]s backed by the server (`alarmListControllerProvider`). Each
/// row can be **swiped** to delete (DELETE), **tapped** to edit (PUT), and
/// toggled active. The title row's "+" adds (POST). Per-day chips moved into the
/// edit sheet — the row only summarises them.
class AlarmListScreen extends ConsumerStatefulWidget {
  /// Creates the alarm list screen.
  const AlarmListScreen({super.key});

  @override
  ConsumerState<AlarmListScreen> createState() => _AlarmListScreenState();
}

class _AlarmListScreenState extends ConsumerState<AlarmListScreen> {
  /// Surfaces a repository [AppException] as a snackbar.
  void _showError(Object error) {
    if (!mounted) return;
    final message = error is AppException
        ? error.message
        : AppLocalizations.of(context).somethingWentWrong;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Runs a controller mutation, showing any failure as a snackbar.
  ///
  /// Returns `true` when [action] completed and `false` when it threw. Callers
  /// that must not proceed on failure need this: `Dismissible.confirmDismiss`
  /// used to `return true` unconditionally because the error was swallowed here,
  /// so a failed DELETE still animated the card away while the controller state
  /// kept the alarm — tripping Flutter's "dismissed Dismissible is still part of
  /// the tree" assertion, and the alarm still rang.
  Future<bool> _run(Future<void> Function() action) async {
    try {
      await action();
      return true;
    } catch (e) {
      _showError(e);
      return false;
    }
  }

  /// Opens the add sheet as a modal bottom sheet; creates the result (POST) if
  /// the user saved. `isScrollControlled` lets the sheet + its inner time-picker
  /// size correctly and rise above the keyboard.
  Future<void> _add() async {
    final result = await showModalBottomSheet<AlarmData>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // Flutter defaults the barrier to black @ 54%; pin it to the app scrim
      // so every dim in the product is the same black @ 50%.
      barrierColor: context.c.materialDim,
      builder: (_) => const AlarmAddSheet(),
    );
    if (result == null) return;
    await _run(() =>
        ref.read(alarmListControllerProvider.notifier).add(result.toEntity()));
  }

  /// Opens the edit sheet (modal bottom sheet) seeded with [alarm]; updates it
  /// (PUT) on save.
  Future<void> _edit(Alarm alarm) async {
    final result = await showModalBottomSheet<AlarmData>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: context.c.materialDim,
      builder: (_) => AlarmAddSheet(initial: AlarmData.fromEntity(alarm)),
    );
    if (result == null) return;
    await _run(() =>
        ref.read(alarmListControllerProvider.notifier).edit(result.toEntity()));
  }

  @override
  Widget build(BuildContext context) {
    final alarmsAsync = ref.watch(alarmListControllerProvider);
    final l10n = AppLocalizations.of(context);

    // Figma `screen/etc_alarm` (`6179:28961`, 09-22 개편): 제목 없는 GNB(뒤로) ·
    // 「알람」 제목 줄 + 추가(+) · 목록형 묶음. 아래 고정 버튼은 없다 — 추가는 + 하나다.
    return AppScaffold(
      background: context.c.backgroundNormalNormal,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gnb.main(title: '', onBack: () => Navigator.pop(context)),
          ContentColumn(
            gutter: 16,
            padding: const EdgeInsets.only(top: 4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  Expanded(
                    // 제목은 한 단어라도 언어마다 길이가 다르다 — 자르지 않고 줄을 바꾼다.
                    child: Text(l10n.alarms,
                        style: AppType.title3.m
                            .copyWith(color: context.c.labelStrong)),
                  ),
                  IconButton(
                    onPressed: _add,
                    icon: AppIcons.plus(size: 28, color: context.c.labelStrong),
                    tooltip: l10n.alarmAdd,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: alarmsAsync.when(
              loading: () => const AlarmListLoading(),
              error: (e, _) => NetworkErrorView(
                message: e is AppException && e.fromServer ? e.message : null,
                onRetry: () => ref.invalidate(alarmListControllerProvider),
              ),
              data: (alarms) => alarms.isEmpty
                  // 빈 목록엔 CTA 를 둔다 — 아래 고정 「추가」 버튼이 없어진 뒤로 추가 경로가
                  // 우상단 + 하나뿐이라, 처음 온 사람은 그걸 못 찾을 수 있다(검수 지적 09-22).
                  ? EmptyScreen(
                      title: l10n.noAlarms,
                      body: l10n.noAlarmsBody,
                      ctaText: l10n.alarmAdd,
                      onCta: _add,
                    )
                  : _list(alarms),
            ),
          ),
        ],
      ),
    );
  }

  /// 목록형 묶음 — 줄마다 밀어서 삭제 · 눌러서 편집 · 토글로 켜기/끄기.
  Widget _list(List<Alarm> alarms) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    return SingleChildScrollView(
      child: ContentColumn(
        gutter: 16,
        padding: const EdgeInsets.only(top: 12, bottom: 24),
        child: RowAlarmGroup(
          children: [
            for (var i = 0; i < alarms.length; i++)
              _row(alarms[i], i, l10n, locale),
          ],
        ),
      ),
    );
  }

  Widget _row(Alarm a, int i, AppLocalizations l10n, String locale) {
    final view = AlarmData.fromEntity(a);
    final id = a.id;
    return Dismissible(
      key: ValueKey(id ?? i),
      direction: DismissDirection.endToStart,
      background: _deleteBackground(),
      confirmDismiss: (_) async {
        if (id == null) return false;
        // Only let the row go if the server actually deleted it — see [_run].
        return _run(() =>
            ref.read(alarmListControllerProvider.notifier).remove(id));
      },
      child: RowAlarm(
        partner: view.partnerName,
        time: view.clock24,
        // 요약은 반복만 — 방식은 줄 맨 앞 원판이 보여 준다(09-26 사장님 확정 시안 C ·
        // Figma `Row/Alarm` `6179:4634` · 그 전에는 「평일, 학습」).
        summary: AlarmDays.summary(a.days, l10n, locale),
        mode: a.callMode == AlarmCallMode.chat ? RowAlarmMode.freeTalk : RowAlarmMode.study,
        active: a.active,
        onTap: () => _edit(a),
        onChanged: id == null
            ? null
            : (v) => _run(() => ref
                .read(alarmListControllerProvider.notifier)
                .toggleActive(id, v)),
      ),
    );
  }

  /// The "delete" affordance revealed when swiping a card left — a single red
  /// 48 circle holding a 24 trash glyph, centred on the card (`3665:12016`).
  ///
  /// The frame reveals the circle against the screen, not a full-height red
  /// panel behind the card, which is what this used to paint.
  Widget _deleteBackground() {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: context.c.accentForegroundRed,
            shape: BoxShape.circle,
          ),
          // On the red delete circle the glyph is always white — staticWhite,
          // not labelStrong (which flips to #000 in Light and vanishes on red).
          child: AppIcons.trash(color: context.c.staticWhite, size: 24),
        ),
      ),
    );
  }
}

/// 로딩 — Figma `screen/etc_alarm_loading` Mobile `3489:4550` · Tablet `6242:13923`(09-24 개편).
///
/// 목록과 **같은 틀**이다 — 같은 패딩의 [RowAlarmGroup] 안에 [RowAlarmLoading] 세 줄. 실제 줄이
/// 그 자리에 그대로 들어온다. 옛 카드형(`CardAlarmLoading` 두 장)과 하단 「새 일정 추가」 버튼은
/// 뺐다(버튼은 P11 에서 이미 없앤 기능).
class AlarmListLoading extends StatelessWidget {
  /// Creates the alarm list skeleton.
  const AlarmListLoading({super.key});

  @override
  Widget build(BuildContext context) => const SkeletonShimmer(
        child: ContentColumn(
          gutter: 16,
          padding: EdgeInsets.only(top: 12, bottom: 24),
          child: RowAlarmGroup(
            children: [RowAlarmLoading(), RowAlarmLoading(), RowAlarmLoading()],
          ),
        ),
      );
}

/// `Row-Alarm-Loading` — 실제 [RowAlarm] 과 같은 높이(109 = 패딩 12·12 + 16 + 52 + 16 + 선 1).
///
/// 맨 앞은 방식 원판 자리 40 원 · 12 띄움 · 세로 가운데(09-26 사용자 「응 로딩도 반영해」 · Figma
/// `Row/AlarmLoading` `6454:15162`) — [RowAlarm] 에 원판이 생겨 글자가 52 밀렸으니 로딩도 같은
/// 자리에 두어야 불러온 뒤 글자가 옆으로 튀지 않는다.
/// 막대 셋은 이름(16 줄 · 36×10) · 시각(52 줄 · 92×36) · 요약(16 줄 · 72×10)의 **줄 높이**
/// 안에 놓인다. 오른쪽 끝은 토글 자리 52×28 알약. 세로 가운데 · 패딩 12/18.
class RowAlarmLoading extends StatelessWidget {
  /// Creates one skeleton row.
  const RowAlarmLoading({super.key});

  static Widget _line(double h, double w, double barH) => SizedBox(
        height: h,
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Skeleton.bar(width: w, height: barH),
        ),
      );

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Row(
          children: [
            const Skeleton.circle(size: 40),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _line(16, 36, 10),
                _line(52, 92, 36),
                _line(16, 72, 10),
              ],
            ),
            const Spacer(),
            const Skeleton.pill(width: 52, height: 28),
          ],
        ),
      );
}
