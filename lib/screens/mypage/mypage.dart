import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/adaptive.dart';
import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../classroom/widgets/homework_class_card.dart';
import '../../features/normalcall/domain/entities/call_channel.dart';
import '../../features/normalcall/domain/entities/call_course.dart';
import '../../features/normalcall/presentation/build_flags.dart';
import '../../features/normalcall/presentation/cascade_auto_talk.dart';
import '../../features/normalcall/presentation/cascade_experiment.dart';
import '../../components/atoms/button.dart';
import '../../components/layout/need_based_rows.dart';
import '../../components/atoms/progress_bar.dart';
import '../../components/atoms/skeleton.dart';
import '../../components/icons/app_icons.dart';
import '../../components/molecules/empty_state.dart';
import '../../components/molecules/level_progress.dart';
import '../../components/molecules/pronunciation_result.dart';
import '../../components/organisms/dialog_basic.dart';
import '../../components/organisms/dialog_share_profile.dart';
import '../../components/organisms/gnb.dart';
import '../../core/error/app_exception.dart';
import '../../features/auth/domain/entities/accent_breakdown.dart';
import '../../features/auth/domain/entities/level_summary.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/character/presentation/providers/character_providers.dart';
import '../../features/auth/presentation/providers/my_profile_provider.dart';
import '../../features/normalcall/domain/entities/call_result.dart';
import '../../features/normalcall/domain/entities/pron_summary.dart';
import '../../features/normalcall/presentation/normalcall_controller.dart';
import '../../features/normalcall/presentation/normalcall_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../mock/mock_data.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Design-time values for the two cards the server has no source for yet.
///
/// **These are Figma numbers, not live data.** The redesign added a 종합 레벨
/// card and a 발음 분석 card; the backend exposes neither a level percentile nor
/// a recent-sessions score aggregate today, and this pass is UI-only by
/// instruction. Wiring them later means replacing exactly this block:
///
/// - level → `GET /members/me`.`korean_level` (already exists server-side,
///   1–13; the Flutter `Member` entity does not parse it yet).
/// - percentile → no server field exists; needs a new one.
/// - the pronunciation gauge → a recent-sessions aggregate endpoint, or a
///   client fold over `GET /calls/{id}/result`.`score_average`.
/// 서버가 값을 못 줄 때 쓰는 표시 기본값.
///
/// 예전엔 여기 레벨 7·상위 45%·발음 98점 같은 **디자인 목업 숫자**가 들어 있었고
/// 화면이 그걸 그대로 그렸다 — 누구에게나 같은 가짜 수치가 보였다. 이제 값은 전부
/// 서버에서 오고, 여기 남은 건 서버가 굳이 내려줄 필요 없는 스케일 상한뿐이다.
/// (서버가 level_max 를 주면 그 값이 이긴다.)
abstract final class _Fallback {
  static const int levelMax = 13;
}

/// 개발자 도구의 **옛 항목**(캐스케이드 통화·아바타/힌트 토글·취소/에코 리그·계측 토글
/// 6개·컴포넌트 갤러리·빌드 정보 줄)을 그릴지.
///
/// ⛔ 2026-09-12 사장님: 「코스 버튼 3개만」. 화면에서만 내렸다 — 코드·리그·토글·라우트는
///   한 줄도 지우지 않았다. 다시 필요해지면 이 값만 true 로 돌린다.
/// ⚠ 빌드 정보 줄(`BUILD_TAG`·토글 요약·응답시간)도 같이 내렸다. 「남길 것」 목록에 없었다.
///   실기기에서 «이 APK 가 무엇인지» 를 못 보게 되는 대가가 있다 — 필요하면 이 줄만 따로
///   되살린다.
const bool _kLegacyDevTools = false;

/// 플랜 × 코스 행렬의 **행 순서** — 위에서 아래로 상위 플랜(Premium·Free).
/// 서버 `premium` 브랜치(09-23)에서 Pro·Max 가 Premium 하나로 합쳐졌다.
const List<PlanOverride> _devMatrixPlans = [
  PlanOverride.premium,
  PlanOverride.free,
];

/// 코스 이름 한 곳 — 진도 한 줄([_CurMeLine])과 행렬 칸이 같은 표를 본다.
/// 두 벌로 두면 코스를 늘렸을 때 한쪽만 낡는다.
String _courseLabel(CallCourse? c) => switch (c) {
      CallCourse.expression => '표현학습',
      CallCourse.freetalk => '프리토킹',
      CallCourse.chat => '자유대화',
      CallCourse.auto => '자동',
      null => '(모름)',
    };

/// My page — Figma `screen/main_mypage` (Dark `3360:20181`, Light `3703:46474`).
///
/// The redesign turned this screen into an **analysis dashboard**: three cards
/// (억양 분석 · 종합 레벨 · 발음 분석) and nothing else. Everything that used to
/// live below them — Settings / Payment / Support, log out, delete account,
/// version — moved to [Routes.mypageSettings], reached from the gear that
/// replaced the old share icon in the header.
///
/// Sharing did not disappear with that icon: it moved *into* the accent card,
/// whose header now carries its own share button (Figma component
/// `Dialog-ShareProfile-new`, state=mypage → state=share).
class MyPageScreen extends ConsumerWidget {
  /// Creates the my-page screen.
  const MyPageScreen({super.key});

  /// Caption shared alongside the accent-card image (see [DialogShareProfile]).
  static const String _inviteText =
      "I'm learning Korean with Beavertalk — my Korean accent sounds "
      'American! 🦫 Come find your accent and learn with me: '
      'https://beavertalk.im';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    // Accent (nationality) breakdown from GET /members/me/profile. Empty until
    // it loads or when the member has no classification yet.
    // ⚠ 로딩과 「데이터 없음」을 가른다. `valueOrNull` 은 **로딩 중에도 null** 이라
    //   예전엔 응답이 오기 전 찰나에 「억양 데이터가 없어요」가 그대로 보였다.
    //   있는 사람에게 없다고 말하면 기능이 고장 난 것으로 읽힌다.
    final accentAsync = ref.watch(myAccentProvider);
    final accentLoading = accentAsync.isLoading && !accentAsync.hasValue;
    final accentStats = accentAsync.valueOrNull?.stats ?? const <AccentStat>[];
    // Watched, not read on tap: `callListProvider` is autoDispose, so a bare
    // `ref.read` inside the button handler would find it uninitialised and the
    // 발음 학습하기 CTA would always take the records fallback. Watching it here
    // starts the fetch while the screen is open so the newest call id is ready.
    final recentCalls = ref.watch(callListProvider).valueOrNull?.items;
    // 종합 레벨(GET /members/me/profile) — 로딩 중/실패면 빈 카드로 그린다.
    // 여기서 에러 화면을 띄우지 않는 이유: 카드 3개가 각자 독립이라 하나가 실패해도
    // 나머지는 보여주는 편이 낫다.
    final level = ref.watch(myLevelProvider).valueOrNull;
    // 발음 최근 10세션 평균(GET /calls/pronunciation-summary).
    final pron = ref.watch(pronunciationSummaryProvider).valueOrNull;
    // 사용자가 고른 캐릭터의 실제 이미지. 카탈로그가 아직 안 왔거나 image_url 이
    // 비어 있으면 정적 비버로 폴백한다 — id→이미지 추측 매핑은 쓰지 않는다
    // (환경마다 character_id 가 달라 남의 얼굴이 뜬 전례가 있다).
    final charUrl = ref.watch(selectedCharacterProvider)?.imageUrl;
    final ImageProvider avatar =
        (charUrl != null && charUrl.isNotEmpty) ? NetworkImage(charUrl) : beaverImage;

