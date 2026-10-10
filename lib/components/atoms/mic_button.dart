import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/app_color_tokens.dart';
import '../icons/app_icons.dart';
import 'record_circle_button.dart';

/// Recording-face inner disc — a pale mint on the green record disc. Mode-
/// invariant: it sits on `primaryHeavy` in both themes and keeps its contrast,
/// so it stays a literal rather than flipping. Figma has no token for it.
const _kRecordingInner = Color(0xFFE6FFF7);

/// MicButton — the 96px two-state recorder mic button.
///
/// Figma component `Property 1=mic_on` (`37:41776`), extracted from
/// `screen/learning_intro` (`2117:20089`).
///
/// - **idle** ([recording] = `false`) — a green-700 ring (transparent inside)
///   with a green-700 [Icons.mic] glyph; tap to start.
/// - **recording** ([recording] = `true`) — a solid green-700 disc with a pale
///   green-50 inner disc and a green-700 rounded stop square; tap to finish.
class MicButton extends StatelessWidget {
  /// Creates a mic button.
  const MicButton({
    super.key,
    required this.recording,
    required this.onTap,
    this.level,
  });

  /// Whether the button is in the recording (stop) state.
  final bool recording;

  /// Tap handler — starts recording when idle, stops when recording.
  final VoidCallback onTap;

  /// Optional live input level (normalized 0..1) driving a subtle reactive
  /// pulse while recording. `null` (default) keeps the button fully static, so
  /// existing call sites are unaffected. When supplied, an expanding halo ring
  /// and a gentle scale track the level; the two-state visuals are unchanged.
  final double? level;

  static const double _size = 96;

  /// 반응 헤일로가 버튼 면 밖으로 번지는 최대 반경.
  ///
  /// ⛔ **헤일로에 레이아웃을 내주지 마라.** 예전엔 녹음 중에만
  ///    `_size + _maxHalo * 2`(=136) 짜리 박스를 둘러서, 마이크가 정지 버튼으로
  ///    바뀌는 순간 위젯이 96→136 으로 커졌다. 그만큼 CTA 바가 높아지며 버튼이
  ///    위로 밀려, **누른 자리와 다른 자리에 정지 버튼이 뜨는** 결함이 됐다.
  ///    지금은 [OverflowBox] 로 띄워 칠하기만 한다 — 두 상태 모두 위젯은 96×96 다.
  static const double _maxHalo = 20;

  @override
  Widget build(BuildContext context) {
    final core = _buildCore(context);

    final lvl = level;
    // No level provided (or idle) → render the plain two-state button.
    if (lvl == null || !recording) return core;

    final clamped = lvl.clamp(0.0, 1.0);
    return SizedBox(
      width: _size,
      height: _size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Expanding halo ring — grows and fades in with the input level.
          // OverflowBox 라 96 밖으로 번져도 레이아웃 크기는 96 그대로다.
          OverflowBox(
            maxWidth: _size + _maxHalo,
            maxHeight: _size + _maxHalo,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 90),
              curve: Curves.easeOut,
              width: _size + _maxHalo * clamped,
              height: _size + _maxHalo * clamped,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.c.primaryHeavy.withValues(alpha: 0.14 * clamped),
              ),
            ),
          ),
          // Gentle scale of the button face itself (max +5%). Transform 이라
          // 그려지는 크기만 커지고 레이아웃은 안 건드린다.
          AnimatedScale(
            duration: const Duration(milliseconds: 90),
            curve: Curves.easeOut,
            scale: 1 + 0.05 * clamped,
            child: core,
          ),
        ],
      ),
    );
  }

  /// The two-state button face (idle mic circle / recording stop face).
  Widget _buildCore(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Idle reuses the shared white-circle record control (mic glyph).
    if (!recording) {
      return RecordCircleButton(
        icon: AppIcons.mic,
        onTap: onTap,
        semanticLabel: l10n.startRecording,
        size: _size,
      );
    }
    return Semantics(
      button: true,
      label: l10n.stopRecording,
      child: GestureDetector(
        onTap: onTap,
        child: const SizedBox(
            width: _size, height: _size, child: _RecordingFace()),
      ),
    );
  }
}

/// Recording face: solid green-700 disc, pale green-50 inner disc, stop square.
class _RecordingFace extends StatelessWidget {
  const _RecordingFace();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.c.primaryHeavy,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        width: 72,
        height: 72,
        decoration: const BoxDecoration(
          color: _kRecordingInner,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            color: context.c.primaryHeavy,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

/// Gallery demo exposing both [MicButton] states (tap to toggle).
class MicButtonDemo extends StatefulWidget {
  const MicButtonDemo({super.key});

  @override
  State<MicButtonDemo> createState() => _MicButtonDemoState();
}

class _MicButtonDemoState extends State<MicButtonDemo> {
  bool _recording = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MicButton(
            recording: _recording,
            onTap: () => setState(() => _recording = !_recording),
          ),
          const SizedBox(width: 24),
          const MicButton(recording: false, onTap: _noop),
          const SizedBox(width: 24),
          const MicButton(recording: true, onTap: _noop),
        ],
      ),
    );
  }

  static void _noop() {}
}
