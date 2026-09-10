import 'package:flutter/material.dart';
import '../theme/app_color_tokens.dart';
import '../components/chrome/status_bar.dart';
import '../components/chrome/home_indicator.dart';

/// Full-screen shell for every design_app screen. The body fills the real
/// device width and height inside a [SafeArea], so the OS status bar / home
/// indicator insets are respected.
///
/// The old fixed 375×812 mock frame (and its reserved fake-chrome spacers) was
/// dropped: it scaled the whole UI down when the soft keyboard opened. Now the
/// keyboard resizes the body and each screen's own scroll view handles it.
/// [statusVariant] / [homeVariant] are retained so existing call sites keep
/// compiling, but they no longer affect layout.
///
/// 폭 캡은 여기 없다. 예전에는 `maxWidth: 430` 으로 전 화면을 폰 칼럼에 가뒀고,
/// 그래서 태블릿에서는 가운데 430 칼럼 하나에 좌우가 통째로 검은 여백이었다.
/// 이제 셸은 전폭을 채우고 **폭을 줄이는 일은 본문이 `ContentColumn` 으로
/// 스스로 한다** — 전폭이어야 하는 부품(상태바·헤더·탭바 배경)과 600으로
/// 묶여야 하는 본문이 한 캡을 공유하면 둘 중 하나는 반드시 틀리기 때문이다.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.bottomBar,
    this.statusVariant = StatusBarVariant.whiteTransparent,
    this.homeVariant = HomeIndicatorVariant.whiteTransparent,
    this.background,
  });

  /// Screen content; fills the frame's middle band (between the reserved
  /// status-bar and home-indicator spacers).
  final Widget body;

  /// Optional bottom bar pinned below [body], OUTSIDE any scroll area, so a CTA
  /// / control cluster stays fixed at the bottom of the phone column. Wrap it in
  /// [BottomCtaBar] for the shared, consistent bottom inset. Defaults to null
  /// (no bar), preserving existing call sites.
  final Widget? bottomBar;

  /// Retained for call-site compatibility; no longer rendered.
  final StatusBarVariant statusVariant;

  /// Retained for call-site compatibility; no longer rendered.
  final HomeIndicatorVariant homeVariant;
  /// Screen fill. Defaults to `Background/Normal/Deep` **at build time** —
  /// a constructor default must be const, so it could only hold one mode.
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0C10),
      // Keep the soft keyboard resizing the body so each screen's own scroll
      // view lifts the focused field above the keyboard (no whole-UI shrink).
      resizeToAvoidBottomInset: true,
      // 전폭·전높이. SafeArea 가 OS 인셋을 지킨다.
      body: ColoredBox(
        color: background ?? context.c.backgroundNormalDeep,
        child: SafeArea(
          child: SizedBox.expand(
            child: Column(
              children: [
                Expanded(child: body),
                ?bottomBar,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
