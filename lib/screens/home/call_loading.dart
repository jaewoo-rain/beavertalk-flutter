import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_scaffold.dart';
import '../../app/routes.dart';
import '../../components/icons/app_icons.dart';
import '../../components/chrome/home_indicator.dart';
import '../../components/chrome/status_bar.dart';
import '../../features/incoming_call/services/lockscreen_call_service.dart';
import '../../features/normalcall/presentation/normalcall_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Call connecting — Figma `screen/call_loading` (`2117:19923`).
///
/// A dark full-screen "연결 중..." state shown while the WebSocket connects and
/// the server prepares its automatic opening line. It renders the [beaverImage]
/// avatar, a spinner, and a status line, with a top-left close button.
///
/// On [initState] it calls `NormalCallController.start()` (no button — the
/// opening line is server-triggered, plan §8-3). **캐릭터를 넘기지 않는다** —
/// 서버가 `member.character_id` 로 정한다. 예전엔 라우트 `arguments` 로 받아
/// 기본값 `1` 로 폴백했는데, 인자를 안 주는 진입점(마이페이지·기록·온보딩완료)에서
/// 건 전화가 전부 BABA 로 갔다. It then listens to the controller:
/// `inCall` → `pushReplacement(Routes.call)`; `error` → guidance + back home.
/// The close (X) hangs up and returns home (§8-2).
class CallLoadingScreen extends ConsumerStatefulWidget {
  /// Creates the call-connecting screen.
  const CallLoadingScreen({super.key});

  @override
  ConsumerState<CallLoadingScreen> createState() => _CallLoadingScreenState();
}

class _CallLoadingScreenState extends ConsumerState<CallLoadingScreen> {
  bool _navigated = false;

  /// `Frame 4` (`3360:19104`) — the spinner (32) + gap (12) + 연결 중's line
  /// box (24). This is the box the frame centres on the screen.
  static const double _groupHeight = AppSpacing.s32 + AppSpacing.s12 + 24;

  @override
  void initState() {
    super.initState();
    // Start after the first frame so route arguments are available and we can
    // safely read providers.
    WidgetsBinding.instance.addPostFrameCallback((_) => _begin());
  }

  /// Decides what this screen is: the start of a call, or a late view of one.
  ///
  /// A call answered through CallKit starts at the *accept* event, not here —
  /// this screen is only a view of that session. On the lock-screen path it is
  /// pushed while the app is in the background, where Flutter produces no
  /// frames, so this callback does not run until the user actually opens the
  /// app. By then the session may be anywhere in its lifecycle, including
  /// already finished.
  ///
  /// Every phase must therefore be handled explicitly. Falling through to
  /// `start()` on a phase that is not [CallPhase.idle] is what made a call the
  /// user had already hung up look like it never ended: opening the app started
  /// a BRAND NEW call instead of showing the wrap-up.
  void _begin() {
    if (!mounted) return;
    final s = ref.read(normalCallControllerProvider);
    switch (s.phase) {
      case CallPhase.connecting:
      case CallPhase.ending:
        break; // 진행 중 — 리스너가 다음 전이를 받는다.
      case CallPhase.inCall:
        _goCall();
      case CallPhase.ended:
        _goFinish(s);
      case CallPhase.error:
        _goHomeWithError(s.errorMsg);
      case CallPhase.idle:
        // 실제로 여기서 시작하는 유일한 경우 — 홈에서 진입.
        // 캐릭터를 넘기지 않는다 — 서버가 member.character_id 로 정한다.
        // 예전엔 `args is int ? args : 1` 로 폴백해, 인자를 안 주는 진입점
        // (마이페이지·기록·온보딩완료)에서 건 전화가 전부 1(BABA)로 갔다.
        ref.read(normalCallControllerProvider.notifier).start();
    }
  }

  /// 통화 화면으로 교체.
  void _goCall() {
    if (_navigated || !mounted) return;
    _navigated = true;
    Navigator.pushReplacementNamed(context, Routes.call);
  }