    return AppScaffold(
      background: context.c.backgroundNormalNormal,
      body: Column(
        children: [
          Gnb.main(
            title: '',
            onBack: () => Navigator.pop(context),
            trailing: IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, Routes.mypageSettings),
              icon: AppIcons.settings(color: context.c.labelStrong),
              tooltip: l10n.settingsSection,
            ),
          ),
          Expanded(
            child: ContentColumn(
              child: ListView(
                padding: const EdgeInsets.only(top: AppSpacing.s24, bottom: AppSpacing.s24),
                children: [
                  _accentCard(context, l10n, accentStats, avatar,
                      loading: accentLoading),
                  const SizedBox(height: AppSpacing.s24),
                  _levelCard(context, ref, l10n, level),
                  const SizedBox(height: AppSpacing.s24),
                  _pronunciationCard(context, l10n, pron, recentCalls),
                  const SizedBox(height: AppSpacing.s24),
                  // 숙제 진입점 — 형제 지표 카드 뒤 마지막 자리(Figma 실측).
                  const HomeworkClassCard(),
                  if (kDebugMode) ...[
                    const SizedBox(height: AppSpacing.s24),
                    _devToolsCard(context),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 개발자 도구 (디버그 빌드 전용) ──────────────────────────────────────

  /// 제품 플로우에서 도달할 수 없는 dev 화면들의 **유일한 진입점**.
  ///
  /// ⛔ `kDebugMode` 로만 그린다. 릴리즈 빌드에서는 이 카드가 트리에 아예 안 들어가고,
  ///   Dart 컴파일러가 `kDebugMode` 를 상수로 접어 코드째 제거한다. 실사용자가 닿을 수 없다.
  ///
  /// 마이페이지 스크롤 맨 아래에 둔 이유: 이미 아는 화면이라 찾기 쉽고, 끝까지 내려야
  /// 보이니 실수로 눌릴 일이 적다. **숨겨진 제스처(로고 롱프레스 같은 것)는 일부러 피했다** —
  /// 못 찾으면 없는 것과 같고, 그러면 측정이 통째로 막힌다.
  ///
  /// 여기 오기 전까지 `Routes.gallery` 는 라우트만 있고 도달할 UI 가 없어 사실상 죽어
  /// 있었다. dev 진입점을 새로 만드는 김에 같이 살렸다 — 다음 dev 도구도 갈 자리가 생긴다.
  Widget _devToolsCard(BuildContext context) => _card(
        context,
        header: _cardHeader(
          context,
          title: '개발자 도구',
          subtitle: '디버그 빌드에만 보입니다',
        ),
        children: [
          // ⭐ **이 APK 가 무엇인지** 맨 위에 띄운다. 2026-08-14: 서버는 마이크 상시개방을
          //   요청했는데 끼어들기가 한 번도 안 걸렸고, 원인은 폰에 깔린 APK 가
          //   `ANDROID_VOICE_AUDIO` 없이 빌드된 것이었다. **그걸 확인할 방법이 화면에
          //   없어서** 반나절을 왕복했다(외부라 USB 도 못 썼다). 안 보이는 상태가 원인이다.
          // ⛔ 2026-09-12 사장님: 「코스 버튼 3개만」. 아래는 화면에서만 내렸다 — 코드·리그·토글은
          //   그대로다([_kLegacyDevTools] 를 true 로 돌리면 전부 돌아온다).
          if (_kLegacyDevTools) ...[
            _buildInfoRow(context),
            _devRow(
              context,
              title: '캐스케이드 통화 (테스트 서버)',
              description: '실험 통로입니다 — 소켓만 데모 서버로 붙고, 일반 통화(라이브)는 '
                  '운영 서버 그대로입니다. '
                  '⚠ 두 서버가 같은 DB 를 쓰므로 이 통화도 실서비스 데이터에 그대로 쌓입니다. '
                  '통화 후 분석이 정상 동작하는지는 아직 확인되지 않았습니다.',
              route: Routes.callLoading,
              arguments: CallChannel.cascade,
            ),
          ],
          // ── 코스 통화 진입점 ────────────────────────────────────────────
          // ⭐ 통로(캐스케이드)와 **다른 축**이다 — 소켓은 라이브 그대로 `/calls/stream`
          //   이고, `start` 프레임의 `call_type` 만 달라진다([CallCourse] 참조).
          //
          // 그 위 한 줄은 `GET /cur/me` — 지금 어느 차시에 있고 «자동» 을 누르면 서버가
          // 무엇을 정할지. 홈 «이번 통화» 카드의 dev 판이다(디자인은 별건).
          const _CurMeLine(),
          _devRow(
            context,
            title: '표현학습 통화',
            description: '18개 표현을 드릴하고 3개마다 퀴즈를 냅니다(끝에 오답퀴즈). '
                '소켓은 일반 통화와 같은 운영 서버입니다 — 통화 종류만 바뀝니다. '
                '⚠ 같은 DB 라 이 통화도 실서비스 데이터에 그대로 쌓입니다.',
            route: Routes.callLoading,
            arguments: CallCourse.expression,
          ),
          _devRow(
            context,
            title: '프리토킹 통화',
            description: '100% 학습 언어로 자유대화합니다(학습 항목 주입 없음). '
                '소켓은 일반 통화와 같은 운영 서버입니다 — 통화 종류만 바뀝니다. '
                '⚠ 같은 DB 라 이 통화도 실서비스 데이터에 그대로 쌓입니다.',
            route: Routes.callLoading,
            // ⭐ QA 우회 — 이 버튼만 `force_course: true` 를 싣는다(자동·표현학습은 안 싣는다).
            //   admin 계정이면 서버가 `COURSE_LOCKED` 를 우회하고 진도는 안 바꾼다.
            //   user 계정이면 무시되어 지금처럼 잠김 스낵바다. [CourseCallRequest] 참조.
            arguments: const CourseCallRequest(
              CallCourse.freetalk,
              forceCourse: true,
            ),
          ),
          // ⭐ «자동(auto)» 는 이제 **홈의 전화 버튼**이다(2026-09-13). 여기는 대신 옛
          //   일반 통화 — 인자를 안 실어 call_type 이 프레임에서 빠지고 서버 D11 이
          //   라우팅한다(레벨 미확정이면 레벨테스트). 옛 경로를 걸 유일한 자리다.
          _devRow(
            context,
            title: '일반 통화 (normal)',
            description: '옛 일반 통화 — 학습 항목 주입·레벨 시스템. call_type 을 안 보내 '
                '서버 D11 이 라우팅합니다(레벨 미확정이면 레벨테스트). 자동(auto)은 '
                '홈의 전화 버튼이 겁니다. '
                '⚠ 같은 DB 라 이 통화도 실서비스 데이터에 그대로 쌓입니다.',
            route: Routes.callLoading,
          ),
          // ── 플랜 × 코스 (QA) — 6칸 ────────────────────────────────────
          _devCallMatrix(context),
          // ⛔ 2026-09-12 사장님: 「코스 버튼 3개만」 — 위와 같은 이유로 화면에서만 내렸다.
          if (_kLegacyDevTools) ...[
            // ⭐ 격리 실험 스위치 — **캐스케이드에만** 걸린다(라이브는 제품 그대로 = 대조군).
            //   다음 단계가 "하나씩 다시 켜기"라 빌드 없이 껐다 켰다 할 수 있어야 한다.
            _devSwitch(
              context,
              title: '└ 아바타 영상',
              description: '끄면 정적 이미지만. ExoPlayer/SurfaceView 가 안드로이드 '
                  'UI 스레드를 막는지 보는 스위치입니다 — 제1 용의자.',
              flag: CascadeExperiment.avatarVideo,
            ),
            _devSwitch(
              context,
              title: '└ 힌트 카드',
              description: '끄면 힌트를 안 그립니다.',
              flag: CascadeExperiment.hints,
            ),
            _devRow(
              context,
              title: '취소 배관 리그',
              description: '끼어들기(audio_cancel) 수신부터 소리가 실제로 멎기까지 몇 ms 걸리는지 '
                  '반복 측정합니다. 서버 없이 클라 안에서 프레임을 주입합니다.',
              route: Routes.cancelRig,
            ),
            _devRow(
              context,
              title: '에코 측정 리그',
              description: '스피커폰·이어폰에서 비버 소리가 마이크로 얼마나 되돌아오는지 잽니다. '
                  '서버 에코 임계값을 정하는 실측 도구입니다.',
              route: Routes.echoRig,
            ),
            // ── 계측 토글 ──────────────────────────────────────────────────
            // ⛔ 예전엔 전부 `--dart-define` 이었다. 끄고 켤 때마다 **APK 를 구워야 했고**,
            //   그래서 「지금 폰에 깔린 게 어느 빌드냐」를 아무도 못 가렸다. 2026-08-14 에
            //   그것 때문에 반나절을 태웠다 — 서버는 마이크를 열라는데 클라가 거부했고,
            //   원인이 빌드 플래그라는 걸 화면에서 볼 방법이 없었다.
            // ⚠ **오디오 세션에 관계된 것은 다음 통화부터** 먹는다(통화 중에 바꿔도 안 바뀐다).
            //   그 사실을 각 설명에 적는다 — 안 적으면 「토글했는데 안 바뀐다」가 된다.
            _devSwitch(
              context,
              title: '└ 자동 대화',
              description: '사람 없이 문장을 주입해 통화를 채웁니다(12분 뒤 자동 종료). '
                  '⚠ STT 를 안 타므로 **끊김 곡선 전용**이고 응답시간 측정에 쓰면 안 됩니다. '
                  '다음 통화부터 적용.',
              flag: CascadeAutoTalk.toggle,
            ),
            _devSwitch(
              context,
              title: '└ 업링크 차단',
              description: '마이크는 열되 **서버로 보내는 것만** 막습니다. 레코더·AEC 는 그대로 '
                  '돌아서 오디오 세션이 안 흔들립니다. ⛔ 내 목소리가 서버에 안 갑니다. '
                  '다음 통화부터 적용.',
              flag: CascadeMicAlwaysGated.toggle,
            ),
            _devSwitch(
              context,
              title: '└ 쿠션 성장 끔',
              description: '지터 쿠션이 자라지 않게 고정합니다. 끊김이 얼마나 늘어나는지 '
                  '재는 용도입니다(쿠션은 모든 대답의 첫 소리를 그만큼 늦춥니다). '
                  '다음 통화부터 적용.',
              flag: CascadeCushionGrowthOff.toggle,
            ),
            _devSwitch(
              context,
              title: '└ 마이크 끔',
              description: '레코더를 **아예 열지 않습니다**(게이팅과 다릅니다 — 게이팅은 '
                  '프레임을 받은 뒤 버립니다). ⛔ 내 목소리가 서버에 안 갑니다. '
                  '다음 통화부터 적용.',
              flag: CascadeMicOff.toggle,
            ),
            _devSwitch(
              context,
              title: '└ 파일 녹음',
              description: '스트림 대신 파일로 녹음합니다 — 레코더는 돌되 프레임이 앱으로 '
                  '안 올라옵니다. ⛔ 내 목소리가 서버에 안 갑니다. 다음 통화부터 적용.',
              flag: CascadeMicToFile.toggle,
            ),
            _devSwitch(
              context,
              title: '└ AEC 끔',
              description: '에코 제거·음성처리를 끄고 마이크를 엽니다. ⚠ 스피커폰에서 비버가 '
                  '자기 목소리에 끊길 수 있습니다. 다음 통화부터 적용.',
              flag: CascadeMicNoAec.toggle,
            ),
            _devRow(
              context,
              title: '컴포넌트 갤러리',
              description: '디자인 시스템 컴포넌트 미리보기.',
              route: Routes.gallery,
            ),
          ],
          // ── 파괴적 도구 — 맨 아래 ────────────────────────────────────────
          // 사장님 지시(2026-09-13). 카드 끝에 두는 이유: 실수로 눌리기 가장 어려운
          // 자리다(위 개발자 카드 자체가 스크롤 맨 아래인 것과 같은 논리).
          const _CurResetRow(),
        ],
      );

  /// 격리 실험 스위치 한 줄. **통화 밖에서 미리 정해 두고 들어간다.**
  ///
  /// 통화 중에 바꾸면 그 통화의 측정이 두 구성에 걸쳐 오염된다 — 한 통화 = 한 구성이다.
  Widget _devSwitch(
    BuildContext context, {
    required String title,
    required String description,
    required ValueNotifier<bool> flag,
  }) =>
      ValueListenableBuilder<bool>(
        valueListenable: flag,
        builder: (context, on, _) => Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s4),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title,
                        style: AppType.body1.sb
                            .copyWith(color: context.c.labelStrong)),
                    const SizedBox(height: AppSpacing.s4),
                    Text(description,
                        style: AppType.label1.r
                            .copyWith(color: context.c.labelAlternative)),
                  ],
                ),
              ),
              Switch(value: on, onChanged: (v) => flag.value = v),
            ],
          ),
        ),
      );

  /// dev 도구 한 줄. 제목 + 무엇을 하는 화면인지 한 줄.
  ///
  /// 계측 도구 진입점이라 꾸밀 이유가 없다 — 눈에 띄고 뭔지 읽히면 그걸로 끝이다.
  /// 빌드 식별자 + 컴파일 플래그 한 줄. **USB 없이 화면만으로** 어느 APK 인지 가른다.
  ///
  /// ⛔ 값을 손으로 나열하지 않는다 — [BuildFlags] 가 **실제 상수**를 읽는다.
  ///   여기서 문자열을 다시 쓰면 플래그를 늘렸을 때 화면이 조용히 낡아, 정확히 우리가
  ///   없애려는 거짓말이 다시 생긴다.
  Widget _buildInfoRow(BuildContext context) => ValueListenableBuilder<bool>(
        // ⭐ 토글을 켜면 **이 줄이 즉시 바뀌어야** 한다. 안 그러면 「지금 무슨 상태인가」가
        //   두 군데로 갈려 오늘 혼선이 반쪽만 닫힌다. 아무 토글이나 하나를 들으면
        //   setState 가 카드 전체를 다시 그리므로 나머지도 같이 갱신된다.
        valueListenable: CascadeAutoTalk.toggle,
        builder: (context, _, _) => _buildInfoBody(context),
      );

  Widget _buildInfoBody(BuildContext context) {
    final ok = BuildFlags.micReachesServer;
    final anyOn = BuildFlags.anyExperimentOn;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('빌드 ${BuildFlags.tag}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  )),
          const SizedBox(height: 2),
          // ⭐ 응답시간 — **밖에서 USB 없이 읽으라고** 화면에도 둔다. 오늘 그게 반나절을 아꼈다.
          //   통화가 끝나도 마지막 값이 남는다(통화 화면을 나와야 이 화면을 볼 수 있으므로).
          ValueListenableBuilder<String>(
            valueListenable: NormalCallController.responseSummary,
            builder: (context, line, _) => line.isEmpty
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(line,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontWeight: FontWeight.w700)),
                  ),
          ),
          Text(BuildFlags.summary,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontFamily: 'monospace')),
          const SizedBox(height: 4),
          // ⭐ 사람이 판단하지 않아도 되게 **결론을 문장으로** 쓴다. 플래그 조합을 읽고
          //   해석하라고 하면 오늘 같은 혼선이 그대로 반복된다.
          Text(
            ok
                ? '⚠ 끼어들기는 **서버가** 정합니다 — 서버가 허용하면 비버 말 중에도 마이크가 열립니다.'
                : '⛔ 지금 내 목소리가 서버에 가지 않습니다 — 통화가 성립하지 않습니다. '
                    '아래 실험 토글을 끄세요.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ok ? null : Theme.of(context).colorScheme.error,
                ),
          ),
          // ⭐ 켜 둔 채 잊는 것이 다음 사고다. 하나라도 켜져 있으면 눈에 띄게 알린다.
          if (anyOn) ...[
            const SizedBox(height: 4),
            Text(
              '⚠ 실험 토글이 켜져 있습니다 — 지금 이 앱은 제품 동작이 아닙니다.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  /// 플랜 × 코스 6칸(QA) — «Max·표현학습» 부터 «Free·프리토킹» 까지.
  ///
  /// 사장님 지시(2026-09-19): 옛 «Max 로 통화 / Free 로 통화» 2개를 이 6개로 대체했다(09-23 Premium·Free 4개로 축소).
  /// 두 축이 곱해지는 자리라 **행렬로 그린다** — 목록으로 늘어놓으면 6줄이 서로 비슷해
  /// 무엇이 빠졌는지 눈으로 못 센다. 세로가 플랜, 가로가 코스다.
  ///
  /// 보내는 것(한 줄에 셋):
  /// - `plan_override` — free|premium. **admin 만 유효**하고 엔진·조각 수만 바꾼다.
  /// - `call_type` — `expression`|`freetalk` 을 **명시**한다(auto 아님 · 서버가 안 고른다).
  /// - `force_course` — **프리토킹에만** true. 그 차시 표현학습이 안 끝났어도 열린다
  ///   (`COURSE_LOCKED` 우회, 진도 무영향). 표현학습은 원래 안 잠기므로 안 보낸다.
  ///
  /// ⛔ 홈의 제품 진입점(auto)은 이 표와 **무관하다** — 거긴 서버가 코스를 정한다.
  Widget _devCallMatrix(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('플랜 × 코스 통화',
                style: AppType.body1.sb.copyWith(color: context.c.labelStrong)),
            const SizedBox(height: AppSpacing.s4),
            Text(
              '구독과 무관하게 이 통화만 그 플랜 엔진으로 겁니다 — 관리자 계정만 먹습니다. '
              'Premium 은 영상, Free 는 음성. 프리토킹은 잠금을 우회합니다. '
              '⚠ 같은 DB 라 이 통화도 실서비스 데이터에 그대로 쌓입니다.',
              style: AppType.label1.r.copyWith(color: context.c.labelNormal),
            ),
            const SizedBox(height: AppSpacing.s12),
            // Premium → Free(위에서 아래로 상위 플랜).
            // ⛔ `PlanOverride.values` 를 그대로 쓰지 마라 — 그건 와이어 값의 순서다.
            for (final plan in _devMatrixPlans) ...[
              if (plan != _devMatrixPlans.first)
                const SizedBox(height: AppSpacing.s8),
              Row(
                children: [
                  Expanded(
                    child: _devCallCell(context, plan, CallCourse.expression),
                  ),
                  const SizedBox(width: AppSpacing.s8),
                  Expanded(
                    child: _devCallCell(context, plan, CallCourse.freetalk),
                  ),
                ],
              ),
            ],
          ],
        ),
      );

  /// 행렬의 한 칸. 문안은 **시험이 탭하는 이름**이라 바꾸면 시험도 같이 고친다.
  Widget _devCallCell(
    BuildContext context,
    PlanOverride plan,
    CallCourse course,
  ) {
    final label = '${_planLabel(plan)} · ${_courseLabel(course)}';
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        Routes.callLoading,
        arguments: CourseCallRequest(
          course,
          planOverride: plan,
          // 프리토킹만 잠금 우회. 표현학습은 원래 안 잠긴다.
          forceCourse: course == CallCourse.freetalk,
        ),
      ),
      borderRadius: BorderRadius.circular(AppRadius.xs),
      child: Container(
        // Expanded 안이라 폭은 이미 정해졌다 — alignment 는 **글자만** 가운데로 둔다
        // (Container(alignment:) 가 폭을 늘리는 함정은 폭 제약이 없을 때의 얘기다).
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.s12,
          horizontal: AppSpacing.s8,
        ),
        decoration: BoxDecoration(
          color: context.c.backgroundElevatedNormal,
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        // 배율이 커지면 두 줄로 흐른다 — 높이가 고정이 아니라 넘치지 않는다.
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppType.label1.r.copyWith(color: context.c.labelStrong),
        ),
      ),
    );
  }

  static String _planLabel(PlanOverride plan) => switch (plan) {
        PlanOverride.free => 'Free',
        PlanOverride.premium => 'Premium',
      };

  Widget _devRow(
    BuildContext context, {
    required String title,
    required String description,
    required String route,
    Object? arguments,
  }) =>
      InkWell(
        onTap: () =>
            Navigator.pushNamed(context, route, arguments: arguments),
        borderRadius: BorderRadius.circular(AppRadius.xs),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Expanded: 설명이 길어 두 줄 이상으로 접히므로 Row 안에서 폭을 받아야
              // 한다. 고정폭이나 double.infinity 를 쓰면 오버플로가 난다.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title,
                        style: AppType.body1.sb
                            .copyWith(color: context.c.labelStrong)),
                    const SizedBox(height: AppSpacing.s4),
                    Text(description,
                        style: AppType.label1.r
                            .copyWith(color: context.c.labelNormal)),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.s4),
                child: AppIcons.chevronRight(
                    size: 20, color: context.c.labelAssistive),
              ),
            ],
          ),
        ),
      );

  // ── Cards ──────────────────────────────────────────────────────────────

  /// 억양 분석 — the accent breakdown, with the share action in its header.
  ///
  /// The body (avatar → caption → top accent → one [ProgressBar] per stat) is
  /// the old profile card unchanged; the redesign only wrapped it in a titled
  /// header and moved sharing here from the app bar.
  Widget _accentCard(
    BuildContext context,
    AppLocalizations l10n,
    List<AccentStat> stats,
    ImageProvider avatar, {
    bool loading = false,
  }) =>
      _card(
        context,
        header: _cardHeader(
          context,
          title: l10n.accentAnalysis,
          subtitle: l10n.recentSessionsAverage,
          action: InkWell(
            onTap: () => showDialogShareProfile(
              context,
              imageProvider: avatar,
              caption: l10n.accentSoundsLike,
              title: stats.isEmpty ? '—' : stats.first.label,
              stats: [
                for (var i = 0; i < stats.length; i++)
                  ProfileStat(
                    label: stats[i].label,
                    value: stats[i].percent.toDouble(),
                    active: i == 0,
                  ),
              ],
              // The dialog rasterizes the accent card and shares it as a PNG;
              // this text rides along as the caption.
              shareText: _inviteText,
              onShared: () => Navigator.of(context).maybePop(),
            ),
            child: AppIcons.share(color: context.c.labelNormal),
          ),
        ),
        children: loading
            // 아직 모른다 — 「없다」가 아니라 «채워지는 중»을 보인다.
            // 예전엔 로딩 중에도 빈 상태 문구가 그대로 떠서, 억양이 있는 회원에게도
            // 「억양 데이터가 없어요」가 보였다(2026-09-21 실기기 확인).
            ? const [
                Center(child: Skeleton.circle(size: AppSpacing.s80)),
                Center(child: Skeleton.bar(width: 120, height: 20)),
                Skeleton.bar(height: 16),
                Skeleton.bar(height: 16),
              ]
            : stats.isEmpty
            // `screen/main_mypage__null_all` (4849:8301): the header and its
            // share action stay, the body says why it is blank. The old shape
            // drew the avatar over a lone em dash, which reads as a value the
            // server returned rather than as "nothing yet".
            ? [
                EmptyBlock(
                  title: l10n.noAccentDataTitle,
                  body: l10n.noAccentDataBody,
                  scale: EmptyScale.card,
                ),
                // Figma E1 — 억양 분석 전에도 버튼은 **보이되 눌리지 않는다.**
                // 숨기면 기능이 없는 줄 알고, 눌리게 두면 빈 목록으로 떨어진다.
                const SizedBox(height: AppSpacing.s8),
                Button(
                  // ⛔ secondaryFill 을 쓰지 마라 — 그 면색이 카드 자신의 색과 같아서
                  //    다크에서 버튼이 통째로 사라진다(mypage_surface_contrast_test 가
                  //    잡는 바로 그 결함). 카드 안 CTA 는 전부 secondaryElevated 다.
                  type: BtnType.secondaryElevated,
                  size: BtnSize.s60,
                  text: l10n.wsEnterFromMypage,
                  disabled: true,
                ),
              ]
            : [
          Center(
            child: Container(
              width: AppSpacing.s80,
              height: AppSpacing.s80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.c.backgroundElevatedAlternative,
                image: DecorationImage(image: avatar, fit: BoxFit.cover),
              ),
            ),
          ),
          Text(
            l10n.accentSoundsLike,
            textAlign: TextAlign.center,
            style: AppType.body1.r.copyWith(color: context.c.labelNormal),
          ),
          Text(
            stats.first.label,
            textAlign: TextAlign.center,
            style: AppType.title3.b.copyWith(color: context.c.labelStrong),
          ),
          for (var i = 0; i < stats.length; i++)
            ProgressBar(
              label: stats[i].label,
              value: stats[i].percent.toDouble(),
              active: i == 0,
            ),
          // 취약 발음 학습 진입(Figma 01). 공유 아이콘은 헤더에 **그대로 둔다** —
          // 사용자 지시로 되살린 것이라 이 버튼이 그 자리를 뺏지 않는다.
          //
          // 억양 분석 전이면 누를 수 없다(Figma E1). 분석 결과가 없으면 국적별 목록이
          // 통째로 비어서, 들어가 봐야 빈 화면만 보게 된다.
          const SizedBox(height: AppSpacing.s8),
          Button(
            // 위와 같은 이유로 secondaryElevated. 카드 면색과 같은 버튼은 안 보인다.
            type: BtnType.secondaryElevated,
            size: BtnSize.s60,
            text: l10n.wsEnterFromMypage,
            onPressed: () => Navigator.of(context).pushNamed(Routes.weakSounds),
          ),
        ],
      );

  /// 종합 레벨 — stage, percentile and the 1→13 gradient scale.
  Widget _levelCard(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    LevelSummary? level,
  ) =>
      _card(
        context,
        header: _cardHeader(
          context,
          title: l10n.overallLevel,
          subtitle: l10n.overallLevelSubtitle,
        ),
        children: level?.level == null
            // `screen/main_mypage__null_all` (4849:8307). The stage used to read
            // "—" with the rail drawn empty beneath it, which looks like a
            // level of zero rather than a level not taken yet. The CTA is
            // 레벨 테스트 **받기** here, not 다시하기 (§4-6) — a user who has
            // never tested cannot re-take.
            ? [
                EmptyBlock(
                  title: l10n.noLevelYetTitle,
                  body: l10n.noLevelYetBody,
                  ctaText: l10n.takeLevelTest,
                  onCta: () => _startLevelTest(context, ref),
                  ctaSize: BtnSize.s60,
                  // Matches the populated card's button — see its comment.
                  ctaType: BtnType.secondaryElevated,
                  scale: EmptyScale.card,
                ),
              ]
            : [
          // 레벨 · 상위 % — `LabelValueRow`(09-24). 320dp 에서 "Stage 7" + "Among all learners" 가
          // 카드 안쪽 240 을 넘는 긴 언어가 있다. 옛 `Flexible` 둘은 폭을 반반으로 갈라 짧은 쪽이
          // 남긴 폭을 긴 쪽이 못 썼다. 이제 필요 폭대로 나누고, 넘치면 긴 쪽이 줄을 바꾼다.
          // 레벨은 짧은 숫자라 한 줄에서 자르고, 비율 설명은 자르지 않고 줄을 바꾼다.
          LabelValueRow(
            // 레벨 미확정(레벨테스트 전)이면 숫자를 지어내지 않고 "—" 를 둔다.
            // 예전엔 목업 값 7 이 그대로 떠서 테스트도 안 본 사용자에게
            // "7단계" 가 보였다.
            label: Text(
              level?.level == null ? '—' : l10n.levelStage(level!.level!),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppType.title2.b.copyWith(color: context.c.labelStrong),
            ),
            // 상위 % 는 값이 있을 때만 — 없는 백분위를 0% 로 그리면 거짓이 된다.
            value: level?.topPercent == null
                ? const SizedBox.shrink()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ⛔ 비율은 자르지 않는다 — 「상위 3…」 은 없는 숫자다.
                      //   넘치면 줄을 바꾼다.
                      Text(
                        l10n.topPercent(level!.topPercent!),
                        textAlign: TextAlign.end,
                        style: AppType.title3.b
                            .copyWith(color: context.c.primaryNormal),
                      ),
                      const SizedBox(height: AppSpacing.s4),
                      Text(
                        l10n.allLearnersBasis,
                        textAlign: TextAlign.end,
                        style: AppType.body1.r
                            .copyWith(color: context.c.labelNormal),
                      ),
                    ],
                  ),
          ),
          LevelProgress(
            // level=null 이면 마커를 숨긴다(컴포넌트 계약) — 레일만 보인다.
            level: level?.level,
            maxLevel: level?.maxLevel ?? _Fallback.levelMax,
            startLabel: l10n.levelStage(1),
            endLabel: l10n.levelStage(level?.maxLevel ?? _Fallback.levelMax),
          ),
          if (level?.aheadOfPercent != null)
            _aheadLine(context, l10n, level!.aheadOfPercent!),
          Button(
            // Elevated, not Fill: the card is `Background/Surface/Alternative`,
            // which in Dark is the same #252932 that `secondaryFill` paints —
            // the button vanished into the card. `secondaryElevated` 는 09-26 부터
            // 반투명 `Fill/Strong` 이라 카드 면보다 한 단계만 짙다(시안 B).
            type: BtnType.secondaryElevated,
            size: BtnSize.s60,
            text: l10n.retakeLevelTest,
            // 재측정은 진도를 그 레벨 첫 차시로 되돌린다(서버 09-24) — 확인을 먼저 받는다.
            // ⛔ 이 버튼을 없애지 마라 — 레벨을 내리는 유일한 경로다(서버 요청).
            onPressed: () => _confirmRetakeLevelTest(context, ref),
          ),
        ],
      );

  /// 발음 분석 — the existing gauge component under a titled header.
  Widget _pronunciationCard(
    BuildContext context,
    AppLocalizations l10n,
    PronSummary? pron,
    List<CallSummary>? recentCalls,
  ) =>
      _card(
        context,
        header: _cardHeader(
          context,
          title: l10n.pronunciationAnalysis,
          subtitle: l10n.recentSessionsAverage,
        ),
        children: !(pron?.hasData ?? false)
            // `screen/main_mypage__null_all` (4849:8313) replaces the gauge
            // outright rather than showing it at `-%`. Note this supersedes the
            // work order's §4-5 line about a mypage gauge hint: the frame has
            // no gauge here to hang a hint on. The hint survives on analysis,
            // where the gauge does stay.
            ? [
                EmptyBlock(
                  title: l10n.noPronunciationDataTitle,
                  body: l10n.noPronunciationDataBody,
                  ctaText: l10n.practicePronunciation,
                  onCta: () => _openRecentAnalysis(context, recentCalls),
                  ctaSize: BtnSize.s60,
                  ctaType: BtnType.secondaryElevated,
                  scale: EmptyScale.card,
                ),
              ]
            : [
          // 최근 10세션 평균. 점수가 없으면(발음 챌린지를 아직 안 했거나 통화가
          // 없으면) inactive 상태로 게이지가 `-%` 를 그린다 — 0% 로 그리면
          // "0점을 받았다"로 읽혀서 없는 것과 나쁜 것이 구별되지 않는다.
          PronunciationResult(
            state: (pron?.hasData ?? false)
                ? PronunciationState.active
                : PronunciationState.inactive,
            score: pron?.totalScore ?? 0,
            metrics: [
              PronunciationMetric(
                  label: l10n.pronunciation,
                  value: _pct(pron?.pronunciation),
                  score: pron?.pronunciation),
              PronunciationMetric(
                  label: l10n.fluency,
                  value: _pct(pron?.fluency),
                  score: pron?.fluency),
              PronunciationMetric(
                  label: l10n.rhythm,
                  value: _pct(pron?.rhythm),
                  score: pron?.rhythm),
            ],
          ),
          Button(
            // Same reason as 레벨 테스트 다시하기 above — see that comment.
            type: BtnType.secondaryElevated,
            size: BtnSize.s60,
            text: l10n.practicePronunciation,
            onPressed: () => _openRecentAnalysis(context, recentCalls),
          ),
        ],
      );

  // ── Card chrome ────────────────────────────────────────────────────────

  /// The analysis-card shell — Figma `Dialog-ShareProfile` frame: radius 8,
  /// padding 20/20/24/20, `Background/Surface/Alternative`, 16 between rows.
  Widget _card(
    BuildContext context, {
    required Widget header,
    required List<Widget> children,
  }) =>
      Container(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.s20, AppSpacing.s20, AppSpacing.s20, AppSpacing.s24),
        decoration: BoxDecoration(
          color: context.c.backgroundSurfaceAlternative,
          borderRadius: BorderRadius.circular(AppRadius.xs), // 8
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            header,
            for (final child in children) ...[
              const SizedBox(height: AppSpacing.s16),
              child,
            ],
          ],
        ),
      );

  /// Card header: `title` in `Primary/Heavy` SemiBold, `subtitle` in
  /// `Label/Normal` Regular, and an optional trailing [action] pushed to the
  /// far end (only the accent card has one).
  Widget _cardHeader(
    BuildContext context, {
    required String title,
    required String subtitle,
    Widget? action,
  }) =>
      Row(
        children: [
          // Expanded (not Flexible + Spacer): with both the text group and a
          // Spacer flexible, each would only get half the free width and the
          // titles would overflow at 320dp in the wordier locales.
          // ⛔ 제목·부제를 `Flexible` 둘로 나란히 두지 마라. **flex 가 같으면 행이
          //   정확히 반반 갈린다** — 짧은 제목이 안 쓰는 폭까지 잡고, 부제는 남은
          //   절반에 안 들어가 줄이 바뀐다. 「Accent analysis / Last 10 sessions
          //   avg.」 가 공간이 남는데도 두 줄이 됐다(2026-09-23 실기기).
          //   같은 함정이 `card_line.dart` 결제 행 주석에 이미 적혀 있었다.
          //
          // `Wrap` 은 **각자 필요한 만큼만** 쓰고, 한 줄에 안 들어갈 때만 부제를
          // 통째로 다음 줄로 내린다. 문구 중간에서 끊기지 않는다.
          Expanded(
            child: Wrap(
              spacing: AppSpacing.s8,
              runSpacing: 2,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  title,
                  style:
                      AppType.body1.sb.copyWith(color: context.c.primaryHeavy),
                ),
                Text(
                  subtitle,
                  style: AppType.body1.r.copyWith(color: context.c.labelNormal),
                ),
              ],
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: AppSpacing.s8),
            action,
          ],
        ],
      );

  /// "전체 학습자의 **55%**보다 앞서 있어요" — the percentage is emphasised in
  /// `Label/Strong` inside an otherwise `Label/Normal` sentence.
  ///
  /// The emphasis is applied by locating the formatted `NN%` token in the
  /// localized sentence; if a translation words it differently and the token is
  /// absent, the line renders flat rather than mis-splitting.
  Widget _aheadLine(BuildContext context, AppLocalizations l10n, int percent) {
    final sentence = l10n.aheadOfLearners(percent);
    final token = '$percent%';
    final base = AppType.label1.r.copyWith(color: context.c.labelNormal);
    final index = sentence.indexOf(token);
    if (index < 0) return Text(sentence, style: base);
    return Text.rich(
      TextSpan(
        style: base,
        children: [
          TextSpan(text: sentence.substring(0, index)),
          TextSpan(
            text: token,
            style: base.copyWith(color: context.c.labelStrong),
          ),
          TextSpan(text: sentence.substring(index + token.length)),
        ],
      ),
    );
  }

  // ── Actions ────────────────────────────────────────────────────────────

  /// 레벨 테스트 다시하기 → the call flow.
  ///
  /// There is no dedicated level-test screen: the app has one call entry point
  /// ([Routes.callLoading]) and the server decides whether a call counts as a
  /// level test. Onboarding's 바로 통화하기 goes to the same place.
  /// 레벨테스트 다시하기 — **서버에 요청한 뒤에** 통화 화면으로 넘어간다.
  ///
  /// 예전엔 그냥 통화 화면으로 밀기만 해서 일반 통화가 열렸다. 레벨 배정을 다시
  /// 받으려면 서버가 레벨을 비워야 다음 통화가 레벨테스트로 라우팅된다(D11).
  /// 학습 기록(체크판)은 지워지지 않는다 — 레벨만 다시 받는 것이다.
  ///
  /// 하루 1회 제한은 통화 시작 시점에 서버가 검사한다. 즉 이 요청이 성공해도
  /// 오늘 이미 레벨테스트를 했다면 통화 화면에서 DAILY_LIMIT 로 막힌다.
  /// ⚠ **실패하면 통화로 넘어가지 않는다.** 예전엔 예외를 삼키고 그대로 이동했는데,
  /// 서버에 이 API 가 아직 없던 동안(404) 레벨이 안 지워진 채 **일반 통화**가 열렸다.
  /// 사용자 눈에는 "레벨테스트를 눌렀는데 그냥 대화가 시작됨" 으로 보였고 원인이
  /// 드러나지 않았다. 조용한 폴백보다 명확한 실패가 낫다.
  /// 「레벨 테스트 다시하기」 확인 — 서버 「레벨이 이제 «진도» 에서 나온다」(09-24).
  ///
  /// 다시 측정하면 진도가 **그 레벨의 첫 차시로** 돌아간다. 레벨이 같게 나와도 돌아가고,
  /// 차시 완료 표시가 리셋된다(배운 항목·통화 기록·발음 점수는 보존). 되돌리기 어려운 쪽이라
  /// 머무는 「진도 유지하기」가 주요 버튼(primary_fill)이다. 위치는 **아래** — 「다시 측정하기」 위 ·
  /// 「진도 유지하기」 아래(09-24 사장님이 Dialog-Basic variant2 를 직접 고친 정본 · 1285ee5 의
  /// 「진도 유지하기 위」 를 뒤집음). Dialog-Basic `175:12790`(gap 12). 스크림으로 닫으면 **측정하지 않는다.**
  ///
  /// 레벨이 없는 회원의 「레벨 테스트 받기」 는 되돌아갈 진도가 없어 확인 없이 바로 간다.
  Future<void> _confirmRetakeLevelTest(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final retake = await showDialogBasic<bool>(
      context,
      title: l10n.levelRetakeTitle,
      description: l10n.levelRetakeBody,
      actions: [
        DialogAction(
          label: l10n.levelRetakeConfirm,
          onPressed: () => Navigator.of(context).pop(true),
        ),
        DialogAction(
          label: l10n.levelRetakeKeep,
          type: BtnType.primaryFill,
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ],
    );
    if (retake != true || !context.mounted) return;
    await _startLevelTest(context, ref);
  }

  Future<void> _startLevelTest(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(authRepositoryProvider).retakeLevelTest();
    } catch (e) {
      if (!context.mounted) return;
      final msg = e is AppException ? e.message : l10n.tryAgainLater;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(msg)));
      return; // 레벨이 안 지워졌으므로 통화를 열면 일반 통화가 된다
    }
    // 카드가 "레벨 미확정" 으로 돌아가도록 다시 읽는다.
    ref.invalidate(myLevelProvider);
    if (!context.mounted) return;
    Navigator.pushNamed(context, Routes.callLoading);
  }

  /// 0~100 점수 → "96%". 값이 없으면 "-%" (0% 로 그리면 0점으로 읽힌다).
  static String _pct(double? v) => v == null ? '-%' : '${v.round()}%';

  /// 발음 학습하기 → the most recent call's analysis.
  ///
  /// Figma points at `screen/analysis`, which in the app cannot be entered
  /// directly — it renders a `CallResult` handed to it by
  /// [Routes.analysisLoading], which in turn needs a `callId`. The id comes
  /// from [recentCalls]; with no calls yet (or the list still loading) this
  /// falls back to the records screen, where the same analysis is one tap away.
  ///
  /// **Not simply the newest call.** A call that was cut before anyone spoke
  /// lands in the list with `totalTime` 0 and never gets analysed, so aiming at
  /// `first` blindly drops the user on "분석 결과를 불러오지 못했어요" — observed on
  /// device. The newest call with a non-zero duration is the newest one that
  /// can actually have a result.
  void _openRecentAnalysis(
      BuildContext context, List<CallSummary>? recentCalls) {
    if (recentCalls == null || recentCalls.isEmpty) {
      Navigator.pushNamed(context, Routes.records);
      return;
    }
    final analysable = recentCalls
        .where((c) => (c.totalTime ?? 0) > 0)
        .firstOrNull;
    if (analysable == null) {
      Navigator.pushNamed(context, Routes.records);
      return;
    }
    Navigator.pushNamed(context, Routes.analysisLoading,
        arguments: analysable.callId);
  }
}

