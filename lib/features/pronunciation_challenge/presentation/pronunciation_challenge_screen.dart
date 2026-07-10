import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_scaffold.dart';
import '../../../components/atoms/button.dart';
import '../../../components/organisms/gnb.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../domain/game_config.dart';
import 'challenge_controller.dart';
import 'challenge_painter.dart';

/// Screen phases (which overlay panel is shown over the live game canvas).
enum _Phase { start, countdown, playing, result }

/// Pronunciation Challenge — a Ticker + CustomPainter mini-game.
///
/// PHASE 0/1: fully playable with a **temporary tap input** (a tap passes the
/// front-most in-zone live card). Speech recognition, camera, and recording are
/// intentionally stubbed for a later wave.
class PronunciationChallengeScreen extends ConsumerStatefulWidget {
  /// Creates the challenge screen.
  const PronunciationChallengeScreen({super.key});

  @override
  ConsumerState<PronunciationChallengeScreen> createState() =>
      _PronunciationChallengeScreenState();
}

class _PronunciationChallengeScreenState
    extends ConsumerState<PronunciationChallengeScreen>
    with SingleTickerProviderStateMixin {
  late final ChallengeController _controller;
  _Phase _phase = _Phase.start;
  int _countdown = 3;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _controller = ChallengeController(vsync: this);
    _controller.addListener(_onFrame);
    // Ticker runs continuously so the belt animates behind every panel.
    _controller.startTicker();
  }

  /// Detects the running→ended transition to reveal the result panel.
  void _onFrame() {
    if (_phase == _Phase.playing && !_controller.engine.running) {
      _countdownTimer?.cancel();
      setState(() => _phase = _Phase.result);
    }
  }

  void _beginCountdown() {
    _countdownTimer?.cancel();
    setState(() {
      _phase = _Phase.countdown;
      _countdown = 3;
    });
    // Mirror the web game's 800ms cadence (lines 399–404).
    _countdownTimer = Timer.periodic(const Duration(milliseconds: 800), (t) {
      _countdown--;
      if (_countdown <= 0) {
        t.cancel();
        _controller.engine.start();
        setState(() => _phase = _Phase.playing);
      } else {
        setState(() {});
      }
    });
  }

  void _onTapDown() {
    if (_phase == _Phase.playing) _controller.engine.tapPass();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _controller.removeListener(_onFrame);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppColors.surface,
      body: Column(
        children: [
          Gnb.main(
            title: '발음 챌린지',
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: Stack(
              children: [
                // ── live game canvas (9:16 stage) ──
                Positioned.fill(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 9 / 16,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTapDown: (_) => _onTapDown(),
                        child: CustomPaint(
                          painter: ChallengePainter(
                            engine: _controller.engine,
                            repaint: _controller,
                          ),
                          child: const SizedBox.expand(),
                        ),
                      ),
                    ),
                  ),
                ),
                // ── overlay panels ──
                if (_phase == _Phase.start) _startPanel(),
                if (_phase == _Phase.countdown) _countdownPanel(),
                if (_phase == _Phase.result) _resultPanel(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── panels ──────────────────────────────────────────────────────────
  Widget _panelShell({required List<Widget> children}) {
    return Positioned.fill(
      child: ColoredBox(
        color: const Color(0xD1080A0C), // rgba(8,10,12,.82)
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.s24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          ),
        ),
      ),
    );
  }

  Widget _startPanel() {
    return _panelShell(
      children: [
        Text(
          'Pronunciation Challenge',
          textAlign: TextAlign.center,
          style: AppType.title2.b.copyWith(color: AppColors.text),
        ),
        const SizedBox(height: AppSpacing.s12),
        Text(
          '존 안의 카드를 화면 탭으로 통과시켜요.\n(임시 입력 — 음성 인식은 다음 단계)',
          textAlign: TextAlign.center,
          style: AppType.body2.r.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.s24),
        _difficultyToggle(),
        const SizedBox(height: AppSpacing.s24),
        Button(
          type: BtnType.primaryFill,
          size: BtnSize.s60,
          text: '시작하기',
          onPressed: _beginCountdown,
        ),
      ],
    );
  }

  Widget _countdownPanel() {
    return Positioned.fill(
      child: ColoredBox(
        color: const Color(0xD1080A0C),
        child: Center(
          child: Text(
            '$_countdown',
            style: AppType.display1.b.copyWith(
              color: AppColors.text,
              fontSize: 120,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _resultPanel() {
    final engine = _controller.engine;
    return _panelShell(
      children: [
        Text(
          'RESULT',
          style: AppType.label1.b.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.s8),
        Text(
          engine.resultTitle,
          textAlign: TextAlign.center,
          style: AppType.title2.b.copyWith(color: AppColors.text),
        ),
        const SizedBox(height: AppSpacing.s16),
        Text(
          'Score ${_thousands(engine.score)}  ·  '
          'Best Combo ${engine.maxCombo}  ·  Cleared ${engine.passCount}',
          textAlign: TextAlign.center,
          style: AppType.body2.r.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.s24),
        _difficultyToggle(),
        const SizedBox(height: AppSpacing.s24),
        Button(
          type: BtnType.primaryFill,
          size: BtnSize.s60,
          text: 'Play Again',
          onPressed: _beginCountdown,
        ),
      ],
    );
  }

  // ── difficulty toggle (Slow / Normal / Fast) ────────────────────────
  Widget _difficultyToggle() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Difficulty',
          style: AppType.label2.b.copyWith(color: AppColors.textTertiary),
        ),
        const SizedBox(height: AppSpacing.s8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _diffButton(Difficulty.slow, 'Slow'),
            const SizedBox(width: AppSpacing.s8),
            _diffButton(Difficulty.normal, 'Normal'),
            const SizedBox(width: AppSpacing.s8),
            _diffButton(Difficulty.fast, 'Fast'),
          ],
        ),
      ],
    );
  }

  Widget _diffButton(Difficulty d, String label) {
    final active = _controller.difficulty == d;
    return Button(
      type: active ? BtnType.primaryFill : BtnType.secondaryFill,
      size: BtnSize.s36,
      text: label,
      onPressed: () => setState(() => _controller.difficulty = d),
    );
  }

  /// Formats an int with thousands separators.
  String _thousands(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}