  /// 통화가 끝나 이 화면을 떠난다.
  ///
  /// 잠금화면 통화였고 아직 잠겨 있으면 앱을 뒤로 보내고 [inApp] 은 실행하지 않는다.
  /// 그 상태에서 화면을 전환하면 **잠금화면 위에 앱 화면이 남아 잠금 우회**가 된다.
  /// 이 화면은 잠금화면 경로에서 백그라운드 push 되므로(파일 상단 주석 참조) 사용자가
  /// 통화를 끝낼 때까지 떠 있는 경우가 있어, 여기서도 종료 경로를 모두 막아야 한다.
  ///
  /// 뒤로 보낸 뒤에도 **화면 스택은 홈으로 되돌린다.** 통화 화면을 그대로 두면 나중에
  /// 사용자가 앱을 열었을 때 끝난 통화 화면이 멈춘 채로 남는다(종료 버튼도 안 먹는다).
  /// 앱이 이미 백그라운드라 이 전환은 눈에 보이지 않는다.
  ///
  /// 호출자가 `_navigated` 를 이미 세운 뒤에 부르므로 중복 진입은 여기서 다루지 않는다.
  Future<void> _leave(VoidCallback inApp) async {
    final backgrounded = await const LockscreenCallService().exitIfLocked();
    if (!mounted) return;
    // 끝난 통화의 상태를 소비 처리한다. 안 하면 phase 가 `ended` 로 남아, 다음에 통화를
    // 걸어도 이 화면이 새 통화 대신 지난 통화의 요약 화면으로 보낸다([_begin] 참조).
    // 화면 전환 **전에** 부른다 — 전환 뒤에는 이 위젯이 dispose 되어 ref 를 쓸 수 없다.
    ref.read(normalCallControllerProvider.notifier).clearFinished();
    if (backgrounded) {
      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (r) => r.isFirst);
      return;
    }
    inApp();
  }

  /// 이미 끝난 통화 → 요약 화면으로. `call` 화면과 동일한 인자 형태를 쓴다.
  void _goFinish(CallState s) {
    if (_navigated || !mounted) return;
    _navigated = true;
    _leave(() => Navigator.pushReplacementNamed(
      context,
      Routes.callFinish,
      arguments: (
        callId: s.callId,
        elapsedSec: s.elapsedSec,
        baselineCallId: s.baselineCallId,
      ),
    ));
  }

  /// 실패 안내 후 홈으로.
  void _goHomeWithError(String? msg) {
    if (_navigated || !mounted) return;
    _navigated = true;
    final text = msg ?? AppLocalizations.of(context).callConnectFailed;
    _leave(() {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(text)));
      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (r) => r.isFirst);
    });
  }

  /// Cancels connecting and returns home.
  Future<void> _cancel() async {
    // 먼저 잠근다: hangUp이 phase를 ended로 바꾸면 아래 리스너가 요약 화면으로
    // 보내려 하는데, 취소는 홈으로 가야 한다.
    if (_navigated) return;
    _navigated = true;
    await ref.read(normalCallControllerProvider.notifier).hangUp();
    if (!mounted) return;
    await _leave(() => Navigator.pushNamedAndRemoveUntil(
        context, Routes.home, (r) => r.isFirst));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // React to phase transitions.
    ref.listen<CallState>(normalCallControllerProvider, (prev, next) {
      if (_navigated) return;
      switch (next.phase) {
        case CallPhase.inCall:
          _goCall();
        // 연결 화면에 머무는 동안 통화가 끝날 수 있다(잠금화면 종료 버튼 등).
        // 그때는 요약 화면으로 보낸다 — 여기 남아 계속 돌면 통화가 안 끝난 것처럼 보인다.
        case CallPhase.ended:
          _goFinish(next);
        case CallPhase.error:
          _goHomeWithError(next.errorMsg);
        case CallPhase.idle:
        case CallPhase.connecting:
        case CallPhase.ending:
          break;
      }
    });

    return AppScaffold(
      // `common/dark-&-white` (#111111), not `surface` — this screen is darker
      // than the rest of the app on purpose.
      background: context.c.commonDarkAndWhite,
      statusVariant: StatusBarVariant.whiteTransparent,
      homeVariant: HomeIndicatorVariant.whiteTransparent,
      body: Stack(
        children: [
          // The frame (`3360:19104`) centres **only** the spinner + 연결 중
          // group (`Frame 4`, 68 tall) and hangs the hint below it — centring
          // all three together, as this used to, pushes the spinner ~8.5px
          // above where the design puts it.
          Center(
            child: SizedBox(
              width: double.infinity,
              height: _groupHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: AppSpacing.s32,
                          height: AppSpacing.s32,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(context.c.labelStrong),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s12),
                        Text(
                          l10n.connecting,
                          style: AppType.body1.r.copyWith(color: context.c.labelStrong),
                        ),
                      ],
                    ),
                  ),
                  // The frame pins this 9.5 below the group — a residue of
                  // absolute positioning against a half-pixel-centred box, so
                  // it rounds to the 8 token.
                  Positioned(
                    top: _groupHeight + AppSpacing.s8,
                    left: 0,
                    right: 0,
                    child: Text(
                      l10n.connectingHint,
                      textAlign: TextAlign.center,
                      style: AppType.label2.r
                          .copyWith(color: context.c.labelNormal),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Top-right close button → hang up + home (Figma GNB, 56 tall).
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 56,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.s20, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Semantics(
                      button: true,
                      label: l10n.close,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _cancel,
                        child:
                            AppIcons.close(size: 28, color: context.c.labelStrong),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