/// `GET /cur/me` 한 줄 — 개발자 도구용. «차시 4 A1-T01-1 · 남은 2 · 다음: 프리토킹».
///
/// ⭐ 로딩·실패도 **글자로** 보인다. 개발자 도구는 「왜 안 보이나」를 화면에서 바로
///   가려야 하는 자리라 조용히 비우지 않는다(마이페이지의 제품 카드들과 다른 규율).
class _CurMeLine extends ConsumerWidget {
  const _CurMeLine();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = AppType.label1.r.copyWith(color: context.c.labelNormal);
    final cur = ref.watch(curMeProvider);
    final text = cur.when(
      loading: () => '커리큘럼: 불러오는 중…',
      error: (e, _) => '커리큘럼 조회 실패: $e',
      data: (m) => !m.available
          // 언어에 커리큘럼이 없다(available=false) — 차시·상태가 null 로 온다.
          ? '커리큘럼 준비 중 (${m.language ?? '언어 미상'}) · 다음: ${_courseLabel(m.nextCourse)}'
          : '차시 ${m.lesson.no} ${m.lesson.code}'
              ' · 남은 ${m.itemsLeft}/${m.itemsTotal}'
              ' · 상태 ${m.status}'
              ' · 다음: ${_courseLabel(m.nextCourse)}'
              '${m.openFreetalk ? '' : ' · 프리토킹 잠김'}',
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
      child: Text(text, style: style),
    );
  }

}

/// 「내 배운 기록 삭제」 — `POST /__dev/cur-reset`. 표현학습·프리토킹 진도(차시·항목·
/// 커리큘럼 귀속)를 지우고 차시 1 로 돌린다. **통화 기록·분석은 남는다**(서버가 `call`
/// 행을 보존한다 — 감사 기록).
///
/// - 확인 다이얼로그를 거친다(취소가 기본 자리).
/// - 진행 중엔 버튼이 죽는다 — 더블탭이 두 번 지우는 건 무해하지만, 두 번째 응답이
///   첫 스낵바를 덮어 「뭐가 됐는지」 를 흐린다.
/// - 성공하면 [curMeProvider] 를 무효화해 위 진도 한 줄이 «차시 1» 로 즉시 바뀐다.
/// - 403(`ADMIN_ONLY` — user 계정)·그 밖의 실패는 서버 메시지를 스낵바로. 앱이 만든
///   문구로 바꾸지 않는다 — 「관리자 전용」 이 「실패했어요」 로 뭉개지면 원인을 못 본다.
class _CurResetRow extends ConsumerStatefulWidget {
  const _CurResetRow();

  @override
  ConsumerState<_CurResetRow> createState() => _CurResetRowState();
}

class _CurResetRowState extends ConsumerState<_CurResetRow> {
  bool _busy = false;

  Future<void> _confirmAndReset() async {
    if (_busy) return;
    final confirmed = await showDialogBasic<bool>(
      context,
      title: '배운 기록을 지울까요?',
      description: '표현학습·프리토킹 진도(차시·항목 기록)를 지우고 차시 1 부터 다시 '
          '시작합니다. 통화 기록·분석은 남습니다.',
      actions: [
        DialogAction(
          label: '취소',
          onPressed: () => Navigator.of(context).pop(false),
        ),
        DialogAction(
          label: '삭제',
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
    if (confirmed != true || !mounted) return;
    setState(() => _busy = true);
    String msg;
    try {
      final r = await ref.read(normalcallRepositoryProvider).resetCurriculum();
      // 진도 한 줄을 새로 읽는다 — 서버가 방금 차시 1 로 돌렸다.
      ref.invalidate(curMeProvider);
      msg = '차시 ${r.lessonCode} 부터 다시 시작';
    } catch (e) {
      // 403 ADMIN_ONLY 의 「관리자 전용 기능입니다.」 가 여기로 온다(서버 문구 그대로).
      msg = e is AppException ? e.message : '삭제에 실패했어요: $e';
    }
    if (!mounted) return;
    setState(() => _busy = false);
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    // 파괴적 동작 — 빨간 글자·빨간 휴지통. 기존 토큰(accentForegroundRed)만 쓴다.
    final red = context.c.accentForegroundRed;
    final dim = context.c.labelAssistive;
    return InkWell(
      onTap: _busy ? null : _confirmAndReset,
      borderRadius: BorderRadius.circular(AppRadius.xs),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('내 배운 기록 삭제',
                      style: AppType.body1.sb.copyWith(color: _busy ? dim : red)),
                  const SizedBox(height: AppSpacing.s4),
                  Text(
                    _busy
                        ? '지우는 중…'
                        : '표현학습·프리토킹 진도를 지우고 차시 1 부터. '
                            '통화 기록·분석은 남습니다. 관리자 계정 전용.',
                    style: AppType.label1.r.copyWith(color: context.c.labelNormal),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.s12),
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.s4),
              child: _busy
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : AppIcons.trash(size: 20, color: red),
            ),
          ],
        ),
      ),
    );
  }
}
